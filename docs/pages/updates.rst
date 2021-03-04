.. _updates:

.. title:: List of updates

Updates
==================

March 4, 2021
------------------------------------------
Estimated layer thicknesses from Wagstyl et al., 2020 surfaces (ftp://bigbrain.loris.ca/BigBrainRelease.2015/Layer_Segmentation/3D_Surfaces/April2019/) and transformed to standard surface templates

::

    ↪ Pre-computed BigBrain layer thicknesses in /spaces/bigbrain/	|  @caseypaquola
    ↪ Transformed layer thicknesses in fsaverage and /fs_LR		|  @caseypaquola


February 25, 2021
------------------------------------------
Changed all surface-based transformations to multi-modal surface matching, using new registrations from Lindsay.

::

    ↪ Overhaul of surface transformation scripts and documentation	|  @caseypaquola



February 8, 2021
------------------------------------------
Expanded the surface transformation functionality. Now supports (i) multi-modal surface registration via a parcel-based transformation and (ii) fs_LR for vertex-based nearest neighbour interpolation.  

::

    ↪ Added approach option for surface based transformations 		|  @caseypaquola
    ↪ Added surface option for fs_LR and fsaverage compatibility    	|  @caseypaquola
    ↪ Updated documention for surface transformations              	|  @caseypaquola
