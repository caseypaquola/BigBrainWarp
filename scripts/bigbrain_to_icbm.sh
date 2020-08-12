
#!/bin/bash
# perform nonlinear transformation from BigBrain histological space to ICBM2009c nonlinear symmetric
# written by Casey Paquola @ MICA, MNI, 2020*

fileName=bigbrain_axis 	# input file that is in the original histological bigbrain space. Must be a .mnc file. (Try nii2mnc if its a nifti)
			# if the file is in the mni bigbrain space, then skip the first two mincresamples
gitRepo=/path/to/BigBrainWarp/
mincresample -clobber -transformation ${gitRepo}/xfms/bigbrain_to_icbm2009b_lin.xfm -use_input_sampling -nearest_neighbour ${fileName}.mnc ${fileName}_lin.mnc
mincresample -clobber -transformation ${gitRepo}/xfms/bigbrain_to_icbm2009b_nl.xfm -use_input_sampling -nearest_neighbour ${fileName}_lin.mnc ${fileName}_lin_nl.mnc
mincresample -clobber -transformation ${gitRepo}/xfms/BigBrain-to-ICBM2009sym-nonlin.xfm -use_input_sampling -nearest_neighbour ${fileName}_lin_nl.mnc ${fileName}_icbm.mnc


	#done
#done

#cd /data_/mica1/03_projects/casey/sandbox1/6_CorticalConfluence/constructs
	#for b in `seq 1 1 8` ; do
		#rm -f bigbrain_axis_"$nbin"bins_bin"$b".mnc
		#/data_/mica1/01_programs/minc2/nii2mnc bigbrain_axis_regions_"$b".nii bigbrain_axis_regions_"$b".mnc
		#/data_/mica1/01_programs/minc2/mincresample -clobber -transformation bigbrain_to_icbm2009b_lin.xfm -use_input_sampling -nearest_neighbour bigbrain_axis_regions_"$b".mnc bigbrain_axis_regions_"$b"_lin.mnc
		#/data_/mica1/01_programs/minc2/mincresample -clobber -transformation bigbrain_to_icbm2009b_nl.xfm -use_input_sampling -nearest_neighbour bigbrain_axis_regions_"$b"_lin.mnc bigbrain_axis_regions_"$b"_nl.mnc 
		#/data_/mica1/01_programs/minc2/mincresample -clobber -transformation BigBrain-to-ICBM2009sym-nonlin.xfm -use_input_sampling -nearest_neighbour bigbrain_axis_regions_"$b"_nl.mnc bigbrain_axis_regions_"$b"_icbm.mnc
		#mnc2nii bigbrain_axis_regions_"$b"_icbm.mnc bigbrain_axis_regions_"$b"_icbm.nii
	#done

suffix=$1	

#/data_/mica1/01_programs/minc2/nii2mnc bigbrain_${suffix}.nii bigbrain_${suffix}.mnc
#/data_/mica1/01_programs/minc2/mincresample -clobber -transformation bigbrain_to_icbm2009b_lin.xfm -use_input_sampling -nearest_neighbour bigbrain_${suffix}.mnc bigbrain_${suffix}_lin.mnc
#/data_/mica1/01_programs/minc2/mincresample -clobber -transformation bigbrain_to_icbm2009b_nl.xfm -use_input_sampling -nearest_neighbour bigbrain_${suffix}_lin.mnc bigbrain_${suffix}_nl.mnc 
#/data_/mica1/01_programs/minc2/mincresample -clobber -transformation BigBrain-to-ICBM2009sym-nonlin.xfm -use_input_sampling -nearest_neighbour bigbrain_${suffix}_nl.mnc bigbrain_${suffix}_icbm.mnc
#mnc2nii bigbrain_${suffix}_icbm.mnc bigbrain_${suffix}_icbm.nii
3dZeropad -P 64 -RL 182 -IS 182 -prefix bigbrain_${suffix}_padded bigbrain_${suffix}_icbm.nii
3dAFNItoNIFTI bigbrain_${suffix}_padded+orig
