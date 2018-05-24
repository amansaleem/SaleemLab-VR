%% TM - UCL - 18/05/2018
% Temporal distribution of Licking behaviour during a single sPlotObject.ession
% Temporal distribution of trial duration during a single sPlotObject.ession (text
% with nr of trials completed)
% Temporal distribution of running speed during a single sPlotObject.ession

% chanks of 5 mins 

%% plot info from only one sPlotObject.ession
% select trials from first

function BehavParamTemporalDistribution(PlotObject, AnimalSessionInfo)

Tr_s = unique(PlotObject.es.iexp);
% actual plotting function
framerate = str2num(PlotObject.es.sampleRate(1:2)); % Hz
for i = 1:length(Tr_s)
    
     % look at sPlotObject.ession in 5 mins shanks
    Mins = 5;
    DurationChunk = Mins*60;
    DurationSession = max(PlotObject.es.sampleTimes(PlotObject.es.iexp==Tr_s(i)));
    NrChunks = floor(DurationSession/DurationChunk);
    
    Trial_NR = max(PlotObject.es.trialID(find(PlotObject.es.iexp==Tr_s(i))));
   
    Edges = 0:DurationChunk:DurationSession;
    clear LickCount TrialInfo RunningInfo
    for i = 1:length(Edges)-1
        indexes = find(PlotObject.es.sampleTimes>=Edges(i) & PlotObject.es.sampleTimes<Edges(i+1));
        % lick info
        LickCount(i,1) = sum((PlotObject.es.lick(indexes)));
        % trial completed and average trial duration
        TrialsID = find(diff(PlotObject.es.trialID(indexes))==1);
        if i==1
            if ~isempty(TrialsID)
                TrialInfo(i,1) = length(TrialsID); % nr. of trials completed in this time window
                TrialInfo(i,2) = mean(([TrialsID(1); diff(TrialsID)]-unique(PlotObject.es.blanks(TrialsID)))./framerate); % avg. trial duration
                LastTemp = TrialsID(end);
            else
                TrialInfo(i,1) = 0; % nr. of trials completed in this time window
                TrialInfo(i,2) = 300; % avg. trial duration
            end
        else
            if ~isempty(TrialsID)
                TrialInfo(i,1) = length(TrialsID); % nr. of trials completed in this time window
                TrialInfo(i,2) = mean(([TrialsID(1)+length(indexes)-LastTemp; diff(TrialsID)]-(PlotObject.es.blanks(TrialsID)))./framerate); % avg. trial duration
                LastTemp = TrialsID(end);
            else
                TrialInfo(i,1) = 0; % nr. of trials completed in this time window
                TrialInfo(i,2) = 300; % avg. trial duration
            end
        end
        % running speed info
        
        RunningInfo(i,1) = length(find(PlotObject.es.ballspeed(indexes)*PlotObject.VR.EXP.wheelToVR>2))/length(indexes)*100;% percentage of time spent running
        tempSpeed = PlotObject.es.ballspeed(indexes)*PlotObject.VR.EXP.wheelToVR;
        RunningInfo(i,2) = mean(tempSpeed(tempSpeed>2)); % mean moving speed (>2cms/s)
        clear indexPlotObject.es
    end
    Xaxis = 0+mean(diff(Edges))/2:mean(diff(Edges)):max(Edges);
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    hb1 = subtightplot(10,1,1:3,[0.01 0.01],[0.01 0.01],[0.1 0.02]);
    set(hb1,'Parent',PlotObject.figHandle.BeahvEventsTime);
    bar(Xaxis, LickCount);
    xlim([0 round(DurationSession)]) ;
    set(gca,'XTick',[Edges(2:end-1) round(DurationSession)],'XTickLabel',[]);
    set(gca,'YTick',[ceil(max(LickCount)/10)*10/3:ceil(max(LickCount)/10)*10/3:ceil(max(LickCount)/10)*10],...
       'YTickLabel',[round(ceil(max(LickCount)/10)*10/3):round(ceil(max(LickCount)/10)*10/3):ceil(max(LickCount)/10)*10]);
    ylim([0 max(LickCount)])
    set(gca,'box','off','TickDir','out');
    ylabel('Lick count');
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    hb2 = subtightplot(10,1,4:6,[0.01 0.01],[0.01 0.01],[0.1 0.02])
    set(hb2,'Parent',PlotObject.figHandle.BeahvEventsTime);
    bar(Xaxis, TrialInfo(:,1));
    for ii = 1:length(TrialInfo(:,1))
        text(Xaxis(ii)-30, TrialInfo(ii,1) - 1, num2str(TrialInfo(ii,2),4));
    end
    xlim([0 round(DurationSession)]) ;
    set(gca,'XTick',[Edges(2:end-1) round(DurationSession)],'XTickLabel',[]);
    ''''
    set(gca,'box','off','TickDir','out');
    ylabel('Trials');
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    hb3 = subtightplot(10,1,7:10,[0.15 0.01],[0.15 0.01],[0.1 0.02])
    set(hb3,'Parent',PlotObject.figHandle.BeahvEventsTime);
    bar(Xaxis, RunningInfo(:,1));
    for ii = 1:length(RunningInfo(:,1))
        text(Xaxis(ii)-30, RunningInfo(ii,1) - 1, num2str(RunningInfo(ii,2),2));
    end
    xlim([0 round(DurationSession)]) ;
    set(gca,'XTick',[Edges(2:end-1) round(DurationSession)],'XTickLabel',[Edges(2:end-1)/framerate round(DurationSession/framerate)]);
    set(gca,'YTick',[5:5:ceil(max(RunningInfo(:,1)))],...
            'YTickLabel',[5:5:ceil(max(RunningInfo(:,1)))]);
    ylim([0 ceil(max(RunningInfo(:,1)))]);
    set(gca,'box','off','TickDir','out');
    xlabel('minutes'); 
    ylabel('% run time');
end

end