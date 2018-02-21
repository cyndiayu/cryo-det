
% s
function setup()
    try
        lcaClear
    catch e
    end
    setEnv('mitch_epics')
    setDefaults
  
    root='mitch_epics:AMCc:FpgaTopLevel:AppTop:AppCore:SysgenCryo:Base[0]:';
    lcaPut([root,'iqSwapIn'], num2str(1));
    lcaPut([root,'iqSwapOut'], num2str(1));
    lcaPut([root,'refPhaseDelay'], num2str(5));
    lcaPut([root,'toneScale'], num2str(2));
    lcaPut([root,'feedbackGain'], num2str(256));
    lcaPut([root,'feedbackPolarity'], num2str(1));
    
    root='mitch_epics:AMCc:FpgaTopLevel:AppTop:AppCore:SysgenCryo:CryoAdcMux[0]:';
    lcaPut([root,'ChRemap[0]'] , num2str(6));
    lcaPut([root,'ChRemap[1]'] , num2str(7));

    readFpgaStatus( root )
end
