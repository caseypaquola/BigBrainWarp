#!/bin/bash

# Tutorial: Concordance of imaging-derived effects with histological gradients
# the input is the histological gradients already within BigBrainWarp, but this can be changed to any mounted data
docker pull caseypaquola/bigbrainwarp:latest
for i in 1 2 ; do
        docker run -it --rm -v /local/directory/with/freesurfer_license:/license \
        -v /local/directory/with/data/:/BigBrainWarp/mount \
        caseypaquola/bigbrainwarp bigbrainwarp --in_space bigbrain \
                                            --out_space fsaverage \
                                            --wd /BigBrainWarp/mount \
                                            --in_lh /BigBrainWarp/spaces/tpl-bigbrain/tpl-bigbrain_hemi-L_desc-Hist_G${i}.txt \
                                            --in_rh /BigBrainWarp/spaces/tpl-bigbrain/tpl-bigbrain_hemi-R_desc-Hist_G${i}.txt \
                                            --desc Hist_G${i}
                                            
        # to run locally, from within the BigBrainWarp github repository
        # bigbrainwarp --in_space bigbrain \
                       --out_space fsaverage \
                       --wd /local/directory/for/output/ \
                       --in_lh /BigBrainWarp/spaces/tpl-bigbrain/tpl-bigbrain_hemi-L_desc-Hist_G${i}.txt \
                       --in_rh /BigBrainWarp/spaces/tpl-bigbrain/tpl-bigbrain_hemi-R_desc-Hist_G${i}.txt \
                       --desc Hist_G${i}
done                                            

