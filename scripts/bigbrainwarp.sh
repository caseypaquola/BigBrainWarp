#!/bin/bash
#
# BigBrainWarp
#
version() {
  echo -e "\nBigBrainWarp March 2021 (Beta)\n"
}
#---------------- FUNCTION: HELP ----------------#
help() {
echo -e "
\033[38;5;141mCOMMAND:\033[0m
   $(basename $0)

\033[38;5;141mREQUIRED ARGUMENTS:\033[0m
\t\033[38;5;197m-in_space\033[0m 	        : space of input data (bigbrain, bigbrainsym, icbm, fsaverage or fs_LR)
\t\033[38;5;197m-out_space\033[0m 	      : space of output data (bigbrain, bigbrainsym, icbm, fsaverage or fs_LR)
\t\033[38;5;197m-wd\033[0m 	              : Path to a working directory, where data will be output

\033[38;5;141mVOLUME-BASED ARGUMENTS:\033[0m
\t\033[38;5;197m-in\033[0m               : (required) full path to input data. Must be whole brain. Can be mnc, nii or nii.gz
\t\033[38;5;197m-interp\033[0m           : (optional) interpolation method, can be trilinear, tricubic, nearest or sinc. Default is trilinear. 
\t\033[38;5;197m-out_name\033[0m         : (optional) prefix for output files. Default is prefix of input file. Output will be in the form {wd}/{out_name}_{out_space}

\033[38;5;141mSURFACE-BASED ARGUMENTS:\033[0m
\t\033[38;5;197m-in_lh\033[0m            : (required) full path to input data for left hemisphere. Can be .label.gii, .annot, .shape.gii, .curv or .txt
\t\033[38;5;197m-in_rh\033[0m            : (required) full path to input data for right hemisphere. Can be .label.gii, .annot, .shape.gii, .curv or .txt
\t\033[38;5;197m-out_name\033[0m         : (required) prefix for output files. Output will be in the form {wd}/{out_name}_lh_{out_space}.*.gii {wd}/{out_name}_rh_{out_space}.*.gii
\t\033[38;5;197m-interp\033[0m           : (optional) interpolation method, can be linear or nearest. Only works for .txt. Other types are forced to defaults (label.gii and .annot to nearest, shape.gii and .curv to linear)

\t\033[38;5;197m-h|-help\033[0m          : Print help

Casey Paquola, MNI, MICA Lab, 2021
https://bigbrainwarp.readthedocs.io/
"
}

# -----------------------------------------------------------------------------------------------#
#			ARGUMENTS
# Create VARIABLES
for arg in "$@"
do
  case "$arg" in
  -h|-help)
    help
    exit 1
  ;;
  -in_space)
    in_space=$2
    exit 1
  ;;
  --out_space)
    out_space=$2
    shift;shift
  ;;
  --wd)
    wd=$2
    shift;shift
  ;;
  --interp)
    interp=$2
    exit 1
  ;;
  --in)
    in=$2
    shift;shift
  ;;
  --in_lh)
    in_lh=$2
    shift;shift
  ;;
  --in_rh)
    in_rh=$2
    shift;shift
  ;;
  --out_name)
    out_name=$2
    shift;shift
  ;;   
-*)
    Error "Unknown option ${2}"
    help
    exit 1
  ;;
    esac
done

# argument check out & WARNINGS
arg=($in_space $out_space $wd)
if [ ${#arg[@]} -lt 3 ]; then
Error "One or more mandatory arguments are missing:
               -in_space : $in_space
               -out_space : $out_space
               -wd : $wd"

# identify whether volume or surface based transformation will be performed
surface_spaces="fsaverage fs_LR"
if [[ "$surface_spaces" =~ .*"$in_space".* ]] | [[ "$surface_spaces" =~ .*"$out_space".* ]] ; then
    type=surface
else
    type=volume
fi
echo "warping $type"

if [[ "$type" == "volume" ]] ; then
    if [[ -z "$interp" ]] ; then
        interp=trilinear
    fi
    if [[ $in_space == "bigbrain" ]] ; then
        bigbrain_to_icbm $in histological $interp $wd $out_name
    elif [[ $in_space == "bigbrainsym" ]] ; then
        bigbrain_to_icbm $in sym $interp $wd $out_name
    else
        if [[ $out_space == "bigbrain" ]] ; then
            icbm_to_bigbrain $in histological $interp $wd $out_name
        elif [[ $out_space == "bigbrainsym" ]] ; then
            icbm_to_bigbrain $in sym $interp $wd $out_name
        fi
    fi
elif [[ "$type" == "surface" ]] ; then
    if [[ $in_space == .*"bigbrain".* ]]
        bigbrain_to_fsaverage $in_lh $in_rh $out_space $wd/$out_name
    else
        fsaverage_to_bigbrain $in_lh $in_rh $in_space $wd/$out_name
    fi
fi