# This code describes the implementation of Tailored-MRF reconstruction using TensorFlow

# Import libraries
import numpy as np
import h5py
import matplotlib.pyplot as plt
import tensorflow as tf
from tensorflow.python.framework import ops
from tf_utils import load_dataset, random_mini_batches, convert_to_one_hot, predict
from tmrf_utils_vox import get_minibatches, create_placeholders, initialize_parameters, forward_propagation, compute_cost
import scipy.io as sio
import pickle

# Implement the NN model

def model(learning_rate = 0.0001,
          num_epochs = 1000, minibatch_size = 200, print_cost = True):

    ops.reset_default_graph()                         # to be able to rerun the model without overwriting tf variables
    tf.set_random_seed(1)                             # to keep consistent results
    seed = 3                                          # to keep consistent results
    (n_x) = 673 #Hardcoded for now # Input size
    m = 10000    #Hardcoded for now # Number of examples
    n_y = 1    #Hardcoded for now # Output size
    costs = []                                        # To keep track of the cost

    X, Y = create_placeholders(n_x, n_y)

    parameters = initialize_parameters()

# Build forward propagation in the TensorFlow graph
    Z3 = forward_propagation(X, parameters)

# Add cost function to TensorFlow graph
    cost = compute_cost(Z3, Y)

# Back propagation: Define TensorFlow Optimizer
    optimizer = tf.train.AdamOptimizer(learning_rate = learning_rate).minimize(cost)

# Tensorflow model saver

    saver = tf.train.Saver()

# Global initialize
    init = tf.global_variables_initializer()

# Start the session to compute TensorFlow graph

    with tf.Session() as sess:

        # Run the initialization
        sess.run(init)

        # Do the training loop
        for epoch in range(num_epochs):

            epoch_cost = 0.  # Defines a cost related to an epoch
            num_minibatches = int(m / minibatch_size)  # number of minibatches of size minibatch_size in the train set
            seed = seed + 1
            for i in range(0,(num_minibatches)):
                minibatch_Data, minibatch_GT = get_minibatches(i, m, minibatch_size)

                # IMPORTANT: The line that runs the graph on a minibatch.

                _, minibatch_cost = sess.run([optimizer, cost], feed_dict={X: minibatch_Data, Y: minibatch_GT})

                epoch_cost += minibatch_cost / num_minibatches
                #del minibatch_Data, minibatch_GT
            # Print the cost every epoch
            if print_cost == True and epoch % 2 == 0:
                print("Cost after epoch %i: %f" % (epoch, epoch_cost))
            if print_cost == True and epoch % 5 == 0:
                costs.append(epoch_cost)

        # plot the cost
        plt.plot(np.squeeze(costs))
        plt.ylabel('cost')
        plt.xlabel('iterations (per tens)')
        plt.title("Learning rate =" + str(learning_rate))
        plt.show()
        # lets save the parameters in a variable
        parameters = sess.run(parameters)
        print("Parameters have been trained!")

        # Calculate the correct predictions
        #correct_prediction = tf.equal(tf.argmax(Z3), tf.argmax(Y))# need a better metric for accuracy

        # Calculate accuracy on the test set
        Z3 = forward_propagation(X, parameters)
        accuracy = compute_cost(Z3, Y)

        print("Train Accuracy:", accuracy)
        saver.save(sess,'C:/Users/VINEET/PycharmProjects/TMRF_Recon_Test/DNN_net_proper_T2')
        return parameters
parameters = model()
#np.save('/home/indiamr/PycharmProjects/TMRF_Test/parameters_fp2',parameters)





