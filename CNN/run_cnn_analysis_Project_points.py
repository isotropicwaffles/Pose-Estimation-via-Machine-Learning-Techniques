import numpy as np
import sys
import math
import time
import random
import scipy.io as sio
from conv_mod_project_point_data import ArtistConvNet as AC
from six.moves import cPickle as pickle


pixel_width = '256'
shape = 'cone'

def run_all_cnn_analysis():
  #Testing this shit
  print "Define Parameters"

  
  # Hyperparameters arrays
  num_hidden_layers_array =[1,2,3,4,5]
  batch_size_array = [10]
  learning_rate_array = [1e-2,1e-4,1e-8]
  layer1_num_hidden_array = [16, 32, 64, 128] 
  layer2_num_hidden_array = [16, 32, 64, 128]
  layer3_num_hidden_array = [16, 32, 64, 128] 
  layer4_num_hidden_array = [16, 32, 64, 128]
  layer5_num_hidden_array = [16, 32, 64, 128] 
  num_training_steps_array = [5000] 

 
  # Enable dropout and weight decay normalization
  dropout_prob_array = [1] # set to < 1.0 to apply dropout, 1.0 to remove
  weight_penalty_array = [0, 1e-6, 1e-1, 1] # set to > 0.0 to apply weight penalty, 0.0 to remove



  #Set initial values from arrays
  # Hyperparameters
  num_hidden_layers =num_hidden_layers_array[0]

  batch_size = batch_size_array[0]
  learning_rate = learning_rate_array[0]
  layer1_num_hidden = layer1_num_hidden_array[0] 
  layer2_num_hidden = layer2_num_hidden_array[0]
  layer3_num_hidden = layer3_num_hidden_array[0] 
  layer4_num_hidden = layer4_num_hidden_array[0]
  layer5_num_hidden = layer5_num_hidden_array[0] 
  num_training_steps = num_training_steps_array[0] 
  

  dropout_prob = dropout_prob_array[0] # set to < 1.0 to apply dropout, 1.0 to remove
  weight_penalty = weight_penalty_array[0] # set to > 0.0 to apply weight penalty, 0.0 to remove
 
  hyper_parameters = ["num_hidden_layers",
  "batch_size",
  "learning_rate",
  "layer1_num_hidden",
  "layer2_num_hidden",
  "layer3_num_hidden",
  "layer4_num_hidden",
  "layer5_num_hidden",
  "num_training_steps",
  "weight_penalty"]

  
  run_results_list = list()
  l_num_hidden_layers = list()
  l_batch_size = list()
  l_learning_rate = list()
  l_layer1_num_hidden = list()
  l_layer2_num_hidden = list()
  l_layer3_num_hidden = list()
  l_layer4_num_hidden = list()
  l_layer5_num_hidden = list()
  l_num_training_steps = list()
  l_dropout_prob = list()
  l_weight_penalty = list()

  threshold = 42
  last_val_error = 100000000000
  last_train_error = 100000000000
  best_value = 0
  hyper_indx = range(len(hyper_parameters))
  did_it_run_once_flag = 0;
  count = 0
  while count < 10:#last_val_error > 1:
    #print "Saving temp Parameters"
    pickle_file = 'temp_parm.pickle'
    count = count + 1
    print count
    
    random.shuffle(hyper_indx)

    for ix in hyper_indx:
      print 'Running parameter: ' + hyper_parameters[ix]
      last_val_error = 100000000000
      last_train_error = 100000000000
      temp_value = eval(hyper_parameters[ix]+'_array')
      random.shuffle(temp_value)
      #check if there is more than 1 value to iterate over
      if len(temp_value) > 1 or did_it_run_once_flag == 0:
        did_it_run_once_flag = 1
        for x in temp_value:
		
          save = {
            'num_hidden_layers': num_hidden_layers,
            'batch_size': batch_size,
            'learning_rate': learning_rate,
            'layer1_num_hidden': layer1_num_hidden,
            'layer2_num_hidden': layer2_num_hidden,
            'layer3_num_hidden': layer3_num_hidden,
            'layer4_num_hidden': layer4_num_hidden,
            'layer5_num_hidden': layer5_num_hidden,
            'num_training_steps': num_training_steps,
            'dropout_prob': dropout_prob,
            'weight_penalty': weight_penalty
            }
          #update the value we want to
          save[hyper_parameters[ix]] = x

          # print pooling
          save_pickle_file(pickle_file, save)

          try:
            t1 = time.time()
            conv_net = AC(False,pickle_file)
            tmp = conv_net.train_model()
            print tmp
            if tmp['val_mse'] < last_val_error and tmp['val_mse'] > 0:
                best_value = x
                last_val_error = tmp['val_mse']
                last_train_error = tmp['train_mse']
                print "New Best Value, {}: {} , val error = {}".format(hyper_parameters[ix],best_value,last_val_error)
      
            t2 = time.time()
            print "Finished training. Total time taken:", t2-t1
          except:
            print "Failed"

        exec("temp_hyp_val = " + hyper_parameters[ix]) 
        print ""
        print "{} prior best value was: {}".format(hyper_parameters[ix],temp_hyp_val)
        print "Best value observed is: {}".format(best_value)
        exec(hyper_parameters[ix] + " = best_value")
        exec("temp_hyp_val = " + hyper_parameters[ix]) 
        save[hyper_parameters[ix]] = best_value
        print "{} best value is now: {}".format(hyper_parameters[ix],temp_hyp_val)
        print ""
        print "Best Parameters so far, Count: {}".format(count)
        print ''
        for x in save:
          print "{}: {}".format((x),save[x])


        print ""
        save[hyper_parameters[ix]] = x
        save_pickle_file('temp_best.pickle', save)
        #save best value back to variable so it's used when looking at other hyperparameters
    tmp['val_mse'] = last_val_error
    tmp['train_mse'] = last_train_error
    run_results_list.append(tmp)
    l_num_hidden_layers.append(num_hidden_layers)
    l_batch_size.append(batch_size)
    l_learning_rate.append(learning_rate)
    l_layer1_num_hidden.append(layer1_num_hidden)
    l_layer2_num_hidden.append(layer2_num_hidden)
    l_layer3_num_hidden.append(layer3_num_hidden)
    l_layer4_num_hidden.append(layer4_num_hidden)
    l_layer5_num_hidden.append(layer5_num_hidden)
    l_num_training_steps.append(num_training_steps)
    l_dropout_prob.append(dropout_prob)
    l_weight_penalty.append(weight_penalty)

  input_info = {
    'num_hidden_layers': l_num_hidden_layers,
    'batch_size': l_batch_size,
    'learning_rate': l_learning_rate,
    'layer1_num_hidden': l_layer1_num_hidden,
    'layer2_num_hidden': l_layer2_num_hidden,
    'layer3_num_hidden': l_layer3_num_hidden,
    'layer4_num_hidden': l_layer4_num_hidden,
    'layer5_num_hidden': l_layer5_num_hidden,
    'num_training_steps': l_num_training_steps,
    'dropout_prob': l_dropout_prob,
    'weight_penalty': l_weight_penalty
    }                                      
  save_to_mat(run_results_list,input_info)

def save_to_mat(output_list,input_info):
  try:
    sio.savemat(shape+'points_results.mat', {'results': output_list,'inputs': input_info})
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
