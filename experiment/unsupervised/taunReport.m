function config = taunReport(config)
% taunReport REPORTING of the expLanes experiment talspStruct2016_unsupervised
%    config = taunInitReport(config)
%       config : expLanes configuration state

% Copyright: gregoirelafay
% Date: 17-Dec-2016

if nargin==0, unsupervised('report', 'r', 'reportName', 'scat'); return; end

switch config.reportName
    case 'scat'
        m=2;
        for k=1:3
            if k==3, m=1; end
            config = expExpose(config, 't', 'mask', {k 0 0 m 1 2 0 1}, 'step', 5, 'obs', 1, 'percent', 1, 'sort', 1);
        end
    case 'group'
        m=2;
        for k=1:3
            if k==3, m=1; end
            config = expExpose(config, 't', 'mask', {k 1 0 m 1 2 0 1}, 'step', 6, 'obs', 1, 'percent', 1, 'sort', 1);
        end
    case 'paper'
        % baselines for every datasets
        % 2013
        config = expExpose(config, 'p', 'mask', {1 1 0 0 5 1}, 'step', 4, 'expand', 'precision', 'obs', 1, 'percent', 1);
        % 2016
        config = expExpose(config, 'p', 'mask', {2 1 0 2:3 5 1 0 1}, 'step', 4, 'expand', 'precision', 'obs', 1, 'percent', 1, 'marker', {'+', '+', 'o', 'o', 'd', 'd', 's'}, 'color', {'b', 'k','b', 'k', 'b', 'k', 'b', 'k'});
        % 2017
        config = expExpose(config, 'p', 'mask', {3 1 0 1:3 5 1 0 1}, 'step', 4, 'expand', 'precision', 'obs', 1, 'percent', 1, 'marker', {'+', '+', '+', 'o', 'o', 'o', 'd', 'd', 'd', 's'}, 'color', {'m', 'b', 'k', 'm', 'b', 'k', 'm', 'b', 'k', 'm', 'b', 'k'});
        % timings
        config = expExpose(config, 't', 'mask', {3 1 0 1 5 1 0 1}, 'step', 5, 'obs', [3 2 4], 'orderSetting', [3 2 1]);
    case 'toto'
        config = expExpose(config, 't', 'mask', {{2 1 2 2:4 1 2}, {2 0 2 2:4 5 1}}, 'integrate', 'texture', 'obs', 1, 'sort', 1, 'percent', 1);
    otherwise
        for k =1:4
            config = expExpose(config, 'l', 'mask', {2 0 0 k [1 3 5] [2 6] 5 1}, 'negativeRank', 4, 'sort', 3, 'obs', [1 2 4], 'percent', 1);
        end
        return
        %  config = expExpose(config, 't', 'mask', {}, 'step', 3);
        
        % return
        % config = expExpose(config, 'p', 'mask', {4 1 2 [1 4] 0 25 3 0 1}, 'obs', 'p', 'expand', 'precision', 'percent', 1);
        % for l=1:2
        
        config = expExpose(config, 't', 'mask', {{3 0 0 0 [1 3 5] [2 6] 5 1}}', 'obs', 'p', 'percent', 0, 'expand', 'texture');
        
        % end
        %   config = expExpose(config, 't', 'mask', {{2}}, 'integrate', 'precision', 'obs', 'p', 'percent', 0);
        
        %   config = expExpose(config, 't', 'mask', {{1 0 0 0 0 0 5}}, 'integrate', 'integration', 'obs', 'p', 'percent', 0);
        
        
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
        
        
end