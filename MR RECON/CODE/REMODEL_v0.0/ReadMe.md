# REMODEL details

This project implements neural network for image reconstruction from kspace in [Tensorflow](https://github.com/tensorflow/tensorflow/) . 

# Project overview

The aim of this study was to develop and demonstrate a supervised learning algorithm to reconstruct MR images acquired in highly in-homogeneous
magnetic fields. Brain images were used to train a deep neural network. This was performed for image sizes of 32 x 32 and 64 x 64. Results obtained
demonstrate REMODEL’s ability to reconstruct the images obtained in in-homogeneous magnetic fields of up to ±50 kHz with high fidelity. The root-
mean-square-error for these reconstructions compared to the uncorrupted ground truth was lesser than 0.15 and significantly lesser than the
corrupted images.


The main file of the project is *REMODEL.py*, which contains code for dataset loading, training the model and saving the model to working directory

Finally, there are several folders:
- TestData contains preprocessed dataset, which are only test images as numpy array(Please note that current model implementation is supposed to work with at least 64x64 k-space images.)
- chkPoint contains the trained weights for verification.

# Model architecture
<center>
<img src="https://github.com/mirc-dsi/IMRI-MIRC/tree/master/MR%20RECON/CODE/REMODEL_v0.0/images/remodel_architecture.png" >
*Figure1: a) Field maps with off resonance ±50kHz used for training b) flow chart of the REMODEL method c) REMODEL implementation with a deep neural
network architecture composed of 3 fully-connected layers (FC1 to FC3) with Relu activation function followed by 3 convolutional layer (FC3 to Image) and a
deconvolution layer with Relu activation function and adam optimizer for back propogation.*
</center>

## General overview 
Data collection and pre-processing for retrospective inhomogeneous field reconstruction: Sagittal T1 weighted and MPRAGE images from 70 subjects
were collected from the Human Connectome Project (HCP) for training the neural network. These were then converted to axial and coronal images using MeVis
Lab (Fraunhofer MeVis, Germany) to train for different orientations. All these images were rotated in 90o increments to augment the data set to generate 32000
images. Off resonance artifacts were introduced by generating 12 random field maps by creating a random 2x2 matrix which was then extrapolated to cover the
complete image area creating a smooth sinusoids as shown in figure 1a. These field maps were normalized between -1 to 1 and then multiplied by different off-
resonance ranges. Here, we assumed a read out time of 4.96ms. The training data was prepared by multiplying the kspace of the image with one of twelve
randomly selected off resonance phase maps (figure 1b).
Model architecture: The neural network used for training has 3 fully connected layers, 3 convolution layers followed by one deconvolution layer, similar to the
network in ref 4. Tensorflow (Google Inc, USA) was the computational frame work employed to train this neural network. The kspace (nxn complex) was then
reshaped to 2n x1 real valued vector and given as input to first fully connected layer (FC1). The architecture is detailed in figure 1c. All layers were activated by
Relu activation function.
Training details: We trained the network using images of size 32x32 and 64x64 with an off-resonance frequency range of ±10kHz, and ±30k and ±50kHz
respectively. Adam optimizer was used with mini batches of size 128, learning rate 10 . We used Xavier initialization for weights and applied mini batch
normalization across layers. The loss function used for training was mean squared loss between the network output and target image intensity values with an
additional L norm and regularization value of ?=10 . Each network was trained for 600 epochs using 2 GetForce GTX 1080 Ti GPUs with 11GB memory
capacity each. The performance of the resulting network was tested using the images downloaded from HCP that were not included for training, corrupted with
random field maps.

#Preliminary Data

<center>
<img src="https://github.com/mirc-dsi/IMRI-MIRC/tree/master/MR%20RECON/CODE/REMODEL_v0.0/images/figure1.png" >
*Figure 2a shows the 64x64 coronal image corrupted by ±30kHz off-resonance. The figure shows the blurring (red arrow) and pixel shifting (yellow) due to
inhomogeneity. It can be observed in figure 2b that these artifacts are significantly removed by REMODEL. The line intensity profiles in figure 2d are similar to
those shown for GT*
</center>

#Acknowledgements
This work was supported by grant funding from DST/VGST/KFIST/LII/GRD333.

#References
1. Bernstein, Matt A., Kevin F. King, and Xiaohong Joe Zhou. Handbook of MRI pulse sequences. Elsevier, 2004.
2. http://www.humanconnectomeproject.org/
3. Nylund, Andreas. "Off-resonance correction for magnetic resonance imaging with spiral trajectories." (2014).
4. Zhu, Bo, Jeremiah Z. Liu, Bruce R. Rosen, and Matthew S. Rosen. "Image reconstruction by domain transform manifold learning." arXiv preprint
arXiv:1704.08841 (2017).
5. https://github.com/mirc-dsi/IMRI-MIRC/tree/master/MR%20RECON/CODE/REMODEL_v0.0
