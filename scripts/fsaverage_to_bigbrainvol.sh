#!/bin/bash

# use multimodal surface matching to transform surface data (requires workbench)
# Thanks to Lindsay Lewis for creating the multimodal surface matching spheres
#
# written by Casey Paquola @ MICA, MNI, 2021

in_lh=$1 		# full path to left hemisphere input file
in_rh=$2 		# full path to right hemisphere input file
in_space=$3		# input surface can be "fsaverage" or "fs_LR"
interp=$4		# interpolation method. Can be used if .txt input, otherwise is set as default
bb_space=$5		# which bigbrain space is input: "histological" or "sym"
out_res=$6		# output resolution in mm
desc=$7 		# name of descriptor
wd=$8			# working directory

# the output takes the form:
# "$wd"/tpl-bigbrain_hemi-L_res-"$out_res"_desc-"$desc".nii
# "$wd"/tpl-bigbrain_hemi-R_res-"$out_res"_desc-"$desc".nii
#
# check for input data type
extension="${in_lh#*.}"

# check density of input surface
in_den=$(python3 "$bbwDir"/scripts/check_dim.py "$in_lh" "$extension")

for hemi in L R ; do
	# define input
	if [[ "$hemi" == "L" ]] ; then
		inData="$in_lh"
	else
		inData="$in_rh"
	fi

	# define gii_type and convert to gifti if necessary.
	# third argument to python conversions is a template and is relatively arbitrary. Only the giiType is conserved. 
	if [[ "$extension" == *"gii"* ]] ; then
		if [[ "$extension" == *"label"* ]] ; then
			gii_type=label
			interp_res=nearest_neighbour
		else 
			gii_type=shape
			interp_res=trilinear
		fi
		cp "$inData" "$wd"/tpl-"$in_space"_hemi-"$hemi"_den-"$in_den"k_desc-"$desc"."$gii_type".gii
	elif [[ "$extension" == "annot" ]] ; then
		gii_type=label
		interp_res=nearest_neighbour
		python "$bbwDir"/scripts/annot2gii.py "$inData" "$wd"/tpl-"$in_space"_hemi-"$hemi"_den-"$in_den"k_desc-"$desc"."$gii_type".gii "$wd"/tpl-bigbrain_hemi-"$hemi"_desc-Yeo2011_7Networks_N1000.label."$gii_type".gii
	elif [[ "$extension" == "curv" ]] ; then
		gii_type=shape
		interp_res=trilinear
		python "$bbwDir"/scripts/curv2gii.py "$inData" "$wd"/tpl-"$in_space"_hemi-"$hemi"_den-"$in_den"k_desc-"$desc"."$gii_type".gii "$wd"/tpl-bigbrain_hemi-"$hemi"_desc-Func_G1.shape.gii
	elif [[ "$extension" == "txt" ]] ; then
		if [[  "$interp" == "nearest" ]] ; then
			gii_type=label
			interp_res=nearest_neighbour
			python "$bbwDir"/scripts/txt2gii.py "$inData" "$wd"/tpl-"$in_space"_hemi-"$hemi"_den-"$in_den"k_desc-"$desc"."$gii_type".gii "$wd"/tpl-bigbrain_hemi-"$hemi"_desc-Yeo2011_7Networks_N1000.label."$gii_type".gii
		else
			gii_type=shape
			interp_res=trilinear
			python "$bbwDir"/scripts/txt2gii.py "$inData" "$wd"/tpl-"$in_space"_hemi-"$hemi"_den-"$in_den"k_desc-"$desc"."$gii_type".gii "$wd"/tpl-bigbrain_hemi-"$hemi"_desc-Func_G1.shape.gii
		fi
	else
		echo "file type of ${inData} not recognised"
	fi

	# internal upsampling, if necessary
	if [[ "$in_den" == "32" ]] ; then
		if [[ "$gii_type" == "shape" ]] ; then
			wb_command -metric-resample "$wd"/tpl-"$in_space"_hemi-"$hemi"_den-32k_desc-"$desc"."$gii_type".gii \
				"$bbwDir"/spaces/tpl-"$in_space"/tpl-"$in_space"_hemi-"$hemi"_den-32k_desc-sphere.surf.gii \
				"$bbwDir"/spaces/tpl-"$in_space"/tpl-"$in_space"_hemi-"$hemi"_den-164k_desc-sphere.surf.gii BARYCENTRIC \
				"$wd"/tpl-"$in_space"_hemi-"$hemi"_den-164k_desc-"$desc"."$gii_type".gii
		elif [[ "$gii_type" == "label" ]] ; then
			wb_command -label-resample "$wd"/tpl-"$in_space"_hemi-"$hemi"_den-32k_desc-"$desc"."$gii_type".gii \
				"$bbwDir"/spaces/tpl-"$in_space"/tpl-"$in_space"_hemi-"$hemi"_den-32k_desc-sphere.surf.gii \
				"$bbwDir"/spaces/tpl-"$in_space"/tpl-"$in_space"_hemi-"$hemi"_den-164k_desc-sphere.surf.gii BARYCENTRIC \
				"$wd"/tpl-"$in_space"_hemi-"$hemi"_den-164k_desc-"$desc"."$gii_type".gii
		fi
	fi

    # set templates based on bb_space
    if [[ "$bb_space" == "histological" ]] ; then
        pial="$bbwDir"/spaces/tpl-bigbrain/tpl-bigbrain_hemi-"$hemi"_desc-pial.surf.gii
        white="$bbwDir"/spaces/tpl-bigbrain/tpl-bigbrain_hemi-"$hemi"_desc-white.surf.gii
        ref_volume="$bbwDir"/spaces/tpl-bigbrain/tpl-bigbrain_desc-cls_1000um.nii
    else
        pial="$bbwDir"/spaces/tpl-bigbrain/tpl-bigbrain_hemi-"$hemi"_desc-pial_sym.surf.gii
        white="$bbwDir"/spaces/tpl-bigbrain/tpl-bigbrain_hemi-"$hemi"_desc-white_sym.surf.gii
        ref_volume="$bbwDir"/spaces/tpl-bigbrain/tpl-bigbrain_desc-cls_1000um_sym.nii
    fi

    # resample reference volume, if necessary
    if [[ "$out_res" == "1" ]] ; then
        rm -rf "$wd"/tmp_ref.mnc
		nii2mnc "$ref_volume" "$wd"/tmp_ref.mnc

        # Get input spacing and dimension
        vx_input=$(mincinfo "$wd"/tmp_ref.mnc -attvalue xspace:step)
        vy_input=$(mincinfo "$wd"/tmp_ref.mnc -attvalue yspace:step)
        vz_input=$(mincinfo "$wd"/tmp_ref.mnc -attvalue zspace:step)

        dx_input=$(mincinfo "$wd"/tmp_ref.mnc -dimlength xspace)
        dy_input=$(mincinfo "$wd"/tmp_ref.mnc -dimlength yspace)
        dz_input=$(mincinfo "$wd"/tmp_ref.mnc -dimlength zspace)
        
		# Compute output dimension
        dx_output=$(echo "$dx_input * $vx_input / ${out_res}" | bc); dx_output=${dx_output#-}
        dy_output=$(echo "$dy_input * $vy_input / ${out_res}" | bc); dy_output=${dx_output#-}
        dz_output=$(echo "$dz_input * $vz_input / ${out_res}" | bc); dz_output=${dx_output#-}
		echo "$dx_output" "$dy_output" "$dz_output"

        # resample reference image to 
        echo "resampling reference image to provided output resolution"
		mincresample -clobber -"$interp_res" \
            -step "$out_res" "$out_res" "$out_res" \
            -nelements "$dx_output" "$dy_output" "$dz_output" \
			"$wd"/tmp_ref.mnc "$wd"/tmp_ref_resampled.mnc

        mnc2nii "$wd"/tmp_ref_resampled.mnc "$wd"/ref_resampled.nii
        #rm -rf "$wd"/tmp_ref.mnc
        #rm -rf "$wd"/tmp_ref_resampled.mnc
        ref_volume="$wd"/ref_resampled.nii
    fi


	# multimodal surface matching
	msmMesh="$bbwDir"/xfms/tpl-bigbrain_hemi-"$hemi"_desc-sphere_rsled_like_"$in_space".reg.surf.gii
	inMesh="$bbwDir"/xfms/tpl-bigbrain_hemi-"$hemi"_desc-sphere_rot_"$in_space".surf.gii
	if [[ "$gii_type" == "shape" ]] ; then
		wb_command -metric-resample "$wd"/tpl-"$in_space"_hemi-"$hemi"_den-164k_desc-"$desc"."$gii_type".gii \
		"$msmMesh" "$inMesh" BARYCENTRIC \
		"$wd"/tpl-bigbrain_hemi-"$hemi"_desc-"$desc"."$gii_type".gii
        wb_command -metric-to-volume-mapping "$wd"/tpl-bigbrain_hemi-"$hemi"_desc-"$desc"."$gii_type".gii \
			 "$white" "$ref_volume" \
			 "$wd"/tpl-bigbrain_hemi-"$hemi"_desc-"$desc".nii \
			 -ribbon-constrained "$pial" "$white"
	elif [[ "$gii_type" == "label" ]] ; then
		wb_command -label-resample "$wd"/tpl-"$in_space"_hemi-"$hemi"_den-164k_desc-"$desc"."$gii_type".gii \
		"$msmMesh" "$inMesh" BARYCENTRIC \
		"$wd"/tpl-bigbrain_hemi-"$hemi"_desc-"$desc"."$gii_type".gii
        wb_command -label-to-volume-mapping "$wd"/tpl-bigbrain_hemi-"$hemi"_desc-"$desc"."$gii_type".gii \
			"$white" "$ref_volume" \
			"$wd"/tpl-bigbrain_hemi-"$hemi"_desc-"$desc".nii \
			-ribbon-constrained "$pial" "$white"
	fi
done
