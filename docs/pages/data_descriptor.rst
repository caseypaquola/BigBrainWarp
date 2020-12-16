Data Descriptor
==================

Directory overview:

- spaces:
	- bigbrain: original histological space, includes surfaces and volumes
	- bigbrainsym: stereotaxic registration of BigBrain to ICBM512 as part of main BigBrain release, includes surfaces and volumes
	- icbm: volumetric data algined to the symmetric ICBM2009b atlas
	- fsaverage: surface data on fsaverage5

- scripts
	- bigbrain_to_icbm.sh: implements volumetric transformation from BigBrain to ICBM152, using matrices devised by `Xiao et al. 2019 <https://www.nature.com/articles/s41597-019-0217-0>`_
	- icbm_to_bigbrain.sh: inverted version of the above `Xiao et al. 2019 <https://www.nature.com/articles/s41597-019-0217-0>`_
	- fsaverage_to_bigbrain.sh: implements interpolation from fsaverage5 to BigBrain surface
	- bigbrain_to_fsaverage.sh: implements interpolation from BigBrain surface to fsaverage5
	- nn_surface_indexing.m: demonstrates the approach used to perform interpolation between BigBrain and fsaverage5
	- nn_surface_indexing.mat: contains the output of nn_surface_indexing.m, which is used in fsaverage_to_bigbrain.sh and bigbrain_to_fsaverage.sh

2nd level maps, which may be found across spaces. MRI-derived transformed to BigBrain surface are housed in the BigBrain directory only, not BigBrainSym, to avoid redundancy.

- maps	
	- Hist-G1: first gradient of cytoarchitectural differentitation, based on BigBrain
	- Hist-G2: second gradient of cytoarchitectural differentitation, based on BigBrain
	- Micro-G1: first gradient of microstructural differentitation acquired with quantitative T1 imaging
	- Micro-G2: second gradient of microstructural differentitation acquired with quantitative T1 imaging
	- Func-G1: first gradient of functional differentitation acquired with resting state fMRI 
	- Func-G2: second gradient of functional differentitation acquired with resting state fMRI
	- Func-G3: third gradient of functional differentitation acquired with resting state fMRI
	- *h.Yeo2011_7Networks_N1000.txt: clusters of resting-state functional connectivity (`Yeo, Krienen et al., 2011 <https://doi.org/10.1152/jn.00338.2011>`_)
	

Pre-generated BigBrain surfaces

- surfaces
	- gray_hemi_327680- & white_hemi_327680-: BigBrain surfaces (Amunts et al. 2013)
	- layer_1 & layer_4: histologically verified surfaces at the layer I/II boundary and within layer IV (`Wagstyl et al., 2018 <https://doi.org/10.1093/cercor/bhy074>`_)
	- equivolumetric: 50 equivolumetric surfaces constructed between the grey and white matter surfaces
	- confluence: continuous surface that includes isocortex and hippocampal allocortex (`Paquola et al., 2020 <https://elifesciences.org/articles/60673>`_)



