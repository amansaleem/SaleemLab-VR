%% TM - UCL - 18/05/2018

% Histogram of Lick position distribution along the track

%% plot info from only one session
% select trials from first

function LicksDistribution(PlotObject, AnimalSessionInfo)

Tr_s = unique(PlotObject.es.iexp);
% actual plotting function
framerate = str2num(PlotObject.es.sampleRate(1:2)); % Hz
for i = 1:length(Tr_s)
         
    Trial_NR = max(PlotObject.es.trialID(find(PlotObject.es.iexp==Tr_s(i))));
    
    TrackLength  = PlotObject.VR.EXP.l;
    Edges = 0:3.33:TrackLength;
    for i = 1:length(Edges)-1
        indexes = find(PlotObject.es.traj>=Edges(i) & PlotObject.es.traj<Edges(i+1));
        LickCount(i,1) = sum((PlotObject.es.lick(indexes)));
        clear indexes
    end
    bar(0+mean(diff(Edges))/2:mean(diff(Edges)):max(Edges), LickCount);
    hold on
    plot([PlotObject.VR.EXP.rew_pos PlotObject.VR.EXP.rew_pos],[0 max(LickCount)],'k')
    plot([PlotObject.VR.EXP.rew_pos-PlotObject.VR.EXP.rew_tol PlotObject.VR.EXP.rew_pos-PlotObject.VR.EXP.rew_tol],[0 max(LickCount)],'k--')
    plot([PlotObject.VR.EXP.rew_pos+PlotObject.VR.EXP.rew_tol PlotObject.VR.EXP.rew_pos+PlotObject.VR.EXP.rew_tol],[0 max(LickCount)],'k--')
    axis([0 TrackLength 0 max(LickCount)]) 
    set(gca,'box','off','TickDir','out');
    xlabel('VR track position (cm)'); ylabel('Lick count');
end

end