import numpy as np
import sys
import math
import time
import random
import scipy.io as sio
from conv_mod_project import ArtistConvNet as AC
from six.moves import cPickle as pickle


pixel_width = '256'
shape = 'cone'

def run_all_cnn_analysis():
  #Testing this shit
  print "Define Parameters"

  
  # Hyperparameters arrays
  num_hidden_layers_array =[1,2]
  batch_size_array = [10]
  learning_rate_array = [.01]
  layer1_filter_size_array = [5] 
  layer1_depth_array = [16]
  layer1_stride_array = [2] 
  layer2_filter_size_array = [5] 
  layer2_depth_array = [16]
  layer2_stride_array = [2] 
  layer3_num_hidden_array = [64] 
  layer4_num_hidden_array = [64]
  layer5_num_hidden_array = [64] 
  layer6_num_hidden_array = [64]
  layer7_num_hidden_array = [64] 
  layer8_num_hidden_array = [64] 
  num_training_steps_array = [3001] 
  
  # Add max pooling arrays
  pooling_array = [True]
  layer1_pool_filter_size_array = [2]
  layer1_pool_stride_array = [2]
  layer2_pool_filter_size_array = [2]
  layer2_pool_stride_array = [ 2]

 
  # Enable dropout and weight decay normalization
  dropout_prob_array = [1] # set to < 1.0 to apply dropout, 1.0 to remove
  weight_penalty_array = [0.0] # set to > 0.0 to apply weight penalty, 0.0 to remove



