#!/bin/bash

# set up variables - change for your environment
export bbwDir=/data_/mica1/03_projects/casey/BigBrainWarp/  # change to your path to the github repo
export mnc2Path=/data_/mica1/01_programs/minc2/ # path to your path to minc2 installation

# set template
export icbmTemplate=$bbwDir/spaces/tpl-icbm/tpl-icbm_desc-t1_tal_nlin_sym_09c_mask.mnc
cd $bbwDir

# make git ignore
if [[ ! -f $bbwDir/.gitignore ]] ; then
	cp $bbwDir/template_gitignore.txt $bbwDir/.gitignore
fi

# add to paths
export PATH=$bbwDir:$bbwDir/scripts/:$mnc2Path/:$wbPath:$PATH
export MATLABPATH=$bbwDir/scripts/:$MATLABPATH