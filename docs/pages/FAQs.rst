Frequently Asked Questions
====================================

**What's the difference between BigBrain and BigBrainSym?** The original volumetric reconstruction of BigBrain is tilted compared to a typical brain housed in a skull (see below). This has to do with tissue deformations of the specimen post-mortem.

To facilitate comparisons with standard neuroimaging spaces, BigBrain was nonlinearly transformed to ICBM152 space, resulting in BigBrainSym. When parsing arguments to scripts in this toolbox, we use the "bigbrain" for BigBrain and "bigbrainsym" for BigBrainSym.

.. figure:: ./images/FAQ_BigBrainSym.png
   :height: 150px
   :align: center


**How can I build equivolumetric surfaces?** This can be performed using the `python-based surface tools <https://github.com/kwagstyl/surface_tools/tree/v1.0.0>`_, which we've also translated for `matlab-based pipelines <https://github.com/MICA-MNI/micaopen/blob/master/cortical_confluence/scripts/equivolumetric_surfaces.m>`_. You can also use `micapipe <https://micapipe.readthedocs.io/en/latest/>`_ to generate equivolumetric surfaces and sample microstructure profiles. 

**Are there regions of BigBrain that should be treated with caution?** There is a small tear in the left entorhinal cortex of BigBrain, which affects the pial surface construction as well as microstructure profiles in that region. For region of interest studies, it is always a good idea to carry out a detailed visual inspection. Try out the `EBRAINS interactive viewer <https://interactive-viewer.apps.hbp.eu/?templateSelected=Big+Brain+%28Histology%29&parcellationSelected=Cytoarchitectonic+Maps+-+v2.4&cNavigation=0.0.0.-W000..2_ZG29.-ASCS.2-8jM2._aAY3..BSR0..PDY1%7E.rzeq%7E.5qQV..15ye>`_


