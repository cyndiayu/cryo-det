%script testAmplSweep

Nread = 4
dwell = 0.001
freqs = -9.6e6:1.2e6:9.6e6;

for band=0:7
    resp = amplSweep(band, freqs, Nread, dwell);
    figure(band+1);plot(freqs/1e6, abs(resp));grid
    title(['Amplitude Response for Band ' num2str(band)])
    xlabel('Frequency (MHz)')git ci 
    ylabel('Response (arbs)')
end

    