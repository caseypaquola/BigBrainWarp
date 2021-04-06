#!/bin/bash

# Tutorial: Concordance of imaging-derived effects with histological gradients
# the input is the histological gradients already within BigBrainWarp, but this can be changed to any mounted data
docker pull caseypaquola/bigbrainwarp:latest
for i in 1 2 ; do
        docker run -it --rm -v /local/directory/with/freesurfer_license:/license \
        -v /local/directory/with/data/:/BigBrainWarp/tests \
        caseypaquola/bigbrainwarp bigbrainwarp --in_space bigbrain \
                                            --out_space fsaverage \
                                            --wd /BigBrainWarp/tests/ \
                                            --in_lh /BigBrainWarp/spaces/bigbrain/Hist_G${i}_lh.txt \
                                            --in_rh /BigBrainWarp/spaces/bigbrain/Hist_G${i}_rh.txt \
                                            --out_name Hist_G${i}
done                                            

