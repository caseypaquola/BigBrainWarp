#!/bin/bash
# perform nonlinear transformation from ICBM2009c nonlinear symmetric to BigBrain Histological space
# written by Casey Paquola @ MICA, MNI, 2020*

# requires minc2

fileName=$1 		# name of input file without extension. Must be a .mnc file. (Try nii2mnc if your data is nifti)
			# output is in form ${fileName}_bigbrain.mnc
bbwDir=$2		# /path/to/BigBrainWarp/
mincresample -clobber -transformation ${bbwDir}/xfms/BigBrain-to-ICBM2009sym-nonlin.xfm -invert_transformation -tfm_input_sampling -nearest_neighbour ${fileName}.mnc ${fileName}_nl.mnc
mincresample -clobber -transformation ${bbwDir}/xfms/bigbrain_to_icbm2009b_nl.xfm -invert_transformation -tfm_input_sampling -nearest_neighbour ${fileName}_nl.mnc ${fileName}_nl_nl.mnc
mincresample -clobber -transformation ${bbwDir}/xfms/bigbrain_to_icbm2009b_lin.xfm -invert_transformation -tfm_input_sampling -nearest_neighbour ${fileName}_nl_nl.mnc ${fileName}_bigbrain.mnc
