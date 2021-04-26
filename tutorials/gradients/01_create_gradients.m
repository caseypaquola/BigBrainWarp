for init_project = 1
    
    GH          = '/location/of/github/repos/';
    bbwDir      = [GH '/BigBrainWarp/']; 
    
    run_downsample = 0; % option turn off downsampling and uses the precomputed version in BigBrainWarp. Downsampling takes ~15minutes. 
    
    % addpaths
    addpath([bbwDir '/scripts/'])
    addpath(genpath([GH '/micaopen/surfstat']))

    % load surface
    BB = SurfStatAvSurf({[bbwDir '/spaces/bigbrain/gray_left_327680.obj'], ...
        [bbwDir '/spaces/bigbrain/gray_right_327680.obj']});

end

% load profiles
MP = reshape(dlmread([bbwDir '/spaces/bigbrain/profiles.txt']),[], 50)';

% downsample
if run_downsample == 1
    numFaces= 20484;
    patchNormal = patch('Faces', BB.tri, 'Vertices', BB.coord.','Visible','off');
    Sds = reducepatch(patchNormal,numFaces);
    [~, bb_downsample]  = intersect(patchNormal.Vertices,Sds.vertices,'rows');
    BB10.tri = double(Sds.faces);
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
            end %%%%% END FOR WHILE LOOP IS MISSING IN TUTORIAL SEGMENT
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
else
    load([bbwDir '/scripts/nn_surface_indexing.mat'], 'nn_bb');
end

% mpc and gradient
MPC = build_mpc(MP,nn_bb);
normangle = connectivity2normangle(MPC, 0);
[embedding, results] = mica_diffusionEmbedding(normangle, 'ncomponents', 10);
save([projDir '/output/bigbrain_gradients.mat'],'embedding', 'results')

% write out
for ii = 1:2
    Gmpc = BoSurfStatMakeParcelData(embedding(:,ii), BB, nn_bb);
    lhOut = [bbwDir '/spaces/bigbrain/Hist_G' num2str(ii) '_lh.txt'];
    rhOut = [bbwDir 'spaces/bigbrain/Hist_G' num2str(ii) '_rh.txt'];
    writematrix(Gmpc(1:end/2)', lhOut)
    writematrix(Gmpc((end/2)+1:end)', rhOut)
end