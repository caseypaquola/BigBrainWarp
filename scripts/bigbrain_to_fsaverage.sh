#!/bin/bash
# a nearest neighbour interpolation between surfaces
# written by Casey Paquola @ MICA, MNI, 2020*

lhInput=$1 		# full path to left hemisphere input file (must be a .txt file)
rhInput=$2 		# full path to right hemisphere input file (must be a .txt file)
approach=$3		# can be "nn" for vertex-wise nearest neighbour interpolation or "msm" for parcel-wise transformation with 1000 parcels defined by multi-modal surface matching 
outSurf=$4		# output surface can be "fsaverage5", "fs_LR" or "fsaverage". Currently, nn only works for fsaverage5 and msm only works for fs_LR and fsaverage
outName=$5 		# full path of output file (without extension or hemisphere label, eg: User/BigBrain/tests/Ghist). 

# the output takes the form ${outName}_lh_${outSurf}.txt and ${outName}_rh_${outSurf}.txt, representing left and right hemisphere data separately 

# use nearest neighbour surface indexing
python bigbrain2fsaverage.py ${lhInput} ${rhInput} ${approach} ${outSurf} ${outName} ${bbwDir}
