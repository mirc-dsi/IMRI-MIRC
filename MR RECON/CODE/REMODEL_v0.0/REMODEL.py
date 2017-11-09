# -*- coding: utf-8 -*-
"""
Created on Mon Sep 11 10:46:35 2017

@author: Punith BV ,Asha KK
"""

import matplotlib.pyplot as plt
import tensorflow as tf
import numpy as np
#from sklearn.metrics import confusion_matrix
import time
from datetime import timedelta
import math

#from tf_utils1 import *
#from fieldMaps import loadNaturalImages,loadTestImages

#rest tf graph
tf.reset_default_graph()
#end reset

tf.__version__

# Convolutional Layer 1.
filter_size1 = 5        # Convolution filters are 5 x 5 pixels.
num_filters1 = 64         # There are 16 of these filters.

# Convolutional Layer 2.
filter_size2 = 5     # Convolution filters are 5 x 5 pixels.
num_filters2 = 64         # There are 36 of these filters.

# Convolutional Layer 2.
filter_size3 = 5        # Convolution filters are 5 x 5 pixels.
num_filters3 = 64         # There are 36 of these filters.

# Convolutional Layer 2.
filter_size4 = 5        # Convolution filters are 5 x 5 pixels.
num_filters4 = 64         # There are 36 of these filters.


img_size = 64
# Fully-connected layer.
fc_size = img_size*img_size             # Number of neurons in fully-connected layer.


num_classes = img_size*img_size

X_train_orig = np.load("X_train_orig_64.npy")
Y_train_orig = np.load("Y_train_orig_64.npy")

#X_test_orig = np.load("X_test_orig_64.npy")
#Y_test_orig = np.load("Y_test_orig_64.npy")
#X_train_orig,Y_train_orig = loadNaturalImages("D:\\Applications\\OffResonance\\Data\\ImageNET\\NaturalImages",img_size)

#X_test_orig,Y_test_orig = loadTestImages("/Data/OffResonance/TestImages",img_size)



print (X_train_orig.shape , Y_train_orig.shape)
X_train_flatten = X_train_orig.reshape(X_train_orig.shape[0], -1).T
#X_test_flatten = X_test_orig.reshape(X_test_orig.shape[0],-1).T

X_test = X_train_flatten
Y_test = Y_train_orig
X_train = X_train_flatten
Y_train = Y_train_orig

print ("Shape of the X_train",X_train.shape)
print ("Shape of the Y_train",Y_train.shape)

print ("Shape of the X_train",X_test.shape)
print ("Shape of the Y_train",Y_test.shape)



# Images are stored in one-dimensional arrays of this length.
img_size_flat = img_size * img_size

# Tuple with height and width of images used to reshape arrays.
img_shape = (img_size, img_size)

# Number of  channels for the images: 1 channel for real and 1 for imaginary.
num_channels = 1

 




def new_weights(shape, name):
    return tf.get_variable(name, shape, initializer=tf.contrib.layers.xavier_initializer())
    #tf.Variable(tf.truncated_normal(shape, stddev=0.05))

def new_biases(length):
    return tf.Variable(tf.constant(0.05, shape=[length]))

# This flag is used to allow/prevent batch normalization params updates
# depending on whether the model is being trained or used for prediction.
training = tf.placeholder_with_default(True, shape=())

