% takeDebugData( rootPath, fileName )
%    rootPath       - sysgen root path
%    fileName       - file name to save data
%
%
% takeDebugData( rootPath, fileName, dataLength )
%    rootPath       - sysgen root path
%    fileName       - file name to save data
%    dataLength     - data length
%
% takeDebugData( rootPath, fileName, dataLength, type )
%    rootPath       - sysgen root path
%    fileName       - file name to save data
%    dataLength     - data length
%    type           - type of data to take 'debug' 'adc' or 'dac'
%
% takeDebugData( rootPath, fileName, dataLength, type )
%    rootPath       - sysgen root path
%    fileName       - file name to save data
%    dataLength     - data length
%    type           - type of data to take 'debug' 'adc' or 'dac'
%    channel        - adc/dac channel argument


function takeDebugData( rootPath, fileName, varargin )
    global DMBufferSizePV
    
    numvarargs = length( varargin );
    optargs = {2^19, 'debug', 0};

    for i = 1:numvarargs
        if ~isempty( varargin{i} )
            optargs{i} = varargin{i};
        end
    end

    [dataLength, type, channel] = optargs{:};

    C = strsplit(rootPath, ':');
    root = C{1};
    
    C1 = strsplit(fileName, '/');
    if length(C1) == 1
        currentFolder = pwd;
        fullPath = [currentFolder, '/', fileName];
    else
        fullPath = fileName;
    end

    switch type
        case 'adc'
            daqMuxChannel0 = (channel+1)*2;
            daqMuxChannel1 = daqMuxChannel0 + 1;
        case 'dac'
            daqMuxChannel0 = (channel+1)*2 + 10;
            daqMuxChannel1 = daqMuxChannel0 + 1;
        otherwise % catch debug and errors
            daqMuxChannel0 = 22; % +22 to set debug stream
            daqMuxChannel1 = 23;
    end   
    daqMuxChannel0 
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
    
%   Here we do a brief pause then monitor waveform engine done status
    done = 0;
    pause(1)
    while done == 0
        done = 1;
        for j = 0:3
            empty = lcaGet([root,':AMCc:FpgaTopLevel:AmcCarrierCore:AmcCarrierBsa:BsaWaveformEngine[0]:WaveformEngineBuffers:Empty[', num2str(j), ']']);
            if empty == 0
                done = 0;
            end   
        end
       pause(1) 
       % TODO add percent complete for large datasets..
       fprintf('%s','%');
    end
    disp(' ') % newline


    disp('Closing file...')
    lcaPut([root, ':AMCc:streamDataWriter:open'], 'False')
    
%     movefile '/tmp/test.dat' fullPath

    disp('Done taking data')
