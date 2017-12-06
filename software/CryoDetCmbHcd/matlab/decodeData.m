
function [F, dF, fluxRampStrobe] = decodeData(file)

rawData = squeeze(processData(file));
%revised processData will not need buffsize parameter, or squeeze function

%decode strobes
strobes = floor(rawData/2^30);
data = rawData - 2^30*strobes;
ch0Strobe = mod(strobes, 2) ==1;
fluxRampStrobe = floor(strobes/2);

%decode frequencies
ch0idx = find(ch0Strobe(:,1) == 1);
Ffirst = ch0idx(1)
Flast = ch0idx(length(ch0idx))-1
freqs = data(Ffirst:Flast,1);
neg = find(freqs >= 2^23);
if ~isempty(neg)
    freqs(neg) = freqs(neg)-2^24;
end
freqs = reshape(freqs,512,[]) * 19.2/2^24;
F = freqs';

%decode frequency errors 
% UNTESTED until fixed data stream tested
ch0idx = find(ch0Strobe(:,2) == 1);
if ~isempty(ch0idx)
    Dfirst = ch0idx(1)
    Dlast = ch0idx(length(ch0idx))-1
    df = data(Dfirst:Dlast,2);
    neg = find(df >= 2^23);
    if ~isempty(neg)
        df(neg) = df(neg)-2^24;
    end
    df = reshape(df,512,[]) * 19.2/2^24;
    dF = df';
else
    dF = []
end
