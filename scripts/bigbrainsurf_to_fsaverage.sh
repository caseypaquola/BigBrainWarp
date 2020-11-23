#!/bin/bash
# perform nonlinear transformation from BigBrain spaces to fsaverage
# written by Casey Paquola @ MICA, MNI, 2020*

lhInput=$1 		# full path to left hemisphere input file (should be in format lh.*.txt)
rhInput=$2 		# full path to right hemisphere input file (should be in format rh.*.txt)
lhSurf=$3 		# full path to left hemisphere surface (should be .obj and in bigbrainsym space)
rhSurf=$5 		# full path to right hemisphere surface (should be .obj and in bigbrainsym space)
interp=$6		# "linear" (smooth data) or "nearest_neighbour" (discrete data)
workDir=$7 		# working directory
cleanup=$8 		# "y" to remove intermediate files, "n" to keep

% create workDir if is doesn't already exist
[[ -d $workDir ]] || mkdir -p $workDir

% get core of lh_input for file
fileName=$(basename -- "$lh_input")
fileName="${fileName%.*}"
fileName="${fileName##*.}"

% fill the ribbon
outName=$workDir/${fileName}.mnc
matlab -r 'fill_ribbon("'${lh_input}'","'${rh_input}'","'${lh_surf}'","'${rh_surf}'","'${icbmTemplate}'","'${outName}'","'${bbwDir}'"); quit'


% transformation in volume space
echo "transform to icbm"
mincresample -clobber -transformation ${bbwDir}/xfms/BigBrain-to-ICBM2009sym-nonlin.xfm -tfm_input_sampling -like "${icbmTemplate}" -"$interp" "$workDir"/${fileName}.mnc "$workDir"/${fileName}_icbm.mnc

% transformation to surface space
matlab -r 'wrapper_fsaverage2mni("'${${fileName}_icbm.mnc}'", "'${interp}'", "'${fileName}'", "'${bbwDir}'", "'${cbigDir}'"); quit'

% clean up if selected
if [[ "$cleanup" == "y" ]] ; then
	rm "$workDir"/"$fileName"_lin*
	if [[ "$extension" != "mnc" ]] ; then
		rm "$workDir"/${fileName}_icbm.mnc
	fi
fi