for init_project = 1
    
    GH = '/location/of/github/repos/';
    bbwDir      = [GH '/BigBrainWarp/']; 
    
    addpath([bbwDir '/scripts/'])
    addpath(genpath([GH '/micaopen/surfstat']))
    
    S = SurfStatAvSurf({[bbwDir '/spaces/b\igbrain/gray_left_327680.obj'], ...
        [bbwDir '/spaces/bigbrain/gray_right_327680.obj']});
end

% load profiles
MP = reshape(dlmread([bbwDir '/spaces/bigbrain/profiles.txt']),[], 50)';

% downsample
load([bbwDir '/scripts/nn_surface_indexing.mat'], 'nn_bb');

% mpc and gradient
MPC = build_mpc(MP,nn_bb);
normangle = connectivity2normangle(MPC, 0);
[embedding, results] = mica_diffusionEmbedding(normangle, 'ncomponents', 10);
save([projDir '/output/bigbrain_gradients.mat'],'embedding', 'results')

% write out
for ii = 1:2
    Gmpc = BoSurfStatMakeParcelData(embedding(:,ii), S, nn_bb);
    lhOut = [bbwDir '/spaces/bigbrain/Hist_G' num2str(ii) '_lh.txt'];
    rhOut = [bbwDir 'spaces/bigbrain/Hist_G' num2str(ii) '_rh.txt'];
    writematrix(Gmpc(1:end/2)', lhOut)
    writematrix(Gmpc((end/2)+1:end)', rhOut)
end