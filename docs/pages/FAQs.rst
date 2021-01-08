Frequently Asked Questions
====================================

**What's the difference between BigBrain and BigBrainSym?** The original volumetric reconstruction of BigBrain is tilted compared to a typical brain housed in a skull (see below). To facilitate comparisons with standard neuroimaging spaces, BigBrain was nonlinearly transformed to ICBM152 space, resulting in BigBrainSym. When parsing arguments to scripts in this toolbox, we use the shorthand "histological" for BigBrain and "sym" for BigBrainSym.

.. figure:: ./images/FAQ_BigBrainSym.png
   :height: 150px
   :align: center


**How can I build equivolumetric surfaces?** This can be performed using the `python-based surface tools <https://github.com/kwagstyl/surface_tools/tree/v1.0.0>`_, which we've also translated for `matlab-based pipelines <https://github.com/MICA-MNI/micaopen/blob/master/cortical_confluence/scripts/equivolumetric_surfaces.m>`_. You can also use `micapipe <https://micapipe.readthedocs.io/en/latest/>`_ to generate equivolumetric surfaces and sample microstructure profiles. 


