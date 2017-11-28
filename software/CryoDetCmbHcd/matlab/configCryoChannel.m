% configCryoChannel( rootPath, channelNum, frequency_mhz, amplitude, feedbackEnable, etaPhase, etaMag )
%    rootPath       - sysgen root path
%    channelNum     - cryo channel number (0...511)
%    frequency      - frequency within sub-band (MHz) (-19.2...19.2)
%    amplitude      - amplitdue 0...15  (15 full scale)
%    feedbackEnable - enable feedback
%    etaPhase       - feedback ETA phase (deg) (-180 180)
%    etaMag         - feedback ETA mag 
%


function configCryoChannel( rootPath, channelNum, frequency_mhz, amplitude, feedbackEnable, etaPhase, etaMag )
    pvRoot = [rootPath, 'CryoChannels:CryoChannel[', num2str(channelNum), ']:'];
    
    
    n_channels = 32;
    band = 614.4;
    sub_band = band./(n_channels/2); % oversample by 2
    
    % limit frequency to +/- sub-band/2
    if frequency_mhz > sub_band/2
        freq = sub_band/2;    
    elseif frequency_mhz < -sub_band/2config
        freq = -sub_band/2;
    else
        freq = frequency_mhz;
    end
    
    % frequency is written in unsiged number
    if freq < 0
        freq = freq + sub_band;
    end
    
    freq = floor((freq./sub_band)*2^24);
    lcaPut( [pvRoot, 'centerFrequency'], freq );
    
    % amp 0 - 15
    if amplitude > 15
        amp = 15;
    elseif amplitude < 0
        amp = 0;
    else
        amp = amplitude;
    end
    lcaPut( [pvRoot, 'amplitudeScale'], amp );
    
    
    lcaPut( [pvRoot, 'feedbackEnable'], feedbackEnable );
    
    % phase, wrap to +/- 180
    phase = etaPhase;
    while( phase > 180 )
        phase = phase - 360;
    end
    while( phase < -180 )
        phase = phase + 360;
    end

    phase = phase./180; % normalized -1 to 1
    
    lcaPut( [pvRoot, 'etaPhase'], floor(phase*2^15) );
    
    lcaPut( [pvRoot, 'etaMag'], floor(etaMag*2^10) );
