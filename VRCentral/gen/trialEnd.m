function [fhandle, runInfo] = trialEnd(rigInfo, hwInfo, expInfo, runInfo)

global TRIAL;
global GL;

if ~expInfo.OFFLINE
    VRmessage = ['BlockEnd ' expInfo.animalName ' ' expInfo.dateStr ' ' expInfo.sessionName];
    rigInfo.sendUDPmessage(VRmessage);
    if ~isempty(rigInfo.comms)
        rigInfo.comms.send('Bye','Bye');
    end
    VRLogMessage(expInfo, VRmessage);
end
if TRIAL.info.no > 0
    display('Ending expt');
    s = sprintf('%s_trial%03d', expInfo.SESSION_NAME, TRIAL.info.no);
    EXP    = expInfo.EXP;
    REWARD = runInfo.REWARD;
%     TRIAL  = runInfo.TRIAL;
    ROOM   = runInfo.ROOM;
    save(s, 'TRIAL', 'EXP', 'REWARD','ROOM','rigInfo');
end

fprintf('TrialEnd\n'); % debug

if TRIAL.nCompTraj > expInfo.EXP.maxTraj
    fhandle = @endOfExperiment;
    return;
end

if TRIAL.info.no == expInfo.EXP.maxNTrials
    fhandle = @endOfExperiment;
    return;
end

if TRIAL.info.abort == 1
    fhandle = @endOfExperiment;
    return;
end

hwInfo;

fhandle = @endOfExperiment;
return;
end