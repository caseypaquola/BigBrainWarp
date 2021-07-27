#!/bin/bash
#
# use multimodal surface matching to transform surface data (requires workbench)
# Thanks to Lindsay Lewis for creating the multimodal surface matching spheres
#
# written by Casey Paquola @ MICA, MNI, 2021

in_vol=$1 	    # input file 
bb_space=$2     # which bigbrain space is input: "histological" or "sym"
interp=$3		# interpolation method. Can be used if .txt input, otherwise is set as default
out_space=$4	# output surface can be "fsaverage" or "fs_LR"
out_den=$5		# output density. If out_space is fs_LR, can be 164 or 32. Must be 164 for fsaverage
desc=$6 		# name of descriptor
wd=$7			# working directory

# the output takes the form:
# "$wd"/tpl-bigbrain_hemi-L_desc-"$desc".shape.gii  
# "$wd"/tpl-bigbrain_hemi-R_desc-"$desc".shape.gii

# check for input data type
# file conversion to nifti if necessary
file_name=$(basename -- "$in_vol")
extension="${file_name##*.}"
file_name="${file_name%.*}"
if [[ "$extension" == "mnc" ]] ; then
   	mnc2nii "$in_vol" "$wd"/tpl-bigbrain_desc-"$desc".nii
elif [[ "$extension" == "gz" ]] ; then
	file_name=""$file_name%.*""
	gunzip "$in_vol" "$wd"/tpl-bigbrain_desc-"$desc".nii
elif [[ "$extension" == "nii" ]] ; then
	cp "$in_vol" "$wd"/tpl-bigbrain_desc-"$desc".nii
else
	echo "file type not recognised; must be .mnc, .nii or .nii.gz"
fi


for hemi in L R ; do
    # select midsurface based on bb_space
    if [[ "$bb_space" == "histological" ]] ; then
        mid_surf="$bbwDir"/spaces/tpl-bigbrain/tpl-bigbrain_hemi-"$hemi"_desc-mid.surf.gii
    else
        mid_surf="$bbwDir"/spaces/tpl-bigbrain/tpl-bigbrain_hemi-"$hemi"_desc-mid_sym.surf.gii
    fi

    # volume to surface mapping
    if [[ "$interp" == "nearest" ]] ; then
	    wb_command -volume-to-surface-mapping "$wd"/tpl-bigbrain_desc-"$desc".nii \
         "$mid_surf" \
         "$wd"/tpl-bigbrain_desc-"$desc".shape.gii -enclosing
    else
	    wb_command -volume-to-surface-mapping "$wd"/tpl-bigbrain_desc-"$desc".nii \
        "$mid_surf" \
         "$wd"/tpl-bigbrain_desc-"$desc".shape.gii -trilinear
    fi

	# multimodal surface matching
	msmMesh="$bbwDir"/xfms/tpl-"$out_space"_hemi-"$hemi"_den-164k_desc-sphere_rsled_like_bigbrain.reg.surf.gii
	inMesh="$bbwDir"/spaces/tpl-"$out_space"/tpl-"$out_space"_hemi-"$hemi"_den-164k_desc-sphere.surf.gii
	wb_command -metric-resample "$wd"/tpl-bigbrain_hemi-"$hemi"_desc-"$desc".shape.gii \
		"$msmMesh" "$inMesh" BARYCENTRIC \
		"$wd"/tpl-"$out_space"_hemi-"$hemi"_den-164k_desc-"$desc".shape.gii

	# internal downsample, if necessary
	if [[ "$out_den" == "32" ]] ; then
    	wb_command -metric-resample "$wd"/tpl-"$out_space"_hemi-"$hemi"_den-164k_desc-"$desc".shape.gii \
			"$bbwDir"/spaces/tpl-"$out_space"/tpl-"$out_space"_hemi-"$hemi"_den-164k_desc-sphere.surf.gii \
			"$bbwDir"/spaces/tpl-"$out_space"/tpl-"$out_space"_hemi-"$hemi"_den-32k_desc-sphere.surf.gii BARYCENTRIC \
			"$wd"/tpl-"$out_space"_hemi-"$hemi"_den-32k_desc-"$desc".shape.gii
	fi

done
