# This file includes all the functions required for running the DNN script for TMRF
# Author: Vineet V Bhombore

import numpy as np
import h5py
import math
import matplotlib.pyplot as plt
import tensorflow as tf
from tensorflow.python.framework import ops
from tf_utils import load_dataset, random_mini_batches, convert_to_one_hot, predict
import scipy.io as sio
import pickle

# Load Data and GT
def get_minibatches(i, m, mini_batch_size):

    # Read Data
    with h5py.File('C:/Users/VINEET/PycharmProjects/TMRF_Recon_Test/Data_vox.mat', 'r') as g:
        Data = g['Data_vox'][:]
    #Data = np.absolute(Data)
    #Data = np.transpose(Data)
    #Data = np.reshape(Data, (689152, 9000))  # Use if data is not of the mentioned dimension

    # Read GT
    with h5py.File('C:/Users/VINEET/PycharmProjects/TMRF_Recon_Test/T2_vox.mat', 'r') as f:
        GT = f['T2_vox'][:]  # column should be examples - 2nd dimension
    GT = GT/250
    #GT = np.transpose(GT)
    #GT = np.reshape(GT,(1,10000))
    #GT = GT[:,None]
    #GT = np.reshape(GT, (1024, 9000))  # Use if data is not of the mentioned dimension

    # Normalize Data
    mean_Data = np.mean(Data)
    std_Data = np.std(Data)
    Data = (Data - mean_Data) / std_Data

    # Prints every time the function gets called! Should find another way to convey this info
    #print("Mean of Data: ", mean_Data) #
    #print("STD of Data: ", std_Data)  # Need this for forward prop
    # Print the size of variables and number of training examples
    #print("Data size = ", str(Data.shape))
    #print("GT size = ", str(GT.shape))
    #print("Number of training examples = ", str(Data.shape[1]))

    # Create minibatches
    num_complete_minibatches = math.floor(m/mini_batch_size)
    minibatch_Data = Data[:,i*mini_batch_size : i*mini_batch_size + mini_batch_size]
    minibatch_GT = GT[:,i * mini_batch_size: i * mini_batch_size + mini_batch_size]

    if m % mini_batch_size != 0:
        minibatch_Data = Data[:,num_complete_minibatches * mini_batch_size: m]
        minibatch_GT = GT[:,num_complete_minibatches * mini_batch_size: m]

    return minibatch_Data, minibatch_GT

def create_placeholders(n_x, n_y):

    X = tf.placeholder(tf.float32, shape=[n_x, None], name="n_x")#Symbolic math that creates placeholders for the variables which will take values later on
    Y = tf.placeholder(tf.float32, shape=[n_y, None], name="n_y")

    return X, Y

#X, Y = create_placeholders(689152, 1024)#These numbers could be declared as inputs at the beginning of the program - get this from the loaded data of input and output

# Initialize parameters
def initialize_parameters():

    tf.set_random_seed(1)
    W1 = tf.get_variable("W1", [64,673], initializer = tf.contrib.layers.xavier_initializer(seed = 1))
    b1 = tf.get_variable("b1", [64,1], initializer = tf.zeros_initializer())
    W2 = tf.get_variable("W2", [32,64], initializer = tf.contrib.layers.xavier_initializer(seed = 1))
    b2 = tf.get_variable("b2", [32,1], initializer = tf.zeros_initializer())
    W3 = tf.get_variable("W3", [1,32], initializer = tf.contrib.layers.xavier_initializer(seed = 1))
    b3 = tf.get_variable("b3", [1,1], initializer = tf.zeros_initializer())

    parameters = {"W1": W1,
                  "b1": b1,
                  "W2": W2,
                  "b2": b2,
                  "W3": W3,
                  "b3": b3}

    return parameters

# Forward Propagation
def forward_propagation(X, parameters):

    W1 = parameters['W1']
    b1 = parameters['b1']
    W2 = parameters['W2']
    b2 = parameters['b2']
    W3 = parameters['W3']
    b3 = parameters['b3']

    Z1 = tf.add(tf.matmul(W1,X),b1)
    A1 = tf.nn.relu(Z1)
    #print(np.shape(A1))
    Z2 = tf.add(tf.matmul(W2,A1),b2)
    A2 = tf.nn.relu(Z2)
    #print(np.shape(A2))
    Z3 = tf.add(tf.matmul(W3,A2),b3)
    #print(np.shape(Z3))
    return Z3


# Compute Cost
def compute_cost(Z3, Y):

    logits = tf.transpose(Z3)
    labels = tf.transpose(Y)

    cost = tf.reduce_mean(tf.square(Z3 - Y))

    return cost

