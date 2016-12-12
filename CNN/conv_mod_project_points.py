import tensorflow as tf
import numpy as np
from six.moves import cPickle as pickle
import sys
import math
import time
import os

PIXEL_WIDTH = '64'
SHAPE = os.environ['CNN_SHAPE'] #'sphere'
DATA_PATH = '../Input_Data/'
DATA_FILE = DATA_PATH + SHAPE + '_data.pickle'
IMAGE_SIZE = int(os.environ['CNN_SIZE']) #14
NUM_CHANNELS = 2
NUM_DOF = 12
INCLUDE_TEST_SET = False

class ArtistConvNet:
	def __init__(self, invariance=False,filename='temp_parm.pickle'):
		'''Initialize the class by loading the required datasets 
		and building the graph'''
		self.load_pickled_dataset(DATA_FILE)
		self.invariance = invariance

		self.graph = tf.Graph()
		self.define_tensorflow_graph(filename)

	def define_tensorflow_graph(self,filename):
		print '\nDefining model...'
         	print "Loading datasets..."
		with open(filename, 'rb') as f:
         		save = pickle.load(f)

			# Hyperparameters
			num_hidden_layers = save['num_hidden_layers']
			num_conv_layers = save['num_conv_layers']
			batch_size = save['batch_size']
			learning_rate = save['learning_rate']
			conv_layer1_filter_size = save['conv_layer1_filter_size']
			conv_layer1_depth = save['conv_layer1_depth']
			conv_layer1_stride = save['conv_layer1_stride']
			conv_layer2_filter_size = save['conv_layer2_filter_size']
			conv_layer2_depth = save['conv_layer2_depth']
			conv_layer2_stride = save['conv_layer2_stride']
			conv_layer3_filter_size = save['conv_layer3_filter_size']
			conv_layer3_depth = save['conv_layer3_depth']
			conv_layer3_stride = save['conv_layer3_stride']
			layer1_num_hidden = save['layer1_num_hidden']
			layer2_num_hidden = save['layer2_num_hidden']
			layer3_num_hidden = save['layer3_num_hidden']
			layer4_num_hidden = save['layer4_num_hidden']
			layer5_num_hidden = save['layer5_num_hidden']
			num_training_steps = save['num_training_steps']

			# Add max pooling
			pooling = save['pooling']
			conv_layer1_pool_filter_size = save['conv_layer1_pool_filter_size']
			conv_layer1_pool_stride = save['conv_layer1_pool_stride']
			conv_layer2_pool_filter_size = save['conv_layer2_pool_filter_size']
			conv_layer2_pool_stride = save['conv_layer2_pool_stride']
			conv_layer3_pool_filter_size = save['conv_layer3_pool_filter_size']
			conv_layer3_pool_stride = save['conv_layer3_pool_stride']
			# Enable dropout and weight decay normalization
			dropout_prob = save['dropout_prob'] # set to < 1.0 to apply dropout, 1.0 to remove
			weight_penalty = save['weight_penalty'] # set to > 0.0 to apply weight penalty, 0.0 to remove

		with self.graph.as_default():
			# Input data
			tf_train_batch = tf.placeholder(
			    tf.float32, shape=(batch_size, IMAGE_SIZE, NUM_CHANNELS))
			tf_train_labels = tf.placeholder(tf.float32, shape=(batch_size, NUM_DOF))
			tf_valid_dataset = tf.constant(self.val_X)
			tf_test_dataset = tf.placeholder(
			    tf.float32, shape=[len(self.val_X), IMAGE_SIZE, NUM_CHANNELS])
			tf_train_dataset = tf.placeholder(
				tf.float32, shape=[len(self.train_X), IMAGE_SIZE, NUM_CHANNELS])

			# Implement dropout
			dropout_keep_prob = tf.placeholder(tf.float32)
			
			layer_size_going_to_hidden = IMAGE_SIZE*NUM_CHANNELS
			# Network weights/parameters that will be learned
			if num_conv_layers > 0:
				conv_layer1_weights = tf.Variable(tf.truncated_normal(
					[conv_layer1_filter_size, conv_layer1_filter_size, NUM_CHANNELS, conv_layer1_depth], stddev=0.1))
				conv_layer1_biases = tf.Variable(tf.zeros([conv_layer1_depth]))
				conv_layer1_feat_map_size = int(math.ceil(float(IMAGE_SIZE) / conv_layer1_stride))
				if pooling:
					conv_layer1_feat_map_size = int(math.ceil(float(conv_layer1_feat_map_size) / conv_layer1_pool_stride))
				layer_size_going_to_hidden = conv_layer1_feat_map_size * conv_layer1_feat_map_size * conv_layer1_depth

				if num_conv_layers > 1:
					conv_layer2_weights = tf.Variable(tf.truncated_normal(
						[conv_layer2_filter_size, conv_layer2_filter_size, conv_layer1_depth, conv_layer2_depth], stddev=0.1))
					conv_layer2_biases = tf.Variable(tf.constant(1.0, shape=[conv_layer2_depth]))
					conv_layer2_feat_map_size = int(math.ceil(float(conv_layer1_feat_map_size) / conv_layer2_stride))
					if pooling:
						conv_layer2_feat_map_size = int(math.ceil(float(conv_layer2_feat_map_size) / conv_layer2_pool_stride))
					layer_size_going_to_hidden = conv_layer2_feat_map_size * conv_layer2_feat_map_size * conv_layer2_depth
						
					if num_conv_layers > 2:
						conv_layer3_weights = tf.Variable(tf.truncated_normal(
							[conv_layer3_filter_size, conv_layer3_filter_size, conv_layer2_depth, conv_layer3_depth], stddev=0.1))
						conv_layer3_biases = tf.Variable(tf.constant(1.0, shape=[conv_layer3_depth]))
						conv_layer3_feat_map_size = int(math.ceil(float(conv_layer2_feat_map_size) / conv_layer3_stride))
						if pooling:
							conv_layer3_feat_map_size = int(math.ceil(float(conv_layer3_feat_map_size) / conv_layer3_pool_stride))
						layer_size_going_to_hidden =conv_layer3_feat_map_size * conv_layer3_feat_map_size * conv_layer3_depth
					

			layer1_weights = tf.Variable(tf.truncated_normal(
				[layer_size_going_to_hidden, layer1_num_hidden], stddev=0.1))
			layer1_biases = tf.Variable(tf.constant(1.0, shape=[layer1_num_hidden]))
			weights_to_penalize = [layer1_weights]
			
			if num_hidden_layers > 1:
				layer2_weights = tf.Variable(tf.truncated_normal(
				[layer1_num_hidden, layer2_num_hidden], stddev=0.1))
				layer2_biases = tf.Variable(tf.constant(1.0, shape=[layer2_num_hidden]))
				weights_to_penalize = [layer1_weights, layer2_weights]

				if num_hidden_layers > 2:
					layer3_weights = tf.Variable(tf.truncated_normal(
					[layer2_num_hidden, layer3_num_hidden], stddev=0.1))
					layer3_biases = tf.Variable(tf.constant(1.0, shape=[layer3_num_hidden]))
					weights_to_pen = [layer1_weights, layer2_weights, layer3_weights]

					if num_hidden_layers > 3:
						layer4_weights = tf.Variable(tf.truncated_normal(
						[layer3_num_hidden, layer4_num_hidden], stddev=0.1))
						layer4_biases = tf.Variable(tf.constant(1.0, shape=[layer4_num_hidden]))
						weights_to_pen = [layer1_weights, layer2_weights, layer3_weights,layer4_weights]

						if num_hidden_layers > 4:
							layer5_weights = tf.Variable(tf.truncated_normal(
							[layer4_num_hidden, layer5_num_hidden], stddev=0.1))
							layer5_biases = tf.Variable(tf.constant(1.0, shape=[layer5_num_hidden]))
							weights_to_pen = [layer1_weights, layer2_weights, layer3_weights,layer4_weights,layer5_weights]
							
			if num_hidden_layers > 0:
				output_weights = tf.Variable(tf.truncated_normal(
				[layer1_num_hidden, NUM_DOF], stddev=0.1))
				
				if num_hidden_layers > 1:
					output_weights = tf.Variable(tf.truncated_normal(
					[layer2_num_hidden, NUM_DOF], stddev=0.1))
					
					if num_hidden_layers > 2:
						output_weights = tf.Variable(tf.truncated_normal(
						[layer3_num_hidden, NUM_DOF], stddev=0.1))
						if num_hidden_layers > 3:
							output_weights = tf.Variable(tf.truncated_normal(
							[layer4_num_hidden, NUM_DOF], stddev=0.1))
							if num_hidden_layers > 4:
								output_weights = tf.Variable(tf.truncated_normal(
								[layer5_num_hidden, NUM_DOF], stddev=0.1))


			output_biases = tf.Variable(tf.constant(1.0, shape=[NUM_DOF]))

			# Model
			def network_model(data,num_hidden_layers,num_conv_layers):
				'''Define the actual network architecture'''
				if num_conv_layers == 0:
					shape = data.get_shape().as_list()
					reshape = tf.reshape(data, [shape[0], shape[1] * shape[2]])
			
					hidden = tf.nn.relu(tf.add(tf.matmul(reshape, layer1_weights), layer1_biases))
				else:
					# Layer 1
					conv1 = tf.nn.conv2d(data, conv_layer1_weights, [1, conv_layer1_stride, conv_layer1_stride, 1], padding='SAME')
					hidden = tf.nn.relu(tf.add(conv1,conv_layer1_biases))
					if pooling:
						hidden = tf.nn.max_pool(hidden, ksize=[1, conv_layer1_pool_filter_size, conv_layer1_pool_filter_size, 1], 
						strides=[1, conv_layer1_pool_stride, conv_layer1_pool_stride, 1],
						padding='SAME', name='pool1')
								
					if num_conv_layers > 1:
						# Layer 2
						conv2 = tf.nn.conv2d(hidden, conv_layer2_weights, [1, conv_layer2_stride, conv_layer2_stride, 1], padding='SAME')
						hidden = tf.nn.relu(tf.add(conv2, conv_layer2_biases))
						if pooling:
							hidden = tf.nn.max_pool(hidden, ksize=[1, conv_layer2_pool_filter_size, conv_layer2_pool_filter_size, 1], 
							strides=[1, conv_layer2_pool_stride, conv_layer2_pool_stride, 1],
							padding='SAME', name='pool2')
						
						if num_conv_layers > 2:
							# Layer 3
							conv3 = tf.nn.conv2d(hidden, conv_layer3_weights, [1, conv_layer3_stride, conv_layer3_stride, 1], padding='SAME')
							hidden = tf.nn.relu(tf.add(conv3, conv_layer3_biases))
							if pooling:
								hidden = tf.nn.max_pool(hidden, ksize=[1, conv_layer3_pool_filter_size, conv_layer3_pool_filter_size, 1], 
								strides=[1, conv_layer3_pool_stride, conv_layer3_pool_stride, 1],
								padding='SAME', name='pool2')
				
			
				
					# Layer 1
					shape = hidden.get_shape().as_list()

					reshape = tf.reshape(hidden, [shape[0], shape[1] * shape[2] * shape[3]])


					hidden = tf.nn.relu(tf.add(tf.matmul(reshape, layer1_weights),layer1_biases))
			
				

				if num_hidden_layers > 1:
					# Layer 2
					shape = hidden.get_shape().as_list()
					
					#reshape = tf.reshape(hidden, [shape[0], shape[1] * shape[2] * shape[3]])
					
					hidden = tf.nn.relu(tf.add(tf.matmul(hidden, layer2_weights),layer2_biases))
					
					if num_hidden_layers > 2:
						# Layer 3
						shape = hidden.get_shape().as_list()
						#reshape = tf.reshape(hidden, [shape[0], shape[1] * shape[2] * shape[3]])
						hidden = tf.nn.relu(tf.add(tf.matmul(hidden, layer3_weights), layer3_biases))

						if num_hidden_layers > 3:
							# Layer 4
							shape = hidden.get_shape().as_list()
							#reshape = tf.reshape(hidden, [shape[0], shape[1] * shape[2] * shape[3]])
							hidden = tf.nn.relu(tf.add(tf.matmul(hidden, layer4_weights), layer4_biases))
							if num_hidden_layers > 4:
								# Layer 5
								shape = hidden.get_shape().as_list()
								#reshape = tf.reshape(hidden, [shape[0], shape[1] * shape[2] * shape[3]])
								hidden = tf.nn.relu(tf.add(tf.matmul(hidden, layer5_weights) , layer5_biases))

				
				#hidden = tf.nn.dropout(hidden, dropout_keep_prob)
				

				output = tf.add(tf.matmul(hidden, output_weights), output_biases)
				out = output #tf.concat(1, [output[:,0:3], tf.nn.l2_normalize(output[:,3:6], 1), tf.nn.l2_normalize(output[:,6:9], 1), tf.nn.l2_normalize(output[:,9:12], 1)])

				return out

			# Training computation
			logits = network_model(tf_train_batch,num_hidden_layers,num_conv_layers)

			#loss = tf.reduce_mean(tf.nn.softmax_cross_entropy_with_logits(logits, tf_train_labels))
			loss = tf.nn.l2_loss(tf.sub(tf_train_labels, logits))
                        #loss = tf.reduce_sum(tf.abs(tf.sub(tf_train_labels, logits)))


			# Add weight decay penalty
			loss = loss + weight_decay_penalty(weights_to_penalize, weight_penalty)

			# Optimizer
			optimizer = tf.train.GradientDescentOptimizer(learning_rate).minimize(loss)
			#optimizer = tf.train.AdamOptimizer(learning_rate).minimize(loss)
			# Predictions for the training, validation, and test data.
			batch_prediction = logits
			valid_prediction = network_model(tf_valid_dataset,num_hidden_layers,num_conv_layers)
			#test_prediction = network_model(tf_test_dataset,num_hidden_layers,num_conv_layers)
			train_prediction = network_model(tf_train_dataset,num_hidden_layers,num_conv_layers)
			
                        
			def train_model(num_steps=num_training_steps):
				'''Train the model with minibatches in a tensorflow session'''
				with tf.Session(graph=self.graph) as session:
					tf.initialize_all_variables().run()
					print 'Initializing variables...'


					for step in range(num_steps):
						offset = (step * batch_size) % (self.train_Y.shape[0] - batch_size)
						batch_data = self.train_X[offset:(offset + batch_size), :, :]
						batch_labels = self.train_Y[offset:(offset + batch_size), :]
						#print batch_labels
						# Data to feed into the placeholder variables in the tensorflow graph
						feed_dict = {tf_train_batch : batch_data, tf_train_labels : batch_labels, 
									 dropout_keep_prob: dropout_prob}
						_, l, predictions = session.run(
						  [optimizer, loss, batch_prediction], feed_dict=feed_dict)
						if (step % 100 == 0):
							train_preds = session.run(train_prediction, feed_dict={tf_train_dataset: self.train_X,
																		   dropout_keep_prob : 1.0})
							val_preds = session.run(valid_prediction, feed_dict={dropout_keep_prob : 1.0})
							#test_preds = session.run(test_prediction, feed_dict={tf_test_dataset: self.test_X, dropout_keep_prob : 1.0})

							val_error = accuracy(val_preds, self.val_Y)
							train_error = accuracy(train_preds, self.train_Y)
							print ''
							print('Batch loss at step %d: %f' % (step, l))
							print('Batch training Error: %.1f' % accuracy(predictions, batch_labels))
							print('Validation Error: %.1f' % val_error)
							#print('Test Error: %.1f' % accuracy(test_preds, self.test_Y))
							print('Full train Error: %.1f' % train_error)
							
							if math.isnan(l) or math.isinf(l):
								results = {'train_mse': -1,'val_mse': -1}
								return results
					results = {'train_mse': train_error,'val_mse': val_error}
					return results
                                
			# save train model function so it can be called later
			self.train_model = train_model
			#for key, value in results.iteritems() :
                        #        print (key,', '.join(map(str, value)))
                        #        for y in results[x]:
                        #                print (y,', '.join(map(str, results[x][y])))

			

	def load_pickled_dataset(self, pickle_file):
		print "Loading datasetsc..."
		with open(pickle_file, 'rb') as f:
			save = pickle.load(f)
			self.train_X = save['train_data']
			self.train_Y = save['train_labels']
			self.val_X = save['val_data']
			self.val_Y = save['val_labels']

			if INCLUDE_TEST_SET:
				self.test_X = save['test_data']
				self.test_Y = save['test_labels']
			del save  # hint to help gc free up memory
		print 'Training set', self.train_X.shape, self.train_Y.shape
		print 'Validation set', self.val_X.shape, self.val_Y.shape
		if INCLUDE_TEST_SET: print 'Test set', self.test_X.shape, self.test_Y.shape

	

def weight_decay_penalty(weights, penalty):
	return penalty * sum([tf.nn.l2_loss(w) for w in weights])

def accuracy(predictions, labels):
  #print predictions.shape
  print labels.shape
  #print predictions-labels
  return np.mean(np.sum(np.square(predictions-labels),axis=1))

if __name__ == '__main__':
	invariance = False
	if len(sys.argv) > 1 and sys.argv[1] == 'invariance':
		print "Testing finished model on invariance datasets!"
		invariance = True
	
	t1 = time.time()
	conv_net = ArtistConvNet(invariance=invariance)
	conv_net.train_model()
	t2 = time.time()
	print "Finished training. Total time taken:", t2-t1
