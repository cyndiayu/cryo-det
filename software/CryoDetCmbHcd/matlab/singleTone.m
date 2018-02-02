allOff

[band,Foff]=f2band(5308.879)
chan = 16*band;

etaPhaseDeg = 0;
etaScaled = 0;

configCryoChannel(rootPath, chan, offset, 12, 1, etaPhaseDeg, etaScaled);