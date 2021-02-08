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

For surface-based transformations, we can performed a vertex-wise or parcel-wise interpolation. The vertex-wise transformation leverages a nearest neighbour interpolation from the BigBrainSym to fsaverage5. We've pre-computed the indexing between fsaverage5 and the bigbrain surface because it takes a little time to run, but you can see the procedure in **BigBrainWarp/scripts/nn_surface_indexing.m**. Alternatively, you can use a parcel-based transformation. Surface-values are averaged within 1000 parcels, then transformed to matched parcels on the alternative surface. The parcellation was transformed to the BigBrain surface using an optimised multi-modal surface matching (MSM) registration, which holds advantages in aligning cortical morphometry (`click here for more details <https://bigbrainproject.org/docs/4th-bb-workshop/20-06-26-BigBrainWorkshop-Lewis.pdf>`_).

The following bash scripts will call the necessary python functions. You can input .txt, .mgh, .annot, or .gii files, and the output will be .txt files. The functions currently support fsaverage5 for nearest neighbour interpolation ("nn") or fsaverage for MSM informed tranformations ("msm").

.. code-block:: bash

	# Take your input data, say a functional parcellation on fsaverage
	# The positional arguments lh_data, rh_data, approach (nn or msm), input_surface (fsaverage5 or fsaverage) and output_name
	# For example:
	bash fsaverage_to_bigbrain.sh fsaverage/lh.Yeo2011_7Networks_N1000.annot fsaverage/lh.Yeo2011_7Networks_N1000.annot msm fsaverage /projects/casey/bigbrain/Yeo2011_7Networks_N1000
	# The output will be */projects/casey/bigbrain/Yeo2011_7Networks_N1000_lh_bigbrain.txt* and */projects/casey/bigbrain/Yeo2011_7Networks_N1000_rh_bigbrain.txt*

	# Conversely, you can transform data from BigBrain or BigBrainSym surfaces to fsaverage5 using:
	bash bigbrain_to_fsaverage.sh lh_data rh_data approach output_surface output_name
	# For example:
	bash bigbrain_to_fsaverage.sh $bbwDir/spaces/bigbrain/Hist-G2_lh.txt $bbwDir/spaces/bigbrain/Hist-G2_rh.txt nn fsaverage5 /projects/casey/bigbrain/Hist-G2
	# The output will be */projects/casey/bigbrain/qT1_lh_fsaverage5.txt* and */projects/casey/bigbrain/qT1_rh_fsaverage5.txt*



