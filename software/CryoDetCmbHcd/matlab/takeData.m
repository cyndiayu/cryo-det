% check if we're in single channel mode; if we are get the channel
%single = lcaGet([chanPVprefix, 'frequencyError']);
%fileName='Ch64_250HzFR_swh_20171222.dat',takeDebugData(rootPath, fileName, 2^25);

% are we in single channel readout mode, and if so, on what channel?
singleChannelReadoutOpt2 = lcaGet([rootPath 'singleChannelReadoutOpt2']);
readoutChannelSelect = lcaGet([rootPath 'readoutChannelSelect']);

ctime=ctimeForFile();
filename=num2str(ctime);

% add channel suffix for single channel data
if singleChannelReadoutOpt2==1
    filename=[filename '_Ch' num2str(readoutChannelSelect)]
end

% add .dat suffix
datadir=dataDirFromCtime(ctime);
configfile=fullfile(datadir,[filename '.mat']);
filename=fullfile(datadir,[filename '.dat']);
disp(['filename=' filename]);
disp(['configfile=' configfile]);

writeRunFile(rootPath,configfile);

% take data!
takeDebugData(rootPath,filename,2^25);
