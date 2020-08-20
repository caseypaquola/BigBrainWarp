
out_name=[bbwDir '/spaces/bigbrainsym/midsurf_vertices.nii'];


function fill_ribbon(lh_surf, rh_surf, template_vol, out_name, bbwDir)

% add path
addpath(genpath(bbwDir))

% load surface
S = SurfStatAvSurf({lh_surf, rh_surf});

% load template volume
vol = niftiread(template_vol);
info = niftiinfo(template_vol);

% populate new volume with vertex assignment
new_vol = zeros(size(vol), 'double');
for ii = 1:length(S.coord)
    vol_coord = round((S.coord(:,ii) - info.Transform.T(4,1:3)')/info.Transform.T(1,1)); % transformation from surface to volume
    new_vol(vol_coord(1), vol_coord(2), vol_coord(3)) = ii; 
end

info.Filename = out_name;
info.Datatype = 'double';
niftiwrite(new_vol, out_name, info)
