function [config, store, obs] = taun2clustering(config, setting, data)
% taun3clustering CLUSTERING step of the expLanes experiment talspStruct2016_unsupervised
%    [config, store, obs] = taun3clustering(config, setting, data)
%      - config : expLanes configuration state
%      - setting   : set of factors to be evaluated
%      - data   : processing data stored during the previous step
%      -- store  : processing data to be saved for the other steps
%      -- obs    : observations to be saved for analysis

% Copyright: gregoirelafay
% Date: 17-Dec-2016

% Set behavior for debug mode
if nargin==0, unsupervised('do', 2:5, 'mask', {1 1 3 0 2 3}); return; else store=[]; obs=[]; end

%% seed

rng(0);

%% store


%% integration

switch setting.dataset
    case {'2016', '2017'}
        %         length(unique(data.indSample))
        data = setTextureFrames(data, setting);
        %         length(unique(data.indSample))
end

store=data;
rmfield(store, 'features');

store.weight=[];
store.centroid=[];
store.indSample=[];
store.centroidClass=[];
store.prediction=[];

switch setting.sim
    case {'close', 'dtw'}
        if setting.pooling>0
            X = data.features;
            data.features=[];
            store.indSample=[];
            for jj=unique(data.indSample)
                X_tmp=X(:,data.indSample==jj);
                step=round(setting.pooling/(100*data.xp_settings.hoptime));
                onsets=1:step:size(X_tmp,2);
                offsets=[onsets(2:end)-1 size(X_tmp,2)];
                X_tmp=featuresPooling(X_tmp,'mean',onsets,offsets,0,0,data.xp_settings.hoptime);
                data.features = [data.features X_tmp];
                store.indSample=[store.indSample ones(1,size(X_tmp,2))*jj];
            end
            data.indSample = store.indSample;
        end
        store.indSample=[];
        params.clustering='kmeans';
        
        for jj=unique(data.indSample)
            if jj>0
                params.similarity='sqeuclidean';
                params.nbc=ceil(100/setting.integration);
                params.rep=1;
                params.emptyAction='singleton';
                
                if (setting.integration>0)
                    [prediction,centroid] = kmeans(full(data.features(:,data.indSample==jj))',params.nbc,'maxiter',1000,'replicates',params.rep,'start','plus','Distance',params.similarity,'EmptyAction',params.emptyAction);
                    centroid=centroid';
                else
                    prediction = data.class;
                    centroid=full(data.features(:,data.indSample==jj));
                end
                %[prediction,centroid,params] = featuresBasedClustering(data.features(:,data.indSample==jj),params);
                
                %% weight
                
                params.histType='';
                params.nbc=size(centroid,2);
                
                %% Norm
                
                % weight=weight./sum(weight);
                
                %% store
                store.prediction=[store.prediction prediction+params.nbc*(jj-1)];
                store.centroid=[store.centroid centroid];
                store.indSample=[store.indSample ones(1,size(centroid,2))*jj];
                store.centroidClass=[store.centroidClass ones(1,size(centroid,2))*store.class(jj)];
            end
        end
        
    case 'early'
        
        store.centroid=cell2mat(arrayfun(@(x) mean(data.features(:,data.indSample==x),2),unique(data.indSample),'UniformOutput',false));
        store.indSample=unique(data.indSample);
        store.centroidClass=store.class;
        
    case 'gmm'
        expRandomSeed();
        if length(setting.features)>4 && strcmp(setting.features(1:5), 'scatT')
            % perform pca
            coeff = pca(data.features');
            data.features = data.features'*coeff;
            data.features = data.features(:, 1:30)';
        end
        
        for  i=unique(data.indSample)
            gmmi=[];
            for k=1:10
                dn = full(data.features(:,data.indSample==i))';
                if strcmp(setting.dataset, '2016') && i==33
                    dn = dn + randn(size(dn))*1;
                end
                gmmi = createGmm(dn, 10);
                if ~(any(isnan(gmmi.priors)) && any(isnan(gmmi.covars(:))))
                    break;
                end
            end
            if any(isnan(gmmi.priors)) || any(isnan(gmmi.covars(:)))
                fprintf(2, 'unable to learn gmm for sample %d, performing kmeans\n', i);
                
                nbcoef=size(dn,2);
                gmmi = gmm(nbcoef, 10, 'diag');
                % options = foptions;
                options(14) = 200;	% Just use 20 iterations of k-means in initialisation
                options(1)  = -1;
                gmmi = gmminit(gmmi, dn, options);
            end
            store.model{i} = gmmi;
        end
end