#!/bin/bash
#
# use multimodal surface matching to transform surface data (requires workbench)
# Thanks to Lindsay Lewis for creating the multimodal surface matching spheres
#
# written by Casey Paquola @ MICA, MNI, 2021

in_lh=$1 		# full path to left hemisphere input file
in_rh=$2 		# full path to right hemisphere input file
out_space=$3	# output surface can be "fsaverage" or "fs_LR"
desc=$4 		# name of descriptor
wd=$5			# working directory
interp=$6		# interpolation method. Can be used if .txt input, otherwise is set as default
out_den=$7		# output density. If out_space is fs_LR, can be 164 or 32. Must be 164 for fsaverage


# the output takes the form:
# ${wd}/tpl-${out_space}_hemi-L_desc-${desc}.${gii_type}.gii  
# ${wd}/tpl-${out_space}_hemi-R_desc-${desc}.${gii_type}.gii
#
# default $gii_type is shape, however, .annot and .label.gii files will be label type

# check for input data type
extension="${in_lh#*.}"

for hemi in L R ; do
	# define input
	if [[ "$hemi" == "L" ]] ; then
		inData=$in_lh
	else
		inData=$in_rh
	fi

	# define gii_type and convert to gifti if necessary
	if [[ "$extension" == *"gii"* ]] ; then
		if [[ $extension == *"label"* ]] ; then
			gii_type=label
		else 
			gii_type=shape
		fi
		cp $inData ${wd}/tpl-bigbrain_hemi-${hemi}_desc-${desc}.${gii_type}.gii
	elif [[ "$extension" == "annot" ]] ; then
		gii_type=label
		mris_convert --annot $inData \
			$bbwDir/spaces/tpl-bigbrain/tpl-bigbrain_hemi-${hemi}_desc-white.surf.gii \
			${wd}/tpl-bigbrain_hemi-${hemi}_desc-${desc}.${gii_type}.gii
	elif [[ "$extension" == "curv" ]] ; then
		gii_type=shape
		mris_convert -c $inData \
			$bbwDir/spaces/tpl-bigbrain/tpl-bigbrain_hemi-${hemi}_desc-white.surf.gii \
			${wd}/tpl-bigbrain_hemi-${hemi}_desc-${desc}.${gii_type}.gii
	elif [[ "$extension" == "txt" ]] ; then
		if [[ -z $interp ]] ; then
			gii_type=shape
		elif [[  "$interp" == "linear" ]] ; then
			gii_type=shape
		elif [[  "$interp" == "nearest" ]] ; then			
			gii_type=label
		fi
		python $bbwDir/scripts/txt2curv.py $inData ${wd}/tpl-bigbrain_hemi-${hemi}_desc-${desc}.curv
		mris_convert -c ${wd}/tpl-bigbrain_hemi-${hemi}_desc-${desc}.curv \
			$bbwDir/spaces/tpl-bigbrain/tpl-bigbrain_hemi-${hemi}_desc-white.surf.gii \
			${wd}/tpl-bigbrain_hemi-${hemi}_desc-${desc}.${gii_type}.gii
	fi

	# multimodal surface matching
	msmMesh=$bbwDir/xfms/tpl-${out_space}_hemi-${hemi}_den-164k_desc-sphere_rsled_like_bigbrain.reg.surf.gii
	inMesh=$bbwDir/spaces/tpl-${out_space}/tpl-${out_space}_hemi-${hemi}_den-164k_desc-sphere.surf.gii
	if [[ "$gii_type" == "shape" ]] ; then
		wb_command -metric-resample ${wd}/tpl-bigbrain_hemi-${hemi}_desc-${desc}.${gii_type}.gii \
			$msmMesh $inMesh BARYCENTRIC \
			${wd}/tpl-${out_space}_hemi-${hemi}_den-164k_desc-${desc}.${gii_type}.gii
	elif [[ "$gii_type" == "label" ]] ; then
		wb_command -label-resample ${wd}/tpl-bigbrain_hemi-${hemi}_desc-${desc}.${gii_type}.gii \
			$msmMesh $inMesh BARYCENTRIC \
			${wd}/tpl-${out_space}_hemi-${hemi}_den-164k_desc-${desc}.${gii_type}.gii
	fi
	echo ${wd}/tpl-${out_space}_hemi-${hemi}_den-164k_desc-${desc}.${gii_type}.gii

	# internal downsample, if necessary
	if [[ "$out_den" == "32" ]] ; then
		if [[ "$gii_type" == "shape" ]] ; then
			wb_command -metric-resample ${wd}/tpl-${out_space}_hemi-${hemi}_den-164k_desc-${desc}.${gii_type}.gii \
				$bbwDir/spaces/tpl-${out_space}/tpl-${out_space}_hemi-${hemi}_den-164k_desc-sphere.surf.gii \
				$bbwDir/spaces/tpl-${out_space}/tpl-${out_space}_hemi-${hemi}_den-32k_desc-sphere.surf.gii BARYCENTRIC \
				${wd}/tpl-${out_space}_hemi-${hemi}_den-32k_desc-${desc}.${gii_type}.gii
		elif [[ "$gii_type" == "label" ]] ; then
			wb_command -label-resample ${wd}/tpl-${out_space}_hemi-${hemi}_den-164k_desc-${desc}.${gii_type}.gii \
				$bbwDir/spaces/tpl-${out_space}/tpl-${out_space}_hemi-${hemi}_den-164k_desc-sphere.surf.gii \
				$bbwDir/spaces/tpl-${out_space}/tpl-${out_space}_hemi-${hemi}_den-32k_desc-sphere.surf.gii BARYCENTRIC \
				${wd}/tpl-${out_space}_hemi-${hemi}_den-32k_desc-${desc}.${gii_type}.gii
		fi
	fi

done
