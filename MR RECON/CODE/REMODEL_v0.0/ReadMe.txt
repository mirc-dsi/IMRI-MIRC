1. fieldmap.py python file can be used to generate ksapce of images currupted by simulated field map having offresonace frequency +/- 50kHz (input image is of size 64x64) 
2. REMODEL is trained for 32000 brain images and "chkPoint" folder is having the learned model. Test images are available in "TestData" folder. To test the REMODEL performance on test images run the REMODEL.py for one iteration 
3. Results are available in cls_pred_test in the form of numpy array.
How to use fieldmap.py
fieldmap.py can be used to generate new test data
first call the method "getMaxOfDataset" which will return the min and max of the dataset 
then use the method "loadData" to convert test images into numpy array, use these array in REMODEL to test
