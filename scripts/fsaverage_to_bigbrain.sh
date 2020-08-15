#!/bin/bash
# perform surface to volume mapping then nonlinear transformation from fsaverage to BigBrain space
# written by Casey Paquola @ MICA, MNI, 2020*

lh_input=$1
rh_input=$2
interp=$3
outName=$4
bbwDir=$5
cbigDir=$6

. /etc/fsl/5.0/fsl.sh

# use Wu et al., transformation from fsaverage to mni152
export MATLABPATH=$MATLABPATH:$bbwDir/scripts
#matlab19b -r 'wrapper_fsaverage2mni("'${lh_input}'", "'${rh_input}'", "'${interp}'", "'${outName}'", "'${bbwDir}'", "'${cbigDir}'"); quit'
#nii2mnc ${outName}_mni152.nii ${outName}_mni152.mnc
#rm -rf ${outName}_mni152.nii

# precise interpolation method for minc
if [ ${interp} = linear ]; then
	mnc_interp=trilinear
	voe_interp=linear
	dil=dilM # dilation of mean
elif [ ${interp} = nearest ] ; then
	mnc_interp=nearest_neighbour
	voe_interp=nearest_neighbour
	dil=dilD # dilation of mode
fi

# transform from mni152 to bigbrain volume space
export PATH=/data_/mica1/01_programs/minc2/:$PATH
#sh $bbwDir/scripts/icbm_to_bigbrain.sh ${outName}_mni152 $bbwDir $mnc_interp
#mincresample -clobber -transformation ${bbwDir}/xfms/BigBrain-to-ICBM2009sym-nonlin.xfm -invert_transformation -tfm_input_sampling -${mnc_interp} ${outName}_mni152.mnc ${outName}_mni152_nl.mnc
#mincresample -clobber -transformation ${bbwDir}/xfms/bigbrain_to_icbm2009b_nl.xfm -invert_transformation -tfm_input_sampling -${mnc_interp} ${outName}_mni152_nl.mnc ${outName}_mni152_nl_nl.mnc
#mincresample -clobber -transformation ${bbwDir}/xfms/bigbrain_to_icbm2009b_lin.xfm -invert_transformation -tfm_input_sampling -${mnc_interp} ${outName}_mni152_nl_nl.mnc ${outName}_mni152_bigbrain.mnc
#mnc2nii ${outName}_mni152_bigbrain.mnc ${outName}_bigbrain.nii

# dilate the volume in bigbrain space to ensure the whole cortical ribbon is covered
fslmaths ${outName}_bigbrain.nii -abs -thr 0.001 -bin -mul ${outName}_bigbrain.nii ${outName}_bigbrain_thresh.nii
fslmaths ${outName}_bigbrain_thresh.nii -$dil -$dil -$dil -$dil -$dil ${outName}_bigbrain_dilated.nii
gunzip ${outName}_bigbrain_dilated.nii.gz
nii2mnc ${outName}_bigbrain_dilated.nii ${outName}_bigbrain_dilated.mnc

# sample parcellation values from the cortical midsurface
volume_object_evaluate -$voe_linear ${outName}_bigbrain_dilated.mnc $bbwDir/bigbrain_surfaces/equivolumetric/lh.9.obj ${outName}_bigbrain_lh.txt
volume_object_evaluate -$voe_linear ${outName}_bigbrain_dilated.mnc $bbwDir/bigbrain_surfaces/equivolumetric/rh.9.obj ${outName}_bigbrain_rh.txt

