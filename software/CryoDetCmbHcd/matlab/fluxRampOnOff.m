function fluxRampOnOff(frEnable)
%% Simple function for turning the flux ramp on or off.  Default is to switch

rtmSpiRootPath = 'mitch_epics:AMCc:FpgaTopLevel:AppTop:AppCore:RtmCryoDet:C_RtmSpiSr:';
% read current state
%currentFRState = lcaGet( [rtmSpiRootPath, 'Cfg_Reg_Ena Bit'] );

%if nargin <1
%    % set to inverse
%    frEnable=~currentFRState;
%end

%if currentFRState == frEnable
%    return
%end

lcaPut( [rtmSpiRootPath, 'Cfg_Reg_Ena Bit'],  num2str(frEnable)); %switch FR on/off
    
% wait 0.11 secound before handing back 
pause(0.11);

end