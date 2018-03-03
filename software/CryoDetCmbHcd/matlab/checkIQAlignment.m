% 2.4e6 is downconverted channel rate
Band = 3;
Fadc = 614.4e6;
rootPath = 'mitch_epics:AMCc:FpgaTopLevel:AppTop:AppCore:SysgenCryo:Base[0]:';

%% What does DAC think it's putting out?
dacNumber = Band;
dacData = readDacData( rootPath, dacNumber );
figure
pwelch(dacData, [], [], [], Fadc, 'centered')
title('DAC data PSD')


%% check ADC
adcNumber = Band;
adcData = readAdcData( rootPath , adcNumber );
figure
pwelch(adcData, [], [], [], Fadc, 'centered')
title('ADC data PSD')

% save data
ctime=ctimeForFile();
filename=num2str(ctime);
datadir=dataDirFromCtime(ctime);

adcDataFile=fullfile(datadir,[filename '_adc.mat']);
dacDataFile=fullfile(datadir,[filename '_dac.mat']);

save(adcDataFile,'adcData');
save(dacDataFile,'dacData');

disp(['adcDataFile=' adcDataFile]);
disp(['dacDataFile=' dacDataFile]);
    

