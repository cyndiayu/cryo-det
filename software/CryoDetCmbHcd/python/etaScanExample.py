import epics
import numpy

rootPath     = 'mitch_epics:AMCc:FpgaTopLevel:AppTop:AppCore:SysgenCryo:Base[0]:CryoChannels:'
etaScanFreqs = epics.PV( rootPath + 'etaScanFreqs' )
etaScanAmpl  = epics.PV( rootPath + 'etaScanAmplitude' )
etaScanBand  = epics.PV( rootPath + 'etaScanBand' )
etaScanStart = epics.PV( rootPath + 'runEtaScan' )

etaScanResultsI = epics.PV( rootPath + 'etaScanResultsReal' )
etaScanResultsQ = epics.PV( rootPath + 'etaScanResultsImag' )


freqs = numpy.arange( -0.3, 0.3, 0.01 )
band  = 0
ampl  = 10

etaScanFreqs.put( freqs )
etaScanAmpl.put( ampl )
etaScanBand.put( band )
etaScanStart.put( 1 )

i = etaScanResultsI.get( len( freqs ) )
q = etaScanResultsQ.get( len( freqs ) )
