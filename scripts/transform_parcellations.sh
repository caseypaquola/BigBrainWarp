#/bin/bash

bbwDir=/data_/mica1/03_projects/casey/BigBrainWarp/
cbigDir=/data_/mica1/03_projects/casey/CBIG-master/
pipeDir=/data_/mica1/03_projects/casey/micapipe/

export PATH=/data_/mica1/01_programs/minc2/:$PATH

for parc in vosdewael_100 vosdewael_200 vosdewael_300 vosdewael_400 schaefer_100 schaefer_200 schaefer_300 schaefer_400 glasser_360 aparc ; do

	for hemi in lh rh ; do
		mri_surf2surf --srcsubject fsaverage5 --trgsubject fsaverage \
		--hemi $hemi \
		--sval-annot $pipeDir/parcellations/${hemi}.${parc}_fsa5.annot \
		--tval $bbwDir/maps/fsaverage_space/parcellations/${hemi}.${parc}.annot
	done

	sh fsaverage_to_bigbrain $bbwDir/maps/fsaverage_space/parcellations/lh.${parc}.annot \
		$bbwDir/maps/fsaverage_space/parcellations/rh.${parc}.annot \
		nearest \
		$bbwDir/maps/mni152_space/parcellations/${parc} \
		$bbwDir $cbigDir

	mv $bbwDir/maps/mni152_space/parcellations/${parc}_bigbrain.mnc $bbwDir/maps/bigbrain_space/parcellations/${parc}_bigbrain.mnc
done




