#!/bin/bash

#
# written by Casey Paquola @ MICA, MNI, 2021

in_vol=$1 	# input file 
interp=$2	# interpolation method
desc=$3     # name of descriptor
wd=$4       # working directory

# the output takes the form:
# "$wd"/tpl-bigbrain_hemi-L_desc-"$desc".shape.gii  
# "$wd"/tpl-bigbrain_hemi-R_desc-"$desc".shape.gii

# check for input data type
# file conversion to nifti if necessary
file_name=$(basename -- "$in_vol")
extension="${file_name##*.}"
file_name="${file_name%.*}"
if [[ "$extension" == "mnc" ]] ; then
   	mnc2nii "$in_vol" "$wd"/tpl-icbm_desc-"$desc".nii
elif [[ "$extension" == "gz" ]] ; then
	file_name=""$file_name%.*""
	gunzip "$in_vol" "$wd"/tpl-icbm_desc-"$desc".nii
elif [[ "$extension" == "nii" ]] ; then
	cp "$in_vol" "$wd"/tpl-icbm_desc-"$desc".nii
else
	echo "file type not recognised; must be .mnc, .nii or .nii.gz"
fi

# rename interp method to align with minc
if [[ "$interp" == "nearest" ]] ; then
	interp=nearest_neighbour
fi

# icbm to bigbrain volume
ref_volume="$bbwDir"/spaces/tpl-bigbrain/tpl-bigbrain_desc-cls_1000um_sym.nii
mincresample -clobber -transformation "$bbwDir"/xfms/BigBrain-to-ICBM2009sym-nonlin.xfm \
		-invert_transformation \
		-like "$ref_volume" \
		-"$interp" \
		"$wd"/tpl-icbm_desc-"$desc".mnc \
		"$wd"/tpl-bigbrain_desc-"$desc"_sym.mnc
mnc2nii "$wd"/tpl-bigbrain_desc-"$desc"_sym.mnc "$wd"/tpl-bigbrain_desc-"$desc"_sym.nii        

# convert from nifti to gifti
for hemi in L R ; do
    if [[ "$interp" == "nearest_neighbour" ]] ; then
	    wb_command -volume-to-surface-mapping "$wd"/tpl-bigbrain_desc-"$desc"_sym.nii \
        "$bbwDir"/spaces/tpl-bigbrain/tpl-bigbrain_hemi-"$hemi"_desc-mid_sym.surf.gii \
        "$wd"/tpl-bigbrain_desc-"$desc".shape.gii -enclosing
    else
	    wb_command -volume-to-surface-mapping "$wd"/tpl-bigbrain_desc-"$desc"_sym.nii \
        "$bbwDir"/spaces/tpl-bigbrain/tpl-bigbrain_hemi-"$hemi"_desc-mid_sym.surf.gii \
        "$wd"/tpl-bigbrain_desc-"$desc".shape.gii -trilinear
    fi
done