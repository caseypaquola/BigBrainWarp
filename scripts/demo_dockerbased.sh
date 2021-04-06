#!/bin/bash
docker pull caseypaquola/bigbrainwarp:latest

# example: surface-based transformation from bigbrain to fsaverage
# user needs to change both mounts to local directories
# the input is the histological gradients already within BigBrainWarp, but this can be changed to any mounted data
docker run -it --rm -v /local/directory/with/freesurfer_license:/license \
        -v /local/directory/with/data/:/BigBrainWarp/tests \
        caseypaquola/bigbrainwarp bigbrainwarp --in_space bigbrain \
                                            --out_space fsaverage \
                                            --wd /BigBrainWarp/tests/ \
                                            --in_lh /BigBrainWarp/spaces/bigbrain/Hist_G2_lh.txt \
                                            --in_rh /BigBrainWarp/spaces/bigbrain/Hist_G2_rh.txt \
                                            --out_name Hist_G2

# example: volume-based transformation from icbm to bigbrainsym
# the input is a functional gradient already within BigBrainWarp, but this can be changed to any mounted data
docker run -it --rm -v /local/directory/with/freesurfer_license:/license \
        -v /local/directory/with/data/:/BigBrainWarp/tests \
        caseypaquola/bigbrainwarp bigbrainwarp --in_space icbm \
                                            --out_space bigbrainsym \
                                            --wd /BigBrainWarp/tests/ \
                                            --in /BigBrainWarp/spaces/icbm/Func_G1_icbm.nii \ 
                                            --interp trilinear