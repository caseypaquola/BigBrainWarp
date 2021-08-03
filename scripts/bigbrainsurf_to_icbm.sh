#!/bin/bash
#
# written by Casey Paquola @ MICA, MNI, 2021

in_lh=$1 		# full path to left hemisphere input file
in_rh=$2 		# full path to right hemisphere input file
interp=$3		# interpolation method. Can be used if .txt input, otherwise is set as default
out_res=$4		# output resolution in mm
desc=$5 		# name of descriptor
wd=$6			# working directory

# the output takes the form:
# "$wd"/tpl-icbm_desc-"$desc".nii

# check for input data type
filename=$(basename -- "$in_lh")
extension="${filename##*.}"

for hemi in L R ; do
	# define input
	if [[ "$hemi" == "L" ]] ; then
		inData="$in_lh"
	else
		inData="$in_rh"
	fi

	# define gii_type and convert to gifti if necessary
	if [[ "$extension" == "gii" ]] ; then
		substr="$filename: -10"
		if [[ $substr == *"label"* ]] ; then
			gii_type=label
			interp_res=nearest_neighbour
		else 
			gii_type=shape
			interp_res=trilinear
		fi
		cp "$inData" "$wd"/tpl-bigbrain_hemi-"$hemi"_desc-"$desc"."$gii_type".gii
	elif [[ "$extension" == "annot" ]] ; then
		gii_type=label
		interp_res=nearest_neighbour
		mris_convert --annot "$inData" \
			"$bbwDir"/spaces/tpl-bigbrain/tpl-bigbrain_hemi-"$hemi"_desc-white.surf.gii \
			"$wd"/tpl-bigbrain_hemi-"$hemi"_desc-"$desc"."$gii_type".gii
	elif [[ "$extension" == "curv" ]] ; then
		gii_type=shape
		interp_res=trilinear
		mris_convert -c "$inData" \
			"$bbwDir"/spaces/tpl-bigbrain/tpl-bigbrain_hemi-"$hemi"_desc-white.surf.gii \
			"$wd"/tpl-bigbrain_hemi-"$hemi"_desc-"$desc"."$gii_type".gii
	elif [[ "$extension" == "txt" ]] ; then
		if [[  "$interp" == "nearest" ]] ; then			
			gii_type=label
			interp_res=nearest_neighbour
		else
			gii_type=shape
			interp_res=trilinear
		fi
		python "$bbwDir"/scripts/txt2curv.py "$inData" "$wd"/tpl-bigbrain_hemi-"$hemi"_desc-"$desc".curv "$bbwDir"/spaces/tpl-bigbrain/tpl-bigbrain_hemi-"$hemi"_desc-Func_G1.shape.gii
		mris_convert -c "$wd"/tpl-bigbrain_hemi-"$hemi"_desc-"$desc".curv \
			"$bbwDir"/spaces/tpl-bigbrain/tpl-bigbrain_hemi-"$hemi"_desc-white.surf.gii \
			"$wd"/tpl-bigbrain_hemi-"$hemi"_desc-"$desc"."$gii_type".gii
	fi

	# gives struc labels to gifti
    if [[ "$hemi" == "L" ]] ; then
        struc_label=CORTEX_LEFT
    else
        struc_label=CORTEX_RIGHT
    fi

    # bigbrain surface to bigbrain volume
    ref_volume="$bbwDir"/spaces/tpl-bigbrain/tpl-bigbrain_desc-cls_1000um_sym.nii
	if [[ "$gii_type" == "shape" ]] ; then
		wb_command -metric-to-volume-mapping "$wd"/tpl-bigbrain_hemi-"$hemi"_desc-"$desc"."$gii_type".gii \
			"$bbwDir"/spaces/tpl-bigbrain/tpl-bigbrain_hemi-"$hemi"_desc-pial_sym.surf.gii \
			"$ref_volume" \
			"$wd"/tpl-bigbrain_hemi-"$hemi"_desc-"$desc".nii \
			-ribbon-constrained "$bbwDir"/spaces/tpl-bigbrain/tpl-bigbrain_hemi-"$hemi"_desc-pial_sym.surf.gii \
			"$bbwDir"/spaces/tpl-bigbrain/tpl-bigbrain_hemi-"$hemi"_desc-white_sym.surf.gii
	elif [[ "$gii_type" == "label" ]] ; then
		wb_command -label-to-volume-mapping "$wd"/tpl-bigbrain_hemi-"$hemi"_desc-"$desc"."$gii_type".gii \
			"$bbwDir"/spaces/tpl-bigbrain/tpl-bigbrain_hemi-"$hemi"_desc-pial_sym.surf.gii \
			"$ref_volume" \
			"$wd"/tpl-bigbrain_hemi-"$hemi"_desc-"$desc".nii \
			-ribbon-constrained "$bbwDir"/spaces/tpl-bigbrain/tpl-bigbrain_hemi-"$hemi"_desc-pial_sym.surf.gii \
			"$bbwDir"/spaces/tpl-bigbrain/tpl-bigbrain_hemi-"$hemi"_desc-white_sym.surf.gii
	fi

	# define reference volume and resample if necessary
	ref_volume="$bbwDir"/spaces/tpl-icbm/tpl-icbm_desc-t1_tal_nlin_sym_09c_mask.mnc
    if [[ "$out_res" != "1" ]] ; then
        # Get input spacing and dimension
        vx_input=$(mincinfo "$wd"/tmp_ref.mnc -attvalue xspace:step)
        vy_input=$(mincinfo "$wd"/tmp_ref.mnc -attvalue yspace:step)
        vz_input=$(mincinfo "$wd"/tmp_ref.mnc -attvalue zspace:step)
