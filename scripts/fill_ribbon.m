function fill_ribbon(lhSurf, rhSurf, templateVol, outName, bbwDir)

% read and concatenate data
data = [readmatrix(lhSurf); readmatrix(rhSurf)];

% load surface
S = SurfStatAvSurf({lhSurf, rhSurf});

% load template volume
vol = niftiread(templateVol);
info = niftiinfo(templateVol);

% populate new volume with vertex assignment
newVol = zeros(size(vol), 'double');
for ii = 1:length(S.coord)
    volCoord = round((S.coord(:,ii) - info.Transform.T(4,1:3)')/info.Transform.T(1,1)); % transformation from surface to volume
    newVol(volCoord(1), volCoord(2), volCoord(3)) = ii;
end

info.Filename = outName;
info.Datatype = 'double';
niftiwrite(newVol, outName, info)