def new_conv_layer(input,              # The previous layer.
                   num_input_channels, # Num. channels in prev. layer.
                   filter_size,        # Width and height of each filter.
                   num_filters,        # Number of filters.
                   use_pooling=True,name = 'W'):  # Use 2x2 max-pooling.

    # Shape of the filter-weights for the convolution.
    # This format is determined by the TensorFlow API.
    shape = [filter_size, filter_size, num_input_channels, num_filters]

    # Create new weights aka. filters with the given shape.
    weights = new_weights(shape=shape, name = name)

    # Create new biases, one for each filter.
    biases = new_biases(length=num_filters)

    # Create the TensorFlow operation for convolution.
    # Note the strides are set to 1 in all dimensions.
    # The first and last stride must always be 1,
    # because the first is for the image-number and
    # the last is for the input-channel.
    # But e.g. strides=[1, 2, 2, 1] would mean that the filter
    # is moved 2 pixels across the x- and y-axis of the image.
    # The padding is set to 'SAME' which means the input image
    # is padded with zeroes so the size of the output is the same.
    layer = tf.nn.conv2d(input=input,
                         filter=weights,
                         strides=[1, 1, 1, 1],
                         padding='SAME')

    # Add the biases to the results of the convolution.
    # A bias-value is added to each filter-channel.
    layer += biases

    # Use pooling to down-sample the image resolution?
    if use_pooling:
        # This is 2x2 max-pooling, which means that we
        # consider 2x2 windows and select the largest value
        # in each window. Then we move 2 pixels to the next window.
        layer = tf.nn.max_pool(value=layer,
                               ksize=[1, 2, 2, 1],
                               strides=[1, 2, 2, 1],
                               padding='SAME')

    #Batch Normalization.
    cnn_bn = tf.contrib.layers.batch_norm(layer,
    data_format='NHWC',  # Matching the "cnn" tensor which has shape (?, 480, 640, 128).
    center=True,
    scale=True,
    is_training=training)
    
    # Rectified Linear Unit (ReLU).
    # It calculates max(x, 0) for each input pixel x.
    # This adds some non-linearity to the formula and allows us
    # to learn more complicated functions.
    layer = tf.nn.relu(cnn_bn)

    # Note that ReLU is normally executed before the pooling,
    # but since relu(max_pool(x)) == max_pool(relu(x)) we can
    # save 75% of the relu-operations by max-pooling first.

    # We return both the resulting layer and the filter-weights
    # because we will plot the weights later.
    return layer, weights

def new_deconv_layer(input,              # The previous layer.
                   num_input_channels, # Num. channels in prev. layer.
                   filter_size,        # Width and height of each filter.
                   num_filters,        # Number of filters.
                   use_pooling=True,name = 'W'):  # Use 2x2 max-pooling.

    # Shape of the filter-weights for the convolution.
    # This format is determined by the TensorFlow API.
    shape = [filter_size, filter_size, num_input_channels, num_filters]

    # Create new weights aka. filters with the given shape.
    weights = new_weights(shape=shape, name = name)

    # Create new biases, one for each filter.
    biases = new_biases(length=num_input_channels)
    outShape= tf.stack([tf.shape(x_image)[0],img_size,img_size,num_input_channels])
    # Create the TensorFlow operation for convolution.
    # Note the strides are set to 1 in all dimensions.
    # The first and last stride must always be 1,
    # because the first is for the image-number and
    # the last is for the input-channel.
    # But e.g. strides=[1, 2, 2, 1] would mean that the filter
    # is moved 2 pixels across the x- and y-axis of the image.
    # The padding is set to 'SAME' which means the input image
    # is padded with zeroes so the size of the output is the same.
    layer = tf.nn.conv2d_transpose(input,
                         filter=weights,
                         strides=[1, 1, 1, 1],
                         output_shape=outShape,padding = 'SAME')

    # Add the biases to the results of the convolution.
    # A bias-value is added to each filter-channel.
    layer += biases
    layer.set_shape([None,img_size,img_size,num_input_channels])
    print("layer shape",layer.shape)
    # Use pooling to down-sample the image resolution?
   
    #Batch Normalization.
    cnn_bn = tf.contrib.layers.batch_norm(layer,
    data_format='NHWC',  # Matching the "cnn" tensor which has shape (?, 480, 640, 128).
    center=True,
    scale=True,
    is_training=training)
    print(" bdecnn layer shape",cnn_bn.shape)
    # Rectified Linear Unit (ReLU).
    # It calculates max(x, 0) for each input pixel x.
    # This adds some non-linearity to the formula and allows us
    # to learn more complicated functions.
    layer = tf.nn.relu(cnn_bn)

    # Note that ReLU is normally executed before the pooling,
    # but since relu(max_pool(x)) == max_pool(relu(x)) we can
    # save 75% of the relu-operations by max-pooling first.

    # We return both the resulting layer and the filter-weights
    # because we will plot the weights later.
    return layer, weights

