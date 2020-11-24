#!/bin/bash
# perform surface to volume mapping then nonlinear transformation from fsaverage to BigBrain surface
# written by Casey Paquola @ MICA, MNI, 2020*

lhInput=$1		# full path to input file of left hemisphere
rhInput=$2		# full path to input file of righthemisphere
interp=$3		# "linear" (smooth data) or "nearest_neighbour" (discrete data)
workDir=$4 		# working directory
cleanup=$5 		# "y" to remove intermediate files, "n" to keep

% output is $workDir/${fileFile}_bigbrain.mnc or $workDir/${fileFile}_bigbrain.nii (extension is determined by input)
[[ -d $workDir ]] || mkdir -p $workDir

% get name
fileName=$(basename -- "$lhInput")
fileName="${fileName%.*}"
fileName="${fileName##*.}"

# use Wu et al., transformation from fsaverage to mni152
export MATLABPATH=$MATLABPATH:$bbwDir/scripts
outName="$workDir"/"$fileName"
matlab19b -r 'wrapper_fsaverage2mni("'${lhInput}'", "'${rhInput}'", "'${interp}'", "'${outName}'", "'${bbwDir}'", "'${cbigDir}'"); quit'
nii2mnc  "$workDir"/${fileName}_mni152.nii "$workDir"/${fileName}_mni152.mnc
rm -rf  "$workDir"/${fileName}_mni152.nii

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
mincresample -clobber -transformation ${bbwDir}/xfms/BigBrain-to-ICBM2009sym-nonlin.xfm -invert_transformation -tfm_input_sampling -${mnc_interp} ${outName}_mni152.mnc ${outName}_bigbrain.mnc
mnc2nii ${outName}_bigbrain.mnc ${outName}_bigbrain.nii

# dilate the volume in bigbrain space to ensure the whole cortical ribbon is covered
fslmaths ${outName}_bigbrain.nii -abs -thr 0.001 -bin -mul ${outName}_bigbrain.nii ${outName}_bigbrain_thresh.nii
fslmaths ${outName}_bigbrain_thresh.nii -$dil -$dil -$dil -$dil -$dil ${outName}_bigbrain_dilated.nii
gunzip ${outName}_bigbrain_dilated.nii.gz
nii2mnc ${outName}_bigbrain_dilated.nii ${outName}_bigbrain_dilated.mnc

# sample parcellation values from the cortical midsurface
volume_object_evaluate -$voe_interp ${outName}_bigbrain_dilated.mnc $bbwDir/spaces/bigbrain/lh.midsurf.obj ${outName}_bigbrain_lh.txt
volume_object_evaluate -$voe_interp ${outName}_bigbrain_dilated.mnc $bbwDir/spaces/bigbrain/rh.midsurf.obj ${outName}_bigbrain_rh.txt


