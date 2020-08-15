#!bin/bash


# samples the intensity values at the position of each iEEG channel,
# when the image is also in BigBrain space but does not have the same world-to-voxel mapping

sampleImage=$1  # .mnc image in bigbrain space to sample intensity from (don't include extension in name)
outName=$2 	# a tag to name the output text files
bbwDir=$3 	# /path/to/BigBrainWarp

for ii in `seq 1 1 1172` ; do
	world_com=`mincstats -CoM -world_only -binvalue $ii $bbwDir/maps/bigbrain_space/iEEG_channels_bigbrain.mnc`;
	worldtovoxel $sampleImage.mnc ${world_com##*: } >> $bbwDir/maps/bigbrain_space/iEEG_channels_${outName}_coord.txt
done
mnc2nii $sampleImage.mnc $sampleImage.nii # convert to nifti so fslmeants can be used
for ii in `seq 1 1 1172` ; do
	vox=`sed "${ii}q;d" $bbwDir/maps/bigbrain_space/iEEG_channels_${outName}_coord.txt`
	stringarray=($vox)
	int=`fslmeants -i $sampleImage.nii -c ${stringarray[2]} ${stringarray[1]} ${stringarray[0]}` # reverse coordinates order to deal with mnc2nii
	echo $int >> $bbwDir/maps/bigbrain_space/iEEG_channels_${outName}.txt
done




