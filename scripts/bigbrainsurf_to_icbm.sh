#!/bin/bash
#
# use multimodal surface matching to transform surface data (requires workbench)
# Thanks to Lindsay Lewis for creating the multimodal surface matching spheres
#
# written by Casey Paquola @ MICA, MNI, 2021

lhInput=$1 		# full path to left hemisphere input file
rhInput=$2 		# full path to right hemisphere input file
outName=$3 		# full path of output file (without extension or hemisphere label, eg: User/BigBrain/tests/Ghist). 

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
    if [[ $hemi == "lh" ]] ; then
        struc_label=CORTEX_LEFT
	hemi_long=left
    else
        struc_label=CORTEX_RIGHT
	hemi_long=right
    fi
	# multimodal surface matching
	refmesh=$bbwDir/xfms/$hemi.MNI152.rot.fsavg.sphere.surf.gii
	outmeshMSM=$bbwDir/xfms/$hemi.sphere_MNI152_rsled_like_BigBrain.sphere.reg.surf.gii
	if [[ "$giiType" == "shape" ]] ; then
		wb_command -metric-resample ${outName}_${hemi}.${giiType}.gii $outmeshMSM $refmesh BARYCENTRIC ${outName}_${hemi}_icbm.${giiType}.gii
		wb_command -metric-to-volume-mapping ${outName}_${hemi}_icbm.${giiType}.gii $bbwDir/xfms/icbm_avg_mid_sym_mc_${hemi_long}_hires.surf.gii \
		${outName}_icbm.nii \
		-ribbon_constrained 
	elif [[ "$giiType" == "label" ]] ; then
		wb_command -label-resample ${outName}_${hemi}.${giiType}.gii $outmeshMSM $refmesh BARYCENTRIC ${outName}_${hemi}_icbm.${giiType}.gii
	fi
	wb_command -set-structure ${outName}_${hemi}_icbm.${giiType}.gii $struc_label
done


