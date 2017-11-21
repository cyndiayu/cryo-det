function resp = amplSweep(band, freqs, Nread, dwell)
% Sweep frequency, plot amplitude and phase
% band selects one of 32 sub bands (only 0:7 presently allowed)
% freqs is a vector of frequencies in the range -19.2 MHz to + 19.2 MHz
% in units of fractions of 19.2 MHz
% resp is complex response demodulated response
% Nread (optional) number of reads of response per frequency setting
% dwell (optional) dwell time between setting and read and between reads
% Example:
%   Response  = ampleSweep(7, (-9.6:.1:9.6)*1e6) sweeps from -9.6 MHz to
%   +9.6 MHz in steps of 100kHz
% SS 20Nov2017

rootPath = 'mitch_epics:AMCc:FpgaTopLevel:AppTop:AppCore:SysgenCryo:Base[0]:';

if nargin <3 
    Nread = 4; % default number of reads per frequnecy setting
end; 

if nargin <4 
    dwell = 0.001; %dwell time default is 1 ms
end; 

resp = zeros(1, Nread*length(freqs)); %allocate response vector

% up to 16 tones are summed/sub-band
% toneScale selects the scaling after summing 16 channels - global setting
%   0 is scaled by 1/8
%   1 is scaled by 1/4
%   2 is scaled by 1/2
%   3 is scaled by 1    (used for outputting single tone/sub-band)
lcaPut( [rootPath, 'toneScale'], 3 )  % full amplitude in a single tone

% global feedback enable
lcaPut( [rootPath, 'feedbackEnable'], 0 ) %Disable FB

% choose drive amplitude
Adrive = 12; % -6 dB

%Qualify inputs
if band <0 | band > 7 
    display('band out of range (for now  0 <= band <= 7')
    break
end

if min(f)<-19.2e6 | max(freqs)>19.2e6
    display('frequencies must be in range +-19.2MHz')
    break
end

subchan = 16*band; % use channel 0 of this band

lcaPut( [rootPath, 'rfEnable'], 1 ) %enable RF

%loop over frequencies
for j=1:length(freqs)
    freqBits = round(2^24*freqs(j)/38.4e6));    %CHECK SCALING!!!

    % configCryoChannel( rootPath, subchan, frequency_mhz, amplitude, feedbackEnable, etaPhase, etaMag )
    configCryoChannel( rootPath, subchan, freqBits, Adrive, 0, 0, 0 )
    for nr = 1:Nread
        %read I & Q, save response as complex vector
        pause(dwell);
        configCryoChannel( rootPath, subchan, freqBits, Adrive, 0, 0, 0 ); %write again to trigger status register update
        resp((j-1)*Nread + nr) = (lcaGet( [pvRoot, 'I']) + 1i*lcaGet( [pvRoot, 'Q'])) / 2^15; %CHECK SCALING!!!
        % are I&Q synchronous?        
        f((j-1)*Nread + nr) = freqs(j); 
    end
end


% if we should want to check dF:
% [loopFilterOutput, frequencyError] = readbackCryoChannel( rootPath, channelNum )
%[a, b] = readbackCryoChannel( rootPath, 0 )
