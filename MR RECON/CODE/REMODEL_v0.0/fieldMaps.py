# -*- coding: utf-8 -*-
"""
Created on Fri Nov  3 19:33:15 2017

@author: punith, Asha
"""

import os
import numpy as np
import scipy
import matplotlib.pyplot as plt
from numpy import newaxis
import math 
from scipy import ndimage


g_imSize = 64

g_min = 0
g_max = 0
def fft2(img):
    return np.fft.fftshift( np.fft.fft2(img))
    
def ifft2(kspace):
    return np.fft.ifft2(kspace)


"""Get the Y Chanel from RGB Image  """
def getYChanelFromRGB(rgbImg):
    length = len(rgbImg.shape)
    if length == 2 :
        return  np.floor(np.float32(rgbImg))
    R = rgbImg[:,:,0]
    G = rgbImg[:,:,1]
    B = rgbImg[:,:,2]
    Y = np.floor(np.float32(R + G + G + B)/4);       
    return Y

fieldMaps = [[[-0.63230614,  1.50873445],[ 0.46057109,  0.27087383]],[[ 0.6029411 ,  0.5151006 ],[-1.88877809, -0.10989498]],[[ 0.39453179,  0.7759226 ],
       [-0.86426079, -0.26012656]],[[-0.78134954,  0.36716431],[-1.02705693, -0.09341335]],[[ 0.92208892,  0.27303353],[-0.67058718,  0.64394319]],[[ 1.71759939,  0.59080786],
       [-2.09786391,  0.24675302]],[[ 0.79518366,  1.06656754],[-0.59446895,  0.04134708]],[[ 0.61997795, -1.10606444],[-0.03930823,  0.0344024 ]],[[ 1.35578179,  1.53990793],
       [-1.76731253,  1.607409  ]],[[-1.00692308, -0.86053836], [-2.36886859,  1.80638158]]]

def getFieldMap():
    global g_imSize
    index = np.random.randint(0,10)
    modelList = fieldMaps[index]# [[36,1],[56,64]]
    model = np.array(modelList)
    model = scipy.misc.imresize(model,(g_imSize,g_imSize))
    model_max = np.max(model)
    model_min = np.min(model)
    dR = 20000
    model = model  - model_min
    model = model/ model_max    
    model = model*dR
    model = model - 10000    
    return model

def resizeImage(img):
    global g_imSize        
    img = scipy.misc.imresize(img,(g_imSize,g_imSize))
    return img

def loadTestImages(path,size = g_imSize):
    global g_imSize
    g_imSize = size
    dir = path
    #data=np.zeros((g_imSize,g_imSize,2))    
    X_test_data = np.zeros((0,g_imSize,g_imSize,2),dtype = "float32")
    Y_test_data = np.zeros((g_imSize*g_imSize,0),dtype = "float32")

    print (X_test_data.dtype)
    if os.path.isdir(dir) :
      for root , directories , filenames in os.walk(dir):
       for filename in filenames :
         name, file_extension = os.path.splitext(filename)          
         if file_extension.endswith('.jpg') :
           fileName = os.path.join(root,filename)                 
           img = scipy.misc.imread(fileName)     
           img = resizeImage(img)   
           #img1 = img.astype(type('float32',(float,),{})) 
           img1 = img.astype(np.float32) 
           gray = getYChanelFromRGB(img1)           
           
           model = getFieldMap()
           Res = getNormalizedImage(gray, model)   
           X_test_data = np.append(X_test_data,Res,axis = 0)
           A = np.reshape(gray,(1,np.product(gray.shape))).T           
           Y_test_data = np.append(Y_test_data,A,axis = 1)
           
           
    return X_test_data, Y_test_data



