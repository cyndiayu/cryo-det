function [eta, F0, latency, resp, f] = etaEstimator(band, freqs)
%sweep frequencies in a band,
% aquire complex repsonse vs frequency at dF block where eta is used
% fit to dF/dS21 to estimate eta
%must scan twice, once to get real part, once to get imag part

%SSmith 22 Nov 2017

Nread = 5       %normally run with Nread>=4
dwell = 0.010
delF = 0.5

eta = 0;
F0 = 0; 
latency = 0;

[resp, f] = etaScan(band, freqs, Nread, dwell);

figure(1); plot(f, abs(resp), '.');grid
title(['Amplitude Response for Band ' num2str(band)])
xlabel('Frequency (MHz)')
ylabel('Response (arbs)')
ax=axis; xt=ax(1)+0.1*(ax(2)-ax(1)); yt=ax(3) + 0.1*(ax(4)-ax(3));
text(xt,yt,['Band Center = ', num2str(band*38.4), ' MHz'])

netPhase = unwrap(angle(resp));
figure(2); plot(f, netPhase, '.');grid
title(['Phase Response for Band ' num2str(band)])
xlabel('Frequency (MHz)')
ylabel('Phase')
Nf = length(f);
latency = (netPhase(Nf)-netPhase(1))/(f(Nf)-f(1))/2/pi

%complex Response Plot
figure(4)
plot(resp, '.');grid, hold on
a = abs(resp); idx = find(a==min(a),1), plot(resp(idx),'*r')
F0 = f(idx) %center frequency in MHz
left = find(f>F0-delF,1); f(left)
right = find(f>F0+delF,1); f(right)
plot(resp(left), 'gx')
plot(resp(right), 'g+')
title(['Complex Response for Band ' num2str(band)])
axis equal
hold off

%estimate eta
eta = (f(right)-f(left))/(resp(right)-resp(left))
etaMag = abs(eta)
etaPhase = angle(eta)
etaPhaseDeg = angle(eta)*180/pi
etaScaled = etaMag/38.4

figure(5), grid
plot(resp*eta, '.'),grid, hold on
plot(eta*resp(idx),'r*')
plot(eta*resp(right), 'g+')
plot(eta*resp(left), 'gx')
hold off
end                      % end of function etaEstimator


%_________________________________________________________________________
% subfunction etaScan

function [resp, f] = etaScan(band, freqs, Nread, dwell)
% Sweep frequency, plot complex response ast inpur to dF calculation
% band selects one of 32 sub bands (0:31  allowed)
% freqs is a vector of frequencies in the range -19.2 (MHz) to + 19.2 (MHz)


% resp is complex response demodulated response
% Nread (optional) number of reads of response per frequency setting
% dwell (optional) dwell time between setting and read and between reads
% Example:
%   Response  = etaScan(7, (-9.6:.1:9.6)*1e6) sweeps from -9.6 MHz to
%   +9.6 MHz in steps of 100kHz
% SS 20Nov2017

rootPath = 'mitch_epics:AMCc:FpgaTopLevel:AppTop:AppCore:SysgenCryo:Base[0]:';

if nargin <3 
    Nread = 4; % default number of reads per frequnecy setting
end; 

if nargin <4 
    dwell = 0.001; %dwell time default is 1 ms
end; 


respI = zeros(1, Nread*length(freqs)); %allocate response vector
respQ = respI;

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
%Adrive = 15; %  full scale

%Qualify inputs
if band <0 | band > 31 
    display('band out of range ( 0 <= band <= 31')
    return
end

if min(freqs) < -19.2  |  max(freqs) > 19.2
    display('frequencies must be in range +-19.2 MHz')
    return
end

subchan = 16*band; % use channel 0 of this band

lcaPut( [rootPath, 'rfEnable'], 1 ) %enable RF
lcaPut( [rootPath, 'statusChannelSelect'], subchan)   %set monitor channel to this channel
chanPVprefix = [rootPath, 'CryoChannels:CryoChannel[', num2str(subchan), ']:']
  %      dfword = lcaGet( [rootPath, 'CryoChannels:CryoChannel[0]:', 'frequencyError'])/2^24*38.4 ;


%loop over frequencies
% first for real part
etaMag =1;
etaPhase = 0;

for j=1:length(freqs)
    % configCryoChannel( rootPath, subchan, frequency_mhz, amplitude, feedbackEnable, etaPhase, etaMag )
    configCryoChannel( rootPath, subchan, freqs(j), Adrive, 0, etaPhase, etaMag )

    pause(dwell);
    for nr = 1:Nread
        %read dF, save response as complex vector

 %       configCryoChannel( rootPath, subchan, freqs(j), Adrive, 0, etaPhase, etaMag ); %write again to trigger status register update
      pause(0.001);

        dFword = lcaGet([chanPVprefix, 'frequencyError']); %get real part
        if dFword>2^23
            dFword = dFword-2^24;   %treat as signed 24 bit
        end
        respI((j-1)*Nread + nr) = dFword; %get real part

        f((j-1)*Nread + nr) = freqs(j); 
    end
end

etaPhase = -90;     % should this be +90? +270?
for j=1:length(freqs)
    % configCryoChannel( rootPath, subchan, frequency_mhz, amplitude, feedbackEnable, etaPhase, etaMag )
    configCryoChannel( rootPath, subchan, freqs(j), Adrive, 0, etaPhase, etaMag )
    pause(dwell);
    
    for nr = 1:Nread
        pause(0.001);
        dFword = lcaGet([chanPVprefix, 'frequencyError']); %get real part
        if dFword>2^23
            dFword = dFword-2^24;   %treat as signed 24 bit
        end
        respQ((j-1)*Nread + nr) = dFword; %get imaginary part
    end
end

resp = respI + 1i*respQ;    %form complex response

Adrive = 3; %turn down to low amplitude
configCryoChannel( rootPath, subchan, freqs(j), Adrive, 0, 0, 0 ) ;
end
