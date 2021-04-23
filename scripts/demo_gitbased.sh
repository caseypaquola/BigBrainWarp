#!/bin/bash

# set path of github repo
bbwDir=/home/casey/Desktop/BigBrainWarp/ # the github repo
mnc2Path=/opt/minc/1.9.18/bin/
wbPath=/home/casey/Downloads/software/workbench/bin_linux64/
workingDir=/home/casey/Desktop/8_BigBrainWarp/tests/ # somewhere on your local computer

# pull newest version
cd $bbwDir
git pull
cd $bbwDir/scripts

# initialisation
nano $bbwDir/scripts/init.sh  # change the first three lines for your local environment
source $bbwDir/scripts/init.sh

# surface-based transformation - bigbrain to fsaverage
bigbrainwarp --in_space bigbrain --out_space fsaverage --wd $workingDir \
    --in_lh $bbwDir/spaces/bigbrain/Hist_G2_lh.txt --in_rh $bbwDir/spaces/bigbrain/Hist_G2_rh.txt \
    --out_name Hist_G2

# create fressurfer-compatible files
export PYTHONPATH=$PYTHONPATH:$bbwDir/dependencies:$bbwDir/scripts
python obj2fs.py $bbwDir/spaces/bigbrain/gray_left_327680.obj $bbwDir/spaces/bigbrain/lh.pial
python obj2fs.py $bbwDir/spaces/bigbrain/gray_right_327680.obj $bbwDir/spaces/bigbrain/rh.pial
python obj2fs.py $bbwDir/spaces/bigbrainsym/gray_left_327680_2009b_sym.obj $bbwDir/spaces/bigbrainsym/lh.pial
python obj2fs.py $bbwDir/spaces/bigbrainsym/gray_right_327680_2009b_sym.obj $bbwDir/spaces/bigbrainsym/rh.pial
for hemi in lh rh ; do
    python txt2curv.py $bbwDir/spaces/bigbrain/Hist_G2_${hemi}.txt $bbwDir/spaces/bigbrain/Hist_G2_${hemi}.curv
    python txt2curv.py $workingDir/Hist_G2_${hemi}_fsaverage.txt $workingDir/Hist_G2_${hemi}_fsaverage.curv
done
# inspect in freeview
freeview -f ../spaces/bigbrain/rh.pial:overlay=$bbwDir/spaces/bigbrain/Hist_G2_rh.curv \
        -f ../spaces/bigbrainsym/rh.pial:overlay=$bbwDir/spaces/bigbrain/Hist_G2_rh.curv \
        -f $SUBJECTS_DIR/fsaverage/surf/rh.pial:overlay=$workingDir/Hist_G2_rh_fsaverage.curv

# volumetric transformation - motor activation
fsleyes $FSLDIR/data/standard/MNI152_T1_2mm.nii.gz $bbwDir/tests/motor_association-test_z_FDR_0.01.nii -dr 2 20 -cm hot -in spline
bigbrainwarp --in_space icbm --out_space bigbrain --wd $workingDir --in $bbwDir/tests/motor_association-test_z_FDR_0.01.nii --interp trilinear

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

# surface transfomration - Yeo atlas
bigbrainwarp --in_space fsaverage --out_space bigbrain --wd $workingDir \
    --in_lh $workingDir/fsaverage/lh.Yeo2011_7Networks_N1000.annot --in_rh $workingDir/fsaverage/rh.Yeo2011_7Networks_N1000.annot \
    --out_name Yeo2011_7Networks_N1000
# create fressurfer-compatible files
export PYTHONPATH=$PYTHONPATH:$bbwDir/dependencies:$bbwDir/scripts
for hemi in lh rh ; do
    python txt2curv.py $workingDir/Yeo2011_17Networks_N1000_${hemi}_bigbrain.txt $workingDir/Yeo2011_17Networks_N1000_${hemi}_bigbrain.curv
done
# inspect in freeview
freeview -f ../spaces/bigbrain/rh.pial:overlay=$workingDir/Yeo2011_17Networks_N1000_rh_bigbrain.curv
