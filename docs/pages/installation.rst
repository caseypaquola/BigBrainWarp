Installation
==================

Local installation
********************************
1. Clone the GitHub repository to your local machine (https://github.com/caseypaquola/BigBrainWarp.git)
2. Edit the first two lines of 'BigBrainWarp/scripts/init.sh' file based on the specific paths of your machine. These direct the script to BigBrainWarp and minc2
3. Prior to running any scripts, set the necessary global environment variables pull extra files from other places on the internet with:

.. code-block:: bash

	# run within BigBrainWarp github repo
	source scripts/init.sh
	bash scripts/downloads.sh


If you're working with a local version, you will also need to set up the dependencies:

* `MINC2 <https://bic-mni.github.io/#v2-version-1918>`_ is required for volumetric transformations (tested on MINC2-v2)
* `Workbench <https://www.humanconnectome.org/software/get-connectome-workbench>`_ is required for surface transformations (tested on workbench 1.5.0)
* Python (tested on 2.7 and 3.8) is required for surface-based transformations, with `numpy <https://numpy.org/>`_, `scipy <https://www.scipy.org/>`_ and `nibabel <https://nipy.org/nibabel/index.html>`_ packages

These can be located anywhere on your system, just ensure that they are in your PATH and the functions are callable from your command line.

Docker container
********************************
1. Get `Docker <https://docs.docker.com/get-docker/>`_
2. Pull the latest Docker image. The image is automatically updated with each new version of *BigBrainWarp*

.. code-block:: bash

	docker pull caseypaquola/bigbrainwarp:latest	

3. Run *BigBrainWarp* directly within the Docker engine

.. code-block:: bash

	docker run --rm -it caseypaquola/bigbrainwarp bash

For more on interacting with the docker container, for example transferring files between your local machine and the docker container, see https://docs.docker.com/engine/reference/commandline/docker/





