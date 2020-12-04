#!/bin/bash
# a nearest neighbour intrpolation from fsaverage5 to BigBrain surface
# written by Casey Paquola @ MICA, MNI, 2020*

lhInput=$1		# full path to input file of left hemisphere, can be in format .annot, .mgh, .curv, .gii, .txt
rhInput=$2		# full path to input file of right hemisphere
outName=$3 		# full path of output file (without extension or hemisphere label, eg: User/BigBrain/tests/thickness

# default output is .txt, unless the input is .curv or .mgh, in which case this format is used for writing the data too.
# the output takes the form ${outName}_bigbrain.txt (or .mgh, .curv)

# use nearest neighbour surface indexing
matlab -nodisplay -r 'bigbrain2fsaverage("'${lhInput}'","'${rhInput}'","'${outName}'","'${bbwDir}'"); quit'

