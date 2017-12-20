function plotChannels(v, chans, columns)
%function plotChannels(v, chans, colums)
%plots selected channels from array v
%as one subplot per channel. 
%subplots are arranged into a number of columns given by parameter
%"columns" which defaults to 4

if nargin < 3
    columns = 4
end

%how many lines shall we plot?
Nchans = length(chans)
subplot(ceil(Nchans/columns),columns,1)

nplot = 1;

for nchan = 1:Nchans
    subplot(ceil(Nchans/columns), columns, nplot)
    plot(f(:,chans(nchan)), grid, title(['Channel ' num2str(chan)])
    nplot = nplot+1;
end

        
    