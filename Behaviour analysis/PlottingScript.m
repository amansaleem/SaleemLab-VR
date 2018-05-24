

AnimalObject = expSelector;
r = expObject;
r.animal = AnimalObject.expObject.animal;
r.iseries = AnimalObject.expObject.iseries;
r.iexp = AnimalObject.expObject.iexp;
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
    PSTH_interval = 5;    
    RewardIndexes = find((~isnan(es.reward)));
    RewardType = es.reward(RewardIndexes);
    j = 1;
    clear LickVector SpeedVector LickVector500ms
    for i=1:length(RewardIndexes)
        if es.traj(RewardIndexes(i))>(VR.EXP.rew_pos-VR.EXP.rew_tol) && es.traj(RewardIndexes(i))<(VR.EXP.rew_pos+VR.EXP.rew_tol)
            LickVector(j,:) = es.lick(RewardIndexes(i)-framerate*PSTH_interval:RewardIndexes(i)+framerate*PSTH_interval)';
            SpeedVector(j,:) = es.ballspeed(RewardIndexes(i)-framerate*PSTH_interval:RewardIndexes(i)+framerate*PSTH_interval);
            j = j + 1;
        end
    end
    LickVector(isnan(LickVector)) = 0;
    HalfSecondintervals = PSTH_interval*2*2;
    for j = 1:size(LickVector,1)
        for i = 1:HalfSecondintervals
            LickVector500ms(j,i) = sum(LickVector(j,round((length(LickVector)/20))*(i-1)+1:round((length(LickVector)/20))*(i)));
        end
    end
    
    SpeedVector(isnan(SpeedVector)) = 0;
    MeanSpeed = mean(SpeedVector,1);
    SEMSpeed = std(SpeedVector,1)/sqrt(size(SpeedVector,1));
    
    figure
    % plot PSTH of licks
    hb1 = subtightplot(10,1,1:4,[0.01 0.01],[0.01 0.01],[0.1 0.02]);
    %set(hb1,'Parent',PlotObject.figHandle.BeahvEventsTime);
    plot(linspace(-PSTH_interval,PSTH_interval,HalfSecondintervals), sum(LickVector500ms,1))
    hold on
    plot([0 0], [0 max(sum(LickVector500ms,1))],'--k','LineWidth',2)
    set(gca,'box','off','TickDir','out', 'XTick',-PSTH_interval:1:PSTH_interval, 'XTickLabel',[]);
    set(gca,'YTick',[5:5:max(5,max(sum(LickVector500ms,1)))],...
            'YTickLabel',[5:5:max(5,max(sum(LickVector500ms,1)))]);
    ylabel('Licks');
    ylim([0 max(sum(LickVector500ms,1))]);
    text(-3,max(5,max(sum(LickVector500ms,1))),'Reward Release');
    % plot mean of speed
    hb2 = subtightplot(10,1,5:10,[0.15 0.01],[0.15 0.01],[0.1 0.02])
    %set(hb2,'Parent',PlotObject.figHandle.BeahvEventsTime);
    shadedErrorBar(-PSTH_interval:1/framerate:PSTH_interval,MeanSpeed,SEMSpeed)
    set(gca,'box','off','TickDir','out', 'XTick',-PSTH_interval:1:PSTH_interval, ...
                                    'XTickLabel',-PSTH_interval:1:PSTH_interval);
    set(gca,'YTick',5:5:max(5,max(MeanSpeed)),...
       'YTickLabel',5:5:max(5,max(MeanSpeed)));
    xlabel('seconds'); ylabel('speed');
    
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












