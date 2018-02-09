addpath('./glob/');

path2datedirs='/data/cpu-b000-hp01/cryo_data/data2/';
fSample=2.4e6;

clear dls;

%Imax is only used for I and Q
%Imax=1.;
%dls={{'1518091722_Ch496.dat','quadrature direction','adc'}};
%dls={ ...
%        % dataset1
%        struct('fn','1518091859_Ch496.dat', ...
%               'label','inphase direction', ...
%               'type','adc', ...
%               'Imax',318307.4857) ...
%        % dataset2
%        struct('fn','1518091722_Ch496.dat', ...
%               'label','quadrature direction', ...
%               'type','adc', ...
%               'Imax',318307.4857), ...
%    };

dls={ ...
        % dataset1
        %struct('fn','1518107010_Ch256.dat', ...
        %       'label','inphase direction', ...
        %       'type','adc', ...
        %       'swapFdF',false, ...
        %       'Imax',3451415.3009) ...
% %         struct('fn','1518108523_Ch256.dat', ...
% %                'label','quadrature direction (analysisScale=0x3)', ...
% %                'type','adc', ...
% %                'swapFdF',false, ...
% %                'Imax',6901537.0756),...
% %         struct('fn','1518107965_Ch256.dat', ...
% %                'label','quadrature direction (analysisScale=0x0)', ...
% %                'type','adc', ...
% %                'swapFdF',false, ...
% %                'Imax',1727758.3618), ...
% %         struct('fn','1518107078_Ch256.dat', ...
% %                'label','quadrature direction', ...
% %                'type','adc', ...
% %                'swapFdF',false, ...
% %                'Imax',3451415.3009), ...
         struct('fn','1518110654_Ch256.dat', ...
               'label','quadrature direction', ...
               'type','adc', ...
               'swapFdF',false, ...
               'Imax',1339572) ...
    };

plotTitle='SWH 5.22975 GHz I/Q no fridge';
%plotTitle='CY 5.396 GHz no TES, fixed input/variable output attenuation';

% auto-append date
now=datetime('now')
plotTitle=[datestr(now,'yyyy/mm/dd') ' ' plotTitle];

clear fs dfs asds fpws;
fs=[]; dfs=[]; asds=[]; fpws=[];

ColOrd = get(gca,'ColorOrder');
times=linspace(0,33554432/fSample,33554432);


clear LegendString;
LegendString = cell(1,numel(dls));
for c=1:length(dls)
    dfn=getfield(dls{c},'fn')
    
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
    
    dfleg=getfield(dls{c},'label');
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
    
    swapFdF=false;
    if(isfield(dls{c},'swapFdF'))
        swapFdF=getfield(dls{c},'swapFdF');
    end
    fordf=getfield(dls{c},'type');
    % this is a kludge.
    if (strcmp(fordf,'df')||swapFdF)
        % for some reason, often have a glitch at the end of the df time
        % stream.  Truncate.
        f=df;
    end
    
    if(strcmp(fordf,'adc'))
        % decodeSingleChannel assumes data is frequency,
        % so if you're trying to read ADC data directly
        % need to undo the conversion it does
        f=(2^23/19.2)*f;
        df=(2^23/19.2)*f;
    end
    

    
    % truncate by stripping off last 10 samples; for some reason a lot of
    % the time the last sample or so is a glitch for either f or df
    f=f(1:end-10);
    df=df(1:end-10);
    
    ph = atan2(f, ones(size(f))*dls{c}.Imax);
    w = blackman(length(ph));
    [pxx, ff] = pwelch(ph,w,[],[],fSample);

    
    subplot(length(dls),1,c);
    Col = ColOrd(c,:)
    plot(times(1:length(f)),f,'Color',Col);
    if c==1
        title(plotTitle);
    end
    %ylim(1.5*ylim);
    ylabel('\DeltaF (MHz)');
    if strcmp(fordf,'adc')
        ylabel('ADC counts');
    end
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
    
    % 
    Imax=1;
    if isfield(dls{c},'Imax')
        Imax=getfield(dls{c},'Imax');
    end
    
    % w/ windowing
    [pxxpw,fpw] = pwelch(f,2^22,2^10,2^22,fSample);
    
    asd=sqrt(pxxpw);
    if strcmp(fordf,'adc')
        asd=20.*log10(asd/Imax); % x1e6 to convert from MHz to Hz
        semilogx(fpw,asd);
    else %frequency data in MHz
        asd=asd*1.e6; % x1e6 to convert from MHz to Hz
        loglog(fpw,asd);
    end
    
    asds(c,:)=asd; fpws(c,:)=fpw;
   
    if c==1
        hold on;
    end
    
    if c==length(dls)
        xlim([1 fSample/2]);
        xlabel('Frequency (Hz)');
        if strcmp(fordf,'adc')
            ylabel('dBc/Hz');
        else
            ylim([1e-3 1.e4]);
            ylabel('Frequency ASD (Hz/rtHz)');
        end 
        
        legend(LegendString);
        title(plotTitle);
    end
    
    figure(3);
    if c==1
        clf;
    end
    
    % no windowing
    [fpwr,pxxpwr] = psd(f,fSample);
    
    asdr=sqrt(pxxpwr);
    if strcmp(fordf,'adc')
        asdr=20.*log10(asdr/Imax); % x1e6 to convert from MHz to Hz
        semilogx(fpwr,asdr);
        semilogx(ff,10*log10(pxx));
    else %frequency data in MHz
        asdr=asdr*1.e6; % x1e6 to convert from MHz to Hz
        loglog(fpwr,asdr);
    end

    if c==1
        hold on;
    end
    
    if c==length(dls)  
        xlim([1 fSample/2]);
        xlabel('Frequency (Hz)');
        if strcmp(fordf,'adc')
            ylabel('dBc/Hz');
        else
            ylim([1e-3 1.e4]);
            ylabel('Frequency ASD (Hz/rtHz)');
        end 
        
        legend(LegendString);
        title(plotTitle);
    end
end

for c=1:length(dls)
    f=fs(c,:);
    dfleg=getfield(dls{c},'label');
    disp(['-> ' dfleg ' : ']);
    disp(['std(f)=' num2str(std(f)*1.e6) 'Hz']);
end
