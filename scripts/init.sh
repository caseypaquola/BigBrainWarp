#!/bin/bash/

# set up variables - change for your environment
bbwDir=/data_/mica1/03_projects/casey/BigBrainWarp/
cbigDir=/data_/mica1/03_projects/casey/CBIG-master/
icbmTemplate=$bbwDir/spaces/mni152/mni_icbm152_nlin_asym_09c_mask.mnc
<<<<<<< HEAD
mnc2Path=/data_/mica1/01_programs/minc2/
=======
>>>>>>> 47ed142cd313b97aefdf76a2775b6ad65fec8c88

# download template
if [[ ! -f $icbmTemplate ]] ; then
	cd $bbwDir/spaces/mni152/
	wget http://www.bic.mni.mcgill.ca/~vfonov/icbm/2009/mni_icbm152_nlin_asym_09c_minc2.zip
	unzip mni_icbm152_nlin_asym_09c_minc2.zip
<<<<<<< HEAD
	rm mni_icbm152_nlin_asym_09c_minc2.zip
=======
>>>>>>> 47ed142cd313b97aefdf76a2775b6ad65fec8c88
fi

# download nonlinear transformation matrices (note: large files)
if [[ ! -f $bbwDir/xfms/BigBrain-to-ICBM2009sym-nonlin_grid_2.mnc ]] ; then
	mkdir $bbwDir/xfms/
	cd $bbwDir/xfms/
	wget https://packages.bic.mni.mcgill.ca/mni-models/PD25/mni_PD25_20190708_minc2.zip
	unzip mni_PD25_20190708_minc2.zip
	cp tranformation/BigBrain-to-ICBM2009sym* $bbwDir/xfms/
	rm -rf MRI
	rm -rf segmentation
	rm -rf tranformation
	rm subcortical-labels.csv
	rm mni_PD25_20190708_minc2.zip
fi

# make git ignore
if [[ ! -f $bbwDir/.gitignore ]] ; then
	cp $bbwDir/template_gitignore.txt $bbwDir/.gitignore
fi


# add to paths
<<<<<<< HEAD
export PATH=$bbwDir/scripts/:$mnc2Path:$PATH
=======
export PATH=$bbwDir/scripts/:$PATH
>>>>>>> 47ed142cd313b97aefdf76a2775b6ad65fec8c88
export MATLABPATH=$bbwDir/scripts/:$MATLABPATH




