for set_up = 1
    
    micaopen    = '/path/to/parent/directory/'; 
    mainDir     = [micaopen '/CorticalConfluence/'];
    
    % scripts
    addpath(genpath([GH '/surfstat'])) 
    addpath(genpath([mainDir '/scripts/']) )

    % load data
    load([mainDir 'output/hipp_right_coord.mat']);
    load([mainDir 'output/confluent_surface_right.mat']);
    
    
end

% geodesic distance from the bridgeheads, and sorting
coord_mat = reshape(AllEvSurf,3,[],1);
index_local = [coord_mat; reshape(repmat(bridge_dist, 16, 1),1,[])];

% convert from mm to vox
% establish world coordinates based on the start, step and length from the
% mincinfo full8_100um_optbal.mnc
index_local = [coord_mat; reshape(repmat(bridge_dist, 16, 1),1,[])];
index_global = [];
index_global(1,:) = round((index_local(1,:) + 71.66));
index_global(2,:) = round((index_local(2,:) + 72.97));
index_global(3,:) = round((index_local(3,:) + 59.7777));

% remove coordinates outside the confluence
index_global(4,:) = index_local(4,:);
index_global(:,index_local(4,:)==0) = [];

% find unique and fill
[uc, ~, ic] = unique(index_global(1:3,:)', 'rows');
data = nan(140, 154, 121);
for ii = 1:length(uc)
	data(uc(ii,1)-1:uc(ii,1)+1,uc(ii,2)-1:uc(ii,2)+1,uc(ii,3)-1:uc(ii,3)+1) = mean(index_global(4,ic==ii));
end
info = niftiinfo([mainDir '/full8_1000um_optbal.nii']);
info.Datatype = 'double';
niftiwrite(data,[mainDir '/bigbrain_axis_vox.nii'],info);
