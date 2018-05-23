%% TM - UCL - 16/05/2018   

% Single session general info display

%% premble useful as not using the expSelector correctly
% Select session
% Select session
function AnimalSessionInfo = GetSessionInfo(obj)

framerate = str2num(obj.es.sampleRate(1:2)); % Hz
%% Note 1
    % from the VR code
    % TRIAL.balldata(runInfo.currTrial,runInfo.count,:) = [ballTime, dax, dbx, day, dby];
    % so the position in recorded in the third column
%% Note 2
    % dbx = dbx*((2*pi*expInfo.EXP.wheelRadius)./(1024*4)); % (cm)% because it is a 4 x 1024 unit encoder
    % Because of the line above from run_latest,
    % to get the real speed we should multiply by 4 instead of
    % VR.EXP.wheelToVR= 3.9 (only before May, after just 1).

    
% session and mouse information (mouse name, date, time of the day, n-th day of training, session duration, total trial nr
obj.expObject.animal;                                          % mouse name
obj.expObject.iseries;                                         % date
for i = 1:length(obj.AnimalObject.seriesList)
    IseriesList(i) = str2double(obj.AnimalObject.seriesList(i));
end
IseriesList = sort(IseriesList);
SessionDay = find(IseriesList==obj.expObject.iseries);                      % n-th day of training
SessionDayFirst = min(IseriesList);                                                       % firs day of trainig
FileInfo = dir([obj.AnimalObject.dataDir filesep obj.AnimalObject.expObject.animal filesep num2str(obj.AnimalObject.expObject.iseries) filesep ...
    obj.AnimalObject.expObject.animal '_' num2str(obj.AnimalObject.expObject.iseries) '_session_' num2str(obj.AnimalObject.expObject.iexp) '_trial001.mat']);
SessionDate = FileInfo.date;                                                           % date and hour of creation
SessionDur = [num2str(floor(max(obj.es.sampleTimes)/60)) ' min ' num2str(mod(max(obj.es.sampleTimes),60),2) ' seconds']; % session duration
SessionTrials = max(obj.es.trialID);                                                         % total number of trials
% type of VR and task (PIT or not)
if strcmp(obj.VR.EXP.VRType,'Ruler') || strcmp(obj.VR.EXP.VRType,'PIT')
    VR_Type = 'Distance Estimation Task';
else
    VR_Type = 'Linear Beaconed';
end
% trial duration avg
i1=1; i2=1; clear TrialDuration_nc TrialDuration_fc
for i = 1:length(unique(obj.es.trialID))
    Y_pos = obj.es.traj(obj.es.trialID==i);
    if max(Y_pos) < obj.VR.EXP.l*0.99
        TrialDuration_nc(i1) = max(obj.es.sampleTimes(obj.es.trialID==i)) - min(obj.es.sampleTimes(obj.es.trialID==i)) - max(obj.es.blanks(obj.es.trialID==i))/framerate;
        i1 = i1 + 1;
    else
        TrialDuration_fc(i2) = max(obj.es.sampleTimes(obj.es.trialID==i)) - min(obj.es.sampleTimes(obj.es.trialID==i)) - max(obj.es.blanks(obj.es.trialID==i))/framerate;
        i2 = i2+1;
    end
end
AvgTrial_fc = mean(TrialDuration_fc);
AvgTrial_nc = mean(TrialDuration_nc);
% mean moving speed
speedWheel = obj.es.ballspeed*obj.VR.EXP.wheelToVR;
speedWheel(isnan(speedWheel)) = 0;
speed_smoothed = smooth(speedWheel,3);
SpeedMovingAvg = mean(speed_smoothed(abs(speed_smoothed)>2));
% max speed
SpeedMax = max(speed_smoothed);
% percentage of moving time
MovingTimePercent = length(speed_smoothed(abs(speed_smoothed)>2))/length(speed_smoothed)*100;
% total reward (active and passive)
RewardUser = length(sum(obj.es.reward(find(obj.es.reward==0)))); % user rewards
RewardPass = length(obj.es.reward(find(obj.es.reward==1))); % passive rewards
RewardActi = length(obj.es.reward(find(obj.es.reward==2))); % active rewards
% nr/licks per trial
LickPerTrial = sum(obj.es.lick)/max(obj.es.trialID);
% licks before and after reward release
LickPreR = sum(obj.es.lick(find(obj.es.traj(obj.es.traj<(obj.VR.EXP.rew_pos-obj.es.rewardTolerance))))==1);
LickPostR = sum(obj.es.lick)-LickPreR;

AnimalSessionInfo = { ...
                    obj.AnimalObject.expObject.animal; ...
                    obj.AnimalObject.expObject.iseries; ...
                    SessionDay; ...
                    SessionDayFirst; ...
                    SessionDate; ...
                    SessionDur; ...
                    SessionTrials; ...
                    VR_Type; ...
                    TrialDuration_nc; ...
                    TrialDuration_fc; ...
                    AvgTrial_fc; ...
                    AvgTrial_nc; ...
                    SpeedMovingAvg; ...
                    SpeedMax; ...
                    MovingTimePercent; ...
                    RewardUser; ...
                    RewardPass; ...
                    RewardActi; ...
                    LickPerTrial; ...
                    LickPreR; ...
                    LickPostR};
                    
                                     
end

