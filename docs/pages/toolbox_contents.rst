Toolbox contents
==================

Datasets
********************************

.. list-table::
   :widths: 50 50 50
   :header-rows: 1

   * - Data
     - Overview
     - Available templates
   * - profiles
     - cell-staining intensities sampled at each vertex and across 50 equivolumetric surfaces. This is stored as a single vector to reduce the size. Reshape to 50 rows for use. 
     - bigbrain, fsaverage, fs_LR (164k and 32k)
   * - white
     - grey/white matter boundary
     - bigbrain (histological and sym), fsaverage, fs_LR (164k and 32k)
   * - confluence
     - continuous surface that includes isocortex and allocortex (hippocampus) from `Paquola et al., 2020 <https://elifesciences.org/articles/60673>`_. Only available for the right hemisphere. 
     - bigbrain
   * - Hist-G*
     - first two eigenvectors of cytoarchtiectural differentitation derived from BigBrain 
     - bigbrain, fsaverage, fs_LR (164k and 32k), icbm
   * - Micro-G1
     - first eigenvector of microstructural differentitation derived from quantitative in-vivo T1 imaging
     - bigbrain, fsaverage
   * - Func-G*
     - first threee eigenvectors of functional differentitation derived from rs-fMRI
     - bigbrain, fsaverage
   * - Yeo2011_7Networks_N1000
     - 7 functional clusters from `Yeo & Krienen et al., 2011 <https://doi.org/10.1152/jn.00338.2011>`_
     - bigbrain
   * - Yeo2011_17Networks_N1000
     - 17 functional clusters from `Yeo & Krienen et al., 2011 <https://doi.org/10.1152/jn.00338.2011>`_
     - bigbrain
   * - layer*_thickness
     - Approximate layer thicknesses estimated from `Wagstyl et al., 2020 <https://doi.org/10.1371/journal.pbio.3000678>`_
     - bigbrain, fsaverage, fs_LR


Naming conventions
********************************
In an effort to standardise and simplify the naming of files across BigBrainWarp, we have adopted the BIDS-like structure of `TemplateFlow https://www.templateflow.org/ < https://www.templateflow.org/>`_. This means that files likely have a different name than their source. We refer you to the section on Datasets to find the original file names. 
The output of BigBrainWarp is automatically named according to this convention.

.. list-table::
   :widths: 50 50
   :header-rows: 1

   * - Indicator
     - Description
   * - tpl
     - Template of output data. Determined based on the required argument “out_space”.
   * - hemi
     - L for left, R for right. Only included in surface-based transformations where data is separated by hemisphere.  
   * - den
     - Density of output data on mesh. Currently only specified for fs_LR, where 164k and 32k options are possible. Can be indicated using the out_den parameter
   * - desc
     - General description of the data. Determined based on the required argument “desc”. In the “Datasets” table above, the desc is given in the first column. 


Scripts
********************************
The bigbrainwarp function calls a range of scripts:
	* bigbrain_to_fsaverage.sh: called by bigbrainwarp
	* bigbrain_to_icbm.sh: called by bigbrainwarp
	* bigbrainsurf_to_icbm.sh: called by bigbrainwarp
	* compile_profiles.py: collates and saves out intensities into profiles
	* demo_dockerbased.sh: key examples of transformations using the docker installation
	* demo_gitbased.sh: walkthrough of the toolbox utilities using the github installation
	* fsaverage_to_bigbrain.sh: called by bigbrainwarp
	* icbm_to_bigbrain.sh: called by bigbrainwarp
	* icbm_to_bigbrainsurf.sh: called by bigbrainwarp
	* init.sh: initialises the environment
	* io_mesh.py: scripts from `Surface Tools <https://github.com/kwagstyl/surface_tools>`_ that help with loading .obj files
	* nn_surface_indexing.mat: contains mesh decimation output
	* obj2fs.sh: wrapper script to convert .obj surface meshes to a freesurfer style mesh (.pial), which can be loaded into Freeview for visualisation 	
	* sample_intensity_profiles.sh: wrapper script for generating staining intensity profiles
	* txt2curv.sh: wrapper script to convert .txt files to.curv, helpful for visualisation with Freesurfer

