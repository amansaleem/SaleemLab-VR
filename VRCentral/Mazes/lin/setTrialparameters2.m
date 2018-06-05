function setTrialparameters2
%% Set trial parameters
% Room Length

% This is the combined function
% Room length
TRIAL.trialRL(runInfo.currTrial) = getNewTrialParameters(expInfo.EXP.lengthSet, runInfo, expInfo);

% Gain / scaling factor
TRIAL.trialGain(runInfo.currTrial) = getNewTrialParameters(expInfo.EXP.scaleSet, runInfo, expInfo);

% Active / Passive reward
TRIAL.trialActive(runInfo.currTrial) = getNewTrialParameters(expInfo.EXP.active, runInfo, expInfo);

% Reward position
TRIAL.trialRewPos(runInfo.currTrial) = getNewTrialParameters(expInfo.EXP.rew_pos, runInfo, expInfo);
TRIAL.trialRewPos(runInfo.currTrial) = TRIAL.trialRewPos(runInfo.currTrial).*TRIAL.trialRL(runInfo.currTrial);
expInfo.EXP.punishZone = TRIAL.trialRewPos(runInfo.currTrial) - expInfo.EXP.punishLim; % Needed??

% Set the texture positions
% Texture 1 position
TRIAL.tex1pos(runInfo.currTrial) = getNewTrialParameters(expInfo.EXP.tc1pos, runInfo, expInfo);
expInfo.EXP.tc1 = TRIAL.tex1pos;
% Texture 2 position
TRIAL.tex2pos(runInfo.currTrial) = getNewTrialParameters(expInfo.EXP.tc2pos, runInfo, expInfo);
expInfo.EXP.tc2 = TRIAL.tex2pos;
% Texture 3 position
TRIAL.tex3pos(runInfo.currTrial) = getNewTrialParameters(expInfo.EXP.tc3pos, runInfo, expInfo);
expInfo.EXP.tc3 = TRIAL.tex3pos;
% Texture 4 position
TRIAL.tex4pos(runInfo.currTrial) = getNewTrialParameters(expInfo.EXP.tc4pos, runInfo, expInfo);
expInfo.EXP.tc4 = TRIAL.tex4pos;

% Get the room data at the end of getting all the parameters
runInfo.ROOM = getRoomData(expInfo.EXP,TRIAL.trialRL(runInfo.currTrial));

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

display_text = ['Trial ' num2str(runInfo.currTrial) ...
    ', C: ' num2str(TRIAL.trialContr(runInfo.currTrial)) ...
    ', G: ' num2str(TRIAL.trialGain(runInfo.currTrial)) ...
    ', RL: ' num2str(TRIAL.trialRL(runInfo.currTrial)) ...
    ', S: ' num2str(TRIAL.trialStart(runInfo.currTrial)) ...
    ', B: ' num2str(TRIAL.trialBlanks(runInfo.currTrial)) ...
    ', A: ' num2str(TRIAL.trialActive(runInfo.currTrial)) ...
    ', RP: ' num2str(TRIAL.trialRewPos(runInfo.currTrial)) ...
    ', PZ: ' num2str(expInfo.EXP.punishZone) ...
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

    function currTrialVar = getNewTrialParameters(varArray, runInfo, expInfo)
        if length(varArray)>1
            if expInfo.EXP.randScale
                varToSet = varArray(randi(length(varArray)));
            else
                varIdx = runInfo.currTrial;
                if varIdx>length(varArray)
                    varIdx = rem(runInfo.currTrial, length(varArray));
                    if varIdx==0
                        varIdx = length(varArray);
                    end
                end
                varToSet = varArray(varIdx);
            end
        else
            varToSet = 1;
        end
        currTrialVar = varToSet;
    end
end