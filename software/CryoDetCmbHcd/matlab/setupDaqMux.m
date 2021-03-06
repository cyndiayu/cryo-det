% setupDaqMux( rootPath, type )
%    rootPath       - sysgen root path
%    type           - type of data to take 'debug' 'adc' or 'dac'
%
% setupDaqMux( rootPath, type, channel )
%    rootPath       - sysgen root path
%    type           - type of data to take 'debug' 'adc' or 'dac'
%    channel        - adc/dac channel argument
%
% setupDaqMux( rootPath, type, channel, dataLength )
%    rootPath       - sysgen root path
%    type           - type of data to take 'debug' 'adc' or 'dac'
%    channel        - adc/dac channel argument
%    dataLength     - dataLength

function setupDaqMux( rootPath, type, varargin )
    global DMBufferSizePV
    
    numvarargs = length( varargin );
    optargs = {0, 2^19};

    for i = 1:numvarargs
        if ~isempty( varargin{i} )
            optargs{i} = varargin{i};
        end
    end

    [channel, dataLength] = optargs{:};

    C = strsplit(rootPath, ':');
    root = C{1};

    dataType = 'signed 16-bit';
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
            dataType = 'unsigned 32-bit';
    end   

    setBufferSize(dataLength)
    
    lcaPut([root,':AMCc:FpgaTopLevel:AppTop:DaqMuxV2[0]:InputMuxSel[0]'], daqMuxChannel0)
    lcaPut([root,':AMCc:FpgaTopLevel:AppTop:DaqMuxV2[0]:InputMuxSel[1]'], daqMuxChannel1)
    lcaPut([root,':AMCc:StreamDataFormat0'], dataType)
    lcaPut([root,':AMCc:StreamDataFormat1'], dataType)

end