#Set initial values from arrays
 # Hyperparameters
  num_hidden_layers =num_hidden_layers_array[0]
  batch_size = batch_size_array[0]
  learning_rate = learning_rate_array[0]
  layer1_filter_size = layer1_filter_size_array[0] 
  layer1_depth = layer1_depth_array[0]
  layer1_stride = layer1_stride_array[0] 
  layer2_filter_size = layer2_filter_size_array[0] 
  layer2_depth = layer2_depth_array[0]
  layer2_stride = layer2_stride_array[0] 
  layer3_num_hidden = layer3_num_hidden_array[0] 
  layer4_num_hidden = layer4_num_hidden_array[0]
  layer5_num_hidden = layer5_num_hidden_array[0] 
  layer6_num_hidden = layer6_num_hidden_array[0]
  layer7_num_hidden = layer7_num_hidden_array[0] 
  layer8_num_hidden = layer8_num_hidden_array[0] 
  num_training_steps = num_training_steps_array[0] 
  
  # Add max pooling
  pooling = pooling_array[0]
  layer1_pool_filter_size = layer1_pool_filter_size_array[0]
  layer1_pool_stride = layer1_pool_stride_array[0]
  layer2_pool_filter_size = layer2_pool_filter_size_array[0]
  layer2_pool_stride = layer2_pool_stride_array[0]

  dropout_prob = dropout_prob_array[0] # set to < 1.0 to apply dropout, 1.0 to remove
  weight_penalty = weight_penalty_array[0] # set to > 0.0 to apply weight penalty, 0.0 to remove
 
  hyper_parameters = ["num_hidden_layers",
                     "batch_size",
                     "learning_rate",
                     "layer1_filter_size",
                     "layer1_depth",
                     "layer1_stride",
                     "layer2_filter_size",
                     "layer2_depth" "layer2_stride",
                     "layer3_num_hidden",
                     "layer4_num_hidden",
                     "layer5_num_hidden",
                     "layer6_num_hidden",
                     "layer7_num_hidden",
                     "layer8_num_hidden",
                     "num_training_steps",
                     "pooling",
                     "layer1_pool_filter_size",
                     "layer1_pool_stride",
                     "layer2_pool_filter_size",
                     "layer2_pool_stride",
                     "weight_penalty"]

  
  run_results_list = list()
  l_num_hidden_layers = list()
  l_batch_size = list()
  l_learning_rate = list()
  l_layer1_depth = list()
  l_layer1_stride = list()
  l_layer2_filter_size = list()
  l_layer2_depth = list()
  l_layer1_filter_size = list()
  l_layer2_stride = list()
  l_layer3_num_hidden = list()
  l_layer4_num_hidden = list()
  l_layer5_num_hidden = list()
  l_layer6_num_hidden = list()
  l_layer7_num_hidden = list()
  l_layer8_num_hidden = list()
  l_num_training_steps = list()
  l_pooling = list()
  l_layer1_pool_filter_size = list()
  l_layer1_pool_stride = list()
  l_layer2_pool_filter_size = list()
  l_layer2_pool_stride = list()
  l_dropout_prob = list()
  l_weight_penalty = list()

  threshold = 42
  last_error = 100000000000
  best_value = 0
  hyper_indx = range(len(hyper_parameters))
  
  
  while last_error > 1:
    #print "Saving temp Parameters"
    pickle_file = 'temp_parm.pickle'


    random.shuffle(hyper_indx)

    for ix in hyper_indx:

       temp_value = eval(hyper_parameters[ix]+'_array')

       #check if there is more than 1 value to iterate over
       if len(temp_value) > 1:

         for x in temp_value:
           
           save = {
             'num_hidden_layers': num_hidden_layers,
             'batch_size': batch_size,
             'learning_rate': learning_rate,
             'layer1_depth': layer1_depth,
             'layer1_stride': layer1_stride,
             'layer2_filter_size': layer2_filter_size,
             'layer2_depth': layer2_depth,
             'layer1_filter_size': layer1_filter_size,
             'layer2_stride': layer2_stride,
             'layer3_num_hidden': layer3_num_hidden,
             'layer4_num_hidden': layer4_num_hidden,
             'layer5_num_hidden': layer5_num_hidden,
             'layer6_num_hidden': layer6_num_hidden,
             'layer7_num_hidden': layer7_num_hidden,
             'layer8_num_hidden': layer8_num_hidden,
             'num_training_steps': num_training_steps,
             'pooling': pooling,
             'layer1_pool_filter_size': layer1_pool_filter_size,
             'layer1_pool_stride': layer1_pool_stride,
             'layer2_pool_filter_size': layer2_pool_filter_size,
             'layer2_pool_stride': layer2_pool_stride,
             'dropout_prob': dropout_prob,
             'weight_penalty': weight_penalty
             }

           #update the value we want to
           save[hyper_parameters[ix]] = x
           
           

           # print pooling
           save_pickle_file(pickle_file, save)
           #print "Save Successful Parameters"
           t1 = time.time()
           conv_net = AC(False,pickle_file)
           tmp = conv_net.train_model()
           if tmp['val_mse'] < last_error:
             best_value = x
             last_error = tmp['val_mse']
                 
           run_results_list.append(tmp)

           t2 = time.time()
           print "Finished training. Total time taken:", t2-t1

       #save best value back to variable so it's used when looking at other hyperparameters
       exec(hyper_parameters[ix] + " = best_value")

       l_num_hidden_layers.append(num_hidden_layers)
       l_batch_size.append(batch_size)
       l_learning_rate.append(learning_rate)
       l_layer1_depth.append(layer1_depth)
       l_layer1_stride.append(layer1_stride)
       l_layer2_filter_size.append(layer2_filter_size)
       l_layer2_depth.append(layer2_depth)
       l_layer1_filter_size.append(layer1_filter_size)
       l_layer2_stride.append(layer2_stride)
       l_layer3_num_hidden.append(layer3_num_hidden)
       l_layer4_num_hidden.append(layer4_num_hidden)
       l_layer5_num_hidden.append(layer5_num_hidden)
       l_layer6_num_hidden.append(layer6_num_hidden)
       l_layer7_num_hidden.append(layer7_num_hidden)
       l_layer8_num_hidden.append(layer8_num_hidden)
       l_num_training_steps.append(num_training_steps)
       if pooling:
         l_pooling.append(1)
       else:
         l_pooling.append(0)

       l_layer1_pool_filter_size.append(layer1_pool_filter_size)
       l_layer1_pool_stride.append(layer1_pool_stride)
       l_layer2_pool_filter_size.append(layer2_pool_filter_size)
       l_layer2_pool_stride.append(layer2_pool_stride)
       l_dropout_prob.append(dropout_prob)
       l_weight_penalty.append(weight_penalty)

  input_info = {
    'num_hidden_layers': num_hidden_layers,
    'batch_size': l_batch_size,
    'learning_rate': l_learning_rate,
    'layer1_depth': l_layer1_depth,
    'layer1_stride': l_layer1_stride,
    'layer2_filter_size': l_layer2_filter_size,
    'layer2_depth': l_layer2_depth,
    'layer1_filter_size': l_layer1_filter_size,
    'layer2_stride': l_layer2_stride,
    'layer3_num_hidden': l_layer3_num_hidden,
    'layer4_num_hidden': l_layer4_num_hidden,
    'layer5_num_hidden': l_layer4_num_hidden,
    'layer6_num_hidden': l_layer4_num_hidden,
    'layer7_num_hidden': l_layer4_num_hidden,
    'layer8_num_hidden': l_layer4_num_hidden,
    'num_training_steps': l_num_training_steps,
    'pooling': l_pooling,
    'layer1_pool_filter_size': l_layer1_pool_filter_size,
    'layer1_pool_stride': l_layer1_pool_stride,
    'layer2_pool_filter_size': l_layer2_pool_filter_size,
    'layer2_pool_stride': l_layer2_pool_stride,
    'dropout_prob': l_dropout_prob,
    'weight_penalty': l_weight_penalty
    }                                      
  save_to_mat(run_results_list,input_info)

def save_to_mat(output_list,input_info):
  try:
    sio.savemat(shape+pixel_width+'results.mat', {'results': output_list,'inputs': input_info})
  except Exception as e:
	  print('Unable to save list to mat:', e)
	  raise
def save_pickle_file(pickle_file, save_dict):
	try:
	  f = open(pickle_file, 'wb')
	  pickle.dump(save_dict, f, pickle.HIGHEST_PROTOCOL)
	  f.close()
	except Exception as e:
	  print('Unable to save data to', pickle_file, ':', e)
	  raise

	#print "Datasets saved to file", pickle_file


if __name__ == '__main__':
	run_all_cnn_analysis()
	print "Done"