​
        dx_input=$(mincinfo "$wd"/tmp_ref.mnc -dimlength xspace)
        dy_input=$(mincinfo "$wd"/tmp_ref.mnc -dimlength yspace)
        dz_input=$(mincinfo "$wd"/tmp_ref.mnc -dimlength zspace)
​
        # Compute output dimension
        dx_output=$(echo "$dx_input * $vx_input / ${out_res}" | bc); dx_output=${dx_output#-}
        dy_output=$(echo "$dy_input * $vy_input / ${out_res}" | bc); dy_output=${dx_output#-}
        dz_output=$(echo "$dz_input * $vz_input / ${out_res}" | bc); dz_output=${dx_output#-}

        # resample reference image to 
        echo "resampling reference image to provided output resolution"
        mincresample -clobber -"$interp_res" \
            "$wd"/tmp_ref.mnc "$wd"/tmp_ref_resampled.mnc \
            -step "$out_res" "$out_res" "$out_res" \
            -nelements "$dx_output" "$dy_output" "$dz_output"

        mnc2nii "$wd"/tmp_ref_resampled.mnc "$wd"/ref_resampled.nii
        rm -rf "$wd"/tmp_ref.mnc
        rm -rf "$wd"/tmp_ref_resampled.mnc
        ref_volume="$wd"/ref_resampled.nii
	else
		mnc2nii "$ref_volume" "$wd"/ref.nii
		ref_volume="$wd"/ref.nii
    fi

    # rename interp method to align with minc
    if [[ "$interp" == "nearest" ]] ; then
	    interp=nearest_neighbour
    fi

    # use a volume-based transformation for bigbrain to icbm
    yes | rm "$wd"/tpl-bigbrain_hemi-"$hemi"_desc-"$desc".mnc
	nii2mnc "$wd"/tpl-bigbrain_hemi-"$hemi"_desc-"$desc".nii "$wd"/tpl-bigbrain_hemi-"$hemi"_desc-"$desc".mnc
    mincresample -clobber -transformation "$bbwDir"/xfms/BigBrain-to-ICBM2009sym-nonlin.xfm \
		-like "$ref_volume" \
		-"$interp" \
		"$wd"/tpl-bigbrain_hemi-"$hemi"_desc-"$desc".mnc \
		"$wd"/tpl-icbm_hemi-"$hemi"_desc-"$desc".mnc
    mnc2nii "$wd"/tpl-icbm_hemi-"$hemi"_desc-"$desc".mnc "$wd"/tpl-icbm_hemi-"$hemi"_desc-"$desc".nii
    yes | rm "$wd"/tpl-icbm_hemi-"$hemi"_desc-"$desc".mnc

done