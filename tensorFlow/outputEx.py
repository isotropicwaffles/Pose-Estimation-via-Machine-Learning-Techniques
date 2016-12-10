import tensorflow as tf

tf.InteractiveSession()
tfc = tf.constant([1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0,9.0,10.0,11.0,12.0])
out = tf.concat(0, [tfc[0:3], tf.nn.l2_normalize(tfc[3:6], 0), tf.nn.l2_normalize(tfc[6:9], 0), tf.nn.l2_normalize(tfc[9:12], 0)])
out.eval()
print out
