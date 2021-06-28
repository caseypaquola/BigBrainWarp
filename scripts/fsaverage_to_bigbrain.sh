#!/bin/bash

# use multimodal surface matching to transform surface data (requires workbench)
# Thanks to Lindsay Lewis for creating the multimodal surface matching spheres
#
# written by Casey Paquola @ MICA, MNI, 2021

in_lh=$1 		# full path to left hemisphere input file
in_rh=$2 		# full path to right hemisphere input file
in_space=$3		# input surface can be "fsaverage" or "fs_LR"
desc=$4 		# name of descriptor
wd=$5			# working directory

# the output takes the form:
# ${wd}/tpl-bigbrain_hemi-L_desc-${desc}.${gii_type}.gii  
# ${wd}/tpl-bigbrain_hemi-R_desc-${desc}.${gii_type}.gii
#
# default $gii_type is shape, however, .annot and .label.gii files will be label type

# check for input data type
filename=$(basename -- "$in_lh")
extension="${filename##*.}"
echo $extension " input"

# check density of input surface
in_den=`python $bbwDir/scripts/check_dim.py $in_lh`

for hemi in L R ; do
	# define input
	if [[ "$hemi" == "L" ]] ; then
		inData=$in_lh
	else
		inData=$in_rh
	fi

	# define gii_type and convert to gifti if necessary
	if [[ "$extension" == "gii" ]] ; then
		substr="${filename: -10}"
		if [[ $substr == *"label"* ]] ; then
			gii_type=label
		else 
			gii_type=shape
		fi
		cp $inData ${wd}/tpl-${in_space}_hemi-${hemi}_den-${in_den}k_desc-${desc}.${gii_type}.gii
	elif [[ "$extension" == "annot" ]] ; then
		gii_type=label
		mris_convert --annot $inData \
			$bbwDir/spaces/tpl-${in_space}/tpl-${in_space}_hemi-${hemi}_den-${in_den}k_desc-white.surf.gii \
			${wd}/tpl-${in_space}_hemi-${hemi}_den-${in_den}k_desc-${desc}.${gii_type}.gii
	elif [[ "$extension" == "curv" ]] ; then
		gii_type=shape
		mris_convert -c $inData \
			$bbwDir/spaces/tpl-${in_space}/tpl-${in_space}_hemi-${hemi}_den-${in_den}k_desc-white.surf.gii \
			${wd}/tpl-${in_space}_hemi-${hemi}_den-${in_den}k_desc-${desc}.${gii_type}.gii
	elif [[ "$extension" == "txt" ]] ; then
		gii_type=shape
		python $bbwDir/scripts/txt2curv.py $inData ${wd}/tpl-${in_space}_hemi-${hemi}_den-${in_den}k_desc-${desc}.curv
		mris_convert -c ${wd}/tpl-${in_space}_hemi-${hemi}_den-${in_den}k_desc-${desc}.curv \
			$bbwDir/spaces/tpl-${in_space}/tpl-${in_space}_hemi-${hemi}_den-${in_den}k_desc-white.surf.gii \
			${wd}/tpl-${in_space}_hemi-${hemi}_den-${in_den}k_desc-${desc}.${gii_type}.gii
	else
		echo "file type of $inData not recognised"
	fi

	# internal upsampling, if necessary
	if [[ "$in_den" == "32" ]] ; then
		if [[ "$gii_type" == "shape" ]] ; then
			wb_command -metric-resample ${wd}/tpl-${in_space}_hemi-${hemi}_den-32k_desc-${desc}.${gii_type}.gii \
				$bbwDir/spaces/tpl-${in_space}/tpl-${in_space}_hemi-${hemi}_den-32k_desc-sphere.surf.gii \
				$bbwDir/spaces/tpl-${in_space}/tpl-${in_space}_hemi-${hemi}_den-164k_desc-sphere.surf.gii \ 
				BARYCENTRIC \
				${wd}/tpl-${in_space}_hemi-${hemi}_den-164k_desc-${desc}.${gii_type}.gii
		elif [[ "$gii_type" == "label" ]] ; then
			wb_command -label-resample ${wd}/tpl-${in_space}_hemi-${hemi}_den-32k_desc-${desc}.${gii_type}.gii \
				$bbwDir/spaces/tpl-${in_space}/tpl-${in_space}_hemi-${hemi}_den-32k_desc-sphere.surf.gii \
				$bbwDir/spaces/tpl-${in_space}/tpl-${in_space}_hemi-${hemi}_den-164k_desc-sphere.surf.gii \ 
				BARYCENTRIC \
				${wd}/tpl-${in_space}_hemi-${hemi}_den-164k_desc-${desc}.${gii_type}.gii
		fi
	fi

	# multimodal surface matching
	msmMesh=$bbwDir/xfms/tpl-${in_space}/tpl-${in_space}_hemi-${hemi}_den-164k_desc-sphere_rsled_like_bigbrain.reg.surf.gii
	inMesh=$bbwDir/xfms/tpl-bigbrain/tpl-bigbrain_hemi-${hemi}_desc-sphere_rot_${in_space}.surf.gii
	if [[ "$gii_type" == "shape" ]] ; then
		wb_command -metric-resample ${wd}/tpl-${in_space}_hemi-${hemi}_den-164k_desc-${desc}.${gii_type}.gii \
		$msmMesh $inMesh BARYCENTRIC \
		${wd}/tpl-bigbrain_hemi-${hemi}_desc-${desc}.${gii_type}.gii
	elif [[ "$gii_type" == "label" ]] ; then
		wb_command -label-resample ${wd}/tpl-${in_space}_hemi-${hemi}_den-164k_desc-${desc}.${gii_type}.gii \
		$msmMesh $inMesh BARYCENTRIC \
		${wd}/tpl-bigbrain_hemi-${hemi}_desc-${desc}.${gii_type}.gii
	fi
done
