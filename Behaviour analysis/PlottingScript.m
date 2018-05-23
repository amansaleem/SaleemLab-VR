

AnimalObject = expSelector;
r = expObject;
r.animal = AnimalObject.expObject.animal;
r.iseries = AnimalObject.expObject.iseries;
r.exp_list = AnimalObject.expObject.iexp;
% load experiment
[es, totalReward, VR] = loadBehav(AnimalObject.expObject);

PlotObject = behavPlotter;
AnimalObject = AnimalObject;
expObject = r;
es = es;
VR = VR;

createUI(PlotObject)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
Tr_s = unique(es.iexp);
framerate = str2num(es.sampleRate(1:2)); % Hz
for i = 1:length(Tr_s)
         
    % look at session in 5 mins shanks
    Mins = 5;
    DurationChunk = Mins*60;
    DurationSession = max(es.sampleTimes(es.iexp==Tr_s(i)));
    NrChunks = floor(DurationSession/DurationChunk);
    
    Trial_NR = max(es.trialID(find(es.iexp==Tr_s(i))));
   
    Edges = 0:DurationChunk:DurationSession;
    clear LickCount TrialInfo RunningInfo
    for i = 1:length(Edges)-1
        indexes = find(es.sampleTimes>=Edges(i) & es.sampleTimes<Edges(i+1));
        % lick info
        LickCount(i,1) = sum((es.lick(indexes)));
        % trial completed and average trial duration
        TrialsID = find(diff(es.trialID(indexes))==1);
        if i==1
            if ~isempty(TrialsID)
                TrialInfo(i,1) = length(TrialsID); % nr. of trials completed in this time window
                TrialInfo(i,2) = mean(([TrialsID(1); diff(TrialsID)]-unique(es.blanks(TrialsID)))./framerate); % avg. trial duration
                LastTemp = TrialsID(end);
            else
                TrialInfo(i,1) = 0; % nr. of trials completed in this time window
                TrialInfo(i,2) = 300; % avg. trial duration
            end
        else
            if ~isempty(TrialsID)
                TrialInfo(i,1) = length(TrialsID); % nr. of trials completed in this time window
                TrialInfo(i,2) = mean(([TrialsID(1)+length(indexes)-LastTemp; diff(TrialsID)]-unique(es.blanks(TrialsID)))./framerate); % avg. trial duration
                LastTemp = TrialsID(end);
            else
                TrialInfo(i,1) = 0; % nr. of trials completed in this time window
                TrialInfo(i,2) = 300; % avg. trial duration
            end
        end
        % running speed info
        
        RunningInfo(i,1) = length(find(es.ballspeed(indexes)*VR.EXP.wheelToVR>2))/length(indexes)*100;% percentage of time spent running
        tempSpeed = es.ballspeed(indexes)*VR.EXP.wheelToVR;
        RunningInfo(i,2) = mean(tempSpeed(tempSpeed>2)); % mean moving speed (>2cms/s)
        clear indexes
    end
    Xaxis = 0+mean(diff(Edges))/2:mean(diff(Edges)):max(Edges);
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    subtightplot(10,1,1:3,[0.01 0.01],[0.02 0.01],[0.1 0.02])
    hb1 = bar(Xaxis, LickCount);
    xlim([0 round(DurationSession)]) ;
    set(gca,'XTick',[Edges(2:end-1) round(DurationSession)],'XTickLabel',[]);
    set(gca,'YTick',[ceil(max(LickCount)/10)*10/3:ceil(max(LickCount)/10)*10/3:ceil(max(LickCount)/10)*10],...
       'YTickLabel',[ceil(max(LickCount)/10)*10/3:ceil(max(LickCount)/10)*10/3:ceil(max(LickCount)/10)*10]);
    set(gca,'box','off','TickDir','out');
    ylabel('Lick count');
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    subtightplot(10,1,4:6,[0.01 0.01],[0.01 0.02],[0.1 0.02])
    hb2 = bar(Xaxis, TrialInfo(:,1));
    for ii = 1:length(TrialInfo(:,1))
        text(Xaxis(ii)-30, TrialInfo(ii,1) - 1, num2str(TrialInfo(ii,2),4));
    end
    xlim([0 round(DurationSession)]) ;
    set(gca,'XTick',[Edges(2:end-1) round(DurationSession)],'XTickLabel',[]);
    set(gca,'YTick',[1 max(TrialInfo(:,1))],...
            'YTickLabel',[1 max(TrialInfo(:,1))]);
    set(gca,'box','off','TickDir','out');
    ylabel('Trials completed');
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    subtightplot(10,1,7:10,[0.1 0.01],[0.1 0.01],[0.1 0.02])
    hb3 = bar(Xaxis, RunningInfo(:,1));
    for ii = 1:length(RunningInfo(:,1))
        text(Xaxis(ii)-30, RunningInfo(ii,1) - 1, num2str(RunningInfo(ii,2),2));
    end
    xlim([0 round(DurationSession)]) ;
    set(gca,'XTick',[Edges(2:end-1) round(DurationSession)],'XTickLabel',[Edges(2:end-1)/framerate round(DurationSession/framerate)]);
    set(gca,'YTick',[5:5:ceil(max(RunningInfo(:,1)))],...
            'YTickLabel',[5:5:ceil(max(RunningInfo(:,1)))]);
    set(gca,'box','off','TickDir','out');
    xlabel('Duration session (5 mins periods)'); 
    ylabel('% time running >2cm/s');
    
end


a = axes();
a = subplot(2,2,1);
a = subplot(2,2,2);

p = plot(1:10); %returns a handle to a line object
a = get(p,'Parent');

clear f a f2
f = figure('Position', [-1000 100 500 500])
a = subplot(2,2,1)
plot(1:10,'k.')
pause
f2 = figure('Position', [-400 100 300 300]);
ahandle = axes('Parent', f2);
set(a,'Parent', ahandle);
plot(1:10,'.')












