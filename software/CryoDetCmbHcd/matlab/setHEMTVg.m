function hemtVg(bit,doCfg)

if nargin <2
    % set to inverse
    doCfg=false;
end

if bit<0
end
if bit>524287
    bit=524287
end

rtmSpiMaxRootPath = 'mitch_epics:AMCc:FpgaTopLevel:AppTop:AppCore:RtmCryoDet:C_RtmSpiMax:';

%% set RtmCryoDet
%lcaPut( [rtmRootPath, 'LowCycle'],  num2str(2)); 

if doCfg
    lcaPut([rtmSpiMaxRootPath, 'HemtBias DacCtrlReg Ch 33'],num2str(2));
end

lcaPut([rtmSpiMaxRootPath, 'HemtBias DacDataReg Ch 33'],num2str(bit));

%        frCfg.(cfgvar{1})=value;
%    end
%    
%    %% C_RtmSpiSr
%    rtmSpiRootPath = 'mitch_epics:AMCc:FpgaTopLevel:AppTop:AppCore:RtmCryoDet:C_RtmSpiSr:';
%    configvars={'AD5790_NOP_Reg','AD5790_Data_Reg','AD5790_Ctrl_Reg','AD5790_ClrCode_Reg','Config_Reg', ...
%                'Cfg_Reg_Ena Bit','Ramp Slope','Mode Control'}; %,'Fast Step Size','Fast Rst Value'}; %% not reading right now 
%    for cfgvar=configvars
%        value=lcaGet([rtmSpiRootPath, cfgvar{1}]);
%        disp([rtmSpiRootPath, cfgvar{1}]);
%        frCfg.C_RtmSpiSr.(strrep(cfgvar{1},' ','_'))=value;
%    end
%end
% done with read

end
