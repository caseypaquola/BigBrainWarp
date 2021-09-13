#!/bin/bash
#
# use multimodal surface matching to transform surface data (requires workbench)
# Thanks to Lindsay Lewis for creating the multimodal surface matching spheres
#
# written by Casey Paquola @ MICA, MNI, 2021

in_lh=$1 		# full path to left hemisphere input file
in_rh=$2 		# full path to right hemisphere input file
interp=$3		# interpolation method. Can be used if .txt input, otherwise is set as default
out_space=$4	# output surface can be "fsaverage" or "fs_LR"
out_den=$5		# output density. If out_space is fs_LR, can be 164 or 32. Must be 164 for fsaverage
desc=$6 		# name of descriptor
wd=$7			# working directory

# the output takes the form:
# "$wd"/tpl-"$out_space"_hemi-L_desc-"$desc"."$gii_type".gii  
# "$wd"/tpl-"$out_space"_hemi-R_desc-"$desc"."$gii_type".gii
#
# default $gii_type is shape, however, .annot and .label.gii files will be label type

# check for input data type
extension="${in_lh#*.}"

for hemi in L R ; do
	# define input
	if [[ "$hemi" == "L" ]] ; then
		inData="$in_lh"
	else
		inData="$in_rh"
	fi

	# define gii_type and convert to gifti if necessary
	if [[ "$extension" == *"gii"* ]] ; then
		if [[ "$extension" == *"label"* ]] ; then
			gii_type=label
		else 
			gii_type=shape
		fi
		cp "$inData" "$wd"/tpl-bigbrain_hemi-"$hemi"_desc-"$desc"."$gii_type".gii
	elif [[ "$extension" == "annot" ]] ; then
		gii_type=label
		python "$bbwDir"/scripts/annot2gii.py "$inData" "$wd"/tpl-bigbrain_hemi-"$hemi"_desc-"$desc"."$gii_type".gii "$bbwDir"/spaces/tpl-bigbrain/tpl-bigbrain_hemi-"$hemi"_desc-Yeo2011_7Networks_N1000.label."$gii_type".gii
	elif [[ "$extension" == "curv" ]] ; then
		gii_type=shape
		python "$bbwDir"/scripts/curv2gii.py "$inData" "$wd"/tpl-bigbrain_hemi-"$hemi"_desc-"$desc"."$gii_type".gii "$bbwDir"/spaces/tpl-bigbrain/tpl-bigbrain_hemi-"$hemi"_desc-Func_G1.shape.gii
	elif [[ "$extension" == "txt" ]] ; then
		if [[  "$interp" == "nearest" ]] ; then
			gii_type=label
			python "$bbwDir"/scripts/txt2gii.py "$inData" "$wd"/tpl-bigbrain_hemi-"$hemi"_desc-"$desc"."$gii_type".gii "$bbwDir"/spaces/tpl-bigbrain/tpl-bigbrain_hemi-"$hemi"_desc-Yeo2011_7Networks_N1000.label."$gii_type".gii
		else
			gii_type=shape
			python "$bbwDir"/scripts/txt2gii.py "$inData" "$wd"/tpl-bigbrain_hemi-"$hemi"_desc-"$desc"."$gii_type".gii "$bbwDir"/spaces/tpl-bigbrain/tpl-bigbrain_hemi-"$hemi"_desc-Func_G1.shape.gii
		fi
		
	fi

	# multimodal surface matching
	msmMesh="$bbwDir"/xfms/tpl-"$out_space"_hemi-"$hemi"_den-164k_desc-sphere_rsled_like_bigbrain.reg.surf.gii
	inMesh="$bbwDir"/spaces/tpl-"$out_space"/tpl-"$out_space"_hemi-"$hemi"_den-164k_desc-sphere.surf.gii
	if [[ "$gii_type" == "shape" ]] ; then
		wb_command -metric-resample "$wd"/tpl-bigbrain_hemi-"$hemi"_desc-"$desc"."$gii_type".gii \
			"$msmMesh" "$inMesh" BARYCENTRIC \
			"$wd"/tpl-"$out_space"_hemi-"$hemi"_den-164k_desc-"$desc"."$gii_type".gii
	elif [[ "$gii_type" == "label" ]] ; then
		wb_command -label-resample "$wd"/tpl-bigbrain_hemi-"$hemi"_desc-"$desc"."$gii_type".gii \
			"$msmMesh" "$inMesh" BARYCENTRIC \
			"$wd"/tpl-"$out_space"_hemi-"$hemi"_den-164k_desc-"$desc"."$gii_type".gii
	fi

	# internal downsample, if necessary
	if [[ "$out_den" == "32" ]] ; then
		if [[ "$gii_type" == "shape" ]] ; then
			wb_command -metric-resample "$wd"/tpl-"$out_space"_hemi-"$hemi"_den-164k_desc-"$desc"."$gii_type".gii \
				"$bbwDir"/spaces/tpl-"$out_space"/tpl-"$out_space"_hemi-"$hemi"_den-164k_desc-sphere.surf.gii \
				"$bbwDir"/spaces/tpl-"$out_space"/tpl-"$out_space"_hemi-"$hemi"_den-32k_desc-sphere.surf.gii BARYCENTRIC \
				"$wd"/tpl-"$out_space"_hemi-"$hemi"_den-32k_desc-"$desc"."$gii_type".gii
		elif [[ "$gii_type" == "label" ]] ; then
			wb_command -label-resample "$wd"/tpl-"$out_space"_hemi-"$hemi"_den-164k_desc-"$desc"."$gii_type".gii \
				"$bbwDir"/spaces/tpl-"$out_space"/tpl-"$out_space"_hemi-"$hemi"_den-164k_desc-sphere.surf.gii \
				"$bbwDir"/spaces/tpl-"$out_space"/tpl-"$out_space"_hemi-"$hemi"_den-32k_desc-sphere.surf.gii BARYCENTRIC \
				"$wd"/tpl-"$out_space"_hemi-"$hemi"_den-32k_desc-"$desc"."$gii_type".gii
		fi
	fi

done
