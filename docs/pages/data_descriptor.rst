Data Descriptor
==================

* *maps: subdivided by standard space*
	* parcellations
		* aparc: Desikan-Killany, originally on fsaverage
		* vosdewael: subdivision of the Desikan-Killany atlas in 100-400 nodes, originally on fsaverage
		* schaefer: 7 network versions with 100-400 nodes, originally on fsaverage
		* glasser: HCP-MMP1, originally on fsaverage
		* Harvard-Oxford: fsl5.0 implementation, originally in MNI152
	* G1_mpc: first principle gradient of microstructural differentitation acquired with quantitative T1 imaging (Paquola et al., 2019)
* *bigbrain_surfaces*
	* grey/white: original BigBrain surfaces in histological space (Amunts et al. 2013)
	* layer 1/4: histologically verified surfaces at the layer I/II boundary and within layer IV (Wagstyl et al., 2018)
	* equivolumetric: 18 equivolumetric surfaces constructed between the grey and white matter surfaces (Paquola et al., 2019)
* *scripts*
	* bigbrain_to_icbm.sh: implements three-step nonlinear transformation in volume space (Xiao et al. 2019)
	* icbm_to_bigbrain.sh: inverted version of the three-step nonlinear transformation in volume space (Xiao et al. 2019)
	* fsaverage_to_bigbrain.sh: combined fsaverage to MNI152 surface-to-volume transformation (Wu et al., 2018) and icbm_to_bigbrain, then samples intensities along BigBrain midsurface
	* wrapper_fsaverage2mni.m: shell wrapper for fsaverage to MNI152 surface-to-volume transformation (Wu et al., 2018)
	* iEEG_channels_icbm.m: projects iEEG channel coordinates into a MNI152 volume
	* sample_iEEG_channel_intensities.sh: samples intensity of each iEEG channel from an another volume in BigBrain space

