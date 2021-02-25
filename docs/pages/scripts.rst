Scripts
===============

Integrating histological information with in vivo neuroimaging can deepen our understanding of neuroanatomy and structure-function coupling in the human brain. 


Transformations in volume space
********************************

Recently, Xiao et al., (2019) optimised a nonlinear transformation procedure to move between BigBrainSym and `ICBM152 <https://www.bic.mni.mcgill.ca/ServicesAtlases/ICBM152NLin2009>`_. We’ll use these transformations to initialise the transformations between ICBM152 and BigBrain volumes. The script requires the path to the file you want to transform (can be in .mnc or .nii format), the BigBrain space (histological or sym), the interpolation method (linear or nearest neighbour) and your working directory.

.. code-block:: bash

	# For example, if you've definied a region of interest in BigBrain histological space, this can be transformed to ICBM152 like so:
	bash bigbrain_to_icbm.sh /projects/casey/bigbrain/ROI.mnc histological nearest /projects/casey/bigbrain/
	# This will output /projects/casey/bigbrain/ROI_icbm.mnc
	# You can examine the output by overlaying it on BigBrainWarp/spaces/icbm/mni_icbm152_t1_tal_nlin_sym_09c.mnc

	# Conversely, if you have, say, an activation map in ICBM152 space, you can use the opposite script to transform it to BigBrain:
	bash icbm_to_bigbrain.sh /projects/casey/bigbrain/activation.nii sym linear /projects/casey/bigbrain/
	# The output will be /projects/casey/bigbrain/activation_bigbrain.nii
	# Note, the final file type (.mnc or .nii) is determined by the input

If you use this procedure, please cite:
Xiao, Y., et al. 'An accurate registration of the BigBrain dataset with the MNI PD25 and ICBM152 atlases'. Sci Data 6, 210 (2019). https://doi.org/10.1038/s41597-019-0217-0


Transformations for surface-based data
***************************************

Surface-based transformation can be enacted using multi-modal surface matching; a spherical registration approach. Ongoing work by Lewis et al., involves optimisation of registration surafces between BigBrain and standard surface templates. These are available at `ftp://bigbrain.loris.ca/BigBrainRelease.2015/BigBrainWarp_Support <ftp://bigbrain.loris.ca/BigBrainRelease.2015/BigBrainWarp_Support>`_. More details on procedure can be also found on the following `poster <https://drive.google.com/file/d/1vAqLRV8Ue7rf3gsNHMixFqlLxBjxtmc8/view?usp=sharing>`_ and `slides <https://drive.google.com/file/d/11dRgtttd2_FdpB31kDC9mUP4WCmdcbbg/view?usp=sharing>`_.

These transformations are wrapped into the following bash scripts. You can input .txt, .curv, .annot, or .gii files, and the output will be .gii files. The functions currently support fsaverage and fs_LR

.. code-block:: bash

	# Take your input data, say a functional parcellation on fsaverage
	# The positional arguments lh_data, rh_data, input_surface (fsaverage or fs_LR) and output_name
	# For example:
	bash fsaverage_to_bigbrain.sh fsaverage/lh.Yeo2011_7Networks_N1000.annot fsaverage/lh.Yeo2011_7Networks_N1000.annot msm fsaverage /projects/casey/bigbrain/Yeo2011_7Networks_N1000
	# The output will be */projects/casey/bigbrain/Yeo2011_7Networks_N1000_lh_bigbrain.label.gii* and */projects/casey/bigbrain/Yeo2011_7Networks_N1000_rh_bigbrain.label.gii*

	# Conversely, you can transform data from BigBrain or BigBrainSym surfaces to fsaverage or fs_LR using:
	bash bigbrain_to_fsaverage.sh lh_data rh_data output_surface output_name
	# For example:
	bash bigbrain_to_fsaverage.sh $bbwDir/spaces/bigbrain/Hist-G2_lh.txt $bbwDir/spaces/bigbrain/Hist-G2_rh.txt nn fsaverage /projects/casey/bigbrain/Hist-G2
	# The output will be */projects/casey/bigbrain/qT1_lh_fsaverage5.shape.gii* and */projects/casey/bigbrain/qT1_rh_fsaverage5.shape.gii*

If you use the procedure please cite:
Lewis, L.B., et al. 'A multimodal surface matching (MSM) surface registration pipeline to bridge atlases across the MNI and the Freesurfer/Human Connectome Project Worlds' OHBM, Virtual (2020)






