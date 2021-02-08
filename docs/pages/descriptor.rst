Toolbox contents
==================

An overview of what scripts and features are contained in *BigBrainWarp*

* scripts
	* demo_gitbased.sh: walkthrough of the toolbox utilities using the github installation
	* bigbrain_to_icbm.sh: implements one-step transformation to BigBrainSym or three-step transformation BigBrain (Xiao et al. 2019)
	* icbm_to_bigbrain.sh: inverted version of above (Xiao et al. 2019)
	* bigbrain_to_fsaverage.sh: bash wrapper script to perform nearest neighbour interpolation from BigBrain to fsaverage5
	* fsaverage_to_bigbrain.sh: bash wrapper script to perform nearest neighbour interpolation from fsaverage5 to BigBrain
	* nn_surface_indexing.m: the creation of nearest neighbour indexing between fsaverage5 and BigBrainSym surfaces
	* nn_surface_indexing.mat: output of nn_surface_indexing.m
	* bigbrain2fsaverage.py: python script to perform nearest neighbour interpolation from BigBrain to fsaverage5	
	* fsaverage2bigbrain.py: python script to perform nearest neighbour interpolation from fsaverage5 to BigBrain	
	* txt2curv.sh: wrapper script to convert .txt files to .curv, helpful for visualisation with Freesurfer
	* obj2fs.sh: wrapper script to convert .obj surface meshes to a freesurfer style mesh (.pial), which can be loaded into Freeview for visualisation 
	

* spaces:
	* bigbrain: original histological space, includes surfaces and volumes
	* bigbrainsym: stereotaxic registration of BigBrain to ICBM152 as part of first BigBrain release, includes surfaces and volumes
	* icbm: volumetric data algined to the symmetric ICBM2009b atlas
	* fsaverage5: surface data on fsaverage5
	* fsaverage: surface data on fsaverage
	* fs_LR: surface data on fs_LR 32k


Preprocessed data can be found across various spaces:

.. list-table::
   :widths: 50 50 50
   :header-rows: 1

   * - Data
     - What is it?
     - In which spaces?
   * - profiles.txt
     - cell-staining intensities sampled at each vertex and across 50 equivolumetric surfaces
     - bigbrain
   * - gray*327680*
     - pial surface (Amunts et al. 2013)
     - bigbrain, bigbrainsym
   * - white*327680*
     - white matter boundary (Amunts et al. 2013)
     - bigbrain, bigbrainsym
   * - rh.confluence
     - continuous surface that includes isocortex and allocortex (hippocampus) from `Paquola et al., 2020 <https://elifesciences.org/articles/60673>`_
     - bigbrain
   * - Hist-G1
     - first gradient of cytoarchtiectural differentitation derived from BigBrain 
     - bigbrain, fsaverage5
   * - Hist-G2
     - second gradient of cytoarchtiectural differentitation derived from BigBrain 
     - bigbrain, fsaverage5
   * - Micro-G1
     - first gradient of microstructural differentitation derived from quantitative in-vivo T1 imaging
     - bigbrainsym, fsaverage5
   * - Func-G1
     - first gradient of functional differentitation derived from rs-fMRI
     - bigbrainsym, fsaverage5
   * - Func-G2
     - second gradient of functional differentitation derived from rs-fMRI
     - bigbrainsym, fsaverage5
   * - Func-G3
     - third gradient of functional differentitation derived from rs-fMRI
     - bigbrainsym, fsaverage5
   * - *h.Yeo2011_7Networks_N1000
     - 7 functional clusters from `Yeo & Krienen et al., 2011 <https://doi.org/10.1152/jn.00338.2011>`_
     - bigbrainsym, fsaverage5
   * - *h.Yeo2011_17Networks_N1000
     - 17 functional clusters from `Yeo & Krienen et al., 2011 <https://doi.org/10.1152/jn.00338.2011>`_
     - bigbrainsym, fsaverage5