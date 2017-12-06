% Process the data from pyrogue strema interfaces
% data is a multidimensiona matrix with the process data

function data = processData(file)

    % Number of stream channels
    numChannels = 2
    
    % Size of the header (8 bytes in 32-bit words)
    headerSize = 4;
    
    % Read input file
    fileID = fopen(file,'r');
    data = uint32(fread(fileID,'uint32','ieee-le'));
    fclose(fileID);
    
    data(1:headerSize) = [];
    l = length(data);
    data = reshape(data,[l/numChannels numChannels]);

end
