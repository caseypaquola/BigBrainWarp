#!/bin/bash
# perform nonlinear transformation from BigBrain spaces to ICBM2009c nonlinear symmetric
# written by Casey Paquola @ MICA, MNI, 2020*

in_vol=$1 		# full path to input file
bb_space=$2 	# which bigbrain space is input: "histological" or "sym"
interp=$3		# interpolation method: trilinear, tricubic, nearest or sinc
desc=$4 		# descriptor
wd=$5 			# working directory

# the output takes the form:
# ${wd}/tpl-icbm_desc-${desc}.nii

# file conversion if necessary
file_name=$(basename -- "$in_vol")
extension="${file_name##*.}"
file_name="${file_name%.*}"
if [[ "$extension" == "mnc" ]] ; then
	echo "minc image, continuing to transformation"
	cp $in_vol ${wd}/tpl-bigbrain_desc-${desc}_${bb_space}.mnc
elif [[ "$extension" == "gz" ]] ; then
	file_name="${file_name%.*}"
	gunzip $in_vol ${wd}/tpl-bigbrain_desc-${desc}_${bb_space}.nii
	nii2mnc ${wd}/tpl-bigbrain_desc-${desc}_${bb_space}.nii ${wd}/tpl-bigbrain_desc-${desc}_${bb_space}.mnc
elif [[ "$extension" == "nii" ]] ; then
	echo "transforming nii to mnc"
	nii2mnc $in_vol ${wd}/tpl-bigbrain_desc-${desc}_${bb_space}.mnc
else
	echo "file type not recognised; must be .mnc, .nii or .nii.gz"
fi

# transformation
echo "transform to icbm"
icbm_template=${bbwDir}/spaces/tpl-icbm/tpl-icbm_desc-t1_tal_nlin_sym_09c_mask.mnc
if [[ ${bb_space} = histological ]] ; then
	mincresample -clobber -transformation ${bbwDir}/xfms/BigBrainHist-to-ICBM2009sym-nonlin.xfm \
		-tfm_input_sampling -like "$icbm_template" \
		-$interp \
		${wd}/tpl-bigbrain_desc-${desc}_${bb_space}.mnc \
		${wd}/tpl-icbm_desc-${desc}.mnc
else
	mincresample -clobber -transformation ${bbwDir}/xfms/BigBrain-to-ICBM2009sym-nonlin.xfm \
		-tfm_input_sampling -like "$icbm_template" \
		-$interp \
		${wd}/tpl-bigbrain_desc-${desc}_${bb_space}.mnc \
		${wd}/tpl-icbm_desc-${desc}.mnc
fi

# file conversion if necessary
if [[ "$extension" != "mnc" ]] ; then
	echo "transforming mnc to nii"
	mnc2nii ${wd}/tpl-icbm_desc-${desc}.mnc ${wd}/tpl-icbm_desc-${desc}.nii
	rm -f ${wd}/tpl-icbm_desc-${desc}.mnc
	rm -f ${wd}/tpl-bigbrain_desc-${desc}_${bb_space}.mnc
fi
if [[ "$extension" == "gz" ]] ; then
	echo "transforming nii to nii.gz"
	gzip ${wd}/tpl-icbm_desc-${desc}.nii
fi




