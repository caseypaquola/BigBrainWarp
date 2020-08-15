Bridging between BigBrain and MRI
======================================================

Integrating histological information with in vivo neuroimaging can deepen our understanding of neuroanatomy and structure-function coupling in the human brain. 
Recently, Xiao et al., (2019) optimised a nonlinear transformation procedure to shift data between BigBrain and standard MNI152 space. 
Here, we provide simple scripts to transform your own data, as well as MRI-derived maps on on the BigBrain surface, such as gradients or parcellation schemes. 

Transformations in volume space
********************************

.. code-block:: bash

	# Wrapper scripts for the nonlinear transformation procedure of Xiao et al., (2019)
	sh bigbrain_to_icbm.sh file_name /path/to/BigBrainWarp interp_method
	sh icbm_to_bigbrain.sh file_name /path/to/BigBrainWarp interp_method

Transformations for surface-based data
***************************************

We've devised a standard procedure to transform data from fsaverage to the BigBrain surface. This involves:

i) fsaverage surface to MNI152 volume using the Xu et al., technique
ii) Nonlinear transformation from MNI152 to BigBrain volume using an inverted version of the Xiao et al., technique
iii) Sample the parcellation labels along the BigBrain midsurface

This may be accomplished using the following script and works on common freesurfer formats (.annot, .thickness, .curv) and gifti. 

.. code-block:: bash

	sh fsaverage_to_bigbrain.sh lh_data rh_data interp_method output_name /path/to/BigBrainWarp /path/to/CBIG-master


MRI-derived gradients on the BigBrain surface
********************************************

Using the above procedure, we transformed MRI-derived functional and microstructural gradients onto the BigBrain surface. For further information on cortical gradients, we recommend the readers to Margulies et al., (2016), Paquola et al., (2019) and the BrainSpace toolbox. Briefly, these gradients represent the principle axes of variation in resting state functional connectivity and similarity in intracortical architectecture. We generated functional connectivity and microstructural similarity at a vertex-level on the fsaverage5 template for 47 healthy individuals, averaged the matrices across the cohort, extracted the principles axes of variation using diffusion map embedding, then transformed the first gradients to the BigBrain surface.

.. figure:: ./images/mpc_gradient.png
   :height: 300px
   :align: center
   
   Gradient of microstructural gradient on fsaverage5 (above) and BigBrain (below)




