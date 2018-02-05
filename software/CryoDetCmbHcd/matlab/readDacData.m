% [data] = readDacData( rootPath, dacNumber )
%    rootPath       - sysgen root path
%    adcNumber      - DAC number 0...3
%
% [data] = readDacData( rootPath, dacNumber, dataLength )
%    rootPath       - sysgen root path
%    adcNumber      - DAC number 0...3
%    dataLength     - length of acquisition

function [data] = readDacData( rootPath, dacNumber, varargin )
    global DMBufferSizePV
    
    if ( isempty(varargin) )
        dataLength = 2^19;
    else
        dataLength = varargin{1};     
    end


    C = strsplit(rootPath, ':');
    root = C{1};
    
    setupDaqMux( rootPath, 'dac', dacNumber, dataLength );   

    %triggerDM
    lcaPut([root, ':AMCc:FpgaTopLevel:AppTop:AppCore:CmdDacSigTrigArm'],1);
    pause(1)

    streamSize = lcaGet(DMBufferSizePV);
    
    Qdata=lcaGet('mitch_epics:AMCc:Stream0', streamSize);
    Idata=lcaGet('mitch_epics:AMCc:Stream1', streamSize);
    
    data = Idata + j.*Qdata;
