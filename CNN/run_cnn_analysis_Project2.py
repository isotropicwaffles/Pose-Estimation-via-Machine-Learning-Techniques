import numpy as np
import sys
import math
import time
import random
import scipy.io as sio
from conv_mod_project import ArtistConvNet as AC
from six.moves import cPickle as pickle
import os

pixel_width = '64'
shape = os.environ['CNN_SHAPE'] #'cone'
numHLayers = int(os.environ['CNN_HL'])
numCLayers = int(os.environ['CNN_CL'])

def run_all_cnn_analysis():
  #Testing this shit
  print "Define Parameters"

  countResults = {'val_mse': -1, 'train_mse': -1}
  
  # Hyperparameters arrays
  num_hidden_layers_array = [numHLayers] #[1,2,3,4,5]
  num_conv_layers_array =[numCLayers] # [0,1,2,3]
  batch_size_array = [100] #[100]
  learning_rate_array = [1e-2, 1e-4, 1e-8]
  conv_layer1_filter_size_array = [3, 5, 8] 
  conv_layer1_depth_array = [8, 16]
  conv_layer1_stride_array = [1, 2, 4] 
  conv_layer2_filter_size_array = [3, 5, 8] 
  conv_layer2_depth_array = [8, 16]
  conv_layer2_stride_array = [1, 2, 4] 
  conv_layer3_filter_size_array = [3, 5, 8] 
  conv_layer3_depth_array = [8, 16]
  conv_layer3_stride_array = [1, 2, 4] 
  layer1_num_hidden_array = [16, 32, 64, 128] 
  layer2_num_hidden_array = [16, 32, 64, 128]
  layer3_num_hidden_array = [16, 32, 64, 128] 
  layer4_num_hidden_array = [16, 32, 64, 128]
  layer5_num_hidden_array = [16, 32, 64, 128] 
  num_training_steps_array = [100] 
  
  # Add max pooling arrays
  pooling_array = [True,False]
  conv_layer1_pool_filter_size_array = [3, 5, 8]
  conv_layer1_pool_stride_array = [1, 2, 4]
  conv_layer2_pool_filter_size_array = [3, 5, 8]
  conv_layer2_pool_stride_array = [1, 2, 4]
  conv_layer3_pool_filter_size_array = [3, 5, 8]
  conv_layer3_pool_stride_array = [1, 2, 4]
 
  # Enable dropout and weight decay normalization
  dropout_prob_array = [1.0] # set to < 1.0 to apply dropout, 1.0 to remove
  weight_penalty_array = [0, 1e-6, 1e-1, 1] # set to > 0.0 to apply weight penalty, 0.0 to remove



  #Set initial values from arrays
  # Hyperparameters
  num_hidden_layers =num_hidden_layers_array[0]
  num_conv_layers = num_conv_layers_array[0]

  batch_size = batch_size_array[0]
  learning_rate = learning_rate_array[0]
  conv_layer1_filter_size = conv_layer1_filter_size_array[0] 
  conv_layer1_depth = conv_layer1_depth_array[0]
  conv_layer1_stride = conv_layer1_stride_array[0] 
  conv_layer2_filter_size = conv_layer2_filter_size_array[0] 
  conv_layer2_depth = conv_layer2_depth_array[0]
  conv_layer2_stride = conv_layer2_stride_array[0] 
  conv_layer3_filter_size = conv_layer3_filter_size_array[0] 
  conv_layer3_depth = conv_layer3_depth_array[0]
  conv_layer3_stride = conv_layer3_stride_array[0] 
  layer1_num_hidden = layer1_num_hidden_array[0] 
  layer2_num_hidden = layer2_num_hidden_array[0]
  layer3_num_hidden = layer3_num_hidden_array[0] 
  layer4_num_hidden = layer4_num_hidden_array[0]
  layer5_num_hidden = layer5_num_hidden_array[0] 
  num_training_steps = num_training_steps_array[0] 
  
  # Add max pooling
  pooling = pooling_array[0]
  conv_layer1_pool_filter_size = conv_layer1_pool_filter_size_array[0]
  conv_layer1_pool_stride = conv_layer1_pool_stride_array[0]
  conv_layer2_pool_filter_size = conv_layer2_pool_filter_size_array[0]
  conv_layer2_pool_stride = conv_layer2_pool_stride_array[0]
  conv_layer3_pool_filter_size = conv_layer3_pool_filter_size_array[0]
  conv_layer3_pool_stride = conv_layer3_pool_stride_array[0]
  
  dropout_prob = dropout_prob_array[0] # set to < 1.0 to apply dropout, 1.0 to remove
  weight_penalty = weight_penalty_array[0] # set to > 0.0 to apply weight penalty, 0.0 to remove