def flatten_layer(layer):
    # Get the shape of the input layer.
    layer_shape = layer.get_shape()

    # The shape of the input layer is assumed to be:
    # layer_shape == [num_images, img_height, img_width, num_channels]

    # The number of features is: img_height * img_width * num_channels
    # We can use a function from TensorFlow to calculate this.
    num_features = layer_shape[1:4].num_elements()
    
    # Reshape the layer to [num_images, num_features].
    # Note that we just set the size of the second dimension
    # to num_features and the size of the first dimension to -1
    # which means the size in that dimension is calculated
    # so the total size of the tensor is unchanged from the reshaping.
    layer_flat = tf.reshape(layer, [-1, num_features])

    # The shape of the flattened layer is now:
    # [num_images, img_height * img_width * num_channels]

    # Return both the flattened layer and the number of features.
    return layer_flat, num_features


def new_fc_layer(input,          # The previous layer.
                 num_inputs,     # Num. inputs from prev. layer.
                 num_outputs,    # Num. outputs.
                 use_relu=True, name = 'FC'): # Use Rectified Linear Unit (ReLU)?

    # Create new weights and biases.
    weights = new_weights(shape=[num_inputs, num_outputs], name = name)
    biases = new_biases(length=num_outputs)

    # Calculate the layer as the matrix multiplication of
    # the input and weights, and then add the bias-values.
    layer = tf.matmul(input, weights) + biases

    # Use ReLU?
    if use_relu:
        layer = tf.nn.relu(layer)

    return layer






y_true = tf.placeholder(tf.float32, shape=[None, num_classes], name='y_true')


x = tf.placeholder(tf.float32, shape=[None, 2*img_size_flat], name='x')

x_image = tf.reshape(x, [-1, 2*img_size_flat])


layer_fc1 = new_fc_layer(input=x_image,
                         num_inputs=2*img_size_flat,
                         num_outputs=fc_size,
                         use_relu=True, name = 'layer_fc1')

layer_fc1

layer_fc2 = new_fc_layer(input=layer_fc1,
                         num_inputs=fc_size,
                         num_outputs=num_classes,
                         use_relu=True, name = 'layer_fc2')

layer_fc2

layer_fc3 = new_fc_layer(input=layer_fc2,
                         num_inputs=fc_size,
                         num_outputs=num_classes,
                         use_relu=True, name = 'layer_fc3')

layer_fc3

#x = tf.placeholder(tf.float32, shape=[None, img_size_flat], name='x')

x_image1 = tf.reshape(layer_fc3, [-1, img_size, img_size, num_channels])


layer_conv1, weights_conv1 = \
    new_conv_layer(input=x_image1,
                   num_input_channels=num_channels,
                   filter_size=filter_size1,
                   num_filters=num_filters1,
                   use_pooling=False,name = 'weights_conv1')

layer_conv1    

layer_conv2, weights_conv2 = \
    new_conv_layer(input=layer_conv1,
                   num_input_channels=num_filters1,
                   filter_size=filter_size2,
                   num_filters=num_filters2,
                   use_pooling=False, name = 'weights_conv2')
    
layer_conv2

layer_conv3, weights_conv3 = \
    new_conv_layer(input=layer_conv2,
                   num_input_channels=num_filters2,
                   filter_size=filter_size3,
                   num_filters=num_filters3,
                   use_pooling=False, name = 'weights_conv3')
    
layer_conv3

layer_deconv1, weights_deconv1 = \
    new_deconv_layer(input=layer_conv3,
                   num_input_channels=num_channels,
                   filter_size=filter_size3,
                   num_filters=num_filters3,
                   use_pooling=False, name = 'weights_dconv1')
    
layer_deconv1

layer_flat, num_features = flatten_layer(layer_deconv1)

layer_flat



y_pred = layer_flat #tf.nn.relu(layer_fc4) 

y_pred_cls = y_pred 

