function wrapper_fsaverage2mni(CBIG_CODE_DIR, lh_input, rh_input, interp)
% wrapper for fsaverage to volumetric mni space transformations from 
% Wu et al., 2018 (https://doi.org/10.1002/hbm.24213) 
%
% input:
% CBIG_CODE_DIR        /path/to/CBIG-master (https://github.com/ThomasYeoLab/CBIG)
% see CBIG_RF_projectfsaverage2Vol_single for other input arguments
%
% author: Casey Paquola @ MICA, MNI, 2020*

% add necessary paths from CBIG
mainDir = [CBIG_CODE_DIR '/stable_projects/registration/Wu2017_RegistrationFusion/bin/scripts_final_proj'];
addpath(genpath([CBIG_CODE_DIR '/stable_projects/registration/Wu2017_RegistrationFusion/']));
addpath(genpath([CBIG_CODE_DIR '/utilities/matlab']));
addpath(genpath([CBIG_CODE_DIR '/external_packages/SD']));

% set parameters
map=[CBIG_CODE_DIR '/stable_projects/registration/Wu2017_RegistrationFusion/bin/' ...
    'final_warps_FS5.3/allSub_fsaverage_to_FSL_MNI152_FS4.5.0_RF_ANTs_avgMapping.prop.mat'];
mask_input=[CBIG_CODE_DIR '/stable_projects/registration/Wu2017_RegistrationFusion/bin/' ...
                     'liberal_cortex_masks_FS5.3/FSL_MNI152_FS4.5.0_cortex_estimate.nii.gz'];

% run code
projected = CBIG_RF_projectfsaverage2Vol_single(lh_input, rh_input, interp, map, mask_input);
