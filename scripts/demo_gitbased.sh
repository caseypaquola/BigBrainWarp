#!/bin/bash

# set path of github repo
bbwDir=/home/casey/Desktop/BigBrainWarp/ # the github repo
mnc2Path=/opt/minc/1.9.18/
workingDir=/home/casey/Desktop/8_BigBrainWarp/tests/

# pull newest version
cd $bbwDir
git pull
cd $bbwDir/scripts

# initialisation
nano $bbwDir/scripts/init.sh
source $bbwDir/scripts/init.sh
bash $bbwDir/scripts/init.sh

# surface-based transformation
bash bigbrain_to_fsaverage.sh $bbwDir/tests/lh.Ghist.txt $bbwDir/tests/rh.Ghist.txt $workingDir/Ghist

# create fressurfer-compatible files
export PYTHONPATH=$PYTHONPATH:$bbwDir/dependencies:$bbwDir/scripts
python obj2fs.py $bbwDir/spaces/bigbrain/gray_left_327680.obj $bbwDir/spaces/bigbrain/lh.pial
python obj2fs.py $bbwDir/spaces/bigbrain/gray_right_327680.obj $bbwDir/spaces/bigbrain/rh.pial
python obj2fs.py $bbwDir/spaces/bigbrainsym/gray_left_327680_2009b_sym.obj $bbwDir/spaces/bigbrainsym/lh.pial
python obj2fs.py $bbwDir/spaces/bigbrainsym/gray_right_327680_2009b_sym.obj $bbwDir/spaces/bigbrainsym/rh.pial
for hemi in lh rh ; do
    python txt2curv.py $bbwDir/tests/${hemi}.Ghist.txt $workingDir/${hemi}.Ghist.curv
    python txt2curv.py $workingDir/Ghist_${hemi}_fsaverage5.txt $workingDir/Ghist_${hemi}_fsaverage5.curv
done
# inspect in freeview
freeview -f ../spaces/bigbrain/rh.pial:overlay=$workingDir/rh.Ghist.curv \
        -f ../spaces/bigbrainsym/rh.pial:overlay=$workingDir/rh.Ghist.curv \
        -f $SUBJECTS_DIR/fsaverage5/surf/rh.pial:overlay=$workingDir/Ghist_rh_fsaverage5.curv

# volumetric transformation - motor activation
bash icbm_to_bigbrain.sh $bbwDir/tests/motor_association-test_z_FDR_0.01.nii histological linear $workingDir/

# visualisation
fsleyes $FSLDIR/data/standard/MNI152_T1_2mm.nii.gz $bbwDir/tests/motor_association-test_z_FDR_0.01.nii -dr 2 20 -cm hot -in spline
mnc2nii $bbwDir/spaces/bigbrain/full8_400um_optbal.mnc $bbwDir/spaces/bigbrain/full8_400um_optbal.nii
fsleyes $bbwDir/spaces/bigbrain/full8_400um_optbal.nii $workingDir/motor_association-test_z_FDR_0.01_bigbrain.nii -dr 2 20 -cm hot -in spline
mnc2nii $bbwDir/spaces/bigbrainsym/full8_400um_2009b_sym.mnc $bbwDir/spaces/bigbrainsym/full8_400um_2009b_sym.nii
fsleyes $bbwDir/spaces/bigbrainsym/full8_400um_2009b_sym.nii $workingDir/motor_association-test_z_FDR_0.01_bigbrain.nii -dr 2 20 -cm hot -in spline

# surface transofmration - Yeo atlas
bash fsaverage_to_bigbrain.sh $bbwDir/spaces/fsaverage5/lh.Yeo2011_7Networks_N1000.annot \
    $bbwDir/spaces/fsaverage5/lh.Yeo2011_7Networks_N1000.annot \
    $bbwDir/spaces/bigbrain/Yeo2011_17Networks_N1000
# create fressurfer-compatible files
export PYTHONPATH=$PYTHONPATH:$bbwDir/dependencies:$bbwDir/scripts
for hemi in lh rh ; do
    python txt2curv.py $workingDir/Yeo2011_17Networks_N1000_${hemi}_bigbrain.txt $workingDir/Yeo2011_17Networks_N1000_${hemi}_bigbrain.curv
done3
# inspect in freeview
freeview -f ../spaces/bigbrain/rh.pial:overlay=$workingDir/Yeo2011_17Networks_N1000_rh_bigbrain.curv