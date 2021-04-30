#!/bin/bash

# use multimodal surface matching to transform surface data (requires workbench)
# Thanks to Lindsay Lewis for creating the multimodal surface matching spheres
#
# written by Casey Paquola @ MICA, MNI, 2021

fullFile=$1 	# input file 
interp=$2	# interpolation method
workDir=$3      # working directory

# the output takes the form ${outName}_${hemi}_${outSurf}.${giiType}.gii
# where hemi is lh and rh, they are saved out separately
# default type is shape, however, .annot and .label.gii files will be label type

# check for input data type
# file conversion to nifti if necessary
fileName=$(basename -- "$fullFile")
extension="${fileName##*.}"
fileName="${fileName%.*}"
if [[ "$extension" == "mnc" ]] ; then
   	mnc2nii $fullFile $workDir/${fileName}.nii
elif [[ "$extension" == "gz" ]] ; then
	fileName="${fileName%.*}"
	gunzip $fullFile $workDir/${fileName}.nii
elif [[ "$extension" == "nii" ]] ; then
	if [[ ! -f $workDir/${fileName}.nii ]] ; then
		cp $fullFile $workDir/${fileName}.nii
	fi
else
	echo "file type not recognised; must be .mnc, .nii or .nii.gz"
fi

# convert from nifti to gifti
for hemi in lh rh ; do
    inmesh=$bbwDir/xfms/$hemi.BigBrain.rot.fsavg.sphere.surf.gii
    refmesh=$bbwDir/xfms/$hemi.MNI152.rot.fsavg.sphere.surf.gii 
    outmeshMSM=$bbwDir/xfms/$hemi.sphere_MNI152_rsled_like_BigBrain.sphere.reg.surf.gii
    outmeshMSM_inverted=$bbwDir/xfms/$hemi.sphere_BigBrain_rsled_like_MNI152.sphere.reg.surf.gii
    wb_command -surface-sphere-project-unproject $refmesh $outmeshMSM $inmesh $outmeshMSM_inverted
    if [[ $hemi == "lh" ]] ; then
        struc_label=CORTEX_LEFT
	hemi_long=left
    else
        struc_label=CORTEX_RIGHT
	hemi_long=right
    fi
    if [[ $interp == "nearest" ]] ; then
	wb_command -volume-to-surface-mapping $workDir/${fileName}.nii $bbwDir/spaces/icbm/icbm_avg_mid_sym_mc_${hemi_long}_hires.surf.gii $workDir/${hemi}.${fileName}.shape.gii -enclosing
    else
	wb_command -volume-to-surface-mapping $workDir/${fileName}.nii $bbwDir/spaces/icbm/icbm_avg_mid_sym_mc_${hemi_long}_hires.surf.gii $workDir/${hemi}.${fileName}.shape.gii -trilinear
    fi
    wb_command -set-structure $workDir/${hemi}.${fileName}.shape.gii $struc_label
    wb_command -metric-resample $workDir/${hemi}.${fileName}.shape.gii $outmeshMSM_inverted $inmesh BARYCENTRIC $workDir/${hemi}.${fileName}_bigbrain.shape.gii
done
