%% TM - UCL - 21/03/2018   

% VR position vs time plotter, trial per trial
%% premble useful as not using the expSelector correctly

% Select session
es = expSelector;
createUI(es);
% load experiment
obj = es.expObject
[VR, ~, es] = VRWheelLoad_SL(obj.animal, obj.iseries, obj.iexp);
% select trials from first
Tr_s = unique(es.iexp);

%% actual plotting function
framerate = 60; % Hz
for i = 1:length(Tr_s)
         
    Trial_NR = max(es.trialID(find(es.iexp==Tr_s(i))));
    %% plot trial trajectories, in gray unfinished trials
    figure
    hold on
    c1=1; c2=1;
    for j = 1:Trial_NR
        [max_v,max_i] = max(es.traj(min(find(es.trialID==j))+60:max(find(es.trialID==j)))); % added 60 frames rejection criterion at the beginning to avoid false maxima
        [min_v,min_i] = min(es.traj(min(find(es.trialID==j))+60:max(find(es.trialID==j))));
        Y_pos = es.traj(find(es.traj(find(es.trialID==j))==min_v)+min(find(es.trialID==j))+60:find(es.traj(find(es.trialID==j))==max_v)+min(find(es.trialID==j)));
        TrialTime = es.sampleTimes(find(es.traj(find(es.trialID==j))==min_v)+min(find(es.trialID==j))+60:find(es.traj(find(es.trialID==j))==max_v)+min(find(es.trialID==j)));
        if max(Y_pos)< VR.EXP.l*0.99
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
    set(gca,'XTick',0:300:ceil(max(es.sampleTimes)),'xTickLabel',0:5:ceil((max(es.sampleTimes)/60)/5)*5)
    set(gca,'YTick',0:VR.EXP.l/5:VR.EXP.l,'yTickLabel',0:VR.EXP.l/5:VR.EXP.l)
    xlim([0 ceil(max(es.sampleTimes))]);
    hold on
    %% plot reward releases   
    c1=1; c2=1; c3=1; c4=1;
    hold on
    h(3) = plot(es.sampleTimes(find(es.reward==0)),es.traj(find(es.reward==0)),'s','color',[0.5 0.5 0.5],'lineWidth',1); % user rewards
    h(4) = plot(es.sampleTimes(find(es.reward==1)),es.traj(find(es.reward==1)),'o','color',[0.5 0.5 0.5],'lineWidth',1); % passive rewards
    h(5) = plot(es.sampleTimes(find(es.reward==2)),es.traj(find(es.reward==2)),'o','color','k','lineWidth',1.5); % active rewards
    
    %% plot lick events
    h(6) = plot(es.sampleTimes(find(es.lick==1)),es.traj(find(es.lick==1)),'+','color','b','lineWidth',1);
       
    
    LegendItems = { 'position in interrupted trials', ... 
                    'position in completed trials', ...
                    'user reward releases', ...
                    'passive reward releases', ...
                    'active reward releases', ...
                    'licks' ...
                    }; 
    legend(h,LegendItems,'Location', 'Northeast');
    
end