.. _install_page:

.. Alternatively, you can also install the **ENIGMA TOOLBOX** using ``pip``: ::
    pip install enigmatoolbox

.. title:: Install me

Installation
==============================

**ENIGMA TOOLBOX** is available in Python and MATLAB!

.. tabs::

    .. tab:: Python
    
        **ENIGMA TOOLBOX** has the following dependencies:

        - `numpy <https://numpy.org/>`_
        - `pandas <https://pandas.pydata.org/>`_
        - `vtk <https://vtk.org/>`_
        - `nibabel <https://nipy.org/nibabel/index.html>`_
        - `nilearn <https://nilearn.github.io/>`_
        - `matplotlib <https://matplotlib.org/>`_

        The **ENIGMA TOOLBOX** can be directly downloaded from Github as follows: ::

            git clone https://github.com/MICA-MNI/ENIGMA.git
            cd ENIGMA
            python setup.py install


    .. tab:: Matlab

        **ENIGMA TOOLBOX** was tested with MATLAB R2017b.

        To install the MATLAB toolbox simply `download <https://github.com/MICA-MNI/ENIGMA/archive/0.0.1.zip>`_ 
<<<<<<< HEAD
        and unzip the GitHub toolbox (slow 🐢) or run the following command in your terminal (fast 🐅): ::
            
            git clone https://github.com/MICA-MNI/ENIGMA.git
        
        
        Once you have the toolbox on your computer, simply run the following command in MATLAB: ::
=======
        and unzip the GitHub toolbox, and run the following command in MATLAB: ::
>>>>>>> 324355be65bff257eecbf05c0c8c2569f3d3a5e3

            addpath(genpath('/path/to/ENIGMA/matlab/'))