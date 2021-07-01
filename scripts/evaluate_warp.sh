#!/bin/bash

# evaluates the accuracy of a warp, based on anatomical fiducials and regional overlap

#---------------- FUNCTION: HELP ----------------#
help() {
echo -e "
\033[38;5;141mCOMMAND:\033[0m
   $(basename $0)
\033[38;5;141mREQUIRED ARGUMENTS:\033[0m
\t\033[38;5;197m-in_space\033[0m 	      	: input space. Can be bigbrainsym or icbm
\t\033[38;5;197m-out_space\033[0m 	      : output space. Can be bigbrainsym or icbm
\t\033[38;5;197m-warp\033[0m 	      	    : full path to deformation field. Currently only handles .mnc format
\t\033[38;5;197m-wd\033[0m 	              : Path to a working directory, where data will be output

Casey Paquola, MNI, MICA Lab, 2021
https://bigbrainwarp.readthedocs.io/
"
}

# Create VARIABLES
for arg in "$@"
do
  case "$arg" in
  -h|-help)
    help
    exit 1
  ;;
  --in_space)
    in_space=$2
    shift;shift
  ;;
  --wd)
    wd=$2
    shift;shift
  ;;
  --out_space)
    out_space=$2
    shift;shift
  ;;
  --warp)
    warp=$2
    shift;shift
  ;;
  -*)
    esac
done

# pull afids templates
if [[ ! -d $bbwDir/xfms/MNI152NLin2009bSym_T1_Rater03_1_20180917.fcsv ]] ; then
	cd $bbwDir/xfms/
  wget https://raw.githubusercontent.com/afids/afids-analysis/master/data/PHASE4_input_afid/MNI152NLin2009bSym_T1_Rater03_1_20180914.fcsv
fi

# pull subcortical segmentations
if [[ ! -d $bbwDir/xfms/ICBM2009b_sym-SubCorSeg-500um.mnc ]] ; then
  cd $bbwDir/xfms/
  wget -O BigBrain-SubCorSeg-500um.mnc https://osf.io/dbe4v/download
  wget -O ICBM2009b_sym-SubCorSeg-500um.mnc https://osf.io/dbe4v/download
fi

# define direction and perform volume based transformation
if [[ "$in_space" == "bigbrainsym" ]] ; then
    in_af=$bbwDir/xfms/BigBrain_T1_Rater03_1_20180918.fcsv
    out_af=$bbwDir/xfms/MNI152NLin2009bSym_T1_Rater03_1_20180914.fcsv
    in_seg=$bbwDir/xfms/BigBrain-SubCorSeg-500um.mnc
    comp_seg=$bbwDir/xfms/ICBM2009b_sym-SubCorSeg-500um.mnc
    $bbwDir/scripts/bigbrain_to_icbm.sh $in_seg sym $interp SubCorSeg $wd
    trans_seg=$wd/tpl-icbm_desc-SubCorSeg.mnc
elif [[ "$in_space" == "icbm" ]] ; then
    in_af=MNI152NLin2009bSym_T1_Rater03_1_20180917.fcsv
    out_af=$bbwDir/xfms/BigBrain_T1_Rater03_1_20180918.fcsv
    in_seg=$bbwDir/xfms/ICBM2009b_sym-SubCorSeg-500um.mnc
    comp_seg=$bbwDir/xfms/BigBrain-SubCorSeg-500um.mnc
    $bbwDir/scripts/icbm_to_bigbrain.sh $in_seg sym $interp SubCorSeg $wd
    trans_seg=$wd/tpl-bigbrain_desc-SubCorSeg.mnc
fi

# calculate overlap of non-isocortical labels 
python $bbwDir/scripts/reg_overlap.py $trans_seg $comp_seg $wd 

# perform transform and calculate distance for anatomical fiducials
if [[ -f $wd/trans_coords.txt ]] ; then
    rm -f $wd/trans_coords.txt
fi
if [[ -f $wd/set_coords.txt ]] ; then
    rm -f $wd/set_coords.txt
fi
for f in `seq 4 1 35 ` ; do
    IN=`head -n $f $in_af | tail -1`
    arrIN=(${IN//,/ })
    echo "MNI Tag Point File" > $wd/temp.tag
    echo "Volumes = 1;" >> $wd/temp.tag
    echo "Points = " ${arrIN[2]} " " ${arrIN[3]} " " ${arrIN[4]} >> $wd/temp.tag 
    transform_tags $wd/temp.tag $warp $wd/temp_out.tag
    trans_coord=`tail -n 1 $wd/temp_out.tag`
    suffix=' 0 -1 -1;'
    trans_coord=${trans_coord%$suffix}
    echo $trans_coord >> $wd/trans_coords.txt
    IN=`head -n $f $out_af | tail -1`
    arrIN=(${IN//,/ })
    set_coord=`echo ${arrIN[2]} " " ${arrIN[3]} " " ${arrIN[4]}`
    echo $set_coord >> $wd/set_coords.txt
done
python $bbwDir/scripts/af_dist.py $wd



