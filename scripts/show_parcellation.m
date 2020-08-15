GH = 'C:\Users\cpaq3\Desktop\';
bbw = [GH '/BigBrainWarp/'];
addpath(genpath([GH 'micaopen']))
addpath(genpath(bbw))
addpath('C:\Users\cpaq3\OneDrive\useful_scripts')

S = SurfStatAvSurf({[bbw '/bigbrain_surfaces/gray_left_327680.obj'], ...
    [bbw '/bigbrain_surfaces/gray_right_327680.obj']});

% schaefer 200
[~, ~, ctb] = read_annotation('C:\Users\cpaq3\OneDrive\useful_scripts\fsaverage\lh.Schaefer2018_200Parcels_7Networks_order.annot');
lh_colours = ctb.table(:,1:3)/255;
[~, ~, ctb] = read_annotation('C:\Users\cpaq3\OneDrive\useful_scripts\fsaverage\rh.Schaefer2018_200Parcels_7Networks_order.annot');
rh_colours = ctb.table(:,1:3)/255;
parc='schaefer_200';
lh = dlmread([bbw '/maps/bigbrain_space/parcellations/' parc '_bigbrain_lh.txt']);
rh = dlmread([bbw '/maps/bigbrain_space/parcellations/' parc '_bigbrain_rh.txt']);

cmap = distinguishable_colors(101);

f = figure;
SurfStatViewDataNoShade([lh; rh], S)
colormap(cmap)
colormap(lh_colours)

% all parcellations
parc_names = {'vosdewael_100', 'vosdewael_200', 'vosdewael_300', 'vosdewael_400', ...
    'schaefer_100', 'schaefer_200', 'schaefer_300', 'schaefer_400', ...
    'glasser_360', 'aparc'};

f = figure('units','centimeters','outerposition',[0 0 20 20]);
for ii = 1:length(parc_names)
    lh = dlmread([bbw '/maps/bigbrain_space/parcellations/' parc_names{ii} '_bigbrain_lh.txt']);
    rh = dlmread([bbw '/maps/bigbrain_space/parcellations/' parc_names{ii} '_bigbrain_rh.txt']);
    
    BoSurfStat_calibrate4ViewsNoShade([lh;rh], S, ...
        [0.05 1-(0.1*ii) 0.1 0.1; 0.15 1-(0.1*ii) 0.1 0.1; ...
        0.25 1-(0.1*ii) 0.1 0.1; 0.35 1-(0.1*ii) 0.1 0.1], ...
        1:4, [min([lh;rh]) max([lh;rh])], lines) 
end