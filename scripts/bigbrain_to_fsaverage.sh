#!/bin/bash
# perform nonlinear transformation from BigBrain spaces to fsaverage
# written by Casey Paquola @ MICA, MNI, 2020*

fileName=$1 		# full path to input file
bbSpace=$2 		# which bigbrain space is input: "histological" or "sym"
interp=$3		# "linear" (smooth data) or "nearest_neighbour" (discrete data)
workDir=$4 		# working directory
cleanup=$5 		# "y" to remove intermediate files, "n" to keep

% create workDir if is doesn't already exist
[[ -d $workDir ]] || mkdir -p $workDir

% file conversion if necessary
fileName=$(basename -- "$fullFile")
extension="${fileName##*.}"
fileName="${fileName%.*}"
if [[ "$extension" == "mnc" ]] ; then
	echo "minc image, continuing to transformation"
	cp $fullFile $workDir/${fileName}.mnc
elif [[ "$extension" == "nii" ]] ; then
	echo "transforming nii to mnc"
	nii2mnc $fullFile $workDir/${fileName}.mnc
elif [[ "$extension" == "gz" ]] ; then
	echo "transforming nii to mnc"
	gunzip $fullFile
	nii2mnc $workDir/${fileName}.nii $workDir/${fileName}.mnc
else
	echo "file type not recognised; must be .mnc, .nii or .nii.gz"
fi

% transformation in volume space
echo "transform to icbm"
% note: icbmTemplate is set in the docker as "mni_icbm152_nlin_sym_09c.mnc"
if [[ "$bbSpace" == "histological" ]] ; then
	mincresample -clobber -transformation ${bbwDir}/xfms/bigbrain_to_icbm2009b_lin.xfm -tfm_input_sampling -"$interp" "$workDir"/"$fileName".mnc "$workDir"/"$fileName"_lin.mnc
	mincresample -clobber -transformation ${bbwDir}/xfms/bigbrain_to_icbm2009b_nl.xfm -tfm_input_sampling -"$interp" "$workDir"/"$fileName"_lin.mnc "$workDir"/"$fileName"_lin_nl.mnc
	mincresample -clobber -transformation ${bbwDir}/xfms/BigBrain-to-ICBM2009sym-nonlin.xfm -tfm_input_sampling -like "$icbmTemplate" -"$interp" "$workDir"/"$fileName"_lin_nl.mnc "$workDir"/"$fileName"_icbm.mnc
else
	mincresample -clobber -transformation ${bbwDir}/xfms/BigBrain-to-ICBM2009sym-nonlin.xfm -tfm_input_sampling -like "$icbmTemplate" -"$interp" "$workDir"/${fileName}.mnc "$workDir"/${fileName}_icbm.mnc
fi

% transformation to surface space
matlab -r 'wrapper_fsaverage2mni("'${${fileName}_icbm.mnc}'", "'${interp}'", "'${fileName}'", "'${bbwDir}'", "'${cbigDir}'"); quit'

% clean up if selected
if [[ "$cleanup" == "y" ]] ; then
	rm "$workDir"/"$fileName"_lin*
	if [[ "$extension" != "mnc" ]] ; then
		rm "$workDir"/${fileName}_icbm.mnc
	fi
fi
