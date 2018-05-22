%% TM - UCL - 18/05/2018

% Histogram of position distrubution along the track

%% plot info from only one session
% select trials from first

function PositionDistribution(PlotObject, AnimalSessionInfo)

Tr_s = unique(PlotObject.es.iexp);
% actual plotting function
framerate = str2num(PlotObject.es.sampleRate(1:2)); % Hz
for i = 1:length(Tr_s)
         
    Trial_NR = max(PlotObject.es.trialID(find(PlotObject.es.iexp==Tr_s(i))));
    
    TrackLength  = PlotObject.VR.EXP.l;
    Edges = 0:3.33:TrackLength;
    h = histogram(PlotObject.es.traj,Edges,'Normalization','probability');
    hold on
    plot([PlotObject.VR.EXP.rew_pos PlotObject.VR.EXP.rew_pos],[0 1],'k')
    plot([PlotObject.VR.EXP.rew_pos-PlotObject.VR.EXP.rew_tol PlotObject.VR.EXP.rew_pos-PlotObject.VR.EXP.rew_tol],[0 1],'k--')
    plot([PlotObject.VR.EXP.rew_pos+PlotObject.VR.EXP.rew_tol PlotObject.VR.EXP.rew_pos+PlotObject.VR.EXP.rew_tol],[0 1],'k--')
    axis([0 TrackLength 0 max(h.BinCounts)/length(h.Data)+0.1*max(h.BinCounts)/length(h.Data)]) 
    set(gca,'box','off','TickDir','out');
    xlabel('VR track position (cm)'); ylabel('probability');
   
end

end