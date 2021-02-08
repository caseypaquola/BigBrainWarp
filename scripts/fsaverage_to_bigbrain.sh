#!/bin/bash
# a nearest neighbour intrpolation from fsaverage5 to BigBrain surface
# written by Casey Paquola @ MICA, MNI, 2020*

lhInput=$1		# full path to input file of left hemisphere, can be in format .annot, .mgh, .curv, .gii, .txt
rhInput=$2		# full path to input file of right hemisphere
approach=$3		# can be "nn" for vertex-wise nearest neighbour interpolation or "msm" for parcel-wise transformation with 1000 parcels defined by multi-modal surface matching 
inSurf=$4		# input surface can be "fsaverage5", "fs_LR" or "fsaverage". Currently, nn only works for fsaverage5 and msm only works for fs_LR and fsaverage
outName=$5 		# full path of output file (without extension or hemisphere label, eg: User/BigBrain/tests/thickness

# default output is .txt
# the output takes the form ${outName}_lh_bigbrain.txt and ${outName}_rh_bigbrain.txt, representing left and right hemisphere data separately

# use nearest neighbour surface indexing
python fsaverage2bigbrain.py ${lhInput} ${rhInput} ${approach} ${inSurf} ${outName} ${bbwDir}

