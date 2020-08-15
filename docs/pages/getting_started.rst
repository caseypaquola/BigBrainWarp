Getting Started
==================

* Clone this repo to your local machine using `https://github.com/MICA-MNI/BigBrainWarp.git`
* The keystone for the transformations is Xiao et al., (2019). Go to `https://osf.io/xkqb3/` and download `HistTransformations/BigBrainHist-to-ICBM2009sym` as a zip
* Unzip the BigBrainHist-to-ICBM2009sym.zip, move the folder into the top level of BigBrainWarp and rename the directory to `xfms`, like so:

.. image:: ./images/tree_example.PNG
   :scale: 70%
   :align: left

Dependencies
**************

We've included some small dependencies in the github repository. In addition, 

* For all transformations, MINC2 (http://bic-mni.github.io/) and FSL (https://fsl.fmrib.ox.ac.uk/fsl/fslwiki)
* For surface-based transformations, the CBIG git repo (https://github.com/ThomasYeoLab/CBIG) and MATLAB (tested on 19b, https://www.mathworks.com/products/matlab.html)
