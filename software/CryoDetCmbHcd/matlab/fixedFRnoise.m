addpath('/home/cryo/shawn/matlab');

path2datedirs='/data/cpu-b000-hp01/cryo_data/data2/';

clear dls;

%dls={{'1515691298_Ch64.dat','closed loop (f)','f'},{'1515691405_Ch64.dat','open loop (df)','df'}};

% power=12, closed and open loop, first dataset with full SMuRF
%dls={{'1516371718_Ch192.dat','closed loop (f)','f'},{'1516372733_Ch192.dat','open loop (df)','df'},{'1516372981_Ch192.dat','open loop +3.4kHz (df)','df'}};

%power=15
%dls={{'1516373283_Ch192.dat','closed loop (f)','f'},{'1516374372_Ch192.dat','closed loop #2 (f)','f'},{'1516375222_Ch192.dat','open loop (df)','df'}};

%dls={{'1517326062_Ch192.dat','2x amp, 12dB atten','df'},{'1517326152_Ch192.dat','2x amp, 22dB atten','df'},{'1517326359_Ch192.dat','2x amp, 32dB atten','df'}};
%dls={{'1517326887_Ch192.dat','12dB out, 0dB in','df'},{'1517327058_Ch192.dat','2dB out, 10dB in','df'},{'1517327653_Ch192.dat','2dB out, 10dB in, 2xGfb','df'}};

%dls={{'1517329163_Ch192.dat', '12dB out, 0dB in', 'df'},{'1517329478_Ch192.dat','9dB out, 3dB in', 'df'},{'1517330065_Ch192.dat','6dB out, 6dB in', 'df'},{'1517330340_Ch192.dat','3dB out, 9dB in', 'df'},{'1517330843_Ch192.dat','0dB out, 12dB in', 'df'}};

dls={{'1517412850_Ch192.dat', 'everything on','f'},{'1517413026_Ch192.dat','- pulse tube','f'},{'1517413289_Ch192.dat','- cernoxes & diodes','f'},{'1517413428_Ch192.dat','- housekeeping (unplugged)','f'},{'1517414649_Ch192.dat','HEMT on blue boxes','f'}};

%plotTitle='SWH 5.39607 GHz no TES';
plotTitle='SWH 5.396 GHz no TES';

% auto-append date
now=datetime('now')
plotTitle=[datestr(now,'yyyy/mm/dd') ' ' plotTitle];

clear fs dfs asds fpws;
fs=[]; dfs=[]; asds=[]; fpws=[];

ColOrd = get(gca,'ColorOrder');
times=linspace(0,33554432/2.4e6,33554432);


clear LegendString;
LegendString = cell(1,numel(dls));
for c=1:length(dls)
    dfn=dls{c}{1};
    
    % need to find the file; that way we don't have to put the path above,
    % which is annoying.
    dfn_cands=glob(fullfile(path2datedirs,'/*/',dfn));
    % don't take the one that's in the soft-linked current_data directory
    dfnIdxC=strfind(dfn_cands,'/current_data/');
    dfnIdx=find(cellfun('isempty',dfnIdxC));
    dfn=dfn_cands(dfnIdx);
    dfn=dfn{1,1}; % not sure why this is necessary
    disp(['-> found ' dfn]);
    
    [dfpath,dfname,dfext] = fileparts(dfn);
    dsnum=dfname(7:10);
    
    dfleg=dls{c}{2};
    LegendString{c} = [dfleg ' (' dsnum ')'];
    disp([dfn ' : ' dfleg]);
    [filepath,name,ext] = fileparts(dfn)
    
    clear f;
    clear df;
    clear frs;
    % to swap f & df, decodeSingleChannel(dfn,1)
    [f,df,frs]=decodeSingleChannel(dfn);
    fs(c,:)=f;
    dfs(c,:)=df;

    figure(1);
    if c==1
        clf;
    end
    
    fordf=dls{c}{3};
    % this is a kludge.
    if fordf=='df'
        % for some reason, often have a glitch at the end of the df time
        % stream.  Truncate.
        f=df;
    end
    
    % truncate by stripping off last 10 samples; for some reason a lot of
    % the time the last sample or so is a glitch for either f or df
    f=f(1:end-10);
    df=df(1:end-10);
    
    subplot(length(dls),1,c);
    Col = ColOrd(c,:)
    plot(times(1:length(f)),f,'Color',Col);
    if c==1
        title(plotTitle);
    end
    %ylim(1.5*ylim);
    ylabel('\DeltaF (MHz)');
    legend(dfleg);
    if c==length(dls)
        xlabel('Time (s)');
        xl=xlim();
        yl=ylim();
    end
    
    % plot power spectra
    figure(2);
    if c==1
        clf;
    end
    
    % w/ windowing
    [pxxpw,fpw] = pwelch(f,2^22,2^10,2^22,2.4e6);
    asd=sqrt(pxxpw)*1.e6; % x1e6 to convert from MHz to Hz
    
    asds(c,:)=asd; fpws(c,:)=fpw;
    
    loglog(fpw,asd);
    if c==1
        hold on;
    end
    
    if c==length(dls)
        xlim([1 1.2e6]);
        ylim([1e-3 1.e4]);
        
        ylabel('Frequency ASD (Hz/rtHz)');
        %ylabel('Frequency ASD (\mu\Phi_{0}/rtHz)');
        %ylabel('Current ASD (pA/rtHz)');
        xlabel('Frequency (Hz)');
        
        legend(LegendString);
        title(plotTitle);
    end
    
    figure(3);
    if c==1
        clf;
    end
    
    % no windowing
    [fpwr,pxxpwr] = psd(f,2.4e6);
    asdr=sqrt(pxxpwr)*1.e6; % x1e6 to convert from MHz to Hz
    loglog(fpwr,asdr);
    if c==1
        hold on;
    end
    
    if c==length(dls)
        xlim([1/max(times) 1.2e6]);
        ylim([1e-3 1.e4]);
        
        ylabel('Frequency ASD (Hz/rtHz)');
        %ylabel('Frequency ASD (\mu\Phi_{0}/rtHz)');
        %ylabel('Current ASD (pA/rtHz)');
        xlabel('Frequency (Hz)');
        
        legend(LegendString);
        title(plotTitle);
    end
end

for c=1:length(dls)
    f=fs(c,:);
    dfleg=dls{c}{2};
    disp(['-> ' dfleg ' : ']);
    disp(['std(f)=' num2str(std(f)*1.e6) 'Hz']);
end
