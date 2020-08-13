#!/bin/bash
# perform surface to volume mapping then nonlinear transformation from fsaverage to BigBrain space
# written by Casey Paquola @ MICA, MNI, 2020*

lh_input=$1
rh_input=$2
interp=$3
outName=$4
bbwDir=$5
cbigDir=$6

matlab19b -r 'wrapper_fsaverage2mni("'${lh_input}'", "'${rh_input}'", "'${interp}'", "'${outName}'", "'${bbwDir}'", "'${cbigDir}'"); quit'
nii2mnc ${outName}_mni152.nii ${outName}_mni152.mnc
rm -rf ${outName}_mni152.nii

sh $bbwDir/scripts/icbm_to_bigbrain.sh ${outName}_mni152 $bbwDir
mv ${outName}_mni152_bigbrain.mnc ${outName}_bigbrain.mnc

if [ ${interp} = linear ]; then
	voe_interp = linear
elif [ ${interp} = nearest ]
	voe_interp=nearest_neighbour
fi
volume_object_evaluate -${voe_interp} ${outName}_bigbrain.mnc $bbwDir/bigbrain_surfaces/equivolumetric/lh.9.obj ${outName}_bigbrain_lh.txt
volume_object_evaluate -${voe_interp} ${outName}_bigbrain.mnc $bbwDir/bigbrain_surfaces/equivolumetric/rh.9.obj ${outName}_bigbrain_rh.txt


