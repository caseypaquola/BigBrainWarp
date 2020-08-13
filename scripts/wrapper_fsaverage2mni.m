function wrapper_fsaverage2mni(CBIG_CODE_DIR, lh_data, rh_data, interp, outName)
% wrapper for fsaverage to volumetric mni space transformations from 
% Wu et al., 2018 (https://doi.org/10.1002/hbm.24213) 
%
% input:
% CBIG_CODE_DIR        /path/to/CBIG-master (https://github.com/ThomasYeoLab/CBIG)
% lh_data              data on the left hemisphere
% rh_data              data on the right hemisphere 
% interp               type of interpolation to use. Recommended 'nearest' for
%                      discrete data (eg: parcellations) and 'linear' for
%                      smooth data
% outName              name of output file (will be apended with mni152.nii)
% 
% Compatible data input types include:
% .annot               requires Freesurfer matlab component
% .gifti               requires gifti toolbox (https://www.artefact.tk/software/matlab/gifti/)
% .thickness           requires Freesurfer matlab component
% .curv                requires Freesurfer matlab component
% 
% author: Casey Paquola @ MICA, MNI, 2020*

% add necessary paths from CBIG
mainDir = [CBIG_CODE_DIR '/stable_projects/registration/Wu2017_RegistrationFusion/bin/scripts_final_proj'];
addpath(genpath([CBIG_CODE_DIR '/stable_projects/registration/Wu2017_RegistrationFusion/']));
addpath(genpath([CBIG_CODE_DIR '/utilities/matlab']));
addpath(genpath([CBIG_CODE_DIR '/external_packages/SD']));

% load and vectorise surface data
[~,~,ext] = fileparts(lh_data);
if strcmp(ext, '.annot')
    parc = annot2classes(lh_data, rh_data, 0);
    lh_input = parc(1:end/2)';
    rh_input = parc((end/2)+1:end)';
elseif strcmp(ext, '.gii')
    tmp = gifti(lh_data);
    lh_input = tmp.cdata';
    tmp = gifti(rh_data);
    rh_input = tmp.cdata';
else
    lh_input = read_curv(lh_data)';
    rh_input = read_curv(rh_data)';
end
    
% set extra terms
map=[CBIG_CODE_DIR '/stable_projects/registration/Wu2017_RegistrationFusion/bin/' ...
    'final_warps_FS5.3/allSub_fsaverage_to_FSL_MNI152_FS4.5.0_RF_ANTs_avgMapping.prop.mat'];
mask_input=[CBIG_CODE_DIR '/stable_projects/registration/Wu2017_RegistrationFusion/bin/' ...
                     'liberal_cortex_masks_FS5.3/FSL_MNI152_FS4.5.0_cortex_estimate.nii.gz'];
system(['gunzip ' mask_input])
mask_input=[CBIG_CODE_DIR '/stable_projects/registration/Wu2017_RegistrationFusion/bin/' ...
                     'liberal_cortex_masks_FS5.3/FSL_MNI152_FS4.5.0_cortex_estimate.nii'];

% run code
projected = CBIG_RF_projectfsaverage2Vol_single(lh_input, rh_input, interp, map, mask_input);

