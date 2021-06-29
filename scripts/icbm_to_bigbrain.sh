#!/bin/bash
# perform nonlinear transformation from ICBM2009c nonlinear symmetric to BigBrain spaces
# written by Casey Paquola @ MICA, MNI, 2020*

in_vol=$1 		# full path to input file
bb_space=$2 	# which bigbrain space is input: "histological" or "sym"
interp=$3		# interpolation method: trilinear, tricubic, nearest or sinc
desc=$4 		# descriptor
wd=$5 			# working directory

# the output takes the form:
# ${wd}/tpl-bigbrain_desc-${desc}_${bb_space}.nii

# file conversion if necessary
file_name=$(basename -- "$in_vol")
extension="${file_name##*.}"
file_name="${file_name%.*}"
if [[ "$extension" == "mnc" ]] ; then
	echo "minc image, continuing to transformation"
	cp $in_vol ${wd}/tpl-icbm_desc-${desc}.mnc
elif [[ "$extension" == "nii" ]] ; then
	echo "transforming nii to mnc"
	if [[ -f ${wd}/tpl-icbm_desc-${desc}.mnc ]] ; then
		rm ${wd}/tpl-icbm_desc-${desc}.mnc
	fi
	nii2mnc "$in_vol" ${wd}/tpl-icbm_desc-${desc}.mnc
elif [[ "$extension" == "gz" ]] ; then
	echo "transforming nii to mnc"
	file_name="${file_name%.*}"
	gunzip "$in_vol" ${wd}/tpl-icbm_desc-${desc}.nii
	if [[ -f ${wd}/tpl-icbm_desc-${desc}.mnc ]] ; then
		rm ${wd}/tpl-icbm_desc-${desc}.mnc
	fi
	nii2mnc ${wd}/tpl-icbm_desc-${desc}.nii ${wd}/tpl-icbm_desc-${desc}.mnc
else
	echo "file type not recognised; must be .mnc, .nii or .nii.gz"
fi

# transformation
if [[ ${bb_space} = histological ]] ; then
	echo "transform to original BigBrain space"
	mincresample -clobber -transformation ${bbwDir}/xfms/BigBrainHist-to-ICBM2009sym-nonlin.xfm \
		-invert_transformation -tfm_input_sampling -${interp} ${wd}/tpl-icbm_desc-${desc}.mnc ${wd}/tpl-bigbrain_desc-${desc}_${bb_space}.mnc
else
	echo "transform to BigBrainSym"
	mincresample -clobber -transformation ${bbwDir}/xfms/BigBrain-to-ICBM2009sym-nonlin.xfm \
		-invert_transformation -tfm_input_sampling -${interp} ${wd}/tpl-icbm_desc-${desc}.mnc ${wd}/tpl-bigbrain_desc-${desc}_${bb_space}.mnc
fi

# file conversion if necessary
if [[ "$extension" != "mnc" ]] ; then
	echo "transforming nii to mnc"
	mnc2nii ${wd}/tpl-bigbrain_desc-${desc}_${bb_space}.mnc ${wd}/tpl-bigbrain_desc-${desc}_${bb_space}.nii
	rm ${wd}/tpl-bigbrain_desc-${desc}_${bb_space}.mnc
	rm ${wd}/tpl-icbm_desc-${desc}.mnc
fi
if [[ "$extension" == "gz" ]] ; then
	gzip ${wd}/tpl-bigbrain_desc-${desc}_${bb_space}.nii
fi