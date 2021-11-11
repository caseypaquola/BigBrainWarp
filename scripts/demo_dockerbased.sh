#!/bin/bash
docker pull caseypaquola/bigbrainwarp:latest

# FORM 1 - bigbrain volume to icbm volume
# using data within BigBrainWarp
docker run -it --rm -v /local/directory/with/data/:/BigBrainWarp/mount \
        caseypaquola/bigbrainwarp bigbrainwarp \
        --in_space bigbrain --in_vol "$bbwDir"/spaces/tpl-bigbrain/confluence.nii \
        --interp nearest --out_space icbm --out_res 0.5 \
        --desc cls --wd "$wd"

# FORM 2 - bigbrain volume to fsaverage
# using data on local system
docker run -it --rm -v /local/directory/with/data/:/BigBrainWarp/mount \
        caseypaquola/bigbrainwarp \
        bigbrainwarp --in_space bigbrainsym --in_vol /BigBrainWarp/mount/ROI.nii \
        --interp linear --out_type surface --out_space fsaverage \
        --desc ROI --wd "$wd"

# FORM 3 - icbm volume to bigbrain volume
docker run -it --rm -v /local/directory/with/data/:/BigBrainWarp/mount \
        caseypaquola/bigbrainwarp \
        bigbrainwarp --in_space icbm --in_vol "$bbwDir"/spaces/tpl-icbm/tpl-icbm_desc-t1_tal_nlin_sym_09c_mask.mnc \
        --interp nearest --out_space bigbrainsym --out_res 2 \
        --desc cls --wd "$wd"

# FORM 4 - icbm volume to bigbrain surface
docker run -it --rm -v /local/directory/with/data/:/BigBrainWarp/mount \
        caseypaquola/bigbrainwarp \
        bigbrainwarp --in_space icbm --in_vol "$bbwDir"/spaces/tpl-icbm/tpl-icbm_desc-t1_tal_nlin_sym_09c_mask.mnc \
        --interp nearest --out_space bigbrainsym --out_type surface \
        --desc cls --wd "$wd"

# FORM 5 - bigbrain surface to icbm volume
docker run -it --rm -v /local/directory/with/data/:/BigBrainWarp/mount \
        caseypaquola/bigbrainwarp \
        bigbrainwarp --in_space bigbrain \
        --in_lh "$bbwDir"/spaces/tpl-bigbrain/tpl-bigbrain_hemi-L_desc-Hist_G1.txt \
        --in_rh "$bbwDir"/spaces/tpl-bigbrain/tpl-bigbrain_hemi-R_desc-Hist_G1.txt \
        --interp linear --out_space icbm --out_type volume --out_res 0.75 \
        --desc Hist_G1 --wd "$wd"

# FORM 6 - bigbrain surface to fsaverage
docker run -it --rm -v /local/directory/with/data/:/BigBrainWarp/mount \
        caseypaquola/bigbrainwarp \
        bigbrainwarp --in_space bigbrain \
        --in_lh "$bbwDir"/spaces/tpl-bigbrain/tpl-bigbrain_hemi-L_desc-Hist_G1.txt \
        --in_rh "$bbwDir"/spaces/tpl-bigbrain/tpl-bigbrain_hemi-R_desc-Hist_G1.txt \
        --interp linear --out_space fs_LR --out_den 32 \
        --desc Hist_G1 --wd "$wd"

# FORM 7 - fsaverage to bigbrain volume
docker run -it --rm -v /local/directory/with/data/:/BigBrainWarp/mount \
        caseypaquola/bigbrainwarp \
        bigbrainwarp --in_space fsaverage \
        --in_lh "$bbwDir"/spaces/tpl-fsaverage/tpl-fsaverage_hemi-L_den-164k_desc-Func_G1.curv \
        --in_rh "$bbwDir"/spaces/tpl-fsaverage/tpl-fsaverage_hemi-R_den-164k_desc-Func_G1.curv \
        --interp linear --out_space bigbrain --out_type volume \
        --desc Func_G1 --wd "$wd"

# FORM 8 - fsaverage to bigbrain surface
docker run -it --rm -v /local/directory/with/data/:/BigBrainWarp/mount \
        caseypaquola/bigbrainwarp \
        bigbrainwarp --in_space fsaverage \
        --in_lh "$bbwDir"/spaces/tpl-fsaverage/tpl-fsaverage_hemi-L_den-164k_desc-Func_G1.curv \
        --in_rh "$bbwDir"/spaces/tpl-fsaverage/tpl-fsaverage_hemi-R_den-164k_desc-Func_G1.curv \
        --interp nearest --out_space bigbrainsym \
        --desc Func_G1 --wd "$wd"