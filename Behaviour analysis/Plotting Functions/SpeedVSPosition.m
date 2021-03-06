%% TM - UCL - 22/03/2018   

% VR speed vs time plotter, trial per trial

%% premble useful as not using the expSelector correctly
% Select session
% Select session
obj = expSelector;
r = expObject;
r.animal = AnimalObject.expObject.animal;
r.iseries = AnimalObject.expObject.iseries;
r.exp_list = AnimalObject.expObject.iexp;
% load experiment
[VR, es, totalReward] = loadBehav(r);
% select trials from first
Tr_s = unique(es.iexp);

%% Note 1
    % from the VR code
    % TRIAL.balldata(runInfo.currTrial,runInfo.count,:) = [ballTime, dax, dbx, day, dby];
    % so the position in recorded in the third column
%% Note 2
    % dbx = dbx*((2*pi*expInfo.EXP.wheelRadius)./(1024*4)); % (cm)% because it is a 4 x 1024 unit encoder
    % Because of the line above from run_latest,
    % to get the real speed we should multiply by 4 instead of VR.EXP.wheelToVR=3.9 (before 22nd March)

%% actual plotting function
framerate = 60; % Hz
for i = 1:length(Tr_s)
    
    figure
    %% plot speed vs time
    c1=1; c2=1;
    TrackLength  = round(max(es.traj(find(es.iexp==Tr_s(i)))));
    for j = 1:size(es.trajspeed,1)
        % save segment with info of a single trial
        [max_v,max_i] = max(es.traj(min(find(es.trialID==j))+60:max(find(es.trialID==j)))); % added 60 frames rejection criterion at the beginning to avoid false maxima
        [min_v,min_i] = min(es.traj(min(find(es.trialID==j))+60:max(find(es.trialID==j))));
        % save position for each trial
        Y_pos = es.traj(find(es.traj(find(es.trialID==j))==min_v)+min(find(es.trialID==j))+60:find(es.traj(find(es.trialID==j))==max_v)+min(find(es.trialID==j)));
        % save timestamps of the trial and compute the time intervals
        TrialTime = es.sampleTimes(find(es.traj(find(es.trialID==j))==min_v)+min(find(es.trialID==j))+60:find(es.traj(find(es.trialID==j))==max_v)+min(find(es.trialID==j)));
        Time = TrialTime(2:end)-min(TrialTime(2:end));
        TimeDiff = diff(TrialTime); % in seconds
        % save the instantenous speed of the ball and of the VR
        Inst_Wheel_speed = es.ballspeed(find(es.traj(find(es.trialID==j))==min_v)+min(find(es.trialID==j))+60:find(es.traj(find(es.trialID==j))==max_v)+min(find(es.trialID==j)))*4;
        Inst_VR_speed = es.trajspeed(find(es.traj(find(es.trialID==j))==min_v)+min(find(es.trialID==j))+60:find(es.traj(find(es.trialID==j))==max_v)+min(find(es.trialID==j)))*4;        
        %figure
        %plot(Time/max(Time), smooth(Inst_Wheel_speed(2:end),30))
        %plot(TrialTime,Y_pos)
        % find whether the mouse run to the end of the corridor or not        
        if max(Y_pos) < TrackLength*0.99 % incomplete trials
            subplot(2,1,2)
            hold on
            if c1==1
                h(1) = plot(Time/max(Time), smooth(Inst_Wheel_speed(2:end),30), 'color',[0.7 0.7 0.7],'LineWidth', 1.5); % plot inst speed smoothed over 0.5 seconds
                c1=2;
            else
                plot(Time/max(Time), smooth(Inst_Wheel_speed(2:end),30), 'color',[0.7 0.7 0.7],'LineWidth', 1.5); % plot inst speed smoothed over 0.5 seconds
            end
        else 
            subplot(2,1,1)
            hold on
            if c2==1 % complete trials
                h(2) = plot(Time/max(Time), smooth(Inst_Wheel_speed(2:end),30), 'color','k','LineWidth', 1.5); % plot inst speed smoothed over 0.5 seconds
                c2=2;
            else
                plot(Time/max(Time), smooth(Inst_Wheel_speed(2:end),30), 'color','k','LineWidth', 1.5); % plot inst speed smoothed over 0.5 seconds
            end
        end
        
    end
    subplot(2,1,1)
    xlabel('normalised time (a.u.)'); ylabel('cm/s');
    set(gca,'TickDir','out','box','off')
    % set(gca,'XTick',0:10:ceil((max(max(VR.TRIAL.time))/60)/10)*10,'xTickLabel',0:10:ceil((max(max(VR.TRIAL.time))/60)/10)*10)
    % set(gca,'YTick',0:VR.EXP.l/5:VR.EXP.l,'yTickLabel',0:VR.EXP.l/5:VR.EXP.l)
    hold on
    ylim([-5 30])
    subplot(2,1,2)
    xlabel('normalised time (a.u.)'); ylabel('cm/s');
    set(gca,'TickDir','out','box','off')
    % set(gca,'XTick',0:10:ceil((max(max(VR.TRIAL.time))/60)/10)*10,'xTickLabel',0:10:ceil((max(max(VR.TRIAL.time))/60)/10)*10)
    % set(gca,'YTick',0:VR.EXP.l/5:VR.EXP.l,'yTickLabel',0:VR.EXP.l/5:VR.EXP.l)
    hold on
    ylim([-5 30])
    
end

