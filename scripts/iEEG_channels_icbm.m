% all_channels_icbm.m
% populates a nifti volume with each channel from the atlas

% create empty volume using the icbm mask
hdr = niftiinfo([bbwDir '/spaces/mni152/mni_icbm152_t1_tal_nlin_sym_09c_mask.nii']);
vol = zeros(hdr.ImageSize);

% load channel coordinates
tbl = readtable([homeDir '/data/ChannelInformation.csv']); % downloaded from https://mni-open-ieegatlas.research.mcgill.ca 

% place channels in the volume
subs = round(table2array(tbl(:,6:8)) - hdr.Transform.T(4,1:3)); % get 3D subscript of each channel
ind = sub2ind(hdr.ImageSize, subs(:,1), subs(:,2), subs(:,3));
vol(ind) = 1:length(ind);

% save out volume
hdr2 = hdr;
hdr2.Filename = [bbwDir '/maps/mni152_space/all_channels_icbm.nii'];
hdr2.Description = 'ChannelInformation.csv on mni_icbm152_t1_tal_nlin_sym_09c_mas';
niftiwrite(single(vol), [bbwDir '/mni152_space/all_channels_icbm.nii'], hdr2)


