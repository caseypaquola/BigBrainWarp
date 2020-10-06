Data Descriptor
==================

Directory overview:

* spaces:
	* bigbrain: original histological space, includes surfaces and volumes
	* bigbrainsym: stereotaxic registration of BigBrain to ICBM512 as part of main BigBrain release, includes surfaces and volumes
	* mni152: volumetric data algined to the symmetric ICBM2009b atlas
	* fsaverage: surface data on fsaverage
* scripts
	* bigbrain_to_icbm.sh: implements one-step transformation to BigBrainSym or three-step transformation BigBrain (Xiao et al. 2019). Volumeteric.
	* icbm_to_bigbrain.sh: inverted version of above (Xiao et al. 2019). Volumetric. 
	* fsaverage_to_bigbrain.sh: combined fsaverage to MNI152 surface-to-volume transformation (Wu et al., 2018) and icbm_to_bigbrain, then samples intensities along BigBrainSym midsurface.
	* wrapper_fsaverage2mni.m: shell wrapper for fsaverage to MNI152 surface-to-volume transformation (Wu et al., 2018)
	* iEEG_channels_icbm.m: projects iEEG channel coordinates into a MNI152 volume.
	* sample_iEEG_channel_intensities.sh: samples intensity of each iEEG channel from an another volume in BigBrain space

Data, which may be found across spaces:

* surfaces
	* gray_hemi_327680* & white_hemi_327680*: BigBrain surfaces (Amunts et al. 2013)
	* layer_1 & layer_4: histologically verified surfaces at the layer I/II boundary and within layer IV (Wagstyl et al., 2018)
	* equivolumetric: 18 equivolumetric surfaces constructed between the grey and white matter surfaces (Paquola et al., 2019)
	* confluence: continuous surface that includes isocortex and allocortex (hippocampus) (Paquola et al., 2020)
* maps	
	* G1_mpc: first principle gradient of microstructural differentitation acquired with quantitative T1 imaging (Paquola et al., 2019)
	* parcellations:
		* aparc: Desikan-Killany, originally on fsaverage (Desikan et al., 2006)
		* vosdewael: subdivision of the Desikan-Killany atlas into 100-400 nodes of approximately equal size, originally on fsaverage
		* schaefer: 7 network versions with 100-400 nodes, originally on fsaverage (Schaefer et al., 2018)
		* glasser: HCP-MMP1, originally on fsaverage (Glasser et al., 2016)
		* Harvard-Oxford: fsl5.0 implementation, originally in MNI152
