function [fhandle, runInfo] = prepTrialStruct(rigInfo, hwInfo, expInfo, runInfo)
% prepTrialStruct
% initializes trial specific information such us initializing base
% information

global TRIAL; % save trial specific info here

runInfo.currTrial = 1;
switch expInfo.EXP.trajDir
    case 'cw'
        runInfo.TRAJ = expInfo.EXP.delta;
    case 'ccw'
        runInfo.TRAJ = expInfo.EXP.l - expInfo.EXP.delta;
    otherwise 
        runInfo.TRAJ = round(expInfo.EXP.a1/10);
end



runInfo.TRIAL_COUNT = runInfo.TRIAL_COUNT + 1;
runInfo.SAVE_COUNT = 0;

info = [];

info.no = runInfo.TRIAL_COUNT;
info.epoch = 0; %number of steps within a run loop
info.abort = 0;
info.start = -1; % it will be set at the beginning of run.m

TRIAL.info = info;
TRIAL.trialContr = [expInfo.EXP.contrLevels(1) NaN.*ones(1,expInfo.EXP.maxTraj-1)];
TRIAL.trialStart = NaN.*ones(1,expInfo.EXP.maxTraj);
TRIAL.trialGain  = NaN.*ones(1,expInfo.EXP.maxTraj);
TRIAL.trialBlanks  = NaN.*ones(1,expInfo.EXP.maxTraj);
TRIAL.trialActive = 0.*ones(1,expInfo.EXP.maxTraj);
TRIAL.trialRewPos = 110.*ones(1,expInfo.EXP.maxTraj);
TRIAL.trialRewVal   = NaN.*ones(1,expInfo.EXP.maxTraj);
TRIAL.trialOutcome = NaN.*ones(1,expInfo.EXP.maxTraj);

TRIAL.tex1pos   = NaN.*ones(1,expInfo.EXP.maxTraj);
TRIAL.tex2pos   = NaN.*ones(1,expInfo.EXP.maxTraj);
TRIAL.tex3pos   = NaN.*ones(1,expInfo.EXP.maxTraj);
TRIAL.tex4pos   = NaN.*ones(1,expInfo.EXP.maxTraj);
TRIAL.tex5pos   = NaN.*ones(1,expInfo.EXP.maxTraj);

TRIAL.waveLength= NaN.*ones(1,expInfo.EXP.maxTraj);
TRIAL.currList  = ones(1,expInfo.EXP.maxTraj);

%% setting up first trial
TRIAL.trialActive(1) = expInfo.EXP.active(1);
TRIAL.trialRewPos(1) = expInfo.EXP.rew_pos(1);
TRIAL.trialRewVal(1)    = expInfo.EXP.rew_val(1);
TRIAL.trialStart(1) = 0;
TRIAL.trialGain(1)  = 1;
TRIAL.trialBlanks(1) = expInfo.EXP.pause_frames;

TRIAL.tex1pos(1)    = expInfo.EXP.tex1pos(1);
TRIAL.tex2pos(1)    = expInfo.EXP.tex2pos(1);
TRIAL.tex3pos(1)    = expInfo.EXP.tex3pos(1);
TRIAL.tex4pos(1)    = expInfo.EXP.tex4pos(1);
TRIAL.tex5pos(1)    = expInfo.EXP.tex5pos(1);

TRIAL.waveLength(1) = expInfo.EXP.waveLength(1);
TRIAL.currList(1)   = 1;

fprintf('prepTrialStruct\n'); % debug
fprintf('*** trial %4d of %4d ***\n', TRIAL.info.no, expInfo.EXP.maxNTrials); % debug



TRIAL.posdata = zeros(expInfo.EXP.maxTraj, expInfo.EXP.maxTrialDuration*70,6,'double'); % x,y,z,theta,speed,inRoom
TRIAL.posdata(:,:,1) = 0;
TRIAL.traj      = zeros(expInfo.EXP.maxTraj, expInfo.EXP.maxTrialDuration*70,1,'double'); % 

TRIAL.pospars   = {'X','Y','Z','theta','speed','inRoom'};
TRIAL.time      = zeros(expInfo.EXP.maxTraj, expInfo.EXP.maxTrialDuration*70,'double');
TRIAL.balldata  = zeros(expInfo.EXP.maxTraj, expInfo.EXP.maxTrialDuration*70,5,'double');
TRIAL.lick      = zeros(expInfo.EXP.maxTraj, expInfo.EXP.maxTrialDuration*70,'double');


TRIAL.trialIdx = zeros(expInfo.EXP.maxTraj, expInfo.EXP.maxTrialDuration*70,'double'); %

% if ~REPLAY
if expInfo.EXP.changeLength
    if expInfo.EXP.randScale
        roomLength = expInfo.EXP.lengthSet(randi(length(expInfo.EXP.lengthSet)));
    else
        idx = runInfo.currTrial;
        if idx>length(expInfo.EXP.lengthSet)
            idx = rem(runInfo.currTrial, length(expInfo.EXP.lengthSet));
            if idx==0
                idx = length(expInfo.EXP.lengthSet);
            end
        end
        roomLength = expInfo.EXP.lengthSet(idx);
    end
else
    roomLength = 1;
end
TRIAL.trialRL(runInfo.currTrial) = roomLength;
% end

expInfo.EXP.tc1 = TRIAL.tex1pos(1);
expInfo.EXP.tc2 = TRIAL.tex2pos(1);
expInfo.EXP.tc3 = TRIAL.tex3pos(1);
expInfo.EXP.tc4 = TRIAL.tex4pos(1);
expInfo.EXP.tc5 = TRIAL.tex5pos(1);

%% *** LOAD THE ROOM HERE ***
if ~expInfo.REPLAY
    runInfo.ROOM = getRoomData(expInfo.EXP,TRIAL.trialRL(runInfo.currTrial));
else
    runInfo.ROOM = expInfo.OLD.ROOM;
end
%%

runInfo.rewStatus = zeros(size(expInfo.EXP.rewCorners));
TRIAL.nCompTraj = 1; % number of completed trajectories

if expInfo.REPLAY
    TRIAL = expInfo.OLD.TRIAL;
    TRIAL.info.abort = 0;
    TRIAL.currTime = zeros(size(TRIAL.time));
    runInfo.currTrial = 1;
    TRIAL.nCompTraj = 1;
end

rigInfo;
hwInfo;
expInfo;

fhandle =  @run_latest;
return
end
