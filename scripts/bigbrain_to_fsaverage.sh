
#!/bin/bash
# perform nonlinear transformation from BigBrain histological space to ICBM2009c nonlinear symmetric
# written by Casey Paquola @ MICA, MNI, 2020*

fileName=$1 		# input file name without extension. Must be a .mnc file. (Try nii2mnc if its a nifti)
			# output will be in the form ${fileName}_bigbrain.mnc
bbSpace=$2 		# which bigbrain space is input: "histological" or "sym"
icbmTemplate=$3 	# template icbm image, will be used for alignment (ie: voxel size and origin)
interp=$4		# "linear" (smooth data) or "nearest_neighbour" (discrete data)
bbwDir=$5		# /path/to/BigBrainWarp/

if [[ -z $bbSpace=histological ]] ; then
	echo "transform to original BigBrain space"
	mincresample -clobber -transformation ${bbwDir}/xfms/bigbrain_to_icbm2009b_lin.xfm -tfm_input_sampling -${interp} ${fileName}.mnc ${fileName}_lin.mnc
	mincresample -clobber -transformation ${bbwDir}/xfms/bigbrain_to_icbm2009b_nl.xfm -tfm_input_sampling -${interp} ${fileName}_lin.mnc ${fileName}_lin_nl.mnc
	mincresample -clobber -transformation ${bbwDir}/xfms/BigBrain-to-ICBM2009sym-nonlin.xfm -tfm_input_sampling -like ${icbmTemplate} -${interp} ${fileName}_lin_nl.mnc ${fileName}_icbm.mnc
else
	mincresample -clobber -transformation ${bbwDir}/xfms/BigBrain-to-ICBM2009sym-nonlin.xfm -tfm_input_sampling -like ${icbmTemplate} -${interp} ${fileName}.mnc ${fileName}_icbm.mnc
fi

matlab19b -r 'wrapper_fsaverage2mni("'${${fileName}_icbm.mnc}'", "'${interp}'", "'${fileName}'", "'${bbwDir}'", "'${cbigDir}'"); quit'
