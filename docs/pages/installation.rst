Installation
==================

The simplest way to interact with *BigBrainWarp* is using the Docker engine.

1. Get `Docker <https://docs.docker.com/get-docker/>`_
2. Pull the latest Docker image. The image is automatically updated with each new version of *BigBrainWarp*

.. code-block:: bash

	docker pull caseypaquola/bigbrainwarp:latest	

3. Run *BigBrainWarp* directly within the Docker engine

.. code-block:: bash

	docker run --rm -it caseypaquola/bigbrainwarp bash

For more on interacting with the docker container, for example transferring files between your local machine and the docker container, see https://docs.docker.com/engine/reference/commandline/docker/

 
Alternatively, you can also install a local version of BigBrainWarp like so:

1. Clone the GitHub repository to your local machine (https://github.com/caseypaquola/BigBrainWarp.git)
2. Edit the first three lines of 'BigBrainWarp/scripts/init.sh' file based on the specific paths of your machine
3. Prior to running any scripts, set the necessary global environment variables

.. code-block:: bash

	bash BigBrainWarp/scripts/init.sh
	source BigBrainWarp/scripts/init.sh


If you're working with a local version, you will also need to set up the dependencies:

* `MINC2 <https://github.com/BIC-MNI/minc-toolkit-v2>`_ is required for volumetric transformations (tested on MINC2-v2)
* `FSL <https://fsl.fmrib.ox.ac.uk/fsl/fslwiki>`_ is required for volumetric transformations (tested on FSL 5.5)
* Python (tested on 2.7 and 3.8) is required for surface-based transformations, with `numpy <https://numpy.org/>`_, `scipy <https://www.scipy.org/>`_ and `nibabel <https://nipy.org/nibabel/index.html>`_ packages

These can be located anywhere on your system, just ensure that they are in your PATH and the functions are callable from your command line.


