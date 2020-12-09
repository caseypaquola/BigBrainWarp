% nn_surface_indexing
%
% script to index the nearest neighbours between fsaverage and BigBrain
% author: Casey Paquola @ MICA, MNI, 2020*

% load surfaces
GH          = '/data_/mica1/03_projects/casey/';
bbwDir      = [GH '/BigBrainWarp/'];
BB = SurfStatAvSurf({[bbwDir '/spaces/bigbrainsym/gray_left_327680_2009b_sym.obj'], ...
    [bbwDir '/spaces/bigbrainsym/gray_right_327680_2009b_sym.obj']});
fsAv = '/data_/mica1/03_projects/casey/micasoft/parcellations/fsaverage5';
FS = SurfStatAvSurf({[fsAv '/lh.pial'], [fsAv '/rh.pial']});
FSlh = SurfStatReadSurf([fsAv '/lh.pial']);  % using local versions of fsaverage pial surfaces (FS5.3)
FSrh = SurfStatReadSurf([fsAv '/rh.pial']);

% downsample BB
numFaces    = 20484;
patchNormal = patch('Faces', BB.tri, 'Vertices', BB.coord.','Visible','off');
Sds         = reducepatch(patchNormal,numFaces);
[~,bb_downsample]  = intersect(patchNormal.Vertices,Sds.vertices,'rows');
BB10.tri     = double(Sds.faces);
BB10.coord   = Sds.vertices';

% For each vertex on BB, find nearest neighbour on BB10, via mesh neighbours
nn_bb = zeros(1,length(BB.coord));
edg = SurfStatEdg(BB);
parfor ii = 1:length(BB.coord)
    nei = unique(edg(sum(edg==ii,2)==1,:));
    if isempty(nei) && ismember(ii,bb_downsample)
        nn_bb(ii) = ii;
    else
        while sum(ismember(nei, bb_downsample))==0
            nei = [unique(edg(sum(ismember(edg,nei),2)==1,:)); nei];
        end
        matched_vert = nei(ismember(nei, bb_downsample));
        if length(matched_vert)>1  % choose the mesh neighbour that is closest in Euclidean space
            n1 = length(matched_vert);
            d = sqrt(sum((repmat(BB.coord(1:3,ii),1,n1) - BB.coord(:,matched_vert)).^2));
            [~, idx] = min(d);
            nn_bb(ii) = matched_vert(idx);
        else
            nn_bb(ii) = matched_vert;
        end
    end
end

% For indexing fsaverage surfaces, ie: fsaverage2bigbrain
% constrained by hemisphere
n1 = length(FSlh.coord);
nn_fs_bb10 = zeros(1,length(BB10.coord));
parfor ii = 1:length(BB10.coord)
    if bb_downsample(ii)<=(length(FS.coord)/2)
        d = sqrt(sum((repmat(BB10.coord(1:3,ii),1,n1) - FSlh.coord).^2)); 
        nn_fs_bb10(ii) = find(d==min(d)); 
    else
        d = sqrt(sum((repmat(BB10.coord(1:3,ii),1,n1) - FSrh.coord).^2)); 
        nn_fs_bb10(ii) = find(d==min(d))+length(FSlh.coord); 
    end
end

% For indexing bigbrain surfaces, ie: bigbrain2fsaverage
n1 = length(BB10.coord);
nn_bb10_fs = zeros(1,length(FS.coord)); % nearest neighbour of each FS vertex on BB
BBlh_coord = BB10.coord;
BBlh_coord(:,bb_downsample>=(length(BB.coord)/2)) = inf;
parfor ii = 1:(length(FS.coord)/2)
   d = sqrt(sum((repmat(FS.coord(1:3,ii),1,n1) - BBlh_coord).^2)); 
   nn_bb10_fs(ii) = find(d==min(d)); 
end
BBrh_coord = BB10.coord;
BBrh_coord(:,bb_downsample<(length(BB.coord)/2)) = inf;
parfor ii = ((length(FS.coord)/2)+1):length(FS.coord)
    d = sqrt(sum((repmat(FS.coord(1:3,ii),1,n1) - BBrh_coord).^2)); 
    nn_bb10_fs(ii) = find(d==min(d)); 
end

save([bbwDir '/scripts/nn_surface_indexing.mat'], 'bb_downsample',  'nn_bb', 'nn_bb10_fs', 'nn_fs_bb10', 'BB10')