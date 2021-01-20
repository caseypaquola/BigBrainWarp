Scripts
===============

Integrating histological information with in vivo neuroimaging can deepen our understanding of neuroanatomy and structure-function coupling in the human brain. 


Transformations in volume space
********************************

Recently, Xiao et al., (2019) optimised a nonlinear transformation procedure to move between BigBrainSym and `ICBM152 <https://www.bic.mni.mcgill.ca/ServicesAtlases/ICBM152NLin2009>`_. We’ll use these transformations to initialise the transformations between ICBM152 to BigBrain volumes. The script requires the path to the file you want to transform (can be in .mnc or .nii format), the BigBrain space (histological or sym), the interpolation method (linear or nearest neighbour) and your working directory.

.. code-block:: bash

	# For example, if you've definied a region of interest in BigBrain histological space, this can be transformed to ICBM152 like so:
	bash bigbrain_to_icbm.sh /projects/casey/bigbrain/ROI.mnc histological nearest /projects/casey/bigbrain/
	# This will output /projects/casey/bigbrain/ROI_icbm.mnc
	# You can examine the output by overlaying it on BigBrainWarp/spaces/icbm/mni_icbm152_t1_tal_nlin_sym_09c.mnc

	# Conversely, if you have, say, an activation map in ICBM152 space, you can use the opposite script to transform it to BigBrain:
	bash icbm_to_bigbrain.sh /projects/casey/bigbrain/activation.nii sym linear /projects/casey/bigbrain/
	# The output will be /projects/casey/bigbrain/activation_bigbrain.nii
	# Note, the final file type (.mnc or .nii) is determined by the input


Transformations for surface-based data
***************************************

For surface-based transformations, we leverage the common space of fsaverage with BigBrainSym to perform nearest neighbour interpolation. We've pre-computed the indexing between fsaverage5 and the bigbrain surface because it takes a little time to run, but you can see the procedure in **BigBrainWarp/scripts/nn_surface_indexing.m**. All that is left to do, is enter your data:

The following bash scripts will call the necessary matlab functions and are best used with .txt files. You may also input .mgh, .curv, .annot, .thickness and .gii files, however, the output is mostly limited to .txt.

.. code-block:: bash

	# Take your input data, say group-average qT1 on fsaverage5. The arguments should be entered as left hemisphere, right hemipshere, then output name
	bash fsaverage_to_bigbrain.sh /projects/casey/bigbrain/qT1_data_lh.txt /projects/casey/bigbrain/qT1_data_rh.txt /projects/casey/bigbrain/qT1
	# The output will be /projects/casey/bigbrain/qT1_bigbrain.txt

	# Conversely, you can transform data from BigBrain or BigBrainSym surfaces to fsaverage5 using:
	bash bigbrain_to_fsaverage.sh lh_data rh_data output_name



