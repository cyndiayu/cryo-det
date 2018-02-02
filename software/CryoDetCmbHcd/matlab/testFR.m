function testFR( rootPath )

    if nargin < 1
        rootPath='mitch_epics:AMCc:FpgaTopLevel:AppTop:AppCore:SysgenCryo:Base[0]:'; 
    end

    legendInfo={};
    counter=1;
    f=[];
    df=[]
    sync=[];
    v=[]
% MD - setup flux ramp before starting
    fluxRampSetup
    
    for Adrive=[10 10 10 10 10 10]
        try
% MD - turn flux ramp off before setupNotches 
            fluxRampOnOff(0)
            % tune
            %chan = setupNotches_umux16_singletone(rootPath,Adrive);
            chan=272;
% MD - this seems to expect single channel readout mode
            lcaPut([rootPath,'readoutChannelSelect'], chan(1));
            lcaPut([rootPath,'singleChannelReadoutOpt2'], 1);
            % turn flux ramp on
            fluxRampOnOff(1)
            
            % get frame
            [frameFreq,frameFreqError,frameStrobe] = getFrame( rootPath );
        
            % plot frame
            figure(101);
            plot(frameFreq); hold on;
            legendInfo{counter} = ['Adrive = ' num2str(Adrive)];

 % MD - also show frame frequency error - looks to be on a similar scale to frameFreq?           
            figure(102);
            plot(frameFreqError); hold on;
            legendInfo{counter} = ['Adrive = ' num2str(Adrive)];
            counter=counter+1;
        
            f=horzcat(f,frameFreq);
            df=horzcat(df,frameFreqError);
            sync=horzcat(sync,frameStrobe);
            v=horzcat(v,Adrive);
            %pause;
        catch e
            disp( e.identifier )
            disp(['ERROR: ', e.message])
            error(['ERROR! Failed to get good data for : Adrive = ',num2str(Adrive)]);
        end
    end
    figure(101);
    legend(legendInfo);
    figure(102);
    legend(legendInfo);
    % save data
    %% this is redundant, need to make a function
    % are we in single channel readout mode, and if so, on what channel?
    singleChannelReadoutOpt2 = lcaGet([rootPath 'singleChannelReadoutOpt2']);
    readoutChannelSelect = lcaGet([rootPath 'readoutChannelSelect']);

    % keep data organized by date
    datapath='/data/cpu-b000-hp01/cryo_data/data2/';
    now=datetime('now')
    dirdate=datestr(now,'yyyymmdd');
    datadir=fullfile(datapath,dirdate);

    % if today's date directory doesn't exist yet, make it
    if not(exist(datadir))
        disp(['-> creating ' datadir]);
        mkdir(datadir);
    end

    filename=num2str(round(posixtime(now)));
    disp(filename);

    % add channel suffix for single channel data
    if singleChannelReadoutOpt2==1
        filename=[filename '_Ch' num2str(readoutChannelSelect)]
    end

    % add .mat suffix
    filename=fullfile(datadir,[filename '_FvPhi.mat']);
    disp(['filename=' filename]);

    %%
    %save(filename,'v','f','df','sync');
end

function [frameFreq,frameFreqError,frameStrobe] = getFrame( rootPath )

    global DMBufferSizePV

    C = strsplit(rootPath, ':');
    root = C{1};

    % close all
    flux_ramp_rate=1e3; % Hz
    
    % why is sample rate 1.2e6, not 2.4e6?
    tsamp=1/1.2e6; %current sample rate
    fs=1/tsamp;
    
    % multiply by 8 to make sure we get the full flux ramp
    data_length=8*ceil(fs/flux_ramp_rate);

    time=tsamp*(0:1:data_length-1);

    daqMuxChannel0 = 22; % +22 to set debug stream
    daqMuxChannel1 = 23;
    setBufferSize(data_length)
    
    lcaPut([root,':AMCc:FpgaTopLevel:AppTop:DaqMuxV2[0]:InputMuxSel[0]'],daqMuxChannel0)
    lcaPut([root,':AMCc:FpgaTopLevel:AppTop:DaqMuxV2[0]:InputMuxSel[1]'],daqMuxChannel1)

    %triggerDM
    lcaPut([root, ':AMCc:FpgaTopLevel:AppTop:AppCore:CmdDacSigTrigArm'],1);
    pause(1)
    
    streamSize = lcaGet(DMBufferSizePV);
    
    freqWord = lcaGet('mitch_epics:AMCc:Stream0', streamSize);
    freqErrorWord = lcaGet('mitch_epics:AMCc:Stream1', streamSize);
    
    % data is even, strobe is odd, apparently.  
    freq=freqWord(1:2:end);
    freqStrobe=freqWord(2:2:end);

%%%    freq1 = typecast(int32(freqWord),'uint32'); 
%%%    freq = freq1(1:2:end) + freq1(2:2:end)*2^16;
%%%    strobes = floor(freq/2^30);
%%%    freq = freq - strobes*2^30;
%%%    fluxRampStrobe = floor(strobes./2);
    

    neg = find(freq >= 2^23);
    freq = double(freq);
    if ~isempty(neg)
         freq(neg) = freq(neg)-2^24;
    end

     freq = freq * 19.2/2^23;

    freqError=freqErrorWord(1:2:end);
    freqErrorStrobe=freqErrorWord(2:2:end);
    

%%%    freqError= typecast(int32(freqErrorWord(1:2:end) + freqErrorWord(2:2:end)*2^16), 'uint32');
%%%    freqErrorStrobe = floor(freqError./2^30);
%%%    freqError = freqError - 2^30*freqErrorStrobe;
    
    neg = find(freqError >= 2^23);
    freqError = double(freqError);
    if ~isempty(neg)
         freqError(neg) = freqError(neg)-2^24;
    end

     freqError = freqError * 19.2/2^23;

    %decode strobes from freq stream
    strobes = floor(freqStrobe/2^30);
    fluxRampStrobe = -floor(strobes/2); % not sure why this has to be negative

    resets = find(fluxRampStrobe >= 0.5);

    % if there aren't 2 resets or more, need longer datasets for each ramp.
    if length(resets)<2
        error(['ERROR! Not enough flux ramp resets found in acquisition : length(resets) = ',num2str(length(resets))]);
    end

    % incorporates strobe at beginning of this flux ramp
    frameStart=resets(1);
    frameEnd=resets(2)-1;
    frameFreq=freq(frameStart:frameEnd);
    frameFreqError=freqError(frameStart:frameEnd);
    frameStrobe=fluxRampStrobe(frameStart:frameEnd);
    
end
