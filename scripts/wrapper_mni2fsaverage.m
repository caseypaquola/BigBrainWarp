function wrapper_mni2fsaverage(inputVol, interp, workDir, outName, bbwDir, cbigDir)
% wrapper for volumetric mni to space to fsaverage transformations from
% Wu et al., 2018 (https://doi.org/10.1002/hbm.24213) 
% set up for fsaverage5 but can be made more flexible
%
% input:
% inputVol            volumetric data in nifti
% interp               type of interpolation to use. Recommended 'nearest' for
%                      discrete data (eg: parcellations) and 'linear' for
%                      smooth data
% workDir              working directory to save file to 
% outName              name of output file (will be apended with _?h_fsaverage5.curv)
% bbwDir              /path/to/BigBrainWarp/
% cbigDir             /path/to/CBIG-master (https://github.com/ThomasYeoLab/CBIG)
%
%
% author: Casey Paquola @ MICA, MNI, 2020*

% add relevant paths
addpath([char(bbwDir) '/dependencies/freesurfer_matlab']);
addpath(genpath([char(cbigDir) '/stable_projects/registration/Wu2017_RegistrationFusion/']));
addpath(genpath([char(cbigDir) '/utilities/matlab']));
addpath(genpath([char(cbigDir) '/external_packages/SD']));

% read in volume
input = MRIread(inputVol);

% set extra variables
lh_map = [cbigDir '/stable_projects/registration/Wu2017_RegistrationFusion/bin/' ...
        'final_warps_FS5.3/lh.avgMapping_allSub_RF_ANTs_MNI152_orig_to_fsaverage.mat'];
rh_map = [cbigDir '/stable_projects/registration/Wu2017_RegistrationFusion/bin/' ...
        'final_warps_FS5.3/rh.avgMapping_allSub_RF_ANTs_MNI152_orig_to_fsaverage.mat'];
if strcmp(interp,'nearest_neighbour')
    interp = 'nearest';
end
    
% run registration
[lh_proj_data, rh_proj_data] = CBIG_RF_projectVol2fsaverage_single(input, interp, lh_map, rh_map, 'fsaverage5');

% save out in freesurfer curv format
write_curv([workDir '/lh.' outName '_fsaverage5.curv'], lh_proj_data, 20480);
write_curv([workDir '/rh.' outName '_fsaverage5.curv'], rh_proj_data, 20480);
