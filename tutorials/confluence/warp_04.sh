#!/bin/bash

# Tutorial: Variations in resting state functional connectivity along a histological axis
docker pull caseypaquola/bigbrainwarp:latest
docker run -it --rm -v /local/directory/with/data/:/BigBrainWarp/mount \
        caseypaquola/bigbrainwarp bigbrainwarp --in_space bigbrain --out_space icbm --wd /BigBrainWarp/mount \
                --in /BigBrainWarp/tests/histological_axis_vox.nii \
                --desc confluence \
                --interp trilinear
                
# to run locally, from within BigBrainWarp github repo
#bigbrainwarp --in_space bigbrain --out_space icbm --wd /local_directory/for/output/ \
#                --in /full/path/to/histological_axis_vox.nii \
#                --desc confluence \
#                --interp trilinear


