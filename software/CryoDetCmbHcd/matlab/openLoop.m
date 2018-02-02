example();
offset=mean(df);
disp(['offset=',num2str(offset)]);

configCryoChannel(rootPath, chan(ii), offset(ii), Adrive, 0, etaPhaseDeg(ii), etaScaled(ii));