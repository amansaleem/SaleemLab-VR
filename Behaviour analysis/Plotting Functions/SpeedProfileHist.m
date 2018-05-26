%% TM - UCL - 18/05/2018

% Histogram of speed value distrubution

%% plot info from only one session
% select trials from first

function SpeedProfileHist(PlotObject, AnimalSessionInfo)

Tr_s = unique(PlotObject.es.iexp);
% actual plotting function
framerate = str2num(PlotObject.es.sampleRate(1:2)); % Hz
for i = 1:length(Tr_s)
         
    Edges = 0:2:max(PlotObject.es.ballspeed*PlotObject.VR.EXP.wheelToVR); % in step of 2cm/s
    [BinCounts,edges] = histcounts(PlotObject.es.ballspeed*PlotObject.VR.EXP.wheelToVR,Edges,'Normalization','probability');
    bar(0+mean(diff(Edges))/2:mean(diff(Edges)):max(Edges), BinCounts);
    set(gca,'box','off','TickDir','out');
    xlabel('cm/s'); ylabel('speed prob');
    xlim([0 30]);
    
end

end