====================
BigBrainWarp
====================

This repository provides tools and resources for multimodal integration with `Big Brain <https://bigbrain.loris.ca/main.php>`_, 
leveraging state-of-the-art co-registration methods and openly available datasets for in vivo structural and functional MRI, gene expression, receptor mapping, polarized light imaging, and intracranial electroencephalography.

BigBrain is a singular dataset that offers a volumetric reconstruction of high-resolution cell-stained slices of a post mortem human brain.
With BigBrainWarp, we aim provide to provide a centralised repository of resources and code to maximise the utility of BigBrain.

* Centralised information on integration of BigBrain with multi-modal imaging
* Simple scripts to perform nonlinear warping between spaces
* Imaging-based maps in BigBrain space
* BigBrain-based maps in MNI152 space

Getting Started
-----------

* Clone this repo to your local machine using `https://github.com/MICA-MNI/BigBrainWarp.git`
* The keystone for the transformations is Xiao et al., (2019). Go to `https://osf.io/xkqb3/` and download `HistTransformations/BigBrainHist-to-ICBM2009sym` as a zip (sorry, they're too large to include in this repo)
* Unzip the BigBrainHist-to-ICBM2009sym.zip, move the folder into the top level of BigBrainWarp and rename the directory to `xfms`, like so:

.. raw:: html

    <img src="https://github.com/OualidBenkarim/BigBrainWarp/blob/master/docs/tree_example.PNG" height="300px">

Support
-----------

If you have problems installing the software or questions about usage
and documentation, or something else related to BrainSpace,
you can post to the Issues section of our `repository <https://github.com/MICA-MNI/BigBrainWrap/issues>`_.


Core development team
-----------------------

* Casey Paquola, MICA Lab - Montreal Neurological Institute
* Jessica Royer, MICA Lab - Montreal Neurological Institute
* Oualid Benkarim, MICA Lab - Montreal Neurological Institute
* Boris Bernhardt, MICA Lab - Montreal Neurological Institute

