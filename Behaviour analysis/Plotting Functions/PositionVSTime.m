%% TM - UCL - 21/03/2018   
% 18/05/2018 can't display the legend on the big plot

% VR position vs time plotter, trial per trial

%% plot info from only one session
% select trials from first

function PositionVSTime(PlotObject, AnimalSessionInfo);

Tr_s = unique(PlotObject.es.iexp);
% actual plotting function
framerate = str2num(PlotObject.es.sampleRate(1:2)); % Hz
for i = 1:length(Tr_s)
         
    Trial_NR = max(PlotObject.es.trialID(find(PlotObject.es.iexp==Tr_s(i))));
    %% plot trial trajectories, in gray unfinished trials
    %figure
    hold on
    c1=1; c2=1;
    TrackLength  = PlotObject.VR.EXP.l;
    for j = 1:Trial_NR
        [max_v,max_i] = max(PlotObject.es.traj(min(find(PlotObject.es.trialID==j))+60:max(find(PlotObject.es.trialID==j)))); % added 60 frames rejection criterion at the beginning to avoid false maxima
        [min_v,min_i] = min(PlotObject.es.traj(min(find(PlotObject.es.trialID==j))+60:max(find(PlotObject.es.trialID==j))));
        Y_pos = PlotObject.es.traj(find(PlotObject.es.traj(find(PlotObject.es.trialID==j))==min_v)+min(find(PlotObject.es.trialID==j))+framerate*1:find(PlotObject.es.traj(find(PlotObject.es.trialID==j))==max_v)+min(find(PlotObject.es.trialID==j)));
        TrialTime = PlotObject.es.sampleTimes(find(PlotObject.es.traj(find(PlotObject.es.trialID==j))==min_v)+min(find(PlotObject.es.trialID==j))+framerate*1:find(PlotObject.es.traj(find(PlotObject.es.trialID==j))==max_v)+min(find(PlotObject.es.trialID==j)));
        if max(Y_pos)< TrackLength*0.99
            if c1==1
                h(1) = plot(TrialTime,Y_pos,'color',[0.7 0.7 0.7],'LineWidth', 1.5);
                c1=1;
            else
                plot(TrialTime,Y_pos,'color',[0.7 0.7 0.7],'LineWidth', 1.5);
            end
        else
            if c2==1
                h(2) = plot(TrialTime,Y_pos,'color','k','LineWidth', 1.5);
                c2=2;
            else
                plot(TrialTime,Y_pos,'color','k','LineWidth', 1.5);
            end
        end
        hold on    
    end
    xlabel('minutes'); ylabel('cm');
    set(gca,'TickDir','out','box','off')
    set(gca,'XTick',0:300:ceil(max(PlotObject.es.sampleTimes)),'xTickLabel',0:5:ceil((max(PlotObject.es.sampleTimes)/60)/5)*5)
    set(gca,'YTick',0:TrackLength/5:TrackLength,'yTickLabel',0:TrackLength/5:TrackLength)
    xlim([0 ceil(max(PlotObject.es.sampleTimes))]);
    hold on
    %% plot reward releases   
    c1=1; c2=1; c3=1; c4=1;
    hold on
    h(3) = plot(PlotObject.es.sampleTimes(find(PlotObject.es.reward==0)),PlotObject.es.traj(find(PlotObject.es.reward==0)),'s','color',[0.5 0.5 0.5],'lineWidth',1); % user rewards
    h(4) = plot(PlotObject.es.sampleTimes(find(PlotObject.es.reward==1)),PlotObject.es.traj(find(PlotObject.es.reward==1)),'o','color',[0.5 0.5 0.5],'lineWidth',1); % passive rewards
    h(5) = plot(PlotObject.es.sampleTimes(find(PlotObject.es.reward==2)),PlotObject.es.traj(find(PlotObject.es.reward==2)),'o','color','k','lineWidth',1.5); % active rewards
    
    %% plot lick events
    h(6) = plot(PlotObject.es.sampleTimes(find(PlotObject.es.lick==1)),PlotObject.es.traj(find(PlotObject.es.lick==1)),'+','color','b','lineWidth',1);
       
%     
    LegendItems = { 'position in interrupted trials', ... 
                    'position in completed trials', ...
                    'user reward releases', ...
                    'passive reward releases', ...
                    'active reward releases', ...
                    'licks' ...
                    }; 
    
    %legend(h,LegendItems,'Location', 'Northeast');
%     
end

end