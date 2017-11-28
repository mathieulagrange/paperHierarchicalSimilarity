function [config, store, obs] = taun5timings(config, setting, data)
% taun5timings TIMINGS step of the expLanes experiment unsupervised
%    [config, store, obs] = taun5timings(config, setting, data)
%      - config : expLanes configuration state
%      - setting   : set of factors to be evaluated
%      - data   : processing data stored during the previous step
%      -- store  : processing data to be saved for the other steps
%      -- obs    : observations to be saved for analysis

% Copyright: Mathieu Lagrange
% Date: 09-Nov-2017

% Set behavior for debug mode
if nargin==0, unsupervised('do', 5, 'mask', {2, 0, 0, [3  4]}); return; else store=[]; obs=[]; end

for k=1:3
    data = expLoad(config, [], k, 'obs');
    obs.(config.stepName{k}) = data.time;
end
data = expLoad(config, [], 4, 'obs');
obs.ap = [data(:).p];