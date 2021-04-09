#!/bin/bash
# perform nonlinear transformation from ICBM2009c nonlinear symmetric to BigBrain spaces
# written by Casey Paquola @ MICA, MNI, 2020*

fullFile=$1 	# full path to input file
bbSpace=$2 		# which bigbrain space to output to: "histological" or "sym"
interp=$3		# interpolation method: trilinear, tricubic, nearest or sinc
workDir=$4 		# working directory
outName=$5 	# output name prefix (optional)

# output is $workDir/${fileFile}_bigbrain.mnc or $workDir/${fileFile}_bigbrain.nii (extension is determined by input)
[[ -d $workDir ]] || mkdir -p $workDir

# file conversion if necessary
fileName=$(basename -- "$fullFile")
extension="${fileName##*.}"
fileName="${fileName%.*}"
if [[ "$extension" == "mnc" ]] ; then
	echo "minc image, continuing to transformation"
	cp $fullFile "$workDir"/"$fileName".mnc
elif [[ "$extension" == "nii" ]] ; then
	echo "transforming nii to mnc"
	rm "$workDir"/"$fileName".mnc
	nii2mnc "$fullFile" "$workDir"/"$fileName".mnc
elif [[ "$extension" == "gz" ]] ; then
	echo "transforming nii to mnc"
	fileName="${fileName%.*}"
	gunzip "$fullFile" "$workDir"/"$fileName".nii
	rm "$workDir"/"$fileName".mnc
	nii2mnc "$workDir"/"$fileName".nii "$workDir"/"$fileName".mnc
else
	echo "file type not recognised; must be .mnc, .nii or .nii.gz"
fi

# define output name if not provided
if [[ -z $outName ]] ; then
	outname=$fileName
fi

# transformation
if [[ ${bbSpace} = histological ]] ; then
	echo "transform to original BigBrain space"
	if [[ -f "$workDir"/"$outname"_bigbrain.mnc ]] ; then
		rm "$workDir"/"$outname"_bigbrain.mnc
	fi
	mincresample -transformation ${bbwDir}/xfms/BigBrainHist-to-ICBM2009sym-nonlin.xfm -invert_transformation -tfm_input_sampling -${interp} $workDir/"$outname".mnc "$workDir"/"$outname"_bigbrain.mnc
	# file conversion if necessary
	if [[ "$extension" != "mnc" ]] ; then
		echo "transforming nii to mnc"
		mnc2nii "$workDir"/"$outname"_bigbrain.mnc "$workDir"/"$outname"_bigbrain.nii
		rm "$workDir"/"$fileName".mnc
		rm "$workDir"/"$outname"_bigbrain.mnc
	fi
	if [[ "$extension" == "gz" ]] ; then
		gzip "$workDir"/"$outname"_bigbrain.nii
	fi
else
	echo "transform to BigBrainSym"
	if [[ -f "$workDir"/"$outname"_bigbrainsym.mnc ]] ; then
		rm "$workDir"/"$outname"_bigbrainsym.mnc
	fi
	mincresample -transformation ${bbwDir}/xfms/BigBrain-to-ICBM2009sym-nonlin.xfm -invert_transformation -tfm_input_sampling -${interp} $workDir/"$outname".mnc "$workDir"/"$outname"_bigbrainsym.mnc
	# file conversion if necessary
	if [[ "$extension" != "mnc" ]] ; then
		echo "transforming nii to mnc"
		mnc2nii "$workDir"/"$outname"_bigbrainsym.mnc "$workDir"/"$outname"_bigbrainsym.nii
		rm "$workDir"/"$fileName".mnc
		rm "$workDir"/"$outname"_bigbrainsym.mnc
	fi
	if [[ "$extension" == "gz" ]] ; then
		gzip "$workDir"/"$outname"_bigbrainsym.nii
	fi
fi

