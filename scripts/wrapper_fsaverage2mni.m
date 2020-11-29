function wrapper_fsaverage2mni(lhData, rhData, interp, outName, bbwDir, cbigDir)
% wrapper for fsaverage to volumetric mni space transformations from 
% Wu et al., 2018 (https://doi.org/10.1002/hbm.24213) 
%
% input:
% lhData              data on the left hemisphere (1 x vertices, can be )
% rhData              data on the right hemisphere (1 x vertices)
% interp               type of interpolation to use. Recommended 'nearest' for
%                      discrete data (eg: parcellations) and 'linear' for
%                      smooth data
% outName              name of output file (will be apended with mni152.nii)
% bbwDir              /path/to/BigBrainWarp/
% cbigDir             /path/to/CBIG-master (https://github.com/ThomasYeoLab/CBIG)
% 
% 
% Compatible data input types include:
% .annot               requires Freesurfer matlab component
% .gifti               requires gifti toolbox (https://www.artefact.tk/software/matlab/gifti/)
% .thickness           requires Freesurfer matlab component
% .curv                requires Freesurfer matlab component 
% .txt
% 
% author: Casey Paquola @ MICA, MNI, 2020*

% convert variables to character vectors
outName = char(outName);
bbwDir = char(bbwDir);
cbigDir = char(cbigDir);

% add necessary paths from CBIG
addpath(genpath(bbwDir));
addpath(genpath([cbigDir '/stable_projects/registration/Wu2017_RegistrationFusion/']));
addpath(genpath([cbigDir '/utilities/matlab']));
addpath(genpath([cbigDir '/external_packages/SD']));

% load and vectorise surface data
[~,~,ext] = fileparts(lhData);
if strcmp(ext, '.annot')
    parc = annot2classes(lhData, rhData, 0);
    lh_input = parc(1:end/2)';
    rh_input = parc((end/2)+1:end)';
elseif strcmp(ext, '.gii')
    tmp = gifti(lhData);
    lh_input = tmp.cdata';
    tmp = gifti(rhData);
    rh_input = tmp.cdata';
elseif strcmp(ext, '.txt')
    lh_input = readmatrix(lhData);
    rh_input = readmatrix(rhData);
else
    lh_input = read_curv(lhData)';
    rh_input = read_curv(rhData)';
end

% check size and transpose if necessary
compatSizes = [10242, 40962, 163842];
if sum(size(lh_input)==size(rh_input))==2
   error('hemispheric data not the same size');
end
if ~ismember(size(lh_input,2), compatSizes)
    if ismember(size(lh_input,1), compatSizes)
        lh_input = lh_input';
        rh_input = rh_input';
    else
        error('invalid number of vertices');
    end
end

% need to gunzip the mask file (may not be an issue for all systems)
mask_input=[cbigDir '/stable_projects/registration/Wu2017_RegistrationFusion/bin/' ...
                     'liberal_cortex_masks_FS5.3/FSL_MNI152_FS4.5.0_cortex_estimate.nii.gz'];
if exist(mask_input, 'file')
    system(['gunzip ' mask_input])
end
mask_input=[cbigDir '/stable_projects/registration/Wu2017_RegistrationFusion/bin/' ...
                     'liberal_cortex_masks_FS5.3/FSL_MNI152_FS4.5.0_cortex_estimate.nii'];

% set extra terms
map=[cbigDir '/stable_projects/registration/Wu2017_RegistrationFusion/bin/' ...
    'final_warps_FS5.3/allSub_fsaverage_to_FSL_MNI152_FS4.5.0_RF_ANTs_avgMapping.prop.mat'];

% run code
projected = CBIG_RF_projectfsaverage2Vol_single(lh_input, rh_input, interp, map, mask_input);

% write out
MRIwrite(projected,[outName '_mni152.nii'])
