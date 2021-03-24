How to warp
===============

Integrating histological information with in vivo neuroimaging can deepen our understanding of neuroanatomy and structure-function coupling in the human brain. 

Running BigBrainWarp
********************************

.. code-block:: bash

    bigbrainwarp

Required arguments

- *in_space*		: Space of input data (bigbrain, bigbrainsym, icbm, fsaverage or fs_LR)
- *out_space*		: Space of output data (bigbrain, bigbrainsym, icbm, fsaverage or fs_LR)
- *wd*			: Path to a working directory, where data will be output

Volume-based arguments

- *in*			: (required) Full path to input data. Must be whole brain. Can be mnc, nii or nii.gz
- *out_name*		: (optional) Prefix for output files. Default is prefix of input file. Output will be in the form {wd}/{out_name}_{out_space}
- *interp*		: (optional) Interpolation method, can be trilinear, tricubic, nearest or sinc. Default is trilinear. 

Surface-based arguments

- *in_lh*		: (required) Full path to input data for left hemisphere. Can be .label.gii, .annot, .shape.gii, .curv or .txt
- *in_rh*		: (required) Full path to input data for left hemisphere. Can be .label.gii, .annot, .shape.gii, .curv or .txt
- *out_name*		: (required) Prefix for output files. Output will be in the form {wd}/{out_name}_lh_{out_space}.*.gii {wd}/{out_name}_rh_{out_space}.*.gii
- *interp*		: (optional) Interpolation method, can be linear or nearest. Only works for .txt. Other types are forced to defaults (label.gii and .annot to nearest, shape.gii and .curv to linear)


Transformations in volume space
********************************

.. code-block:: bash

	# for example, transformation of a bigbrain to icbm can take the form
	bigbrainwarp --in_space bigbrain --out_space icbm --wd /project/ --in data.nii --interp trilinear

	# in contrast, transformation from icbm to bigbrainsym could be
	bigbrainwarp --in_space icbm --out_space bigbrainsym --wd /project/ --in data.mnc --interp sinc


BigBrainWarp utilises a recently published nonlinear transformation Xiao et al., (2019)
If you use volume-based transformations in BigBrainWarp, please cite:
Xiao, Y., et al. 'An accurate registration of the BigBrain dataset with the MNI PD25 and ICBM152 atlases'. Sci Data 6, 210 (2019). https://doi.org/10.1038/s41597-019-0217-0


Transformations for surface-based data
***************************************

Surface-based transformation can be enacted using multi-modal surface matching; a spherical registration approach. Ongoing work by Lewis et al., involves optimisation of registration surafces between BigBrain and standard surface templates. These are available at `ftp://bigbrain.loris.ca/BigBrainRelease.2015/BigBrainWarp_Support <ftp://bigbrain.loris.ca/BigBrainRelease.2015/BigBrainWarp_Support>`_. More details on procedure can be also found on the following `poster <https://drive.google.com/file/d/1vAqLRV8Ue7rf3gsNHMixFqlLxBjxtmc8/view?usp=sharing>`_ and `slides <https://drive.google.com/file/d/11dRgtttd2_FdpB31kDC9mUP4WCmdcbbg/view?usp=sharing>`_.
The functions currently support fsaverage and fs_LR as standard imaging templates for input or output.

.. code-block:: bash

	# for example, transformation of a bigbrain to fsaverage can take the form
	bigbrainwarp --in_space bigbrain --out_space fsaverage --wd /project/ --in_lh lh.data.label.gii --in_rh rh.data.label.gii --out_name data

	# in contrast, transformation from icbm to bigbrainsym could be
	bigbrainwarp --in_space fs_LR --out_space bigbrain --wd /project/ --in_lh lh.data.label.txt --in_rh rh.data.label.txt --out_name data --interp linear


If you use surface-based transformations in BigBrainWarp, please cite:
Lewis, L.B., et al. 'A multimodal surface matching (MSM) surface registration pipeline to bridge atlases across the MNI and the Freesurfer/Human Connectome Project Worlds' OHBM, Virtual (2020)






