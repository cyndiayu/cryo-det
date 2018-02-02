function datadir=dataDirFromCtime(ctime,createDateDir)
    if nargin < 2
        createDateDir=true;
    end
    
    if isstring(ctime)
        ctime=str2num(ctime);
    end
    
    dt = datetime(ctime, 'ConvertFrom', 'posixtime');
    dirdate=datestr(dt,'yyyymmdd');
        
    datapath=getSMuRFenv('SMURF_DATA');
    datadir=fullfile(datapath,dirdate);
        
    if createDateDir
        % if today's date directory doesn't exist yet, make it
        if not(exist(datadir))
            disp(['-> creating ' datadir]);
            mkdir(datadir);
        end
    end
end
    
    