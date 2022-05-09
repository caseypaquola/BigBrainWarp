%% Initialise Project
    
    GH          = '/location/of/github/repos/';
    bbwDir      = [GH '/BigBrainWarp/'];
    
    run_downsample = 0; % option turn off downsampling and uses the precomputed version in BigBrainWarp. Downsampling takes ~15minutes. 
    
    % addpaths
    addpath([bbwDir '/scripts/']);
    addpath(genpath([GH '/micaopen/'])); % https://github.com/MICA-MNI/micaopen

    % load surface
    BB = SurfStatAvSurf({[bbwDir '/spaces/tpl-bigbrain/tpl-bigbrain_hemi-L_desc-pial.obj'], ...
        [bbwDir '/spaces/tpl-bigbrain/tpl-bigbrain_hemi-R_desc-pial.obj']});

%% Analysis
% load staining intensity profiles
MP = reshape(dlmread([bbwDir '/spaces/tpl-bigbrain/tpl-bigbrain_desc-profiles.txt']),[], 50)';

% create a parcellation on BigBrain based on morphometry
% downsampling is necessary to calculate correlations between profiles across whole cortex
% the output is provided in BigBrainWarp and may be directly loaded. If so,
% set run_downsample to 0 (see line 6).
if run_downsample == 1    
    % mesh decimation
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
            end
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
MPC = build_mpc(MP,nn_bb); % parcellate profiles and perform partial correlation
normangle = connectivity2normangle(MPC, 0); % convert to normalised angle matrix
[embedding, results] = mica_diffusionEmbedding(normangle, 'ncomponents', 10); % diffusion map embedding. Eigenvectors ("gradients") are in the embedding output

%% Visualisation
f = figure('units','centimeters','outerposition',[0 0 20 20]);

% profiles
% for two parcels (in this example 1 and 4), plots the mean profile and the
% individual profiles
% uses "lapaz", "vik" and "roma" colormaps - https://www.fabiocrameri.ch/colourmaps/
a(1) = axes('position', [0.1 0.6 0.15 0.3]);
ubb = unique(nn_bb);
plot(MP(:,nn_bb==ubb(1))*-1, flip(1:50),'--', 'Color', lapaz(50,:), 'LineWidth', 0.001)
alpha 0.5
hold on
plot(mean(MP(:,nn_bb==ubb(1))*-1,2), flip(1:50), 'LineWidth', 1.5, 'Color', lapaz(20,:))
plot(MP(:,nn_bb==ubb(4))*-1, flip(1:50),'--', 'Color', lapaz(150,:), 'LineWidth', 0.001)
alpha 0.5
hold on
plot(mean(MP(:,nn_bb==ubb(4))*-1,2), flip(1:50), 'LineWidth', 1.5, 'Color', lapaz(50,:))
ylim([1 51])

% MPC matrix (ordered by first eigenvector)
a(2) = axes('position', [0.3 0.6 0.3 0.3]);
[~, idx] = sort(embedding(:,1));
imagesc(MPC(idx,idx)); axis off
camroll(45)
colormap(a(2), vik)

% pseudo-variance explained
a(3) = axes('position', [0.7 0.6 0.15 0.3]);
scatter(1:10, results.lambdas(1:10)/sum(results.lambdas), ...
            20, [0.5 0.5 0.5], 'filled', 'MarkerEdgeColor', 'k')

% eigenvectors on the cortical surface
GOnSurf = BoSurfStatMakeParcelData(embedding(:,1), BB, nn_bb); % expand from parcels to vertices
BoSurfStat_calibrate4Views(GOnSurf, BB, ...
        [0.4 0.3 0.2 0.2; 0.4 0.1 0.2 0.2; ...
        0.58 0.1 0.2 0.2; 0.58 0.3 0.2 0.2], ...
        1:4, [min(embedding(:,1)) max(embedding(:,1))], roma)

%% Export
% write out as text files for BigBrainWarp
for ii = 1:2
    Gmpc = BoSurfStatMakeParcelData(embedding(:,ii), BB, nn_bb);
    lhOut = [bbwDir '/spaces/tpl-bigbrain/tpl-bigbrain_hemi-L_desc-Hist_G' num2str(ii) '.txt'];
    rhOut = [bbwDir '/spaces/tpl-bigbrain/tpl-bigbrain_hemi-R_desc-Hist_G' num2str(ii) '.txt'];
    writematrix(Gmpc(1:end/2)', lhOut)
    writematrix(Gmpc((end/2)+1:end)', rhOut)
end