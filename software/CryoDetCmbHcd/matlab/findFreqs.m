%% tries to find all of the resonators
band0 = 5.25e3;
ctime=1517519090;
bands=0:31;

% sweep all bands
[f,resp]=fullBandAmplSweep(bands,Nread,dwell,freqs)

% plot
figure
hold on;
xlabel('Frequency (MHz)')
ylabel('Amplitude (normalized)')
title('32 sub-band response')

for band=0:31
    disp(['Plotting band ' num2str(band)])
    if band == 10
        xlim([-300 300]);
    end
    plot(f(band+1,:), abs(resp(band+1,:)), '.', 'color', rand(1,3))
    grid on;
end

xlim([-300 300])
xlabel('Frequency (MHz)')
ylabel('Amplitude (normalized)')
title('32 sub-band response')
%% done plotting sweep results

% create directory for results
datadir=dataDirFromCtime(ctime);

resultsDir=fullfile(datadir,num2str(ctime));

% if resuls directory doesn't exist yet, make it
if not(exist(resultsDir))
    disp(['-> creating ' resultsDir]);
    mkdir(resultsDir);
end

% save figure and data to directory
sweepFigureFilename=fullfile(resultsDir,[num2str(ctime),'_amplSweep.png']);
saveas(gcf,sweepFigureFilename);
sweepDataFilename=fullfile(resultsDir,[num2str(ctime),'_amplSweep.mat']);
save(sweepDataFilename,'f','resp');

% analyze
plotsaveprefix=fullfile(resultsDir,num2str(ctime));
res=findAllPeaks(sweepDataFilename,bands,plotsaveprefix);
res = res + band0;

disp(['res(MHz) = ',num2str(res)]);

% save resonators to file as list, by band and Foff
[band, Foff] = f2band(res);
dlmwrite(fullfile(resultsDir,[num2str(ctime),'.res']),horzcat(band',Foff',res'),'delimiter','\t');

