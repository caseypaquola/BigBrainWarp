#!/bin/bash/

# set up variables - change for your environment
export bbwDir=/home/casey/Desktop/BigBrainWarp/  # change to your path to the github repo
export mnc2Path=/opt/minc/1.9.18/ # path to your path to minc2 installation

# set template and download if not already there
export icbmTemplate=$bbwDir/spaces/icbm/mni_icbm152_t1_tal_nlin_sym_09c_mask.mnc
if [[ ! -f $icbmTemplate ]] ; then
	cd $bbwDir/spaces/icbm/
	wget http://www.bic.mni.mcgill.ca/~vfonov/icbm/2009/mni_icbm152_nlin_sym_09c_minc2.zip
	unzip mni_icbm152_nlin_sym_09c_minc2.zip
	rm mni_icbm152_nlin_sym_09c_minc2.zip
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

# download nonlinear transformation for BigBrainHist       
if [[ ! -f $bbwDir/xfms/BigBrainHist-to-ICBM2009sym-nonlin_grid_2.mnc ]] ; then                                                                              
	cd $bbwDir/xfms/                                                                                                                                              
	wget -O BigBrainHist-to-ICBM2009sym-nonlin.xfm https://osf.io/mr4gn/download                                             
	wget -O BigBrainHist-to-ICBM2009sym-nonlin_grid_0.mnc https://osf.io/a8ks2/download                                                         
	wget -O BigBrainHist-to-ICBM2009sym-nonlin_grid_1.mnc https://osf.io/83rgw/download
	wget -O BigBrainHist-to-ICBM2009sym-nonlin_grid_2.mnc https://osf.io/59c7v/download
 	wget -O BigBrainHist-to-ICBM2009sym-nonlin_grid_3.mnc https://osf.io/j8q3e/download
fi

# download bigbrain templates
if [[ ! -f $bbwDir/spaces/bigbrainsym/full8_400um_2009b_sym.mnc ]] ; then
	cd $bbwDir/spaces/bigbrainsym/
	wget ftp://bigbrain.loris.ca/BigBrainRelease.2015/3D_Volumes/MNI-ICBM152_Space/full8_400um_2009b_sym.mnc
fi
if [[ ! -f $bbwDir/spaces/bigbrain/full8_400um_optbal.mnc ]] ; then
	cd $bbwDir/spaces/bigbrain/
	wget ftp://bigbrain.loris.ca/BigBrainRelease.2015/3D_Volumes/Histological_Space/full8_400um_optbal.mnc
fi

# download parcellations for MSM based transformations templates
if [[ ! -f $bbwDir/spaces/bigbrain/rh.Schaefer2018_1000Parcels_17Networks_order.label.txt ]] ; then
	cd $bbwDir/spaces/bigbrain/
	wget ftp://bigbrain.loris.ca/BigBrainRelease.2015/Surface_Parcellations/BigBrain_space/Schaefer2018/lh.Schaefer2018_1000Parcels_17Networks_order.label.txt
	wget ftp://bigbrain.loris.ca/BigBrainRelease.2015/Surface_Parcellations/BigBrain_space/Schaefer2018/rh.Schaefer2018_1000Parcels_17Networks_order.label.txt
	cd $bbwDir/spaces/fsaverage/
	wget ftp://bigbrain.loris.ca/BigBrainRelease.2015/Surface_Parcellations/fsaverage/Schaefer2018/lh.Schaefer2018_1000Parcels_17Networks_order.label.txt
	wget ftp://bigbrain.loris.ca/BigBrainRelease.2015/Surface_Parcellations/fsaverage/Schaefer2018/rh.Schaefer2018_1000Parcels_17Networks_order.label.txt
	cd $bbwDir/spaces/fs_LR/
	wget ftp://bigbrain.loris.ca/BigBrainRelease.2015/Surface_Parcellations/fs_LR/Schaefer2018/lh.Schaefer2018_1000Parcels_17Networks_order.label.txt
	wget ftp://bigbrain.loris.ca/BigBrainRelease.2015/Surface_Parcellations/fs_LR/Schaefer2018/rh.Schaefer2018_1000Parcels_17Networks_order.label.txt
fi

# make git ignore
if [[ ! -f $bbwDir/.gitignore ]] ; then
	cp $bbwDir/template_gitignore.txt $bbwDir/.gitignore
fi

# add to paths
export PATH=$bbwDir/scripts/:$mnc2Path/bin/:$PATH
export PATH=$bbwDir/scripts/:$PATH
export MATLABPATH=$bbwDir/scripts/:$MATLABPATH
