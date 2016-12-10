import tensorflow as tf
import numpy as np
import MLUtils as mlu
import math
import os
import sys
import random
import re
from PIL import Image
from PIL import ImageEnhance
import PIL.ImageOps
import scipy.io as sio
from six.moves import cPickle as pickle

PIXEL_WIDTH = '256'
FOV = 60
SHAPE = 'cone'
FILENAME = 'PointDataSet.mat'
DATA_PATH = '../Input_Data/'
VALIDATION_PERCENT = .2
TEST_PERCENT = .2
#CONE: 79, SPHERE:62: CUBE:14
NUM_POINTS = 79
NUM_FOCAL_PLANE_DOF= 2#RGB channels
NUM_ARTISTS = 1
NUM_DOF = 12
PARTITION_TEST = True

def load_artist(artist):
	'''Load the images for a single artist.'''
	print "Loading images for artist", artist
	mat_contents = sio.loadmat(DATA_PATH+FILENAME, struct_as_record=False)

	temp_data = mat_contents[SHAPE]

	#THIS IS 1xn array that needs to be reorganized
	points = temp_data[0,0].Points

	Runs = temp_data[0,0].Runs

	features = np.empty([Runs.shape[0],points.shape[1], NUM_FOCAL_PLANE_DOF], dtype=np.float32)
	print points.shape
	print Runs.shape
	outputs = np.empty([Runs.shape[0], NUM_DOF], dtype=np.float32)
	count1 = 0
	for i in xrange(0, Runs.shape[0]):
		for j in xrange(0,points.shape[1]):
			if 0:#Runs[i,0].Occluded[j][0] == 1:
				features[i,j,0] = 0
				features[i,j,1] = 0
			else:
				count1 = count1 + 1
				features[i,j,0] = Runs[i,0].Points[0,j]
				features[i,j,1] = Runs[i,0].Points[1,j]
				#print features[i,j,:]
		temp_dcm =  mlu.pose2DCM(Runs[i,0].yaw[0,0],Runs[i,0].pitch[0,0],Runs[i,0].roll[0,0])
		outputs[i][0] = Runs[i,0].x[0,0]
		outputs[i][1] = Runs[i,0].y[0,0]
		outputs[i][2] = Runs[i,0].z[0,0]
		outputs[i][3] = temp_dcm[0][0]
		outputs[i][4] = temp_dcm[0][1]
		outputs[i][5] = temp_dcm[0][2]
		outputs[i][6] = temp_dcm[1][0]
		outputs[i][7] = temp_dcm[1][1]
		outputs[i][8] = temp_dcm[1][2]
		outputs[i][9] = temp_dcm[2][0]
		outputs[i][10] = temp_dcm[2][1]
		outputs[i][11] = temp_dcm[2][2]
		#print outputs[i]	  
	
	print 'Shape dataset size:', features.shape
	print 'Mean:', np.mean(features) 
	print 'Standard deviation:', np.std(features)
	print ''
	#print outputs 
	print count1
	return features, outputs


def make_dataset_arrays(num_rows=2000):
	data = np.ndarray((num_rows, NUM_POINTS, NUM_FOCAL_PLANE_DOF), dtype=np.float32)
	labels = np.ndarray((num_rows, NUM_DOF), dtype=np.float32)
	return data, labels

def randomize(dataset, labels):
	permutation = np.random.permutation(labels.shape[0])
	shuffled_dataset = dataset[permutation, :, :]
	shuffled_labels = labels[permutation, :]
	return shuffled_dataset, shuffled_labels

def trim_dataset_arrays(data, labels, new_size):
	data = data[0:new_size, :, :]
	labels = labels[0:new_size, :]
	return data, labels


def make_basic_datasets():
	artist_path = DATA_PATH
	artists = [1]
	assert len(artists) == NUM_ARTISTS

	train_data, train_labels = make_dataset_arrays()
	val_data, val_labels = make_dataset_arrays()
	test_data, test_labels = make_dataset_arrays()
	num_train = num_val = num_test = 0
    
        #     print d[1]

	
        #    print d[1] # 248
	for label,artist in enumerate(artists):
		# create a one-hot encoding of this artist's label

		artist_data,artist_label = load_artist(artist)
		#print artist_data.shape 
        #randomize the data		
		artist_data, artist_label = randomize(artist_data, artist_label)	
		num_paintings = len(artist_data)

		# randomly shuffle the data to ensure random validation and test sets
		#np.random.shuffle(artist_data)

		nv = int(num_paintings * VALIDATION_PERCENT)

		# partition validation data
		artist_val = artist_data[0:nv, :, :]
		val_data[num_val:num_val+nv, :, :] = artist_val
		val_labels[num_val:num_val+nv, :] = artist_label[num_val:num_val+nv]
		
                num_val += nv

		# partition test data
		if PARTITION_TEST:
			nt = int(num_paintings * TEST_PERCENT)
			artist_test = artist_data[nv:nv+nt, :, :]
			test_data[num_test:num_test+nt, :, :] = artist_test
			test_labels[num_test:num_test+nt, :] = artist_label[num_test:num_test+nt]
			num_test += nt
		else:
			nt = 0

		# patition train data
		artist_train = artist_data[nv+nt:, :, :]
		ntr = len(artist_train)
		train_data[num_train:num_train+ntr, :, :] = artist_train
		train_labels[num_train:num_train+ntr, :] = artist_label[num_train:num_train+ntr]
		num_train += ntr

	# throw out extra allocated rows
	train_data, train_labels = trim_dataset_arrays(train_data, train_labels, num_train)
	val_data, val_labels = trim_dataset_arrays(val_data, val_labels, num_val)

	# shuffle the data to distribute samples from artists randomly
	#train_data, train_labels = randomize(train_data, train_labels)
	#val_data, val_labels = randomize(val_data, val_labels)

	print 'Training set:', train_data.shape, train_labels.shape
	print 'Validation:', val_data.shape, val_labels.shape

	if PARTITION_TEST:
		test_data, test_labels = trim_dataset_arrays(test_data, test_labels, num_test)
		test_data, test_labels = randomize(test_data, test_labels)
		print 'Testing:', test_data.shape, test_labels.shape
		print ''

	# save all the datasets in a pickle file
	pickle_file = 'data.pickle'
	save = {
	    'train_data': train_data,
	    'train_labels': train_labels,
	    'val_data': val_data,
	    'val_labels': val_labels
	}
        #print val_labels

	if PARTITION_TEST:
		save['test_data'] = test_data
		save['test_labels'] = test_labels
	save_pickle_file(pickle_file, save)


def save_pickle_file(pickle_file, save_dict):
	try:
	  f = open(DATA_PATH + SHAPE + "_"  + pickle_file, 'wb')
	  pickle.dump(save_dict, f, pickle.HIGHEST_PROTOCOL)
	  f.close()
	except Exception as e:
	  print('Unable to save data to', pickle_file, ':', e)
	  raise

	print "Datasets saved to file", DATA_PATH + SHAPE + "_"  + pickle_file

if __name__ == '__main__':
  print "Making artist dataset and saving it to:", DATA_PATH
  print "To change this and other settings, edit the flags at the top of this file."

  make_basic_datasets()


