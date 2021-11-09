#!/bin/bash

# set up variables - change for your environment
export bbwDir=/data_/mica1/03_projects/casey/BigBrainWarp/  # change to your path to the github repo
export mnc2Path=/data_/mica1/01_programs/minc2/ # path to your path to minc2 installation

# set template and download if not already there
export icbmTemplate=$bbwDir/spaces/tpl-icbm/tpl-icbm_desc-t1_tal_nlin_sym_09c_mask.mnc
if [[ ! -f $icbmTemplate ]] ; then
	cd $bbwDir/spaces/tpl-icbm/
	wget --no-check-certificate http://www.bic.mni.mcgill.ca/~vfonov/icbm/2009/mni_icbm152_nlin_sym_09c_minc2.zip
	unzip -j mni_icbm152_nlin_sym_09c_minc2.zip mni_icbm152_t1_tal_nlin_sym_09c_mask.mnc -d $bbwDir/spaces/tpl-icbm/
	rm -f mni_icbm152_nlin_sym_09c_minc2.zip
	mv mni_icbm152_t1_tal_nlin_sym_09c_mask.mnc tpl-icbm_desc-t1_tal_nlin_sym_09c_mask.mnc
fi

# download nonlinear transformation matrices (note: large files)
if [[ ! -f $bbwDir/xfms/BigBrain-to-ICBM2009sym-nonlin_grid_2.mnc ]] ; then
	mkdir $bbwDir/xfms/
	cd $bbwDir/xfms/
	wget --no-check-certificate https://packages.bic.mni.mcgill.ca/mni-models/PD25/mni_PD25_20190708_minc2.zip 
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
if [[ ! -f $bbwDir/spaces/tpl-bigbrain/tpl-bigbrain_desc-cls_1000um_sym.nii ]] ; then
	cd $bbwDir/spaces/tpl-bigbrain/
	wget ftp://bigbrain.loris.ca/BigBrainRelease.2015/3D_Classified_Volumes/MNI-ICBM152_Space/nii/full_cls_1000um_2009b_sym.nii.gz
	gunzip full_cls_1000um_2009b_sym.nii.gz
	mv full_cls_1000um_2009b_sym.nii tpl-bigbrain_desc-cls_1000um_sym.nii
fi
if [[ ! -f $bbwDir/spaces/tpl-bigbrain/tpl-bigbrain_desc-cls_1000um.nii ]] ; then
	cd $bbwDir/spaces/tpl-bigbrain/
	wget ftp://bigbrain.loris.ca/BigBrainRelease.2015/3D_Classified_Volumes/Histological_Space/nii/full_cls_1000um.nii.gz
	gunzip full_cls_1000um.nii.gz
	mv full_cls_1000um.nii tpl-bigbrain_desc-cls_1000um.nii
fi

cd $bbwDir

# make git ignore
if [[ ! -f $bbwDir/.gitignore ]] ; then
	cp $bbwDir/template_gitignore.txt $bbwDir/.gitignore
fi

# add to paths
export PATH=$bbwDir:$bbwDir/scripts/:$mnc2Path/:$wbPath:$PATH
export MATLABPATH=$bbwDir/scripts/:$MATLABPATH