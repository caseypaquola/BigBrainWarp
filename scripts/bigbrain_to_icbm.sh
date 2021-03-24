#!/bin/bash
# perform nonlinear transformation from BigBrain spaces to ICBM2009c nonlinear symmetric
# written by Casey Paquola @ MICA, MNI, 2020*

fullFile=$1 	# full path to input file
bbSpace=$2 		# which bigbrain space is input: "histological" or "sym"
interp=$3		# interpolation method: trilinear, tricubic, nearest or sinc
workDir=$4 		# working directory
outName=$5 	# output name prefix (optional)

# output is $workDir/${fileFile}_icbm.mnc or $workDir/${fileFile}_icbm.nii (extension is determined by input)
[[ -d $workDir ]] || mkdir -p $workDir

# file conversion if necessary
fileName=$(basename -- "$fullFile")
extension="${fileName##*.}"
fileName="${fileName%.*}"
if [[ "$extension" == "mnc" ]] ; then
	echo "minc image, continuing to transformation"
	cp $fullFile $workDir/${fileName}.mnc
elif [[ "$extension" == "gz" ]] ; then
	gunzip $fullFile
	fileName="${fileName%.*}"
	nii2mnc $workDir/${fileName}.nii $workDir/${fileName}.mnc
elif [[ "$extension" == "nii" ]] ; then
	echo "transforming nii to mnc"
	nii2mnc $fullFile $workDir/${fileName}.mnc
else
	echo "file type not recognised; must be .mnc, .nii or .nii.gz"
fi

# define output name if not provided
if [[ -z $outName ]] ; then
	outname=$fileName
fi

# transformation
echo "transform to icbm"
if [[ ${bbSpace} = histological ]] ; then
	mincresample -clobber -transformation ${bbwDir}/xfms//BigBrainHist-to-ICBM2009sym-nonlin.xfm -tfm_input_sampling -like "$icbmTemplate" -${interp} "$workDir"/"$fileName".mnc "$workDir"/"$fileName"_icbm.mnc
else
	mincresample -clobber -transformation ${bbwDir}/xfms/BigBrain-to-ICBM2009sym-nonlin.xfm -tfm_input_sampling -like "$icbmTemplate" -${interp} "$workDir"/${fileName}.mnc "$workDir"/${fileName}_icbm.mnc
fi

# file conversion if necessary
if [[ "$extension" != "mnc" ]] ; then
	echo "transforming nii to mnc"
	mnc2nii "$workDir"/${fileName}_icbm.mnc "$workDir"/${fileName}_icbm.nii
	rm "$workDir"/${fileName}_icbm.mnc
	rm $workDir/${fileName}.mnc
fi



