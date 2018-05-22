%% TM - UCL - 18/05/2018

% Histogram of speed distrubution along the track

%% plot info from only one session
% select trials from first

function SpeedDistribution(PlotObject, AnimalSessionInfo)

Tr_s = unique(PlotObject.es.iexp);
% actual plotting function
framerate = str2num(PlotObject.es.sampleRate(1:2)); % Hz
for i = 1:length(Tr_s)
         
    Trial_NR = max(PlotObject.es.trialID(find(PlotObject.es.iexp==Tr_s(i))));
    
    TrackLength  = PlotObject.VR.EXP.l;
    Edges = 0:3.33:TrackLength;
    for i = 1:length(Edges)-1
        indexes = find(PlotObject.es.traj(~isnan(PlotObject.es.traj))>=Edges(i) & PlotObject.es.traj(~isnan(PlotObject.es.traj))<Edges(i+1));
        temp = PlotObject.es.ballspeed(indexes)
        Speed(i,1) = mean(temp(~isnan(temp)))*PlotObject.VR.EXP.wheelToVR;
        Speed(i,2) = std(temp(~isnan(temp)))*PlotObject.VR.EXP.wheelToVR;
        clear indexes
    end
    errorbar(0+mean(diff(Edges))/2:mean(diff(Edges)):max(Edges), Speed(:,1), Speed(:,2))
    hold on
    plot([PlotObject.VR.EXP.rew_pos PlotObject.VR.EXP.rew_pos],[-(min(Speed(:,1))+max(Speed(:,2))) max(Speed(:,1))+max(Speed(:,2))],'k')
    plot([PlotObject.VR.EXP.rew_pos-PlotObject.VR.EXP.rew_tol PlotObject.VR.EXP.rew_pos-PlotObject.VR.EXP.rew_tol],[-(min(Speed(:,1))+max(Speed(:,2))) max(Speed(:,1))+max(Speed(:,2))],'k--')
    plot([PlotObject.VR.EXP.rew_pos+PlotObject.VR.EXP.rew_tol PlotObject.VR.EXP.rew_pos+PlotObject.VR.EXP.rew_tol],[-(min(Speed(:,1))+max(Speed(:,2))) max(Speed(:,1))+max(Speed(:,2))],'k--')
    
    axis([0 TrackLength -(min(Speed(:,1))+max(Speed(:,2))) max(Speed(:,1))+max(Speed(:,2))]) 
    set(gca,'box','off','TickDir','out');
    xlabel('VR track position (cm)'); ylabel('mean speed (cm/s)');
end

end