Bridging BigBrain and MRI
======================================================

Understanding the histological underpinnings of imaging-based differences can greatly enhance our understanding of neuroanatomy. 
Recently, Xiao et al., optimised a nonlinear transformation procedure to shift data between BigBrain and standard MNI152 space. 
Here, we provide simple scripts to transform your own data as well as precomputed MRI-derived gradients on the BigBrain surface.


Transformations in volume space
********************************

.. code-block:: bash

	sh bigbrain_to_icbm.sh file_name /path/to/BigBrainWarp interp_method

	sh icbm_to_bigbrain.sh file_name /path/to/BigBrainWarp interp_method


Transformations for surface-based data
***************************************

We've devised a standard procedure to transform data from fsaverage to the BigBrain surface. This involves:

i) fsaverage surface to MNI152 volume using the Xu et al., technique
ii) Nonlinear transformation from MNI152 to BigBrain volume using an inverted version of the Xiao et al., technique
iii) Sample the parcellation labels along the BigBrain midsurface

And can be accomplished using

.. code-block:: bash

	sh fsaverage_to_bigbrain.sh lh_data rh_data interp_method output_name /path/to/BigBrainWarp /path/to/CBIG-master


MRI-based gradients on the BigBrain surface
********************************************

Using the above procedure we have generated functional and microstructural gradients in a healthy cohort of individuals (n=47).
Please refer to MICs cohort for further details. 

