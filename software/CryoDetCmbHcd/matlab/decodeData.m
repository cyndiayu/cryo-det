
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
F = double(freqs);
if ~isempty(neg)
    F(neg) = F(neg)-2^24;
end
F = reshape(F,512,[]) * 19.2/2^24;
F = F';

%decode frequency errors 
% UNTESTED until fixed data stream tested
ch0idx = find(ch0Strobe(:,2) == 1);
if ~isempty(ch0idx)
    Dfirst = ch0idx(1)
    Dlast = ch0idx(length(ch0idx))-1
    df = data(Dfirst:Dlast,2);
    neg = find(df >= 2^23);
    dF = double(df);
    if ~isempty(neg)
        dF(neg) = dF(neg)-2^24;
    end
    dF = reshape(dF,512,[]) * 19.2/2^24;
    dF = dF';
else
    dF = []
end
