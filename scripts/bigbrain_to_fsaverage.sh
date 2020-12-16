#!/bin/bash
# a nearest neighbour interpolation between surfaces
# written by Casey Paquola @ MICA, MNI, 2020*

lhInput=$1 		# full path to left hemisphere input file (must be a .txt file)
rhInput=$2 		# full path to right hemisphere input file (must be a .txt file)
outName=$3 		# full path of output file (without extension or hemisphere label, eg: User/BigBrain/tests/Ghist). 

# the output takes the form ${outName}_fsaverage5.txt

# use nearest neighbour surface indexing
matlab -nodisplay -r 'bigbrain2fsaverage("'${lhInput}'","'${rhInput}'","'${outName}'","'${bbwDir}'"); quit'
