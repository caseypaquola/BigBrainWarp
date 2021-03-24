#!/bin/bash
#
# use multimodal surface matching to transform surface data (requires workbench)
# Thanks to Lindsay Lewis for creating the multimodal surface matching spheres
#
# written by Casey Paquola @ MICA, MNI, 2021

lhInput=$1 		# full path to left hemisphere input file
rhInput=$2 		# full path to right hemisphere input file
outSurf=$3		# output surface can be "fsaverage" or "fsLR"
outName=$4 		# full path of output file (without extension or hemisphere label, eg: User/BigBrain/tests/Ghist). 

# the output takes the form ${outName}_${hemi}_${outSurf}.${giiType}.gii
# where hemi is lh and rh, they are saved out separately
# default type is shape, however, .annot and .label.gii files will be label type

# check for input data type
filename=$(basename -- "$lhInput")
extension="${filename##*.}"

for hemi in lh rh ; do
	# define input
	if [[ "$hemi" == "lh" ]] ; then
		inData=$lhInput
	else
		inData=$rhInput
	fi

	# rename outSurf to be able to find files
	if [[ "$outSurf" == "fsaverage" ]] ; then
		outSurf2="fsavg"
	elif [[ "$outSurf" == "fs_LR" ]] ; then
		outSurf2="fsLR"
	fi

	# define giiType and convert to gifti if necessary
	if [[ "$extension" == "gii" ]] ; then
		substr="${filename: -10}"		
		if [[ $substr == *"label"* ]] ; then
			giiType=label
		else 
			giiType=shape
		fi
		cp $inData ${outName}_${hemi}_${outSurf}.${giiType}.gii
	elif [[ "$extension" == "annot" ]] ; then
		giiType=label
		mris_convert --annot $inData $bbwDir/spaces/bigbrain/${hemi}.BigBrain.white.surf.gii ${outName}_${hemi}.${giiType}.gii
	elif [[ "$extension" == "curv" ]] ; then
		giiType=shape
		mris_convert -c $inData $bbwDir/spaces/bigbrain/${hemi}.BigBrain.white.surf.gii ${outName}_${hemi}.${giiType}.gii
	elif [[ "$extension" == "txt" ]] ; then
		if [[ -z $interp ]] ; then
			giiType=shape
		elif [[  "$interp" == "linear" ]] ; then
			giiType=shape
		elif [[  "$interp" == "nearest" ]] ; then			
			giiType=label
		fi
		python $bbwDir/scripts/txt2curv.py $inData ${outName}_${hemi}.curv
		mris_convert -c ${outName}_${hemi}.curv $bbwDir/spaces/bigbrain/${hemi}.BigBrain.white.surf.gii ${outName}_${hemi}.${giiType}.gii
	fi

	# multimodal surface matching
	msmMesh=$bbwDir/xfms/${hemi}.sphere_${outSurf2}_rsled_like_BigBrain.sphere.reg.surf.gii
	inMesh=$bbwDir/xfms/${hemi}.${outSurf2}.sphere.surf.gii
	if [[ "$giiType" == "shape" ]] ; then
		wb_command -metric-resample ${outName}_${hemi}.${giiType}.gii $msmMesh $inMesh BARYCENTRIC ${outName}_${hemi}_${outSurf}.${giiType}.gii	
	elif [[ "$giiType" == "label" ]] ; then
		wb_command -label-resample ${outName}_${hemi}.${giiType}.gii $msmMesh $inMesh BARYCENTRIC ${outName}_${hemi}_${outSurf}.${giiType}.gii	
	fi
done
