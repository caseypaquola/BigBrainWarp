Integration with existing datasets
====================================

There is an abundance of excellent datasets that benefit multi-modal integration with BigBrain. Here’s an overview to help get you started on BigBrain-MRI cross-pollination

🌺🐝🌺


Cytoarchitectural
****************************

**Precisely delineated cytoarchitectural areas** The dataset, available through EBRAINS, includes ultrahigh resolution 3D maps of cytoarchitectural areas interpolated to BigBrain volume. More areas are added on an ongoing basis, and the interpolation increasingly utilises Deep Convolutional Networks to optimise the segmentation on BigBrain: https://search.kg.ebrains.eu/instances/Project/af8d3519-9561-4060-8da9-2de1bb966a81

**Layer Segmentation** `Wagstyl et al., <https://doi.org/10.1371/journal.pbio.3000678>`_ used a convolutional neural network to automatically segment the cortical layers in BigBrain. The boundaries of the layers are available for download and can used to explore the laminar architecture of BigBrain: ftp://bigbrain.loris.ca/BigBrainRelease.2015/LayerSegmentation

**Hippocampal Segmentation** `DeKraker  et al. <https://doi.org/10.1016/j.neuroimage.2019.116328>`_  manually segmented the hippocampal subfields in BigBrain and generated surface meshes for each subfield. Additionally, the work shows how the hippocampus can be “unfolded”, creating a simplified 3D coordinate space to characterise the internal cytoarchitecture: ftp://bigbrain.loris.ca/BigBrainRelease.2015/HippocampalSegmentation



In vivo imaging
*********************

**ENIGMA toolbox** A central repository for archiving meta-analytical case-control comparisons across a wide range of disorders from the ENIGMA consortium. This toolbox is a one-stop-shop for effect sizes of prevalent psychiatric disorders on cortical morphometry: https://enigma-toolbox.readthedocs.io/en/latest/





