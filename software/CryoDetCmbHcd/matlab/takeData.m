% check if we're in single channel mode; if we are get the channel
%single = lcaGet([chanPVprefix, 'frequencyError']);
%fileName='Ch64_250HzFR_swh_20171222.dat',takeDebugData(rootPath, fileName, 2^25);

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

% add .dat suffix
configfile=fullfile(datadir,[filename '.mat']);
filename=fullfile(datadir,[filename '.dat']);
disp(['filename=' filename]);
disp(['configfile=' configfile]);

writeRunFile(rootPath,configfile);

% take data!
takeDebugData(rootPath,filename,2^25);
