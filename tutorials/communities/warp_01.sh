#!/bin/bash

# Tutorial: Characterisation of cytoarchitecture within functional networks
# change /local/directory/with/data/ to a local working directory which contains *.Yeo2011_17Networks_N1000.annot
# pull docker
docker pull caseypaquola/bigbrainwarp:latest
# run bigbrainwarp via docker
docker run -it --rm -v /local/directory/with/freesurfer_license:/license \
                -v /local/directory/with/data/:/BigBrainWarp/tests \
                caseypaquola/bigbrainwarp bigbrainwarp --in_space fsaverage --out_space bigbrain --wd /BigBrainWarp/tests \
                --in_lh /BigBrainWarp/tests/lh.Yeo2011_17Networks_N1000.annot --in_rh /BigBrainWarp/tests/rh.Yeo2011_17Networks_N1000.annot \
                --desc Yeo2011_17Networks_N1000

