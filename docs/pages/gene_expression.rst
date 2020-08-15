Gene expression across BigBrain
======================================================

With increasing availablity of gene expression maps of the human brain, such as the Allen Human Brain Atlas (AHBA), we may investigate the spatial variation of transcriptomics in relation the cytoarchitectural information provided by BigBrain.  





Step 1: Retrieve gene expression estimates from ABHA
**************************************************************

Numerous tools exist to extract gene expression estimates from ABHA. Here, we use the abagen toolbox (https://abagen.readthedocs.io/).
Abagen utilises parcellation schemes to collate probes within cortical regions. For example, we may use the Desikan-Killany atlas.




Step 2: Parcellate the BigBrain cortical surface
**************************************************************

We've devised a standard procedure to transform a parcellation scheme from fsaverage to the BigBrain surface. This involves:

i) fsaverage surface to MNI152 volume using the Xu et al., technique
ii) Nonlinear transformation from MNI152 to BigBrain volume using an inverted version of the Xiao et al., technique
iii) Sample the parcellation labels along the BigBrain midsurface

.. figure:: ./images/aparc_parcellation.png
   :height: 300px
   :align: center
   
   For example, the Desikan-Killany atlas on fsaverage5 (above) and BigBrain (below)

In this manner we may match the cytoarchitectural features with gene expression from the AHBA.
