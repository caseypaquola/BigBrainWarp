Workflow
==================

Multi-modal integration of BigBrain involves many moving parts. Here's a simple schema of the core transformations that are involved.

.. image:: ./images/bbw_workflow/Slide1.PNG
   :height: 350px
   :align: center

Upacking this further, the most simple scripts that transform between BigBrain and ICBM volumetric would follow the paths:

.. image:: ./images/bbw_workflow/Slide2.PNG
   :height: 350px
   :align: center

.. image:: ./images/bbw_workflow/Slide3.PNG
   :height: 350px
   :align: center

In contrast, the conversion from fsaverage to the BigBrain surface, for example with an MRI-derived cortical gradient, follows the path:

.. image:: ./images/bbw_workflow/Slide4.PNG
   :height: 350px
   :align: center