%% TM - UCL - 18/05/2018
% Temporal distribution of Licking behaviour during a single session
% Temporal distribution of trial duration during a single session (text
% with nr of trials completed)
% Temporal distribution of running speed during a single session

% chanks of 5 mins 

%% plot info from only one session
% select trials from first

function BehavParamTemporalDistribution(PlotObject, AnimalSessionInfo)

Tr_s = unique(PlotObject.es.iexp);
% actual plotting function
framerate = str2num(PlotObject.es.sampleRate(1:2)); % Hz
for i = 1:length(Tr_s)
    
    % look at session in 5 mins shanks
    Mins = 5;
    DurationChunk = Mins*60;
    DurationSession = max(PlotObject.es.sampleTimes(PlotObject.es.iexp==Tr_s(i)));
    NrChunks = floor(DurationSession/DurationChunk);
    
    Trial_NR = max(PlotObject.es.trialID(find(PlotObject.es.iexp==Tr_s(i))));
   
    Edges = 0:DurationChunk:DurationSession;
    
    for i = 1:length(Edges)-1
        indexes = find(PlotObject.es.sampleTimes>=Edges(i) & PlotObject.es.sampleTimes<Edges(i+1));
        % lick info
        LickCount(i,1) = sum((PlotObject.es.lick(indexes)));
        % trial info
        TrialsID = find(diff(PlotObject.es.trialID(indexes))==1);
        TrialInfo(i,1) = length(TrialsID); % nr. of trials completed in this time window
        TrialInfo(i,2) = (Edges(i+1)+Diff)/TrialInfo(i,1); % avg. trial duration
        % running speed info
%         RunningInfo(i,1) = % percentage of time spent running
%         RunningInfo(i,2) = % mean moving speed (>2cms/s)
        clear indexes
    end
    
      bar(0+mean(diff(Edges))/2:mean(diff(Edges)):max(Edges), LickCount);
%     hold on
%     plot([PlotObject.VR.EXP.rew_pos PlotObject.VR.EXP.rew_pos],[0 max(LickCount)],'k')
%     plot([PlotObject.VR.EXP.rew_pos-PlotObject.VR.EXP.rew_tol PlotObject.VR.EXP.rew_pos-PlotObject.VR.EXP.rew_tol],[0 max(LickCount)],'k--')
%     plot([PlotObject.VR.EXP.rew_pos+PlotObject.VR.EXP.rew_tol PlotObject.VR.EXP.rew_pos+PlotObject.VR.EXP.rew_tol],[0 max(LickCount)],'k--')
      xlim([0 round(DurationSession)]) ;
      set(gca,'XTick',[Edges(1:end-1) round(DurationSession)],'XTickLabel',[Edges(1:end-1)/framerate round(DurationSession/framerate)]);
      set(gca,'box','off','TickDir','out');
      xlabel('Duration session (5 mins perionds)'); ylabel('Lick count');
end

end