#!/bin/bash

# use multimodal surface matching to transform surface data (requires workbench)
# Thanks to Lindsay Lewis for creating the multimodal surface matching spheres
#
# written by Casey Paquola @ MICA, MNI, 2021

in_vol=$1 	# input file 
interp=$2	# interpolation method
desc=$3     # name of descriptor
wd=$4       # working directory

# the output takes the form:
# ${wd}/tpl-bigbrain_hemi-L_desc-${desc}.shape.gii  
# ${wd}/tpl-bigbrain_hemi-R_desc-${desc}.shape.gii

# check for input data type
# file conversion to nifti if necessary
file_name=$(basename -- "$in_vol")
extension="${file_name##*.}"
file_name="${file_name%.*}"
if [[ "$extension" == "mnc" ]] ; then
   	mnc2nii $in_vol ${wd}/tpl-icbm_desc-${desc}.nii
elif [[ "$extension" == "gz" ]] ; then
	file_name="${file_name%.*}"
	gunzip $in_vol ${wd}/tpl-icbm_desc-${desc}.nii
elif [[ "$extension" == "nii" ]] ; then
	cp $in_vol ${wd}/tpl-icbm_desc-${desc}.nii
else
	echo "file type not recognised; must be .mnc, .nii or .nii.gz"
fi

# convert from nifti to gifti
for hemi in L R ; do
    inmesh=$bbwDir/xfms/tpl-bigbrain_hemi-${hemi}_desc-sphere_rot_fsaverage.surf.gii
    outmeshMSM_inverted=$bbwDir/xfms/tpl-bigbrain_hemi-${hemi}_desc-sphere_rsled_like_icbm.reg.surf.gii
    if [[ $hemi == "L" ]] ; then
        struc_label=CORTEX_LEFT
    else
        struc_label=CORTEX_RIGHT
    fi
    if [[ $interp == "nearest" ]] ; then
	    wb_command -volume-to-surface-mapping ${wd}/tpl-icbm_desc-${desc}.nii \
        $bbwDir/spaces/tpl-icbm/tpl-icbm_hemi-${hemi}_desc-mid.surf.gii \
         ${wd}/tpl-icbm_desc-${desc}.shape.gii -enclosing
    else
	    wb_command -volume-to-surface-mapping ${wd}/tpl-icbm_desc-${desc}.nii \
        $bbwDir/spaces/tpl-icbm/tpl-icbm_hemi-${hemi}_desc-mid.surf.gii \
         ${wd}/tpl-icbm_desc-${desc}.shape.gii -trilinear
    fi
    wb_command -set-structure ${wd}/tpl-icbm_desc-${desc}.shape.gii $struc_label
    wb_command -metric-resample ${wd}/tpl-icbm_desc-${desc}.shape.gii \
        $outmeshMSM_inverted $inmesh BARYCENTRIC ${wd}/tpl-bigbrain_desc-${desc}.shape.gii
done