def getNormalizedImage(gray,model):
   global g_imSize , g_min , g_max
   gray = gray/255;
   
   #ph = sineWaveGeneration()
   #img_cmplx = np.multiply(gray,np.exp(1j*ph))
  
   kspace = fft2(gray)
   
   f = np.exp(2*math.pi*1j*model*0.0004096)
   kspace_cur = np.multiply(kspace,f) 

   kspaceReal = kspace_cur.real
   rmean = np.mean(kspaceReal)
   kspaceReal = (kspaceReal - rmean) / (g_max - g_min)
   
   kspaceImg = kspace_cur.imag   
   imean = np.mean(kspaceImg)
   kspaceImg = (kspaceImg - imean) / (g_max - g_min)
        
   Res=np.dstack((kspaceReal,kspaceImg))
   test = np.zeros((1,g_imSize,g_imSize,2))
   test[0,:,:,:] = Res  
   Res = test.astype(np.float32)
   return Res

def getMaxOfDataset(dir):
    global g_min,g_max
    max = 0
    min = 0
    count = 0
    if os.path.isdir(dir) :
      for root , directories , filenames in os.walk(dir):
       for filename in filenames :
         name, file_extension = os.path.splitext(filename)          
         if file_extension.endswith('.jpg') :
           fileName = os.path.join(root,filename)                  
           img1 = scipy.misc.imread(fileName)                
           img1 = resizeImage(img1)
          # print(fileName,count)
           count += 1
           #img = img1.astype(type('float32',(float,),{}))          
           img = img1.astype(np.float32)          
           gray = getYChanelFromRGB(img)          
           gray = gray/255          
           kspace = fft2(gray)
           kspaceReal = kspace.real   
           kspaceImg = kspace.imag      
           min1 = np.min(kspaceReal)
           min2 = np.min(kspaceImg)
           max1 = np.max(kspaceReal)
           max2 = np.max(kspaceImg)
           tmin = None
           tmax = None
           if min1 < min2:
               tmin = min1
           else :
               tmin = min2
           if max1 > max2:
               tmax = max1
           else :
               tmax = max2
           if tmin < min :
               min = tmin
           if tmax > max :
               max = tmax    
    g_min = min
    g_max = max
    print (g_min,g_max)
    return max ,min

def loadNaturalImages(path,size):
    global g_imSize
    g_imSize = size
    dir = path
    
    X_train_data = np.zeros((0,g_imSize,g_imSize,2),dtype = "float32")
    Y_train_data = np.zeros((g_imSize*g_imSize,0),dtype = "float32")
    count = 0
    print (X_train_data.dtype)
    if os.path.isdir(dir) :
      for root , directories , filenames in os.walk(dir):
       for filename in filenames :
         name, file_extension = os.path.splitext(filename)          
         if file_extension.endswith('.jpg') :
           fileName = os.path.join(root,filename) 
           if count % 100 == 0 :
               print (count , " : ", fileName)
           count += 1
           img = scipy.misc.imread(fileName)     
           img = resizeImage(img)   
           #img1 = img.astype(type('float32',(float,),{})) 
           img1 = img.astype(np.float32) 
           gray = getYChanelFromRGB(img1)           
           model = getFieldMap()
           Res = getNormalizedImage(gray,model)                 
           X_train_data = np.append(X_train_data,Res,axis = 0)
           A = np.reshape(gray,(1,np.product(gray.shape))).T           
           Y_train_data = np.append(Y_train_data,A,axis = 1)
           
           gray = np.rot90(gray)
           Res = getNormalizedImage(gray,model)
           X_train_data = np.append(X_train_data,Res,axis = 0)
           A = np.reshape(gray,(1,np.product(gray.shape))).T                                
           Y_train_data = np.append(Y_train_data,A,axis = 1)

           gray = np.rot90(np.rot90(gray))
           Res = getNormalizedImage(gray,model)
           X_train_data = np.append(X_train_data,Res,axis = 0)
           A = np.reshape(gray,(1,np.product(gray.shape))).T                      
           Y_train_data = np.append(Y_train_data,A,axis = 1)
           
           gray = np.rot90(np.rot90(np.rot90(gray)))
           Res = getNormalizedImage(gray,model)
           X_train_data = np.append(X_train_data,Res,axis = 0)
           A = np.reshape(gray,(1,np.product(gray.shape))).T                      
           Y_train_data = np.append(Y_train_data,A,axis = 1)                     
   
    return X_train_data, Y_train_data