beta = 0.001
def compute_cost(Z3, Y):
    """
    Computes the cost
    
    Arguments:
    Z3 -- output of forward propagation (output of the last LINEAR unit)
    Y -- "true" labels vector placeholder, same shape as Z3
    
    Returns:
    cost - Tensor of the cost function
    """
    
    logits = tf.transpose(Z3)
    labels = tf.transpose(Y)
    cost = tf.reduce_mean(tf.square(logits-labels))
    ### START CODE HERE ### (1 line of code)
    #cost = tf.reduce_mean(tf.nn.softmax_cross_entropy_with_logits(logits = logits, labels = labels))    
    regularizer2 = beta * tf.nn.l2_loss(weights_conv3)
    regularizer3 = beta * tf.nn.l2_loss(weights_conv2)
    regularizer4 = beta * tf.nn.l2_loss(weights_conv1)    
    
    cost = tf.reduce_mean(0.5*tf.square(logits-labels) +  regularizer2 + regularizer3 + regularizer4)    
    #cost = tf.reduce_mean(tf.square(Z3-Y))        
    return cost

cost = compute_cost(y_pred_cls, y_true)



optimizer = tf.train.AdamOptimizer(learning_rate=0.001).minimize(cost)
optimizer1 = tf.train.AdamOptimizer(learning_rate=1e-4).minimize(cost)



session = tf.Session()

session.run(tf.global_variables_initializer())

train_batch_size = 64

# Counter for total number of iterations performed so far.
total_iterations = 0



def random_mini_batches(X, Y, mini_batch_size = 64, seed = 0):

    
    m = X.shape[1]                  # number of training examples
    mini_batches = []
    #np.random.seed(seed)
    
    # Step 1: Shuffle (X, Y)
    permutation = list(np.random.permutation(m))
    shuffled_X = X[:, permutation]
    shuffled_Y = Y[:, permutation].reshape((Y.shape[0],m))

    # Step 2: Partition (shuffled_X, shuffled_Y). Minus the end case.
    num_complete_minibatches = int(math.floor(m/mini_batch_size)) # number of mini batches of size mini_batch_size in your partitionning
    for k in range(0, num_complete_minibatches):
        mini_batch_X = shuffled_X[:, k * mini_batch_size : k * mini_batch_size + mini_batch_size]
        mini_batch_Y = shuffled_Y[:, k * mini_batch_size : k * mini_batch_size + mini_batch_size]
        mini_batch = (mini_batch_X, mini_batch_Y)
        mini_batches.append(mini_batch)
    
    # Handling the end case (last mini-batch < mini_batch_size)
    if m % mini_batch_size != 0:
        mini_batch_X = shuffled_X[:, num_complete_minibatches * mini_batch_size : m]
        mini_batch_Y = shuffled_Y[:, num_complete_minibatches * mini_batch_size : m]
        mini_batch = (mini_batch_X, mini_batch_Y)
        mini_batches.append(mini_batch)
    
    return mini_batches


 # Allocate an array for the predicted classes which
    # will be calculated in batches and filled into this array.
cls_pred_train = np.zeros(shape=(num_classes,X_train.shape[1]), dtype=np.float32)
cls_pred_test = np.zeros(shape=(num_classes,X_test.shape[1]), dtype=np.float32)
test_batch_size=1
def Evaluate_Train_Results():

    print ("Shape of the X_train Data",X_train.shape)    
    num_test = X_train.shape[1]

    # Now calculate the predicted classes for the batches.
    # We will just iterate through all the batches.
    # There might be a more clever and Pythonic way of doing this.

    # The starting index for the next batch is denoted i.
    i = 0
    
    while i < num_test:
    
        j = min(i + test_batch_size, num_test)

        # Get the images from the test-set between index i and j.
        images = X_train[:,i:j].T

        # Get the associated labels.
        labels = Y_train[:,i:j].T

        # Create a feed-dict with these images and labels.
        feed_dict = {x: images,
                     y_true: labels}

        # Calculate the predicted class using TensorFlow.
        train_res = session.run(y_pred_cls, feed_dict=feed_dict)
        cls_pred_train[:,i:j] = train_res.T

        # Set the start-index for the next batch to the
        # end-index of the current batch.
        i = j

    # Convenience variable for the true class-numbers of the test-set.
    print ("*****************************END***************************")
    print ("Shape of cls_pred_train",cls_pred_train.shape)
   
