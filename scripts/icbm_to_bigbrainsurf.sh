#!/bin/bash

# use multimodal surface matching to transform surface data (requires workbench)
# Thanks to Lindsay Lewis for creating the multimodal surface matching spheres
#
# written by Casey Paquola @ MICA, MNI, 2021

fullFile=$1 	# input file 
interp=$2		# interpolation method
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
	cp $fullFile $workDir/${fileName}.nii
else
	echo "file type not recognised; must be .mnc, .nii or .nii.gz"
fi

# convert from nifti to gifti
for hemi in lh rh ; do
    $inmesh=$bbwDir/xfms/$hemi.BigBrain.rot.fsavg.sphere.surf.gii
    $refmesh=$bbwDir/xfms/$hemi.MNI152.rot.fsavg.sphere.surf.gii 
    $outmeshMSM=$bbwDir/xfms/$hemi.sphere_MNI152_rsled_like_BigBrain.sphere.reg.surf.gii
    $outmeshMSM_inverted=$bbwDir/xfms/$hemi.sphere_BigBrain_rsled_like_MNI152.sphere.reg.surf.gii
    wb_command -surface-sphere-project-unproject $refmesh $outmeshMSM $inmesh $outmeshMSM_inverted
    if [[ $hemi == "lh" ]] ; 
        struc_label=CORTEX_LEFT
    else
        struc_label=CORTEX_RIGHT
    fi
    if [[ $interp == "nearest" ]] ; then
        wb_command -cifti-convert -from-nifti $workDir/${fileName}.nii $bbwDir/xfmx/$hemi.AAL.template.nii $workDir/$hemi.${fileName}.label.nii
        wb_command -cifti-separate $workDir/${fileName}.nii COLUMN -label $struc_label ${hemi}.$workDir/${fileName}.label.gii
        wb_command -label-resample ${hemi}.$workDir/${fileName}.label.gii $outmeshMSM_inverted $inmesh BARYCENTRIC ${hemi}.$workDir/${fileName}_bigbrain.label.gii
        wb_command -set-structure ${hemi}.$workDir/${fileName}_bigbrain.label.gii $struc_label
    else
        wb_command -cifti-convert -from-nifti $workDir/${fileName}.nii $bbwDir/xfmx/${hemi}.AAL.template.nii $workDir/${hemi}.${fileName}.shape.nii
        wb_command -cifti-separate $workDir/${fileName}.nii COLUMN -shape $struc_label ${hemi}.$workDir/${fileName}.shape.gii
        wb_command -metric-resample ${hemi}.$workDir/${fileName}.shape.gii $outmeshMSM_inverted $inmesh BARYCENTRIC ${hemi}.$workDir/${fileName}_bigbrain.shape.gii
    fi
fi
