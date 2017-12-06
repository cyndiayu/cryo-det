% takeDebugData( rootPath, fileName )
%    rootPath       - sysgen root path
%    dataLength     - data length
%
%
% takeDebugData( rootPath, fileName, dataLength )
%    rootPath       - sysgen root path
%    dataLength     - data length
%    fileName       - file name to save data


function takeDebugData( rootPath, fileName, varargin )
    global DMBufferSizePV
     
    if ( isempty(varargin) )
        dataLength = 2^19;
    else
        dataLength = varargin{1};     
    end


    C = strsplit(rootPath, ':');
    root = C{1};
    
    C1 = strsplit(fileName, '/');
    if length(C1) == 1
        currentFolder = pwd;
        fullPath = [currentFolder, '/', fileName];
    else
        fullPath = fileName;
    end
    
    daqMuxChannel0 = 22; % +22 to set debug stream
    daqMuxChannel1 = 23;
    setBufferSize(dataLength)
    
    lcaPut([root,':AMCc:FpgaTopLevel:AppTop:DaqMuxV2[0]:InputMuxSel[0]'],daqMuxChannel0)
    lcaPut([root,':AMCc:FpgaTopLevel:AppTop:DaqMuxV2[0]:InputMuxSel[1]'],daqMuxChannel1)
    
    disp('Data acquisiton in progress...')
    
    % open file relative current directory?    
    
%     delete '/tmp/test.dat'
    
    disp('Setting file name...')
%     lcaPut([root, ':AMCc:streamDataWriter:dataFile'], double('/tmp/test.dat'))
    lcaPut([root, ':AMCc:streamDataWriter:dataFile'], double(fullPath))

    disp(['Opening file...',fullPath])
    lcaPut([root, ':AMCc:streamDataWriter:open'], 'True')

    %triggerDM
    disp(['Taking data...'])
    lcaPut([root, ':AMCc:FpgaTopLevel:AppTop:AppCore:CmdDacSigTrigArm'],1);
    

    % how long to pause?
    
    pause(10)
    % should we monitor buffer status instead?
%     lcaGet([root,':AMCc:FpgaTopLevel:AmcCarrierCore:AmcCarrierBsa:BsaWaveformEngine[0]:WaveformEngineBuffers:Empty[0]'])
%     lcaGet([root,':AMCc:FpgaTopLevel:AmcCarrierCore:AmcCarrierBsa:BsaWaveformEngine[0]:WaveformEngineBuffers:Empty[1]'])
%     lcaGet([root,':AMCc:FpgaTopLevel:AmcCarrierCore:AmcCarrierBsa:BsaWaveformEngine[0]:WaveformEngineBuffers:Empty[2]'])
%     lcaGet([root,':AMCc:FpgaTopLevel:AmcCarrierCore:AmcCarrierBsa:BsaWaveformEngine[0]:WaveformEngineBuffers:Empty[3]'])
    
    disp('Closing file...')
    lcaPut([root, ':AMCc:streamDataWriter:open'], 'False')
    
%     movefile '/tmp/test.dat' fullPath

    disp('Done taking data')