function config = taunReport(config)
% taunReport REPORTING of the expLanes experiment talspStruct2016_unsupervised
%    config = taunInitReport(config)
%       config : expLanes configuration state

% Copyright: gregoirelafay
% Date: 17-Dec-2016

if nargin==0, unsupervised('report', 'rcv'); return; end

features = {'mfcc','scatT'};
scat_log = {'','log'};
integration = {'early','clustering'};
similarity_dist = {'emd','average','closest'};
db=2;
features = {'mfcc'};

% config = expExpose(config, 'p', 'mask', {4 1 2 [1 4] 0 25 3 0 1}, 'obs', 'p', 'expand', 'precision', 'percent', 1);
  config = expExpose(config, 'p', 'mask', {{5, 1, 2, [1  4], 0, 25, 3, 0, 1}}, 'expand', 'precision', 'obs', 'p', 'percent', 0);


return

for k=[1 3]

config = expExpose(config, 'p', 'mask', {k 1 2 [1 3 4] 0 25 3 0 1}, 'obs', 'p', 'expand', 'precision', 'percent', 1);
% config = expExpose(config, 't', 'mask', {1 1 2 [1 3 4] 5 25  3 0 1}, 'integrate', 'precision', 'obs', 'p', 'percent', 1, 'uncertainty', -1);
config = expExpose(config, 't', 'mask', {k 1 2 [1 3 4] 0 25  3 0 1}, 'integrate', 'precision', 'obs', [5 2], 'percent', 0, 'uncertainty', -1);
%        config = expExpose(config, 't', 'mask', {[1] 1 2 [3] 4 15  3}, 'obs', [5 2], 'integrate', 'precision', 'percent', 1, 'uncertainty', -1);
% config = expExpose(config, 't', 'mask', {1 1 2 [1 2 3 4] 0 25 3 5}, 'obs', 1, 'percent', 1);
end
% 2016
%     config = expExpose(config, 't', 'mask', {2 1 2 [ 3 4] 5 0 3 7}, 'obs', 'pf', 'precision', 4, 'percent', 1);
%  config = expExpose(config, 'p', 'mask', {2 1 2 [1 2 3] 1 0 3}, 'expand', 'precision', 'obs', 2);
% config = expExpose(config, 'p', 'mask', {2 1 2 [1 2 3] 1 3 3}, 'expand', 'precision', 'obs', 3);

% 2016all
%     config = expExpose(config, 't', 'mask', {3 1 2 [1 2 3:4] 0 25 3 7}, 'obs', 'p', 'precision', 4, 'percent', 1);

%   config = expExpose(config, 'p', 'mask', {3 1 2 [1 3:4] 0 25 3 0 1}, 'expand', 'precision', 'obs', 'p', 'percent', 0);
%   config = expExpose(config, 't', 'mask', {3 1 2 [4] 0 25 3 0 0}, 'integrate', 'precision', 'obs', [5 2], 'percent', 0, 'uncertainty', -1);


% config = expExpose(config, 'p', 'mask', {3 1 0 0 1 1}, 'expand', 'precision', 'obs', 3);


return

%config = expExpose(config, 't','fontSize','scriptsize','step', 5, 'mask',{db});
%return

for a=1:length(features)
    for c=1:length(integration)   
        switch integration{c} 
            case 'early'
                switch features{a}
                    case 'mfcc'
                        config = expExpose(config, 't','fontSize','scriptsize','step', 5, 'mask',{db a 0 c 0 [1 2 3] 0},'obs',[1 2 3 4 5 6 7 8 9],'precision', 2,'save',1,'name', ...
                            ['unsupervised_test_' features{a} '_' integration{c}]);
                    case 'scatT'
                        for b=1:length(scat_log)
                            config = expExpose(config, 't','fontSize','scriptsize','step', 5, 'mask',{db a b c 0 [1 2 3] 0},'obs',[1 2 3 4 5 6 7 8 9],'precision', 2,'save',1,'name', ...
                                ['unsupervised_test_' scat_log{b} features{a} '_' integration{c}]);
                        end
                end  
            case 'clustering'
                for d=1:length(similarity_dist)
                    switch features{a}
                        case 'mfcc'
                            config = expExpose(config, 't','fontSize','scriptsize','step', 5, 'mask',{db a 0 c 0 [1 2 3] d},'obs',[1 2 3 4 5 6 7 8 9],'precision', 2,'save',1,'name', ...
                                ['unsupervised_test_' features{a} '_' integration{c} '_' similarity_dist{d}]);
                        case 'scatT'
                            for b=1:length(scat_log)
                                config = expExpose(config, 't','fontSize','scriptsize','step', 5, 'mask',{db a b c 0 [1 2 3] d},'obs',[1 2 3 4 5 6 7 8 9],'precision', 2,'save',1,'name', ...
                                    ['unsupervised_test_' scat_log{b} features{a} '_' integration{c} '_' similarity_dist{d}]);
                            end
                    end  
                end
        end
    end
end


