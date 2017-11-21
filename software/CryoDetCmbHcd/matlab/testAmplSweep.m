%script testAmplSweep

Nread = 4
dwell = 0.02
freqs = -19:1:19;   %frequencies in MHz



for band=0:7
    [resp, f] = amplSweep(band, freqs, Nread, dwell);
    display(['for band ', num2str(band), ' stDev = ', num2str(std(resp),5)])
    figure(band+1);plot(f, abs(resp), '.');grid
    title(['Amplitude Response for Band ' num2str(band)])
    xlabel('Frequency (MHz)')
    ylabel('Response (arbs)')
    
    figure(100), subplot(2, 4, band+1), plot(f, abs(resp), '.');grid
    title(['Amplitude Response for Band ' num2str(band)])
    xlabel('Frequency (MHz)')
    ylabel('Response (arbs)')
end

    