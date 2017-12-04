% [data] = readbackCryoChannel( rootPath, adcNumber )
%    rootPath       - sysgen root path
%    adcNumber      - DAC number 0...3
%
% [data] = readbackCryoChannel( rootPath, adcNumber, dataLength )
%    rootPath       - sysgen root path
%    adcNumber      - DAC number 0...3
%    dataLength     - length of acqusition

function [data] = readDacData( rootPath, dacNumber, varargin )
    global DMBufferSizePV
    
    if ( isempty(varargin) )
        dataLength = 2^19;
    else
        dataLength = varargin{1};     
    end


    C = strsplit(rootPath, ':');
    root = C{1};
    
    daqMuxChannel0 = (dacNumber+1)*2 + 10;
    daqMuxChannel1 = daqMuxChannel0 + 1;
    setBufferSize(dataLength)
    
    lcaPut([root,':AMCc:FpgaTopLevel:AppTop:DaqMuxV2[0]:InputMuxSel[0]'],daqMuxChannel0)
    lcaPut([root,':AMCc:FpgaTopLevel:AppTop:DaqMuxV2[0]:InputMuxSel[1]'],daqMuxChannel1)
    %triggerDM
    lcaPut([root, ':AMCc:FpgaTopLevel:AppTop:AppCore:CmdDacSigTrigArm'],1);
    pause(1)

    streamSize = lcaGet(DMBufferSizePV);
    
    Qdata=lcaGet('mitch_epics:AMCc:Stream0', streamSize);
    Idata=lcaGet('mitch_epics:AMCc:Stream1', streamSize);
    
    data = Idata + j.*Qdata;
