chan=64;
lcaPut([rootPath,'readoutChannelSelect'], chan(1));
lcaPut([rootPath,'singleChannelReadoutOpt2'], 1);
        
quickData();
offset=mean(df);
disp(['offset=',num2str(offset)]);

pvRoot = [rootPath, 'CryoChannels:CryoChannel[', num2str(chan(1)), ']:'];

ampl=lcaGet([pvRoot,'amplitudeScale']);

etaPhase=lcaGet([pvRoot,'etaPhase']);
etaPhaseDeg=(etaPhase/2^15)*180;

etaMag=lcaGet([pvRoot,'etaMag']);
etaScaled=etaMag/2^10;

configCryoChannel(rootPath, chan(1), offset(1), ampl, 0, etaPhaseDeg(1), etaScaled(1));