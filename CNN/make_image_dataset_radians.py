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
from six.moves import cPickle as pickle

PIXEL_WIDTH = '256'
SHAPE = 'cone'
DATA_PATH = '../Input_Data/images/data' + PIXEL_WIDTH +'/' + SHAPE +'/'
VALIDATION_PERCENT = .2
TEST_PERCENT = .2
IMAGE_SIZE = 256
NUM_CHANNELS = 3 #RGB channels
PIXEL_DEPTH = 255.0
NUM_ARTISTS = 1
NUM_DOF = 12
PARTITION_TEST = True

def load_artist(artist):
  print "Loading images for " + PIXEL_WIDTH + " pixel " + SHAPE
  folder = DATA_PATH
  image_files = [x for x in os.listdir(folder) if '.bmp' in x]
  #print image_files 
  dataset = np.ndarray(shape=(len(image_files), IMAGE_SIZE, IMAGE_SIZE, NUM_CHANNELS),
                         dtype=np.float32)
  num_indices = list()


  num_images = 0
  for image in image_files:
    image_file = os.path.join(folder, image)
    try:
      #print image_file
      image_data = read_image_from_file(image_file)
      dataset[num_images, :, :, :] = image_data
      num_indices.append(int(filter(str.isdigit,  image)) - 1)
      num_images = num_images + 1
    except IOError as e:
      print('Could not read:', image_file, ':', e)
          
  dataset = dataset[0:num_images, :, :, :]
    
  print 'Shape dataset size:', dataset.shape
  print 'Mean:', np.mean(dataset) 
  print 'Standard deviation:', np.std(dataset)
  print ''
  print num_indices 
  return dataset, num_indices

def read_image_from_file(file_path):
	img = Image.open(file_path)

	img = img.resize((IMAGE_SIZE,IMAGE_SIZE), Image.ANTIALIAS) #downsample image
	pixel_values = np.array(img.getdata())
        #print pixel_values
	return np.reshape(pixel_values, [IMAGE_SIZE, IMAGE_SIZE, NUM_CHANNELS])

def make_dataset_arrays(num_rows=2000):
	data = np.ndarray((num_rows, IMAGE_SIZE, IMAGE_SIZE, NUM_CHANNELS), dtype=np.float32)
	labels = np.ndarray((num_rows, NUM_DOF), dtype=np.float32)
	return data, labels

def randomize(dataset, labels):
	permutation = np.random.permutation(labels.shape[0])
	shuffled_dataset = dataset[permutation, :, :, :]
	shuffled_labels = labels[permutation, :]
	return shuffled_dataset, shuffled_labels

def trim_dataset_arrays(data, labels, new_size):
	data = data[0:new_size, :, :, :]
	labels = labels[0:new_size, :]
	return data, labels

def scale_pixel_values(dataset):
	return (dataset - PIXEL_DEPTH / 2.0) / PIXEL_DEPTH

def make_basic_datasets():
	artist_path = DATA_PATH
	artists = [1]
	assert len(artists) == NUM_ARTISTS

	train_data, train_labels = make_dataset_arrays()
	val_data, val_labels = make_dataset_arrays()
	test_data, test_labels = make_dataset_arrays()
	num_train = num_val = num_test = 0
    
	temp_d = np.loadtxt(DATA_PATH + '../poses.txt',dtype=np.float32,delimiter=" ")
	d = np.empty([temp_d.shape[0],12],dtype=np.float32)
        #     print d[1]
	for i in xrange(0, len(temp_d)-1):
		temp_dcm =  mlu.pose2DCM(temp_d[i][3], temp_d[i][4],temp_d[i][5])
		d[i][0] = temp_d[i][0]
		d[i][1] = temp_d[i][1]
		d[i][2] = temp_d[i][2]
		d[i][3] = temp_dcm[0][0]
		d[i][4] = temp_dcm[0][1]
		d[i][5] = temp_dcm[0][2]
		d[i][6] = temp_dcm[1][0]
		d[i][7] = temp_dcm[1][1]
		d[i][8] = temp_dcm[1][2]
		d[i][9] = temp_dcm[2][0]
		d[i][10] = temp_dcm[2][1]
		d[i][11] = temp_dcm[2][2]
		print d[i]

	
        #    print d[1] # 248
	for label,artist in enumerate(artists):
		# load in the images and poses
		artist_data,num_indices = load_artist(artist)
		artist_label =  d[num_indices]
		#randomize the data		
		artist_data, artist_label = randomize(artist_data, artist_label)		
                #print artist_label
		#scale the data
		artist_data = scale_pixel_values(artist_data)
		num_paintings = len(artist_data)

		# randomly shuffle the data to ensure random validation and test sets
		#np.random.shuffle(artist_data)

		nv = int(num_paintings * VALIDATION_PERCENT)

		# partition validation data
		artist_val = artist_data[0:nv, :, :, :]
		val_data[num_val:num_val+nv, :, :, :] = artist_val
		val_labels[num_val:num_val+nv, :] = artist_label[num_val:num_val+nv]
		
                num_val += nv

		# partition test data
		if PARTITION_TEST:
			nt = int(num_paintings * TEST_PERCENT)
			artist_test = artist_data[nv:nv+nt, :, :, :]
			test_data[num_test:num_test+nt, :, :, :] = artist_test
			test_labels[num_test:num_test+nt, :] = artist_label[num_test:num_test+nt]
			num_test += nt
		else:
			nt = 0

		# patition train data
		artist_train = artist_data[nv+nt:, :, :, :]
		ntr = len(artist_train)
		train_data[num_train:num_train+ntr, :, :, :] = artist_train
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
	pickle_file = 'art_data.pickle'
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
	  f = open(DATA_PATH + pickle_file, 'wb')
	  pickle.dump(save_dict, f, pickle.HIGHEST_PROTOCOL)
	  f.close()
	except Exception as e:
	  print('Unable to save data to', pickle_file, ':', e)
	  raise

	print "Datasets saved to file", DATA_PATH + pickle_file

if __name__ == '__main__':
  print "Making image dataset and saving it to:", DATA_PATH
  print "To change this and other settings, edit the flags at the top of this file."

  make_basic_datasets()