def Evaluate_Test_Results():
     print ("Shape of the X_train Data",X_test.shape)
     num_test = X_test.shape[1]

    # Now calculate the predicted classes for the batches.
    # We will just iterate through all the batches.
    # There might be a more clever and Pythonic way of doing this.

    # The starting index for the next batch is denoted i.
     i = 0
    
     while i < num_test:
    
        j = min(i + test_batch_size, num_test)

        # Get the images from the test-set between index i and j.
        images = X_test[:,i:j].T

        # Get the associated labels.
        labels = Y_test[:,i:j].T

        # Create a feed-dict with these images and labels.
        feed_dict = {x: images}

        # Calculate the predicted class using TensorFlow.
        test_res = session.run(y_pred_cls, feed_dict=feed_dict)
        cls_pred_test[:,i:j] = test_res.T

        # Set the start-index for the next batch to the
        # end-index of the current batch.
        i = j
     print ("Shape of cls_pred_test",cls_pred_test.shape)
     pass

saver = tf.train.Saver()

def optimize(num_iterations):
    # Ensure we update the global variable rather than a local copy.
    global total_iterations

    # Start-time used for printing time-usage below.
    start_time = time.time()
    seed = 3
    costs = [] 
    for i in range(total_iterations,
                   total_iterations + num_iterations):

        # Get a batch of training examples.
        # x_batch now holds a batch of images and
        # y_true_batch are the true labels for those images.
        #x_batch, x_batch = data.train.next_batch(train_batch_size)
        seed = seed + 1
        epoch_cost = 0.  
        mini_batches = random_mini_batches(X_train, Y_train, train_batch_size, seed)
        
        num_minibatches = len(mini_batches)
        for minibatch in mini_batches:
            (x_batch, y_true_batch) = minibatch
            
            x_batch = x_batch.T
            y_true_batch = y_true_batch.T
       
            # Put the batch into a dict with the proper names
            # for placeholder variables in the TensorFlow graph.
            feed_dict_train = {x: x_batch,
                               y_true: y_true_batch}

            # Run the optimizer using this batch of training data.
            # TensorFlow assigns the variables in feed_dict_train
            # to the placeholder variables and then runs the optimizer.
            if i<5000:
                _ , minibatch_cost = session.run([optimizer,cost], feed_dict=feed_dict_train)
            else:
                 _ , minibatch_cost = session.run([optimizer1,cost], feed_dict=feed_dict_train)
            
            epoch_cost += minibatch_cost / num_minibatches
            # Print the cost every 100 epoch
        if  i % 100 == 0:
                print ("Cost after epoch %i: %f" % (i, epoch_cost))
        if  i % 5 == 0:
                costs.append(epoch_cost)
        
    total_iterations += num_iterations

    # Ending time.
    end_time = time.time()

    # Difference between start and end-times.
    time_dif = end_time - start_time

    # Print the time-usage.
    print("Time usage: " + str(timedelta(seconds=int(round(time_dif)))))
    



#saver.restore(session, "/Data/OffResonance/CNN/64x64_head/tmpDF400_100Kdf/model.ckpt")
optimize(num_iterations=1)    




optimize(num_iterations=200) # We already performed 1 iteration above.
X_train = X_train
Y_train = Y_train

Evaluate_Train_Results()
Evaluate_Test_Results()
saver.save(session, "/Data/OffResonance/CNN/64x64_head_unseen/tmpDF400_100Kdf/model.ckpt")
#save_path = saver.save(session, "/tmp/model.ckpt")
result = cls_pred_test[:,2:3] # To display 3rd image
plt.imshow(result.reshape(img_size,img_size))






