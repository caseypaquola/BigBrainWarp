#!/bin/bash

# Tutorial: Characterisation of cytoarchitecture within functional networks
# change /local/directory/with/data/ to a local working directory which contains *.Yeo2011_17Networks_N1000.annot
# pull docker
docker pull caseypaquola/bigbrainwarp:latest
# run bigbrainwarp via docker
docker run -it --rm -v /local/directory/with/data/:/BigBrainWarp/mount \
                caseypaquola/bigbrainwarp bigbrainwarp --in_space fsaverage --out_space bigbrain --wd mount \
                --in_lh /BigBrainWarp/mount/lh.Yeo2011_17Networks_N1000.annot --in_rh /BigBrainWarp/mount/rh.Yeo2011_17Networks_N1000.annot \
                --desc Yeo2011_17Networks_N1000
                
# to run locally, from within the BigBrainWarp directory
# bigbrainwarp --in_space fsaverage --out_space bigbrain --wd /local/directory/for/output/ \
#                --in_lh /full/path/to/lh.Yeo2011_17Networks_N1000.annot --in_rh /full/path/to/rh.Yeo2011_17Networks_N1000.annot \
#                --desc Yeo2011_17Networks_N1000

