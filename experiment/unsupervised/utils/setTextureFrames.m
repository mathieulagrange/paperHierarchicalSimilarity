function data = setTextureFrames(data, setting)

if strcmp(setting.dataset, '2016') && setting.texture==10
    ind = [];
    return;
end

if (strcmp(setting.dataset, '2016') && setting.texture==30) || (strcmp(setting.dataset, '2017') && setting.texture==10)
    ind = data.indSample;
    return;
end

switch setting.dataset
    case {'2016'}
        increment = setting.texture/30;
    case {'2017'}
        increment = setting.texture/10;
end

for k=1:length(data.xp_settings.recIndex)
    dec(k).recIndex = data.xp_settings.recIndex{k};
    dec(k).recStart = data.xp_settings.recStart(k);
    dec(k).recEnd = data.xp_settings.recEnd(k);
    dec(k).soundIndex = data.xp_settings.soundIndex(k);
end

ind = zeros(size(data.indSample));
index=1;
class = [];
while ~isempty(dec)
    % pick first from dec
    series = 1;
    seriesIndex = dec(1).soundIndex;
    % search successors
    for k=1:increment-1
        for m=1:length(dec)
            if strcmp(dec(series(end)).recIndex, dec(m).recIndex) && dec(series(end)).recEnd==dec(m).recStart
                series(end+1) = m;
                seriesIndex(end+1) = dec(m).soundIndex;
                break;
            end
        end
    end
    if length(series) == increment
        for k=1:length(series)
            ind(data.indSample==seriesIndex(k)) =  index;
        end
        class(end+1) = data.class(seriesIndex(1));
        index = index+1;
    end
    % remove them form dec
    dec(series) = [];
end
data.indSample=ind;
data.features(:, data.indSample==0) = [];
data.indSample(:, data.indSample==0) = [];
data.soundIndex = 1:length(unique(data.indSample));
data.class = class;


