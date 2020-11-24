#!/bin/bash
# perform nonlinear transformation from BigBrain spaces to fsaverage
# written by Casey Paquola @ MICA, MNI, 2020*

lhInput=$1 		# full path to left hemisphere input file (should be in format lh.*.txt)
rhInput=$2 		# full path to right hemisphere input file (should be in format rh.*.txt)
lhSurf=$3 		# full path to left hemisphere surface (should be .obj and in bigbrainsym space)
rhSurf=$4 		# full path to right hemisphere surface (should be .obj and in bigbrainsym space)
interp=$5		# "linear" (smooth data) or "nearest_neighbour" (discrete data)
workDir=$6 		# working directory
cleanup=$7 		# "y" to remove intermediate files, "n" to keep

# create workDir if is doesn't already exist
[[ -d $workDir ]] || mkdir -p $workDir

# get core of lh_input for file
fileName=$(basename -- "$lhInput")
fileName="${fileName%.*}"
fileName="${fileName##*.}"
echo $fileName

# precise interpolation method for minc
if [ ${interp} = linear ]; then
	mnc_interp=trilinear
	dil=dilM # dilation of mean
elif [ ${interp} = nearest ] ; then
	mnc_interp=nearest_neighbour
	dil=dilD # dilation of mode
fi

# fill the ribbon
outName=$workDir/${fileName}.nii
bname=${icbmTemplate%.*}
icbmTemplateNii=$bname.nii
if [[ ! -f $icbmTemplateNii ]] ; then
	mnc2nii $icbmTemplate $icbmTemplateNii
fi
matlab -nodisplay -r 'fill_ribbon("'${lhInput}'","'${rhInput}'","'${lhSurf}'","'${rhSurf}'","'${icbmTemplateNii}'","'${outName}'","'${bbwDir}'"); quit'
nii2mnc $workDir/${fileName}.nii $workDir/${fileName}.mnc

# transformation in volume space
echo "transform to icbm"
mincresample -clobber -transformation ${bbwDir}/xfms/BigBrain-to-ICBM2009sym-nonlin.xfm -tfm_input_sampling -like "${icbmTemplate}" -"$mnc_interp" "$workDir"/${fileName}.mnc "$workDir"/${fileName}_icbm.mnc

# conve"$workDir"/${fileName}_icbm_dilated.niirt to nifti and perform dilation
mnc2nii "$workDir"/${fileName}_icbm.mnc "$workDir"/${fileName}_icbm.nii
rm "$workDir"/${fileName}_icbm.mnc
fslmaths "$workDir"/${fileName}_icbm.nii -$dil -$dil -$dil -$dil -$dil "$workDir"/${fileName}_icbm_dilated.nii
gunzip "$workDir"/${fileName}_icbm_dilated.nii.gz

# transformation to surface space
inputVol="$workDir"/${fileName}_icbm_dilated.nii
matlab -nodisplay -r 'wrapper_mni2fsaverage("'${inputVol}'", "'${interp}'", "'${fileName}'", "'${bbwDir}'", "'${cbigDir}'"); quit'

# clean up if selected
if [[ "$cleanup" == "y" ]] ; then
	rm "$workDir"/"$fileName"_lin*
	if [[ "$extension" != "mnc" ]] ; then
		rm "$workDir"/${fileName}_icbm.mnc
		rm "$workDir"/${fileName}*.nii
	fi
fi