#Structure that hold the current best guess
  save = {
            'num_hidden_layers': num_hidden_layers,
            'num_conv_layers': num_conv_layers,
            'batch_size': batch_size,
            'learning_rate': learning_rate,
            'conv_layer1_filter_size': conv_layer1_filter_size,
            'conv_layer1_depth': conv_layer1_depth,
            'conv_layer1_stride': conv_layer1_stride,
            'conv_layer2_filter_size': conv_layer2_filter_size,
            'conv_layer2_depth': conv_layer2_depth,
            'conv_layer2_stride': conv_layer2_stride,
            'conv_layer3_filter_size': conv_layer3_filter_size,
            'conv_layer3_depth': conv_layer3_depth,
            'conv_layer3_stride': conv_layer3_stride,
            'layer1_num_hidden': layer1_num_hidden,
            'layer2_num_hidden': layer2_num_hidden,
            'layer3_num_hidden': layer3_num_hidden,
            'layer4_num_hidden': layer4_num_hidden,
            'layer5_num_hidden': layer5_num_hidden,
            'num_training_steps': num_training_steps,
            'pooling': pooling,
            'conv_layer1_pool_filter_size': conv_layer1_pool_filter_size,
            'conv_layer1_pool_stride': conv_layer1_pool_stride,
            'conv_layer2_pool_filter_size': conv_layer2_pool_filter_size,
            'conv_layer2_pool_stride': conv_layer2_pool_stride,
            'conv_layer3_pool_filter_size': conv_layer3_pool_filter_size,
            'conv_layer3_pool_stride': conv_layer3_pool_stride,
            'dropout_prob': dropout_prob,
            'weight_penalty': weight_penalty
            }
 
