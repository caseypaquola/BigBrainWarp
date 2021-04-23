#!/bin/bash

# redefine these variables as necessary
in_vol=${bbwDir}/bigbrain/full16_100um_optbal.mnc  # download a bigbrain volume from the ftp. Should be mnc format. Ensure the space is matched the surfaces (ie: histological with histological or sym with sym)
upper_surf=${bbwDir}/bigbrain/gray_left_327680.obj
lower_surf=${bbwDir}/bigbrain/white_left_327680.obj
out_name=${bbwDir}/tests/left_
num_surf=50

# pull surface tools repo, if not already contained in scripts
if [[ ! -d $bbwDir/scripts/surface_tools/ ]] ; then
	cd $bbwDir/scripts/
	git clone https://github.com/kwagstyl/surface_tools
fi
cd $bbwDir/scripts/surface_tools/equivolumetric_surfaces/

if [[ ! -d $out_dir ]] ; then
	mkdir $out_dir
fi

python generate_equivolumetric_surfaces.py ${upper_surf} ${lower_surf} ${num_surf} ${out_name}
x=$(ls -t ${out_name}*) # orders my time created
for n in `seq 1 1 $num_surf` ; do
	echo $n
	which_surf=$(sed -n "$n"p <<< "$x")
	nd=`$num_surf - $n` # numbered from upper to lower
	volume_object_evaluate $in_vol $which_surf ${out_name}.$nd.txt
done

cd $bbwDir/scripts/
python compile_profiles.py ${out_name} ${num_surf}
