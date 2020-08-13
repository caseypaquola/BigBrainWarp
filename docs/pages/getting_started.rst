Getting Started
==================

* Clone this repo to your local machine using `https://github.com/MICA-MNI/BigBrainWarp.git`
* The keystone for the transformations is Xiao et al., (2019). Go to `https://osf.io/xkqb3/` and download `HistTransformations/BigBrainHist-to-ICBM2009sym` as a zip
* Unzip the BigBrainHist-to-ICBM2009sym.zip, move the folder into the top level of BigBrainWarp and rename the directory to `xfms`, like so:

.. raw:: html

    <img src="https://github.com/OualidBenkarim/BigBrainWarp/blob/master/docs/tree_example.PNG" height="300px">

Dependencies
**************

We've included some small dependencies in the github repository. In addition, 

* For all transformations, MINC2 - http://bic-mni.github.io/
* For surface-based transformations, the CBIG git repo - https://github.com/ThomasYeoLab/CBIG
* For surface-based transformations, MATLAB (tested on 19b, https://www.mathworks.com/products/matlab.html) 
