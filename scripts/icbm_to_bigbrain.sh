#!/bin/bash
# perform nonlinear transformation from ICBM2009c nonlinear symmetric to BigBrain spaces
# written by Casey Paquola @ MICA, MNI, 2020*

in_vol=$1 		# full path to input file
bb_space=$2 	# which bigbrain space is input: "histological" or "sym"
interp=$3		# interpolation method: trilinear, tricubic, nearest or sinc
out_res=$4		# output resolution in mm
desc=$5 		# descriptor
wd=$6 			# working directory

# the output takes the form:
# "$wd"/tpl-bigbrain_desc-"$desc"_"$bb_space".nii

# file conversion if necessary
file_name=$(basename -- "$in_vol")
extension="${file_name##*.}"
file_name="${file_name%.*}"
if [[ "$extension" == "mnc" ]] ; then
	echo "minc image, continuing to transformation"
	cp "$in_vol" "$wd"/tpl-icbm_desc-"$desc".mnc
elif [[ "$extension" == "nii" ]] ; then
	echo "transforming nii to mnc"
	if [[ -f "$wd"/tpl-icbm_desc-"$desc".mnc ]] ; then
		rm "$wd"/tpl-icbm_desc-"$desc".mnc
	fi
	nii2mnc "$in_vol" "$wd"/tpl-icbm_desc-"$desc".mnc
elif [[ "$extension" == "gz" ]] ; then
	echo "transforming nii to mnc"
	file_name=""$file_name%.*""
	gunzip "$in_vol" "$wd"/tpl-icbm_desc-"$desc".nii
	if [[ -f "$wd"/tpl-icbm_desc-"$desc".mnc ]] ; then
		rm "$wd"/tpl-icbm_desc-"$desc".mnc
	fi
	nii2mnc "$wd"/tpl-icbm_desc-"$desc".nii "$wd"/tpl-icbm_desc-"$desc".mnc
else
	echo "file type not recognised; must be .mnc, .nii or .nii.gz"
fi

# rename interp method to align with minc
if [[ "$interp" == "nearest" ]] ; then
	interp=nearest_neighbour
fi

# define reference volume and resample if necessary
if [[ "$bb_space" == "histological" ]] ; then
	ref_volume="$bbwDir"/spaces/tpl-bigbrain/tpl-bigbrain_desc-cls_1000um.nii
else
	ref_volume="$bbwDir"/spaces/tpl-bigbrain/tpl-bigbrain_desc-cls_1000um_sym.nii
fi
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
    mincresample -clobber -"$interp" \
        "$wd"/tmp_ref.mnc "$wd"/ref_resampled.mnc \
        -step "$out_res" "$out_res" "$out_res" \
        -nelements "$dx_output" "$dy_output" "$dz_output"

    ref_volume="$wd"/ref_resampled.mnc
    rm -rf "$wd"/tmp_ref.mnc
else
	nii2mnc "$ref_volume" "$wd"/tmp_ref.mnc
	ref_volume="$wd"/tmp_ref.mnc
fi

# transformation
if [[ "$bb_space" = histological ]] ; then
	echo "transform to original BigBrain space"
	mincresample -clobber -transformation "$bbwDir"/xfms/BigBrainHist-to-ICBM2009sym-nonlin.xfm \
		-invert_transformation \
		-like "$ref_volume" \
		-"$interp" \
		"$wd"/tpl-icbm_desc-"$desc".mnc \
		"$wd"/tpl-bigbrain_desc-"$desc"_"$bb_space".mnc
else
	echo "transform to BigBrainSym"
	mincresample -clobber -transformation "$bbwDir"/xfms/BigBrain-to-ICBM2009sym-nonlin.xfm \
		-invert_transformation \
		-like "$ref_volume" \
		-"$interp" \
		"$wd"/tpl-icbm_desc-"$desc".mnc \
		"$wd"/tpl-bigbrain_desc-"$desc"_"$bb_space".mnc
fi

# file conversion if necessary
if [[ "$extension" != "mnc" ]] ; then
	echo "transforming nii to mnc"
	mnc2nii "$wd"/tpl-bigbrain_desc-"$desc"_"$bb_space".mnc "$wd"/tpl-bigbrain_desc-"$desc"_"$bb_space".nii
	rm "$wd"/tpl-bigbrain_desc-"$desc"_"$bb_space".mnc
	rm "$wd"/tpl-icbm_desc-"$desc".mnc
fi
if [[ "$extension" == "gz" ]] ; then
	gzip "$wd"/tpl-bigbrain_desc-"$desc"_"$bb_space".nii
fi