function [expInfo, runInfo, TRIAL] = setTrialparameters(expInfo, runInfo, TRIAL)

%% Set trial parameters
% fn = fieldnames(expInfo.EXP);
% fn_rand = endsWith(fn,'_rand');

% Room Length

% This is the combined function
% Room length
[TRIAL.trialRL(runInfo.currTrial), RLidx] = getNewTrialParameter(expInfo.EXP.lengthSet, expInfo.EXP.lengthSet_rand, runInfo, expInfo);

% Gain / scaling factor
TRIAL.trialGain(runInfo.currTrial) = getNewTrialParameter(expInfo.EXP.scaleSet, expInfo.EXP.scaleSet_rand, runInfo, expInfo);

% Active / Passive reward
TRIAL.trialActive(runInfo.currTrial) = getNewTrialParameter(expInfo.EXP.active, expInfo.EXP.active_rand, runInfo, expInfo);

% Reward position
TRIAL.trialRewPos(runInfo.currTrial) = getNewTrialParameter(expInfo.EXP.rew_pos, expInfo.EXP.rew_pos_rand, runInfo, expInfo);

TRIAL.trialRewPos(runInfo.currTrial) = TRIAL.trialRewPos(runInfo.currTrial).*TRIAL.trialRL(runInfo.currTrial);
expInfo.EXP.punishZone = TRIAL.trialRewPos(runInfo.currTrial) - expInfo.EXP.punishLim; % Needed??

% Set the texture positions
% Texture 1 position
[TRIAL.tex1pos(runInfo.currTrial), tc1idx] = getNewTrialParameter(expInfo.EXP.tex1pos, expInfo.EXP.tex1pos_rand, runInfo, expInfo);
expInfo.EXP.tc1 = TRIAL.tex1pos(runInfo.currTrial);
display(num2str(expInfo.EXP.tc1));
% Texture 2 position
[TRIAL.tex2pos(runInfo.currTrial), tc2idx] = getNewTrialParameter(expInfo.EXP.tex2pos, expInfo.EXP.tex2pos_rand, runInfo, expInfo);
expInfo.EXP.tc2 = TRIAL.tex2pos(runInfo.currTrial);
% Texture 3 position
[TRIAL.tex3pos(runInfo.currTrial), tc3idx] = getNewTrialParameter(expInfo.EXP.tex3pos, expInfo.EXP.tex3pos_rand, runInfo, expInfo);
expInfo.EXP.tc3 = TRIAL.tex3pos(runInfo.currTrial);
% Texture 4 position
[TRIAL.tex4pos(runInfo.currTrial), tc4idx] = getNewTrialParameter(expInfo.EXP.tex4pos, expInfo.EXP.tex4pos_rand, runInfo, expInfo);
expInfo.EXP.tc4 = TRIAL.tex4pos(runInfo.currTrial);
% 
% WaveLength
[TRIAL.waveLength(runInfo.currTrial), WLidx] = getNewTrialParameter(expInfo.EXP.waveLength, expInfo.EXP.waveLength_rand, runInfo, expInfo);

% Contrast
[TRIAL.trialContr(runInfo.currTrial), CONidx] = getNewTrialParameter(expInfo.EXP.contrLevels, expInfo.EXP.contrLevels_rand, runInfo, expInfo);
        
% Get the room data at the end of getting all the parameters
runInfo.ROOM = getRoomData(expInfo.EXP, TRIAL.trialRL(runInfo.currTrial));

% Start Position
% This is just doing a random start position based on the start region,
% running this is very different
if ~expInfo.EXP.randStart
    if strcmp(expInfo.EXP.trajDir,'cw')
        runInfo.TRAJ = 0.1;
    else
        runInfo.TRAJ = expInfo.EXP.l-0.1;
    end
else
    if strcmp(expInfo.EXP.trajDir,'cw')
        runInfo.TRAJ = expInfo.EXP.l;
    else
        runInfo.TRAJ = expInfo.EXP.l - expInfo.EXP.l*rand(1)*expInfo.EXP.startRegion;
    end
end
TRIAL.trialStart(runInfo.currTrial) = runInfo.TRAJ;

p = runInfo.TRAJ;

% Contrast has same structure but is within the setupTextures

X=1; Y=2; Z=3; T=4;
if ~expInfo.REPLAY
    TRIAL.posdata(runInfo.currTrial,runInfo.count,Z) = -p;
    TRIAL.posdata(runInfo.currTrial,runInfo.count,X) = 0;
    TRIAL.posdata(runInfo.currTrial,1,Y) = expInfo.EXP.c3;
    TRIAL.posdata(runInfo.currTrial,runInfo.count,T) = 0;
end

TRIAL.trialIdx(runInfo.currTrial,runInfo.count) = TRIAL.nCompTraj;

if ~expInfo.REPLAY
    switch expInfo.EXP.trajDir
        case 'ccw'
            TRIAL.posdata(runInfo.currTrial,runInfo.count,T) =  TRIAL.posdata(runInfo.currTrial,runInfo.count,T) + pi;
        otherwise
            TRIAL.posdata(runInfo.currTrial,runInfo.count,T) =  TRIAL.posdata(runInfo.currTrial,runInfo.count,T);
    end
end