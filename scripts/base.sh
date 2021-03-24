#!/bin/bash

# set path of github repo
bbwDir=/home/casey/Desktop/BigBrainWarp/ # the github repo
workingDir=/home/casey/Desktop/8_BigBrainWarp/tests/ # somewhere on your local computer

# pull newest version
cd $bbwDir
git pull
cd $bbwDir/scripts

# initialisation
nano $bbwDir/scripts/init.sh  # change the first two lines for your local environment
source $bbwDir/scripts/init.sh
bash $bbwDir/scripts/init.sh

# surface-based transformation
bash bigbrain_to_fsaverage.sh $bbwDir/spaces/bigbrain/Hist-G2_lh.txt $bbwDir/spaces/bigbrain/Hist-G2_rh.txt nn fsaverage5 $workingDir/Hist-G2

# create fressurfer-compatible files
export PYTHONPATH=$PYTHONPATH:$bbwDir/dependencies:$bbwDir/scripts
python obj2fs.py $bbwDir/spaces/bigbrain/gray_left_327680.obj $bbwDir/spaces/bigbrain/lh.pial
python obj2fs.py $bbwDir/spaces/bigbrain/gray_right_327680.obj $bbwDir/spaces/bigbrain/rh.pial
python obj2fs.py $bbwDir/spaces/bigbrainsym/gray_left_327680_2009b_sym.obj $bbwDir/spaces/bigbrainsym/lh.pial
python obj2fs.py $bbwDir/spaces/bigbrainsym/gray_right_327680_2009b_sym.obj $bbwDir/spaces/bigbrainsym/rh.pial
for hemi in lh rh ; do
    python txt2curv.py $bbwDir/spaces/bigbrain/Hist-G2_${hemi}.txt $bbwDir/spaces/bigbrain/Hist-G2_${hemi}.curv
    python txt2curv.py $workingDir/Hist-G2_${hemi}_fsaverage5.txt $workingDir/Hist-G2_${hemi}_fsaverage5.curv
done
# inspect in freeview
freeview -f ../spaces/bigbrain/rh.pial:overlay=$bbwDir/spaces/bigbrain/Hist-G2_rh.curv \
        -f ../spaces/bigbrainsym/rh.pial:overlay=$bbwDir/spaces/bigbrain/Hist-G2_rh.curv \
        -f $SUBJECTS_DIR/fsaverage5/surf/rh.pial:overlay=$workingDir/Hist-G2_rh_fsaverage5.curv

# volumetric transformation - motor activation
fsleyes $FSLDIR/data/standard/MNI152_T1_2mm.nii.gz $bbwDir/tests/motor_association-test_z_FDR_0.01.nii -dr 2 20 -cm hot -in spline
bash icbm_to_bigbrain.sh $bbwDir/tests/motor_association-test_z_FDR_0.01.nii histological linear $workingDir/

# visualisation
mnc2nii $bbwDir/spaces/bigbrain/full8_400um_optbal.mnc $bbwDir/spaces/bigbrain/full8_400um_optbal.nii
fsleyes $bbwDir/spaces/bigbrain/full8_400um_optbal.nii $workingDir/motor_association-test_z_FDR_0.01_bigbrain.nii -dr 2 20 -cm hot -in spline

## project activation to bigbrain midsurface
nii2mnc $workingDir/motor_association-test_z_FDR_0.01_bigbrain.nii $workingDir/motor_association-test_z_FDR_0.01_bigbrain.mnc
for hemi in left right ; do
    average_surfaces $workingDir/bigbrain_midsurface_${hemi}.obj none none 1 $bbwDir/spaces/bigbrain/gray_${hemi}_327680.obj $bbwDir/spaces/bigbrain/white_${hemi}_327680.obj 
    python obj2fs.py $workingDir/bigbrain_midsurface_${hemi}.obj $workingDir/bigbrain_${hemi}.mid
    volume_object_evaluate $workingDir/motor_association-test_z_FDR_0.01_bigbrain.mnc $workingDir/bigbrain_midsurface_${hemi}.obj $workingDir/motor_association-test_z_FDR_0.01_bigbrain_${hemi}.txt
    python txt2curv.py $workingDir/motor_association-test_z_FDR_0.01_bigbrain_${hemi}.txt $workingDir/motor_association-test_z_FDR_0.01_bigbrain_${hemi}.curv
done 
freeview -f $workingDir/bigbrain_${hemi}.mid:overlay=$workingDir/motor_association-test_z_FDR_0.01_bigbrain_right.curv