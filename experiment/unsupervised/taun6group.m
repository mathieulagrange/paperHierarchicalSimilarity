function [config, store, obs] = taun6group(config, setting, data)
% taun6group GROUP step of the expLanes experiment unsupervised
%    [config, store, obs] = taun6group(config, setting, data)
%      - config : expLanes configuration state
%      - setting   : set of factors to be evaluated
%      - data   : processing data stored during the previous step
%      -- store  : processing data to be saved for the other steps
%      -- obs    : observations to be saved for analysis

% Copyright: Mathieu Lagrange
% Date: 27-Nov-2017

% Set behavior for debug mode
if nargin==0, unsupervised('do', 6, 'mask', {3 1 1 4 0 0 0 1 1}); return; else store=[]; obs=[]; end

data = expLoad(config, '', 3);

expRandomSeed();

if ~isfield(data, 'A'), obs.nmi=0; return; end

S = data.A;
S=(S+S')/2;
S(isinf(S)) = 0;
S(isnan(S)) = 0;
S = S-min(S(:));
S = S/max(S(:));

outputFilePrefix = expSave(config, [], 'data') ;
outputFilePrefix = outputFilePrefix(1:end-4);
simpleWriteMatrix(S, [outputFilePrefix '.matrix']);

nbClasses = length(unique(data.class));

for k=1:10
    maxCrit = -Inf;
    for m=1:50
        init = ceil(rand(1, length(data.class))*nbClasses);
        init(1:nbClasses) = 1:nbClasses;
        switch setting.group
            case 'kaverages'
                [clusters, log] = simpleClustering(setting.group, [outputFilePrefix '.matrix'],nbClasses, outputFilePrefix, init);
            case 'kkmeans'
                clusters=init;
                %% version 1: directly implement the formula in [1]
                last = 0;
                nbIterations=0;
                n = size(S,1);
                SS = repmat((1:nbClasses)',1,n);
                while any(clusters ~= last) && nbIterations<1000
                    E = double(bsxfun(@eq,SS,clusters));
                    E = bsxfun(@rdivide,E,sum(E,2));
                    T = E*S;
                    Z = repmat(diag(T*E'),1,n)-2*T;
                    
                    last = clusters;
                    [val, clusters] = min(Z,[],1);
                    nbIterations=nbIterations+1;
                end
        end    
        crit = energy(S, clusters);
        if crit>maxCrit
           maxCrit = crit;
           maxClustering = clusters;
        end
    end
    cm = clusteringMetrics(maxClustering, data.class);
    obs.nmi(k) = cm.nmi;
end


