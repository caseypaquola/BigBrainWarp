#/bin/bash

parc=$1

bbwDir=/data_/mica1/03_projects/casey/BigBrainWarp/
cbigDir=/data_/mica1/03_projects/casey/CBIG-master/
pipeDir=/data_/mica1/03_projects/casey/micapipe/

export PATH=/data_/mica1/01_programs/minc2/:$PATH
export FREESURFER_HOME=/data_/mica1/03_projects/casey/freesurfer
source $FREESURFER_HOME/SetUpFreeSurfer.sh

for hemi in lh rh ; do
	mri_surf2surf --srcsubject fsaverage5 --trgsubject fsaverage \
	--hemi $hemi \
	--sval-annot $pipeDir/parcellations/${hemi}.${parc}_fsa5.annot \
	--tval $bbwDir/maps/fsaverage_space/parcellations/${hemi}.${parc}.annot
done

sh $bbwDir/scripts/fsaverage_to_bigbrain.sh $bbwDir/maps/fsaverage_space/parcellations/lh.${parc}.annot $bbwDir/maps/fsaverage_space/parcellations/rh.${parc}.annot nearest $bbwDir/maps/bigbrain_space/parcellations/${parc} $bbwDir $cbigDir

rm -rf $bbwDir/maps/bigbrain_space/${parc}*.nii
rm -rf $bbwDir/maps/bigbrain_space/${parc}*.mnc





