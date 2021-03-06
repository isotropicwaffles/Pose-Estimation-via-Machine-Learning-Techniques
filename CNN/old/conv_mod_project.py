import tensorflow as tf
import numpy as np
from six.moves import cPickle as pickle
import sys
import math
import time

PIXEL_WIDTH = '256'
SHAPE = 'cone'
DATA_PATH = '../../Input_Data/images/data' + PIXEL_WIDTH +'/' + SHAPE +'/'
DATA_FILE = DATA_PATH + 'art_data.pickle'
IMAGE_SIZE = 256
NUM_CHANNELS = 3
NUM_LABELS = 6
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
			batch_size = save['batch_size']
			learning_rate = save['learning_rate']
			layer1_filter_size = save['layer1_filter_size']
			layer1_depth = save['layer1_depth']
			layer1_stride = save['layer1_stride']
			layer2_filter_size = save['layer2_filter_size']
			layer2_depth = save['layer2_depth']
			layer2_stride = save['layer2_stride']
			layer3_num_hidden = save['layer3_num_hidden']
			layer4_num_hidden = save['layer4_num_hidden']
			num_training_steps = save['num_training_steps']

			# Add max pooling
			pooling = save['pooling']
			layer1_pool_filter_size = save['layer1_pool_filter_size']
			layer1_pool_stride = save['layer1_pool_stride']
			layer2_pool_filter_size = save['layer2_pool_filter_size']
			layer2_pool_stride = save['layer2_pool_stride']

			# Enable dropout and weight decay normalization
			dropout_prob = save['dropout_prob'] # set to < 1.0 to apply dropout, 1.0 to remove
			weight_penalty = save['weight_penalty'] # set to > 0.0 to apply weight penalty, 0.0 to remove

		with self.graph.as_default():
			# Input data
			tf_train_batch = tf.placeholder(
			    tf.float32, shape=(batch_size, IMAGE_SIZE, IMAGE_SIZE, NUM_CHANNELS))
			tf_train_labels = tf.placeholder(tf.float32, shape=(batch_size, NUM_LABELS))
			tf_valid_dataset = tf.constant(self.val_X)
			tf_test_dataset = tf.placeholder(
			    tf.float32, shape=[len(self.val_X), IMAGE_SIZE, IMAGE_SIZE, NUM_CHANNELS])
			tf_train_dataset = tf.placeholder(
				tf.float32, shape=[len(self.train_X), IMAGE_SIZE, IMAGE_SIZE, NUM_CHANNELS])

			# Implement dropout
			dropout_keep_prob = tf.placeholder(tf.float32)

			# Network weights/parameters that will be learned
			layer1_weights = tf.Variable(tf.truncated_normal(
				[layer1_filter_size, layer1_filter_size, NUM_CHANNELS, layer1_depth], stddev=0.1))
			layer1_biases = tf.Variable(tf.zeros([layer1_depth]))
			layer1_feat_map_size = int(math.ceil(float(IMAGE_SIZE) / layer1_stride))
			if pooling:
				layer1_feat_map_size = int(math.ceil(float(layer1_feat_map_size) / layer1_pool_stride))

			layer2_weights = tf.Variable(tf.truncated_normal(
				[layer2_filter_size, layer2_filter_size, layer1_depth, layer2_depth], stddev=0.1))
			layer2_biases = tf.Variable(tf.constant(1.0, shape=[layer2_depth]))
			layer2_feat_map_size = int(math.ceil(float(layer1_feat_map_size) / layer2_stride))
			if pooling:
				layer2_feat_map_size = int(math.ceil(float(layer2_feat_map_size) / layer2_pool_stride))

			layer3_weights = tf.Variable(tf.truncated_normal(
				[layer2_feat_map_size * layer2_feat_map_size * layer2_depth, layer3_num_hidden], stddev=0.1))
			layer3_biases = tf.Variable(tf.constant(1.0, shape=[layer3_num_hidden]))

			layer4_weights = tf.Variable(tf.truncated_normal(
			  [layer4_num_hidden, NUM_LABELS], stddev=0.1))
			layer4_biases = tf.Variable(tf.constant(1.0, shape=[NUM_LABELS]))

			# Model
			def network_model(data):
				'''Define the actual network architecture'''

				# Layer 1
				conv1 = tf.nn.conv2d(data, layer1_weights, [1, layer1_stride, layer1_stride, 1], padding='SAME')
				hidden = tf.nn.relu(conv1 + layer1_biases)

				if pooling:
					hidden = tf.nn.max_pool(hidden, ksize=[1, layer1_pool_filter_size, layer1_pool_filter_size, 1], 
									   strides=[1, layer1_pool_stride, layer1_pool_stride, 1],
                         			   padding='SAME', name='pool1')
				
				# Layer 2
				conv2 = tf.nn.conv2d(hidden, layer2_weights, [1, layer2_stride, layer2_stride, 1], padding='SAME')
				hidden = tf.nn.relu(conv2 + layer2_biases)

				if pooling:
					hidden = tf.nn.max_pool(hidden, ksize=[1, layer2_pool_filter_size, layer2_pool_filter_size, 1], 
									   strides=[1, layer2_pool_stride, layer2_pool_stride, 1],
                         			   padding='SAME', name='pool2')
				
				# Layer 3
				shape = hidden.get_shape().as_list()

				reshape = tf.reshape(hidden, [shape[0], shape[1] * shape[2] * shape[3]])
                               
				hidden = tf.nn.relu(tf.matmul(reshape, layer3_weights) + layer3_biases)
				#hidden = tf.nn.dropout(hidden, dropout_keep_prob)
				

				output = tf.matmul(hidden, layer4_weights) + layer4_biases

				return output

			# Training computation
			logits = network_model(tf_train_batch)

                        #print logits

    			
			#loss = tf.reduce_mean(tf.nn.softmax_cross_entropy_with_logits(logits, tf_train_labels))
                        loss = tf.sqrt(tf.reduce_mean(tf.square(tf.sub(tf_train_labels, logits))))


			# Add weight decay penalty
			loss = loss + weight_decay_penalty([layer3_weights, layer4_weights], weight_penalty)

			# Optimizer
			optimizer = tf.train.GradientDescentOptimizer(learning_rate).minimize(loss)

			# Predictions for the training, validation, and test data.
			batch_prediction = logits
			valid_prediction = network_model(tf_valid_dataset)
			test_prediction = network_model(tf_test_dataset)
			train_prediction = network_model(tf_train_dataset)
			
                        
			def train_model(num_steps=num_training_steps):
				'''Train the model with minibatches in a tensorflow session'''
				with tf.Session(graph=self.graph) as session:
					tf.initialize_all_variables().run()
					print 'Initializing variables...'
					l_step= list()
					l_batch_loss = list()
					l_batch_train_acc = list()
					l_val_acc = list()
					l_train_acc = list()
					l_test_acc = list()

					for step in range(num_steps):
						offset = (step * batch_size) % (self.train_Y.shape[0] - batch_size)
						batch_data = self.train_X[offset:(offset + batch_size), :, :, :]
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
							print ''
							print('Batch loss at step %d: %f' % (step, l))
							print('Batch training Error: %.1f' % accuracy(predictions, batch_labels))
							print('Validation Error: %.1f' % accuracy(val_preds, self.val_Y))
							#print('Test Error: %.1f' % accuracy(test_preds, self.test_Y))
							print('Full train Error: %.1f' % accuracy(train_preds, self.train_Y))
							l_step.append(step)
                                                        l_batch_loss.append(l)
                                                        l_batch_train_acc.append(accuracy(predictions, batch_labels))
                                                        l_val_acc.append(accuracy(val_preds, self.val_Y))
                                                        l_train_acc.append(accuracy(train_preds, self.train_Y))
                                                        #l_test_acc.append(accuracy(train_preds, self.test_Y))
                                                        #print ', '.join(map(str, l_step))
                                                        #print ', '.join(map(str, l_batch_loss))
                                                        #print ', '.join(map(str, l_batch_train_acc))
                                                        #print ', '.join(map(str, l_val_acc))
                                                        #print ', '.join(map(str, l_train_acc))
                                                        
                                        results = {'step': l_step,'batch_loss': l_batch_loss,'batch_train_acc': l_batch_train_acc,'val_acc': l_val_acc,'train_acc': l_train_acc}
                                        


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
  #print predictions
  #print labels
  #print predictions-labels
  return np.sqrt(np.sum(np.square(predictions-labels)))

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
