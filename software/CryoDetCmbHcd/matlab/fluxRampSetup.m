
function frCfg=fluxRampSetup(doRead,fluxRampEnable)

if nargin <1
    % set to inverse
    doRead=false;
end

rtmRootPath = 'mitch_epics:AMCc:FpgaTopLevel:AppTop:AppCore:RtmCryoDet:';
rtmSpiRootPath = 'mitch_epics:AMCc:FpgaTopLevel:AppTop:AppCore:RtmCryoDet:C_RtmSpiSr:';

% before doing anything, disable the flux ramp
lcaPut( [rtmSpiRootPath, 'Cfg_Reg_Ena Bit'],  num2str(0));


% Need to scale flux ramp reset with carrier freq
rampStep = 1;
%
% Setup the flux ramp

%% set RtmCryoDet
lcaPut( [rtmRootPath, 'LowCycle'],  num2str(2)); 
lcaPut( [rtmRootPath, 'HighCycle'],  num2str(2)); 
lcaPut( [rtmRootPath, 'KRelay'],  num2str(3)); 
lcaPut( [rtmRootPath, 'RampMaxCnt'], num2str(323583/rampStep));
% % % lcaPut( [rtmRootPath, 'RampMaxCnt'], num2str(271138));
lcaPut( [rtmRootPath, 'SelectRamp'], num2str(1));
lcaPut( [rtmRootPath, 'EnableRamp'],  num2str(1)); 
lcaPut( [rtmRootPath, 'RampStartMode'],  num2str(0)); 
lcaPut( [rtmRootPath, 'PulseWidth'],  num2str(65535)); 
lcaPut( [rtmRootPath, 'DebounceWidth'],  num2str(255));
    
%% set C_RtmSpiSr
lcaPut( [rtmSpiRootPath, 'Ramp Slope'],  num2str(0));
lcaPut( [rtmSpiRootPath, 'Mode Control'],  num2str(0));
lcaPut( [rtmSpiRootPath, 'Fast Step Size'],  num2str(rampStep));
lcaPut( [rtmSpiRootPath, 'Fast Rst Value'],  num2str(65535));

% Done setting up the flux ramp
%

%
% read & return
frCfg={};
frCfg.C_RtmSpiSr={};

if doRead
    %% read current state
    % RtmCryoDet
    rtmRootPath = 'mitch_epics:AMCc:FpgaTopLevel:AppTop:AppCore:RtmCryoDet:';
    configvars={'LowCycle','HighCycle','RampMaxCnt','SelectRamp','EnableRamp','RampStartMode','PulseWidth','DebounceWidth'};
    for cfgvar=configvars
        value=lcaGet([rtmRootPath, cfgvar{1}]);
        frCfg.(cfgvar{1})=value;
    end
    
    %% C_RtmSpiSr
    rtmSpiRootPath = 'mitch_epics:AMCc:FpgaTopLevel:AppTop:AppCore:RtmCryoDet:C_RtmSpiSr:';
    configvars={'Cfg_Reg_Ena Bit','Ramp Slope','Mode Control'}; %,'Fast Step Size','Fast Rst Value'}; %% not reading right now 
    for cfgvar=configvars
        value=lcaGet([rtmSpiRootPath, cfgvar{1}]);
        disp([rtmSpiRootPath, cfgvar{1}]);
        frCfg.C_RtmSpiSr.(strrep(cfgvar{1},' ','_'))=value;
    end
end
% done with read

end