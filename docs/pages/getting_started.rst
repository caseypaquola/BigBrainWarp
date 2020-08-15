Getting Started
==================

* Clone this repository to your local machine
* Download the transformation matrices. Specifically, the 'HistTransformations/BigBrainHist-to-ICBM2009sym' folder on https://osf.io/xkqb3/
* Unzip BigBrainHist-to-ICBM2009sym, move the folder into the top level of BigBrainWarp and rename the directory to `xfms`, like so:

.. image:: ./images/tree_example.PNG
   :height: 250px
   :align: left


Dependencies
**************

We've included some small dependencies in the github repository. In addition, 

* All transformation require MINC2 (http://bic-mni.github.io/) and FSL (https://fsl.fmrib.ox.ac.uk/fsl/fslwiki)
* Surface-based transformations require the CBIG git repository (https://github.com/ThomasYeoLab/CBIG) and MATLAB (tested on 19b, https://www.mathworks.com/products/matlab.html)
