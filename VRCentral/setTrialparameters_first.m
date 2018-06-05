function setTrialparameters_first
%% First trial settings
if ~expInfo.EXP.randStart
    if strcmp(expInfo.EXP.trajDir,'cw')
        runInfo.TRAJ = 0.1;
    else
        runInfo.TRAJ = expInfo.EXP.l-0.1;
    end
else
    if strcmp(expInfo.EXP.trajDir,'cw')
        runInfo.TRAJ = 1;
    else
        runInfo.TRAJ = expInfo.EXP.l- expInfo.EXP.l*rand(1)*expInfo.EXP.startRegion;
    end        
end

TRIAL.trialStart(runInfo.currTrial) = runInfo.TRAJ;

if expInfo.EXP.randContr
    contrLevel = expInfo.EXP.contrLevels(randi(length(expInfo.EXP.contrLevels)));
else
    idxc = runInfo.currTrial;
    if idxc>length(expInfo.EXP.contrLevels)
        idxc = rem(runInfo.currTrial, length(expInfo.EXP.contrLevels));
        if idxc==0
            idxc = length(expInfo.EXP.contrLevels);
        end
    end
    contrLevel = expInfo.EXP.contrLevels(idxc);
end
TRIAL.trialContr(runInfo.currTrial) = contrLevel;


if strcmp(rigInfo.DevType,'NI')
    hwInfo.rotEnc.zero;
    hwInfo.likEnc.zero;
end
likCount = 0;

% Scaling of the room
if expInfo.EXP.scaling
    if expInfo.EXP.randScale
        scaling_factor = expInfo.EXP.scaleSet(randi(length(expInfo.EXP.scaleSet)));
    else
        idx = runInfo.currTrial;
        if idx>length(expInfo.EXP.scaleSet)
            idx = rem(runInfo.currTrial, length(expInfo.EXP.scaleSet));
            if idx==0
                idx = length(expInfo.EXP.scaleSet);
            end
        end
        scaling_factor = expInfo.EXP.scaleSet(idx);
    end
else
    scaling_factor = 1;
end
TRIAL.trialGain(runInfo.currTrial) = scaling_factor;

% Active/Passive reward
idx = runInfo.currTrial;
if idx>length(expInfo.EXP.active)
    idx = rem(runInfo.currTrial, length(expInfo.EXP.active));
    if idx==0
        idx = length(expInfo.EXP.active);
    end
end
TRIAL.trialActive(runInfo.currTrial) = expInfo.EXP.active(idx);

% Reward Position
% Active/Passive reward
idx = runInfo.currTrial;
if idx>length(expInfo.EXP.rew_pos)
    idx = rem(runInfo.currTrial, length(expInfo.EXP.rew_pos));
    if idx==0
        idx = length(expInfo.EXP.rew_pos);
    end
end

TRIAL.trialRewPos(runInfo.currTrial) = expInfo.EXP.rew_pos(idx);
expInfo.EXP.punishZone = TRIAL.trialRewPos(runInfo.currTrial) - expInfo.EXP.punishLim;
% end
display_text = ['Trial ' num2str(runInfo.currTrial) ...
    ', C: ' num2str(TRIAL.trialContr(runInfo.currTrial)) ...
    ', G: ' num2str(TRIAL.trialGain(runInfo.currTrial)) ...
    ', RL: ' num2str(TRIAL.trialRL(runInfo.currTrial)) ...
    ', S: ' num2str(TRIAL.trialStart(runInfo.currTrial)) ...
    ', B: ' num2str(TRIAL.trialBlanks(runInfo.currTrial)) ...
    ', A: ' num2str(TRIAL.trialActive(runInfo.currTrial)) ...
    ', RP: ' num2str(TRIAL.trialRewPos(runInfo.currTrial)) ...
    ', PZ: ' num2str(expInfo.EXP.punishZone) ... redundant ??
    ];
display(['Trial ' num2str(runInfo.currTrial) ...
    ', C: ' num2str(TRIAL.trialContr(runInfo.currTrial)) ...
    ', G: ' num2str(TRIAL.trialGain(runInfo.currTrial)) ...
    ', RL: ' num2str(TRIAL.trialRL(runInfo.currTrial)) ...
    ', S: ' num2str(TRIAL.trialStart(runInfo.currTrial)) ...
    ', B: ' num2str(TRIAL.trialBlanks(runInfo.currTrial)) ...
    ', A: ' num2str(TRIAL.trialActive(runInfo.currTrial)) ...
    ', RP: ' num2str(TRIAL.trialRewPos(runInfo.currTrial)) ...
    ', PZ: ' num2str(expInfo.EXP.punishZone) ...
    ]);
if ~isempty(rigInfo.comms)
    rigInfo.comms.send('currentTrial',num2str(runInfo.currTrial));
    rigInfo.comms.send('trialParam',display_text);
end