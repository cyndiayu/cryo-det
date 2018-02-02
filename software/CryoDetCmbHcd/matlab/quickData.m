% take a short dumb dataset
system('rm /tmp/tmp2.dat');
takeDebugData(rootPath,'/tmp/tmp2.dat',2^12);

dfn='/tmp/tmp2.dat';
[f,df,frs]=decodeSingleChannel(dfn);