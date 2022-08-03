for init_project = 1
    
    GH          = '/location/of/github/repos/';
    bbwDir      = [GH '/BigBrainWarp/']; 
    projDir     = '/local/working/directory/';
    
    addpath([bbwDir '/scripts/'])
    addpath(genpath([GH '/micaopen/surfstat']))
    
end

% load network atlas
parc_name='Yeo2011_17Networks_N1000';
lh = gifti([bbwDir '/spaces/tpl-bigbrain/tpl-bigbrain_hemi-L_desc-' parc_name '.label.gii']);
rh = gifti([bbwDir '/spaces/tpl-bigbrain/tpl-bigbrain_hemi-R_desc-' parc_name '.label.gii']);
parc = [lh.cdata; rh.cdata];
names = [lh.labels.name rh.labels.name];

% moments 
MP = 65536 - reshape(dlmread([bbwDir '/spaces/tpl-bigbrain/tpl-bigbrain_desc-profiles.txt']),[], 50)';
MPmoments = calculate_moments(MP); % caution will take ~60 minutes to run with 10 parallel workers

% create cross folds 
folds = 10;
n = floor(6558/folds); % set n vertices, to ensure matched number across networks. n is based number of vertices in smallest network
Xcv_eq = zeros(n*17,size(MPmoments,1),folds);
ycv_eq = zeros(n*17,folds);
for ii = 1:17
    idx = randperm(sum(parc==ii),sum(parc==ii)); % randomly assigns an integer to each vertex of the network
    idx_net = find(parc==ii); % where is the network in the feature vector
    for cv = 1:folds
        Xcv_eq(((ii-1)*n)+1:(ii*n),:,cv) = MPmoments(:,idx_net(ismember(idx,((cv-1)*n)+1:(cv*n))))'; % randomly selects n/folds vertices from the network
        ycv_eq(((ii-1)*n)+1:(ii*n),cv) = repmat(ii,n,1); % labels network
    end
end
save([projDir '/output/tpl-bigbrain_desc-yeo17_moments.mat'], 'Xcv_eq', 'ycv_eq')
