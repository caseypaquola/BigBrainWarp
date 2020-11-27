Bridging between BigBrain and MRI
======================================================

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

We've devised a basic procedure to transform data from fsaverage and the BigBrain surface. This involves:

i) fsaverage surface to MNI152 volume using the Wu et al., (2018) technique
ii) Nonlinear transformation from MNI152 to BigBrainSym volume using an inverted version of the Xiao et al., (2019) technique
iii) Coordinate-based sampling along BigBrain surface

This may be accomplished using the following script and works on common freesurfer formats (.annot, .thickness, .curv), .gii and .txt files. The function is executed in bash, but beware it does call matlab. 

.. code-block:: bash

	# Take your input data, say group-average qT1 on fsaverage5
	sh fsaverage_to_bigbrain.sh lh_data rh_data interp_method output_name

	# Conversely, you can transform data from either BigBrain surface to fsaverage5 using:
	sh bigbrainsurf_to_freesurfer.sh lh_data rh_data interp_method output_name

