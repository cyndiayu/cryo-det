%script testAmplSweep

Nread = 4
dwell = 0.001
freqs = -9.8:0.1:9.8;   %frequencies in MHz

for band=0:7
    [resp, f] = amplSweep(band, freqs, Nread, dwell);
    display(['for band ', num2str(band), ' stDev = ', num2str(std(resp),5)])
    figure(band+1);plot(f, abs(resp), '.');grid
    title(['Amplitude Response for Band ' num2str(band)])
    xlabel('Frequency (MHz)')
    ylabel('Response (arbs)')

    figure(band+11);plot(abs(resp), '.');grid
    title(['Amplitude Response for Band ' num2str(band)])
    xlabel('sample number')
    ylabel('Response (arbs)')
       
    figure(100), subplot(2, 4, band+1), plot(f, abs(resp), '.');grid
    title(['Amplitude Response for Band ' num2str(band)])
    xlabel('Frequency (MHz)')
    ylabel('Response (arbs)')
    ax=axis; xt=ax(1)+0.1*(ax(2)-ax(1)); yt=ax(3) + 0.1*(ax(4)-ax(3));
    text(xt,yt,['Band Center = ', num2str(band*38.4), ' MHz'])
end

    