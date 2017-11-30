function [config, store, obs] = taun3similarity(config, setting, data)
% taun4similarity SIMILARITY step of the expLanes experiment talspStruct2016_unsupervised
%    [config, store, obs] = taun4similarity(config, setting, data)
%      - config : expLanes configuration state
%      - setting   : set of factors to be evaluated
%      - data   : processing data stored during the previous step
%      -- store  : processing data to be saved for the other steps
%      -- obs    : observations to be saved for analysis

% Copyright: gregoirelafay
% Date: 17-Dec-2016


% Set behavior for debug mode
if nargin==0, unsupervised('do', 3:6, 'mask', {1 1 4 2 2 3}); return; else store=[]; obs=[]; end

%% store

% store=data;

store.xp_settings = data.xp_settings;
store.class = data.class;

%% get clusters Similarity

params.mode='centroid';
params.similarity='rbf';
params.class=data.centroidClass;



switch setting.sim
    case {'close'}
        for k=1:length(data.class)
            for l=k+1:length(data.class)
                dkl = dist2(data.centroid(:, data.indSample==k)', data.centroid(:, data.indSample==l)');
%                 if setting.similarity_nn~=0
%                     if setting.similarity_nn<1
%                         nn=max([1 round(setting.similarity_nn*size(dkl,2))]);
%                     else
%                         nn = setting.similarity_nn;
%                     end
%                     dkl = rbfKernel(dkl,'st-1nn',nn);
%                 end
                dkl = dkl(:);
                d(k, l) = min(dkl(dkl~=0));
                d(l, k) = d(k, l);
            end
        end
        store.A=1-d;
        d=1-d;
        d=(d+d')/2;
        %         d(logical(eye(size(d)))) = 1;
        store.A = d;
   
    case 'early'
        store.A = 1-squareform(pdist(data.centroid'));
    case 'dtw'
        n=1;
        
        for k=1:length(data.class)
            vec=[];
            for m=k+1:length(data.class)
                M = simmx(data.centroid(:, data.indSample==k), data.centroid(:, data.indSample==m));
                [~, ~, C] = dpfast(1-M);
                vec(m) = C(size(C,1),size(C,2));
            end
            for m=k+1:length(data.class)
                d(n) = vec(m);
                n = n+1;
            end
        end
        store.A = 1-squareform(d);
    case 'gmm'
        d=[];
        for k=1:length(data.model)
            vec=[];
            parfor l=k+1:length(data.model)
                vec(l) = distanceModelToModel(data.model{k}, data.model{l}, setting.nbSamples);
            end
            for l=k+1:length(data.model)
                d(k, l) = vec(l);
                d(l, k) = d(k, l);
            end
        end
        store.A = 1-d;
end