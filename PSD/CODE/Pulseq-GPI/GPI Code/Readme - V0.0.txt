Python language based implementation of Pulseq in GPI Lab. Tested on macOS Sierra 10.12.1. and windows 10

TABLE OF CONTENTS

Installing GPI Lab
Installing Pulseq for GPI Lab
Getting started
Issues & TODOs
Appendix
Contributing

1. Installing GPI Lab
Download v1 beta from - http://gpilab.com/downloads/
Typical installation on Mac for windows need to have ubuntu\Linux OS

2. Installing Pulseq for GPI Lab
Clone repo
Open GPI Lab
Click on Config > Generate User Library
Place the mr_gpi and nodes inside this auto-generated user library folder: Mac - /Users/<user-name>/gpi/<user-name>/
In GPI Lab, click on 'Config' > 'Scan for new nodes'
Place Spin Echo.net file in: Mac - /Applications/GPI.app/Contents/Resources/miniconda/share/doc/gpi/Examples/
PRO TIP: With your Finder open, press ? + Shift + G and paste the path to jump to that location

3. Getting started

This section helps you get started implementing a Gradient Recalled Echo (GRE), Spin Echo (SE) and Spin Echo Echo Planar Imaging (SE-EPI) pulse sequences.

Open GPI Lab.
Drag and drop the Spin Echo.net file onto the blank canvas.
Configure the pulse sequence values by right clicking the ConfigSeq and AddBlock nodes. Each Event mandatorily needs a unique name. Each Node also mandatorily needs a unique name.
From left to right, click Compute Events in each Node.
Right click the 'GenSeq' Node. Here you will see a list of the Nodes you have defined in your canvas. Enter the Node names in the order in which you want the Events to be played out. Node names are separated by a comma (,).
Click on 'ComputeEvents' once you are done. Make sure the 'GenSeq' Node's output connectors are linked to the input connectors of the 'Matplotlib' Node.
Right click on the 'Matplotlib' Node to view graphs.

4. Issues & TODO
Issue: Only cartesian coordinate system supported
TODO: Customize Matplotlib node to support subplots

First AddBlock Node - Rf, Gz

Event 1 - Rf
Parameter            Value
duration (s)          2.5e-3
timeBwProduct (s)      4
apodization	      0.5
sliceThickness(m)     3e-3

Second AddBlock Node - Gx,ADC
Event 1 - Gx

Parameter	    Value
channel               x
readoutTime (s)     0.0010
area               1.2246e+03

Event 2 - ADC

Parameter	   Value
numSamples	    256
duration (s)	  0.0010
delay (s)	 2.3000e-04

Third AddBlock Node - Delay 1
Event 1 - Delay

Parameter	    Value
delay (s)	    0.0435

Fourth AddBlock Node - rf180,gz180

Event 1 - RF

Parameter	     Value
duration (s)          2.5e-3
timeBwProduct (s)      4
apodization	       0.5
sliceThickness(m)     3e-3

Fifth AddBlock Node - Delay 2
Event 1 - Delay

Parameter           Value
delay (s)            0.0479

sixth AddBlock Node - GxPre, GyPre, GzReph

Event 1 - G

Parameter	     Value
channel	               x
duration (s)	     2.5e-3
area	            612.3047

Event 2 - GyPre

Event 3 - G

Parameter	    Value
channel	              z
duration (s)	    2.5e-3
area	          -701.3333

Seventh AddBlock Node - Delay 3

Event 1 - Delay

Parameter	Value
delay (s)	1.8985

5. Contributing

Fork & PR!

NOTES

Click Off under each Event, and then proceed to configuring the appropriate events in each Node
ConfigSeq should mandatorily be the first GPI Node in any pulse sequence
GenSeq node should mandatorily be the last GPI Node in any pulse sequence
If the canvas is yellow coloured, right click and uncheck ‘Pause’
GPI Lab docs - http://docs.gpilab.com/en/develop/intro.html