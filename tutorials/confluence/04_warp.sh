#!/bin/bash

# Tutorial: Variations in resting state functional connectivity along a histological axis

# pull the bigbrainwarp repo - alternatively, use GitHub Desktop
git clone https://github.com/caseypaquola/BigBrainWarp.git

# set path of github repo
bbwDir=/home/casey/Desktop/BigBrainWarp/ # the github repo
mnc2Path=/opt/minc/1.9.18/bin/  # location of minc2 commands 
wbPath=/home/casey/Downloads/software/workbench/bin_linux64/ # location of wb_command
workingDir=/home/casey/Desktop/8_BigBrainWarp/tests/ # somewhere on your local computer

# initialisation
nano $bbwDir/scripts/init.sh  # change the first three lines for your local environment
source $bbwDir/scripts/init.sh

# warp histological axis 
bigbrainwarp --in_space bigbrain --out_space icbm --wd $workingDir --in $workingDir/histological_axis_vox.nii --interp trilinear
