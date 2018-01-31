%script testAmplSweep

Nread = 4
dwell = 0.02;
freqs = -14.8:0.2:14.8;   %frequencies in MHz

resp = zeros(32, size(freqs,2)*Nread);
f = zeros(32, size(freqs,2)*Nread);

band_centers1 = circshift((0:1:15)-8,8)';
band_centers2 = circshift((0.5:1:15.5)-8,8)';
band_centers = [band_centers1; band_centers2]*38.4;

for band=0:31
    disp(['band ' num2str(band)])
    [resp(band+1,:), f(band+1,:)] = amplSweep(band, freqs, Nread, dwell);
    f(band+1,:) = f(band+1,:) + band_centers(band+1);
end




figure
for band = 0:15
    plot(f(band+1,:), abs(resp(band+1,:)), '.', 'color', rand(1,3))
    hold on
end

% TODO fix multiply by 2 
for band = 16:31
    plot(f(band+1,:), 2*abs(resp(band+1,:)), '.', 'color', rand(1,3))
    hold on
end

xlim([-307.2 307.2])
ylabel('Frequency (MHz)')
xlabel('Amplitude (normalized)')
title('32 sub-band response')
