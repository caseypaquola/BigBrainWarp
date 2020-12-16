Scripts
===============

Integrating histological information with in vivo neuroimaging can deepen our understanding of neuroanatomy and structure-function coupling in the human brain. 
Recently, Xiao et al., (2019) optimised a nonlinear transformation procedure to shift data between BigBrainSym and standard MNI152 space. 
Here, we provide simple scripts to transform your own data, as well as MRI-derived maps on the BigBrain surface, such as gradients.

Transformations in volume space
********************************

Only one line of code is necessary to transform from icbm to bigbrain volumetric space, or vice versa. You will just need to supply the path to the file you want to transform (can be.mnc or .nii), the bigbrain space (histological or sym), the interpolation method (linear or nearest neighbour), your working directory and whether you would like the function to clean up intermediary files. 

.. code-block:: bash

	# For example, if you've definied a region of interest in BigBrain histological space, this can be transformed to icbm like so:
	sh bigbrain_to_icbm.sh ROI.mnc histological nearest my_working_directory y
	# This will output my_working_directory/ROI_icbm.mnc, which can be examined by overlaying on BigBrainWarp/spaces/icbm/mni_icbm152_t1_tal_nlin_sym_09c.mnc

	# Conversely, if you have, say, an activation map in icbm, you can use the opposite script to transform it to BigBrain space:
	sh icbm_to_bigbrain.sh activation.nii sym linear my_working_directory n
	# The output will be my_working_directory/activation_bigbrain.nii
	# Note, the final file type (.mnc or .nii) is determined by the input


Transformations for surface-based data
***************************************

For surface-based transformation, we leverage the common space of fsaverage with BigBrainSym to perform nearest neighbour interpolation. We've pre-computed the indexing between fsaverage5 and the bigbrain surface because it takes a little time to run, but you can see the procedure in "nn_surface_indexing.m". All that is left to do, is enter your data:

The following bash scripts will call the necessary matlab functions and best used with .txt files. You may also input .mgh, .curv, .annot, .thickness and .gii files, however, the output mostly limited to .txt.

.. code-block:: bash

	# Take your input data, say group-average qT1 on fsaverage5
	sh fsaverage_to_bigbrain.sh lh_data rh_data output_name

	# Conversely, you can transform data from either BigBrain surface to fsaverage5 using:
	sh bigbrain_to_fsaverage.sh lh_data rh_data output_name