#Names of all the hyper parameters
  hyper_parameters = ["num_hidden_layers",
  "num_conv_layers",
  "batch_size",
  "learning_rate",
  "conv_layer1_filter_size",
  "conv_layer1_depth",
  "conv_layer1_stride",
  "conv_layer2_filter_size",
  "conv_layer2_depth",
  "conv_layer2_stride",
  "conv_layer3_filter_size",
  "conv_layer3_depth",
  "conv_layer2_stride",
  "layer1_num_hidden",
  "layer2_num_hidden",
  "layer3_num_hidden",
  "layer4_num_hidden",
  "layer5_num_hidden",
  "num_training_steps",
  "pooling",
  "conv_layer1_pool_filter_size",
  "conv_layer1_pool_stride",
  "conv_layer2_pool_filter_size",
  "conv_layer2_pool_stride",
  "conv_layer3_pool_filter_size",
  "conv_layer3_pool_stride",
  "weight_penalty"]

  l_train_results = list()
  l_val_results = list()
  l_num_hidden_layers = list()
  l_num_conv_layers = list()
  l_batch_size = list()
  l_learning_rate = list()
  l_conv_layer1_filter_size = list()
  l_conv_layer1_depth = list()
  l_conv_layer1_stride = list()
  l_conv_layer2_filter_size = list()
  l_conv_layer2_depth = list()
  l_conv_layer2_stride = list()
  l_conv_layer3_filter_size = list()
  l_conv_layer3_depth = list()
  l_conv_layer3_stride = list()
  l_layer1_num_hidden = list()
  l_layer2_num_hidden = list()
  l_layer3_num_hidden = list()
  l_layer4_num_hidden = list()
  l_layer5_num_hidden = list()
  l_num_training_steps = list()
  l_pooling = list()
  l_conv_layer1_pool_filter_size = list()
  l_conv_layer1_pool_stride = list()
  l_conv_layer2_pool_filter_size = list()
  l_conv_layer2_pool_stride = list()
  l_conv_layer3_pool_filter_size = list()
  l_conv_layer3_pool_stride = list()
  l_dropout_prob = list()
  l_weight_penalty = list()

  hyper_indx = range(len(hyper_parameters))
  count = 0
  while count < 10:#last_val_error > 1:
    #print "Saving temp Parameters"
    pickle_file = 'temp_parm.pickle'
    count = count + 1
    print count
    
    for ix in hyper_indx:
      curr_hyper_param = hyper_parameters[ix]
      old_hyp_value = save[hyper_parameters[ix]]
      hyperParameter_values = eval(curr_hyper_param+'_array')

      #Code to skip degenerate optimizations
      if num_hidden_layers < 5 and 'layer5_num_hidden' == curr_hyper_param:
          continue
      if num_hidden_layers < 4 and 'layer4_num_hidden' == curr_hyper_param:
          continue
      if num_hidden_layers < 3 and 'layer3_num_hidden' == curr_hyper_param:
          continue
      if num_hidden_layers < 2 and 'layer2_num_hidden' == curr_hyper_param:
          continue
      if num_conv_layers < 3:
        list_to_check = ['conv_layer3_filter_size',
                         'conv_layer3_depth', 
                         'conv_layer3_stride',
                         'conv_layer3_pool_filter_size',
                         'conv_layer3_pool_stride']

        if any(curr_hyper_param in s for s in list_to_check):
          continue
      if num_conv_layers < 2:
        list_to_check = ['conv_layer2_filter_size',
                         'conv_layer2_depth', 
                         'conv_layer2_stride',
                         'conv_layer2_pool_filter_size',
                         'conv_layer2_pool_stride']

        if any(curr_hyper_param in s for s in list_to_check):
          continue
      if num_conv_layers < 1:
        list_to_check = ['conv_layer1_filter_size',
                         'conv_layer1_depth', 
                         'conv_layer1_stride',
                         'conv_layer1_pool_filter_size',
                         'conv_layer1_pool_stride',
                         'pooling']

        if any(curr_hyper_param in s for s in list_to_check):   
          continue
      #End code to skip degenerate cases

      print 'Running parameter: ' + curr_hyper_param
      last_val_error = 100000000000

      #check if there is more than 1 value to iterate over
      if len(hyperParameter_values) > 1:
        for x in hyperParameter_values:
		
          #update the value we want to
          save[curr_hyper_param] = x

          # print pooling
          save_pickle_file(pickle_file, save)

          try:
            conv_net = AC(False,pickle_file)
            NetworkResults = conv_net.train_model()
            if NetworkResults['val_mse'] < last_val_error and NetworkResults['val_mse'] > 0:
              best_value = x
              last_val_error = NetworkResults['val_mse']
              last_train_error = NetworkResults['train_mse']
              countResults['val_mse'] = last_val_error
              countResults['train_mse'] = last_train_error
          except:
            print "Failed"
        #End loop over all parameters

        #Save out whatever the best thing was
        save[curr_hyper_param] = best_value
      #End if there is more than 1 value
    #End for every hyper-parameter

    #Do stuff at the end of a count
    print 'Count Val Error: ' + str(countResults['val_mse'])
    print 'Count Val Error: ' + str(countResults['train_mse'])
    time.sleep(5)
    l_val_results.append(countResults['val_mse'])
    l_train_results.append(countResults['train_mse']) 
    #print l_val_results
    time.sleep(5)
    l_num_hidden_layers.append(save['num_hidden_layers'])
    l_num_conv_layers.append(save['num_conv_layers'])
    l_batch_size.append(save['batch_size'])
    l_learning_rate.append(save['learning_rate'])
    l_conv_layer1_filter_size.append(save['conv_layer1_filter_size'])
    l_conv_layer1_depth.append(save['conv_layer1_depth'])
    l_conv_layer1_stride.append(save['conv_layer1_stride'])
    l_conv_layer2_filter_size.append(save['conv_layer2_filter_size'])
    l_conv_layer2_depth.append(save['conv_layer2_depth'])
    l_conv_layer2_stride.append(save['conv_layer2_stride'])
    l_conv_layer3_filter_size.append(save['conv_layer3_filter_size'])
    l_conv_layer3_depth.append(save['conv_layer3_depth'])
    l_conv_layer3_stride.append(save['conv_layer3_stride'])
    l_layer1_num_hidden.append(save['layer1_num_hidden'])
    l_layer2_num_hidden.append(save['layer2_num_hidden'])
    l_layer3_num_hidden.append(save['layer3_num_hidden'])
    l_layer4_num_hidden.append(save['layer4_num_hidden'])
    l_layer5_num_hidden.append(save['layer5_num_hidden'])
    l_num_training_steps.append(save['num_training_steps'])
    if save['pooling']:
      l_pooling.append(1)
    else:
      l_pooling.append(0)

    l_conv_layer1_pool_filter_size.append(save['conv_layer1_pool_filter_size'])
    l_conv_layer1_pool_stride.append(save['conv_layer1_pool_stride'])
    l_conv_layer2_pool_filter_size.append(save['conv_layer2_pool_filter_size'])
    l_conv_layer2_pool_stride.append(save['conv_layer2_pool_stride'])
    l_conv_layer3_pool_filter_size.append(save['conv_layer3_pool_filter_size'])
    l_conv_layer3_pool_stride.append(save['conv_layer3_pool_stride'])
    l_dropout_prob.append(save['dropout_prob'])
    l_weight_penalty.append(save['weight_penalty'])

  #End for every count

  #Begin final save
  input_info = {
    'num_hidden_layers': l_num_hidden_layers,
    'num_conv_layers': l_num_conv_layers,
    'batch_size': l_batch_size,
    'learning_rate': l_learning_rate,
    'conv_layer1_filter_size': l_conv_layer1_filter_size,
    'conv_layer1_depth': l_conv_layer1_depth,
    'conv_layer1_stride': l_conv_layer1_stride,
    'conv_layer2_filter_size': l_conv_layer2_filter_size,
    'conv_layer2_depth': l_conv_layer2_depth,
    'conv_layer2_stride': l_conv_layer2_stride,
    'conv_layer3_filter_size': l_conv_layer3_filter_size,
    'conv_layer3_depth': l_conv_layer3_depth,
    'conv_layer3_stride': l_conv_layer3_stride,
    'layer1_num_hidden': l_layer1_num_hidden,
    'layer2_num_hidden': l_layer2_num_hidden,
    'layer3_num_hidden': l_layer3_num_hidden,
    'layer4_num_hidden': l_layer4_num_hidden,
    'layer5_num_hidden': l_layer5_num_hidden,
    'num_training_steps': l_num_training_steps,
    'pooling': l_pooling,
    'conv_layer1_pool_filter_size': l_conv_layer1_pool_filter_size,
    'conv_layer1_pool_stride': l_conv_layer1_pool_stride,
    'conv_layer2_pool_filter_size': l_conv_layer2_pool_filter_size,
    'conv_layer2_pool_stride': l_conv_layer2_pool_stride,
    'conv_layer3_pool_filter_size': l_conv_layer3_pool_filter_size,
    'conv_layer3_pool_stride': l_conv_layer3_pool_stride,
    'dropout_prob': l_dropout_prob,
    'weight_penalty': l_weight_penalty
    }
  run_results = {'val_mse': l_val_results,
                 'train_mse': l_train_results}
                                     
  save_to_mat(run_results,input_info)

def save_to_mat(output_list,input_info):
  try:
    sio.savemat(shape+pixel_width+'_H' + str(numHLayers) + '_C' + str(numCLayers) + 'results.mat', {'results': output_list,'inputs': input_info})
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
