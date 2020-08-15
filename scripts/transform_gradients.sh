#!bin/bash/

gname=$1 # name of gradient

bbwDir=/data_/mica1/03_projects/casey/BigBrainWarp/
cbigDir=/data_/mica1/03_projects/casey/CBIG-master/

export FREESURFER_HOME=/data_/mica1/03_projects/casey/freesurfer
source $FREESURFER_HOME/SetUpFreeSurfer.sh

for hemi in lh rh ; do
	mri_surf2surf --srcsubject fsaverage5 --trgsubject fsaverage \
	--hemi $hemi \
	--sval ${bbwDir}/maps/fsaverage_space/${hemi}.${gname}.fsaverage5.curv \
	--tval ${bbwDir}/maps/fsaverage_space/${hemi}.${gname}.curv \
	--tfmt curv
done

sh $bbwDir/scripts/fsaverage_to_bigbrain.sh ${bbwDir}/maps/fsaverage_space/lh.${gname}.curv \
	${bbwDir}/maps/fsaverage_space/lh.${gname}.curv \
	linear \
	${bbwDir}/maps/bigbrain_space/${gname} \
	$bbwDir \
	$cbigDir