def plot_conv_weights(weights, input_channel=0):
    # Assume weights are TensorFlow ops for 4-dim variables
    # e.g. weights_conv1 or weights_conv2.
    
    # Retrieve the values of the weight-variables from TensorFlow.
    # A feed-dict is not necessary because nothing is calculated.
    w = session.run(weights)

    # Get the lowest and highest values for the weights.
    # This is used to correct the colour intensity across
    # the images so they can be compared with each other.
    w_min = np.min(w)
    w_max = np.max(w)

    # Number of filters used in the conv. layer.
    num_filters = w.shape[3]

    # Number of grids to plot.
    # Rounded-up, square-root of the number of filters.
    num_grids = math.ceil(math.sqrt(num_filters))
    
    # Create figure with a grid of sub-plots.
    fig, axes = plt.subplots(num_grids, num_grids)

    # Plot all the filter-weights.
    for i, ax in enumerate(axes.flat):
        # Only plot the valid filter-weights.
        if i<num_filters:
            # Get the weights for the i'th filter of the input channel.
            # See new_conv_layer() for details on the format
            # of this 4-dim tensor.
            img = w[:, :, input_channel, i]

            # Plot image.
            ax.imshow(img, vmin=w_min, vmax=w_max,
                      interpolation='nearest', cmap='seismic')
        
        # Remove ticks from the plot.
        ax.set_xticks([])
        ax.set_yticks([])
    
    # Ensure the plot is shown correctly with multiple plots
    # in a single Notebook cell.
    plt.show()


def plot_conv_layer(layer, image):
    # Assume layer is a TensorFlow op that outputs a 4-dim tensor
    # which is the output of a convolutional layer,
    # e.g. layer_conv1 or layer_conv2.

    # Create a feed-dict containing just one image.
    # Note that we don't need to feed y_true because it is
    # not used in this calculation.
    feed_dict = {x: [image]}

    # Calculate and retrieve the output values of the layer
    # when inputting that image.
    values = session.run(layer, feed_dict=feed_dict)

    # Number of filters used in the conv. layer.
    num_filters = values.shape[3]

    # Number of grids to plot.
    # Rounded-up, square-root of the number of filters.
    num_grids = math.ceil(math.sqrt(num_filters))
    
    # Create figure with a grid of sub-plots.
    fig, axes = plt.subplots(num_grids, num_grids)

    # Plot the output images of all the filters.
    for i, ax in enumerate(axes.flat):
        # Only plot the images for valid filters.
        if i<num_filters:
            # Get the output image of using the i'th filter.
            # See new_conv_layer() for details on the format
            # of this 4-dim tensor.
            img = values[0, :, :, i]

            # Plot image.
            ax.imshow(img, interpolation='nearest', cmap='binary')
        
        # Remove ticks from the plot.
        ax.set_xticks([])
        ax.set_yticks([])
    
    # Ensure the plot is shown correctly with multiple plots
    # in a single Notebook cell.
    plt.show()

def plot_image(image):
    plt.imshow(image.reshape(img_shape),
               interpolation='nearest',
               cmap='gray')
    plt.show()




#image1 = X_train[0]
#plot_image(np.abs(np.fft.ifft2(np.reshape((image1[0:num_classes:1]),(img_size,img_size)) + np.reshape((image1[0:num_classes:1]),(img_size,img_size))*1j )))
#
#
#image2 = X_train[1]
#
#plot_image(np.abs(np.fft.ifft2(np.reshape((image2[0:num_classes:1]),(img_size,img_size)) + np.reshape((image2[0:num_classes:1]),(img_size,img_size))*1j )))
#
#plot_conv_weights(weights=weights_conv1)
#
#plot_conv_layer(layer=layer_conv1, image=image1)
#
#plot_conv_layer(layer=layer_conv1, image=image2)
#
#plot_conv_weights(weights=weights_conv2, input_channel=0)
#
#plot_conv_weights(weights=weights_conv2, input_channel=1)
#
#plot_conv_layer(layer=layer_conv2, image=image1)
#
#plot_conv_layer(layer=layer_conv2, image=image2)
#
#plot_conv_layer(layer=layer_conv3, image=image1)
#
#plot_conv_layer(layer=layer_conv3, image=image2)


    
