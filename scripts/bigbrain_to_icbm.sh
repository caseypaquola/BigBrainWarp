
#!/bin/bash
# perform nonlinear transformation from BigBrain histological space to ICBM2009c nonlinear symmetric
# written by Casey Paquola @ MICA, MNI, 2020*

fileName=$1 		# input file name without extension. Must be a .mnc file. (Try nii2mnc if its a nifti)
			# output will be in the form ${fileName}_bigbrain.mnc
bbwDir=$2 		# /path/to/BigBrainWarp/
interp=$3
mincresample -clobber -transformation ${bbwDir}/xfms/bigbrain_to_icbm2009b_lin.xfm -tfm_input_sampling -${interp} ${fileName}.mnc ${fileName}_lin.mnc
mincresample -clobber -transformation ${bbwDir}/xfms/bigbrain_to_icbm2009b_nl.xfm -tfm_input_sampling -${interp} ${fileName}_lin.mnc ${fileName}_lin_nl.mnc
mincresample -clobber -transformation ${bbwDir}/xfms/BigBrain-to-ICBM2009sym-nonlin.xfm -tfm_input_sampling -${interp} ${fileName}_lin_nl.mnc ${fileName}_icbm.mnc
