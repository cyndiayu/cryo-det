% script to find the eta parameters and setup 32 frequencies
function chan = setupNotches_umux16_singletone(rootPath,Adrive,resonators)

    if nargin < 1
        rootPath='mitch_epics:AMCc:FpgaTopLevel:AppTop:AppCore:SysgenCryo:Base[0]:'; 
    end

    if nargin < 2
        Adrive=10; % roughly -33dBm at connector on SMuRF card output
    end

    if nargin < 3
        % no TES
        resonators=[5395.7396];

        % TES
        %resonators=[5310.60];
        
    end
    
    Off

    %
    % if flux ramp is on, turn it off for the sweep
    %rtmSpiRootPath = 'mitch_epics:AMCc:FpgaTopLevel:AppTop:AppCore:RtmCryoDet:C_RtmSpiSr:';
    % read current state
    %preFRState = lcaGet( [rtmSpiRootPath, 'Cfg_Reg_Ena Bit'] );
    fluxRampOnOff(0);
    pause(0.5);
    %if preFRState == 1
    %	% flux ramp was on when we started the sweep.  Wait a little bit to
    %	% make sure things have settled before doing sweep.
    %    pause(5);
    %end
    %

    band0 = 5.25e3;
    bandchans = zeros(32,1);
    
    for ii =1:length(resonators)
        res = resonators(ii);
        display(' ')
        display('_________________________________________________')
        display(['Calibrate line at RF = ' num2str(res) ' MHz  IF = ' num2str(res - 5250 + 750) ' Mhz'])
        [band, Foff] = f2band(res)    ;
        disp(['band=',num2str(band)]);
        Foff
    
        % track the number of channels in the band
        bandchans(band+1) =bandchans(band+1)+1;
        chan(ii) = 16*band + bandchans(band+1) -1;
        offset(ii) = Foff;

        try
            figure(ii)
            [eta, F0, latency, resp, f] = etaEstimator(band, [(offset(ii) - .3):0.01:(offset(ii) + 0.3)],Adrive);
            hold on; subplot(2,2,4);
            ax = axis; xt = ax(1) + 0.1*(ax(2)-ax(1)); 
            yt = ax(4) - 0.1*(ax(4)-ax(3));
            text(xt, yt, ['Line @ ', num2str(res), ' MHz    (' num2str(res - 5250) ' wrt band center'])
            hold off;
            etaPhaseDeg(ii) = angle(eta)*180/pi;
            etaScaled(ii) =abs(eta)/19.2;
        catch e
            display(['ERROR: ', e.message])
            display(['Failed to calibrate line number ' num2str(ii)])
            etaPhaseDeg(ii) =0;
            etaScaled(ii)=0;
        end
    
    end

    for ii=1:length(resonators)
        configCryoChannel(rootPath, chan(ii), offset(ii), Adrive, 1, etaPhaseDeg(ii), etaScaled(ii));
    end
end
    