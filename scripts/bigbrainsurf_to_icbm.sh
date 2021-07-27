#!/bin/bash
#
# use multimodal surface matching to transform surface data (requires workbench)
# Thanks to Lindsay Lewis for creating the multimodal surface matching spheres
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
		if [[ -z $interp ]] ; then
			gii_type=shape
			interp_res=trilinear
		elif [[  "$interp" == "linear" ]] ; then
			gii_type=shape
			interp_res=trilinear
		elif [[  "$interp" == "nearest" ]] ; then			
			gii_type=label
			interp_res=nearest_neighbour
		fi
		python "$bbwDir"/scripts/txt2curv.py "$inData" "$wd"/tpl-bigbrain_hemi-"$hemi"_desc-"$desc".curv
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

	# define reference volume and resample if necessary
	ref_volume="$bbwDir"/spaces/tpl-icbm/tpl-icbm_desc-t1_tal_nlin_sym_09c_mask.nii
    if [[ "$out_res" == "1" ]] ; then
        nii2mnc "$ref_volume" "$wd"/tmp_ref.mnc

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
            -step "$vx_output" "$vy_output" "$vz_output" \
            -nelements "$dx_output" "$dy_output" "$dz_output"

        mnc2nii "$wd"/tmp_ref_resampled.mnc "$wd"/ref_resampled.nii
        rm -rf "$wd"/tmp_ref.mnc
        rm -rf "$wd"/tmp_ref_resampled.mnc
        ref_volume="$wd"/ref_resampled.nii
    fi

	# multimodal surface matching
	refmesh="$bbwDir"/xfms/tpl-icbm_hemi-"$hemi"_desc-sphere_rot_fsaverage.surf.gii
	outmeshMSM="$bbwDir"/xfms/tpl-icbm_hemi-"$hemi"_desc-sphere_rsled_like_bigbrain.reg.surf.gii
	if [[ "$gii_type" == "shape" ]] ; then
		wb_command -metric-resample "$wd"/tpl-bigbrain_hemi-"$hemi"_desc-"$desc"."$gii_type".gii \
			"$outmeshMSM" "$refmesh" BARYCENTRIC "$wd"/tpl-icbm_hemi-"$hemi"_desc-"$desc"."$gii_type".gii
		wb_command -set-structure "$wd"/tpl-icbm_hemi-"$hemi"_desc-"$desc"."$gii_type".gii $struc_label
		wb_command -metric-to-volume-mapping "$wd"/tpl-icbm_hemi-"$hemi"_desc-"$desc"."$gii_type".gii \
			"$bbwDir"/spaces/tpl-icbm/tpl-icbm_hemi-"$hemi"_desc-white.surf.gii \
			"$ref_volume" \
			"$wd"/tpl-icbm_hemi-"$hemi"_desc-"$desc".nii \
			-ribbon-constrained "$bbwDir"/spaces/tpl-icbm/tpl-icbm_hemi-"$hemi"_desc-mid.surf.gii \
			"$bbwDir"/spaces/tpl-icbm/tpl-icbm_hemi-"$hemi"_desc-white.surf.gii
	elif [[ "$gii_type" == "label" ]] ; then
		wb_command -label-resample "$wd"/tpl-bigbrain_hemi-"$hemi"_desc-"$desc"."$gii_type".gii \
			"$outmeshMSM" "$refmesh" BARYCENTRIC "$wd"/tpl-icbm_hemi-"$hemi"_desc-"$desc"."$gii_type".gii
		wb_command -set-structure "$wd"/tpl-icbm_hemi-"$hemi"_desc-"$desc"."$gii_type".gii $struc_label
		wb_command -label-to-volume-mapping "$wd"/tpl-icbm_hemi-"$hemi"_desc-"$desc"."$gii_type".gii \
			"$bbwDir"/spaces/tpl-icbm/tpl-icbm_hemi-"$hemi"_desc-white.surf.gii \
			"$ref_volume" \
			"$wd"/tpl-icbm_hemi-"$hemi"_desc-"$desc".nii \
			-ribbon-constrained "$bbwDir"/spaces/tpl-icbm/tpl-icbm_hemi-"$hemi"_desc-mid.surf.gii \
			"$bbwDir"/spaces/tpl-icbm/tpl-icbm_hemi-"$hemi"_desc-white.surf.gii
	fi
done
