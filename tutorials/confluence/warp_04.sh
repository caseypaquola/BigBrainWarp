#!/bin/bash

# Tutorial: Variations in resting state functional connectivity along a histological axis
docker pull caseypaquola/bigbrainwarp:latest
docker run -it --rm -v /local/directory/with/freesurfer_license:/license \
        -v /local/directory/with/data/:/BigBrainWarp/tests \
        bigbrainwarp --in_space bigbrain --out_space icbm --wd /BigBrainWarp/tests \
        --desc confluence --interp trilinear \
        --in /BigBrainWarp/tests/histological_axis_vox.nii 