#data=np.zeros((g_imSize,g_imSize,2))
getMaxOfDataset("D:\\asha1\\Work\\IFFT_Code\\Automap_Data")
print (g_min,g_max,"min and max vlaues of the whole dataset")
X_train_orig,Y_train_orig =   loadNaturalImages("D:\\asha1\\Work\\IFFT_Code\\Automap_Data\\1",g_imSize)
X_train_orig2,Y_train_orig2 = loadNaturalImages("D:\\asha1\\Work\\IFFT_Code\\Automap_Data\\2",g_imSize)
X_train_orig3,Y_train_orig3 = loadNaturalImages("D:\\asha1\\Work\\IFFT_Code\\Automap_Data\\3",g_imSize)
X_train_orig4,Y_train_orig4 = loadNaturalImages("D:\\asha1\\Work\\IFFT_Code\\Automap_Data\\4",g_imSize)
X_train_orig5,Y_train_orig5 = loadNaturalImages("D:\\asha1\\Work\\IFFT_Code\\Automap_Data\\5",g_imSize)
X_train_orig6,Y_train_orig6 = loadNaturalImages("D:\\asha1\\Work\\IFFT_Code\\Automap_Data\\6",g_imSize)
X_train_orig7,Y_train_orig7 = loadNaturalImages("D:\\asha1\\Work\\IFFT_Code\\Automap_Data\\7",g_imSize)
X_train_orig8,Y_train_orig8 = loadNaturalImages("D:\\asha1\\Work\\IFFT_Code\\Automap_Data\\8",g_imSize)
X_train_orig9,Y_train_orig9 = loadNaturalImages("D:\\asha1\\Work\\IFFT_Code\\Automap_Data\\9",g_imSize)
X_train_orig10,Y_train_orig10 = loadNaturalImages("D:\\asha1\\Work\\IFFT_Code\\Automap_Data\\10",g_imSize)
#
X_train_orig = np.append(X_train_orig,X_train_orig2,axis = 0)
X_train_orig = np.append(X_train_orig,X_train_orig3,axis = 0)
X_train_orig = np.append(X_train_orig,X_train_orig4,axis = 0)
X_train_orig = np.append(X_train_orig,X_train_orig5,axis = 0)
X_train_orig = np.append(X_train_orig,X_train_orig6,axis = 0)
X_train_orig = np.append(X_train_orig,X_train_orig7,axis = 0)
X_train_orig = np.append(X_train_orig,X_train_orig8,axis = 0)
X_train_orig = np.append(X_train_orig,X_train_orig9,axis = 0)
X_train_orig = np.append(X_train_orig,X_train_orig10,axis = 0)

Y_train_orig = np.append(Y_train_orig,Y_train_orig2,axis = 1)
Y_train_orig = np.append(Y_train_orig,Y_train_orig3,axis = 1)
Y_train_orig = np.append(Y_train_orig,Y_train_orig4,axis = 1)
Y_train_orig = np.append(Y_train_orig,Y_train_orig5,axis = 1)
Y_train_orig = np.append(Y_train_orig,Y_train_orig6,axis = 1)
Y_train_orig = np.append(Y_train_orig,Y_train_orig7,axis = 1)
Y_train_orig = np.append(Y_train_orig,Y_train_orig8,axis = 1)
Y_train_orig = np.append(Y_train_orig,Y_train_orig9,axis = 1)
Y_train_orig = np.append(Y_train_orig,Y_train_orig10,axis = 1)

np.save("X_train_orig_64.npy",X_train_orig)
np.save("Y_train_orig_64.npy",Y_train_orig)

X_test_orig , Y_test_orig = loadTestImages("D:\\asha1\\Work\\IFFT_Code\\Automap_Data\\MasterTest")
np.save("X_test_orig_64.npy",X_test_orig)
np.save("Y_test_orig_64.npy",Y_test_orig)
#

