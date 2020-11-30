#!/bin/bash
# perform nonlinear transformation from ICBM2009c nonlinear symmetric to BigBrain spaces
# written by Casey Paquola @ MICA, MNI, 2020*

fullFile=$1 		# full path to input file
bbSpace=$2 		# which bigbrain space to output to: "histological" or "sym"
interp=$3		# "linear" (smooth data) or "nearest_neighbour" (discrete data)
workDir=$4 		# working directory
cleanup=$5 		# "y" to remove intermediate files, "n" to keep

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
	nii2mnc "$fullFile" "$workDir"/"$fileName".mnc
elif [[ "$extension" == "gz" ]] ; then
	echo "transforming nii to mnc"
	fileName="${fileName%.*}"
	gunzip "$fullFile" "$workDir"/"$fileName".nii
	nii2mnc "$workDir"/"$fileName".nii "$workDir"/"$fileName".mnc
else
	echo "file type not recognised; must be .mnc, .nii or .nii.gz"
fi

# precise interpolation method for minc
if [ ${interp} = linear ]; then
	mnc_interp=trilinear
elif [ ${interp} = nearest ] ; then
	mnc_interp=nearest_neighbour
fi

# transformation
if [[ -z $bbSpace=histological ]] ; then
	echo "transform to original BigBrain space"
	mincresample -transformation ${bbwDir}/xfms/BigBrainHist-to-ICBM2009sym-nonlin.xfm -invert_transformation -tfm_input_sampling -${mnc_interp} $workDir/"$fileName".mnc "$workDir"/"$fileName"_bigbrain.mnc
else
	echo "transform to BigBrainSym"
	mincresample -transformation ${bbwDir}/xfms/BigBrain-to-ICBM2009sym-nonlin.xfm -invert_transformation -tfm_input_sampling -${mnc_interp} $workDir/"$fileName".mnc "$workDir"/"$fileName"_bigbrain.mnc
fi

# file conversion if necessary
if [[ "$extension" != "mnc" ]] ; then
	echo "transforming nii to mnc"
	mnc2nii "$workDir"/"$fileName"_bigbrain.mnc "$workDir"/"$fileName"_bigbrain.nii
fi

# clean up if selected
if [[ "$cleanup" == "y" ]] ; then
	rm "$workDir"/"$fileName"_nl*
	if [[ "$extension" != "mnc" ]] ; then
		rm "$workDir"/"$fileName"_bigbrain.mnc
	fi
fi

