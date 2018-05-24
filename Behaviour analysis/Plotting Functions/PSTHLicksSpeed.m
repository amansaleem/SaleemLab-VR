%% TM - UCL - 23/05/2018

% PSTH of licks and speed around reward releases

%% plot info from only one session
% select trials from first

function PSTHLicksSpeed(PlotObject, AnimalSessionInfo)

Tr_s = unique(PlotObject.es.iexp);
% actual plotting function
framerate = str2num(PlotObject.es.sampleRate(1:2)); % Hz
for i = 1:length(Tr_s)
    if ~length(isnan(PlotObject.es.reward))==length(PlotObject.es.reward)
        PSTH_interval = 5;
        RewardIndexes = find((~isnan(PlotObject.es.reward)));
        RewardType = PlotObject.es.reward(RewardIndexes);
        j = 1;
        clear LickVector SpeedVector LickVector500ms
        for i=1:length(RewardIndexes)
            if PlotObject.es.traj(RewardIndexes(i))>(PlotObject.VR.EXP.rew_pos-PlotObject.VR.EXP.rew_tol) && PlotObject.es.traj(RewardIndexes(i))<(PlotObject.VR.EXP.rew_pos+PlotObject.VR.EXP.rew_tol)
                if RewardIndexes(i)-framerate*PSTH_interval>0 && RewardIndexes(i)+framerate*PSTH_interval<length(PlotObject.es.lick)
                    LickVector(j,:) = PlotObject.es.lick(RewardIndexes(i)-framerate*PSTH_interval:RewardIndexes(i)+framerate*PSTH_interval)';
                    SpeedVector(j,:) = PlotObject.es.ballspeed(RewardIndexes(i)-framerate*PSTH_interval:RewardIndexes(i)+framerate*PSTH_interval);
                    j = j + 1;
                end
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
        
        % plot PSTH of licks
        hb1 = subtightplot(10,1,1:4,[0.01 0.01],[0.01 0.01],[0.1 0.02]);
        set(hb1,'Parent',PlotObject.figHandle.PSTHLicksSpeed);
        plot(linspace(-PSTH_interval,PSTH_interval,HalfSecondintervals), sum(LickVector500ms,1))
        hold on
        plot([0 0], [0 max(sum(LickVector500ms,1))],'--k','LineWidth',2)
        set(gca,'box','off','TickDir','out', 'XTick',-PSTH_interval:1:PSTH_interval, 'XTickLabel',[]);
        if max(sum(LickVector500ms,1))<20
            set(gca,'YTick',[5:5:max(5,max(sum(LickVector500ms,1)))],...
                'YTickLabel',[5:5:max(5,max(sum(LickVector500ms,1)))]);
        else
            set(gca,'YTick',[10:10:max(5,max(sum(LickVector500ms,1)))],...
                'YTickLabel',[10:10:max(5,max(sum(LickVector500ms,1)))]);
        end
        ylabel('Licks');
        ylim([0 max(sum(LickVector500ms,1))]);
        text(-3,max(5,max(sum(LickVector500ms,1)))-1,'Reward Release');
        % plot mean of speed
        hb2 = subtightplot(10,1,5:10,[0.15 0.01],[0.15 0.01],[0.1 0.02])
        set(hb2,'Parent',PlotObject.figHandle.PSTHLicksSpeed);
        shadedErrorBar(-PSTH_interval:1/framerate:PSTH_interval,MeanSpeed,SEMSpeed)
        set(gca,'box','off','TickDir','out', 'XTick',-PSTH_interval:1:PSTH_interval, ...
            'XTickLabel',-PSTH_interval:1:PSTH_interval);
        if max(MeanSpeed)<5
            set(gca,'YTick',1:1:5,...
                'YTickLabel',1:1:5);
            ylim([0 max(MeanSpeed)]);
        else
            set(gca,'YTick',5:5:max(5,max(MeanSpeed)),...
                'YTickLabel',5:5:max(5,max(MeanSpeed)));
            ylim([0 max(5,max(MeanSpeed))]);
        end
        xlabel('seconds'); ylabel('speed');
    else
        text(0.1,0.5,'no water rewards were recorded during this session!')
    end
    
end

end