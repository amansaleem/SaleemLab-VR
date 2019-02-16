function runInfo = giveReward(count, tag, lastActiveBase, corner, expInfo, runInfo, hwInfo, rigInfo, rewScale)

% playSound('correctResponse');
% 'EXP.BASEvalveTime',1.5,...           % Reward for correct base
%              'EXP.PASSvalveTime',2,...           % Reward for correct base
%              'EXP.ACTVvalveTime',3,...           % Reward for correct base
if nargin<9
    rewScale = 1;
end

if ~expInfo.OFFLINE
    if(strcmp(runInfo.rewardStartT.Running, 'off') && strcmp(runInfo.STOPrewardStopT.Running,'off')...
            && strcmp(runInfo.BASErewardStopT.Running,'off'))
        VRmessage = ['Reward given at trial Time: ' num2str(round(count/(60*60))) ' min ' num2str(round(rem(count/60,60))) ' s ' tag];
        disp(VRmessage);
%         VRLogMessage(expInfo, VRmessage);
        
        runInfo.REWARD.TRIAL = [runInfo.REWARD.TRIAL lastActiveBase];
        runInfo.REWARD.count = [runInfo.REWARD.count count];
        % compute amount of time pinch valve needs to open for desired
        % amount
        [x, index] = min(abs(abs(expInfo.EXP.BASEvalveTime*rewScale)-rigInfo.RewardCal(:,2)));
        TotTime=round(rigInfo.RewardCal(index,1));% .*sign(rewScale);
        switch tag
            case 'STOP'
                if expInfo.EXP.soundOn
                    play(runInfo.oBeepSTOP);
                end
            switch rigInfo.DevType
                case 'NI'
                    hwInfo.rewVal.deliverBackground(abs(expInfo.EXP.BASEvalveTime*rewScale));
                case 'ARDUINO'
                    %fwrite(hwInfo.ardDev,20,'uint8');
                    flushinput(hwInfo.ardDev);
                    fprintf(hwInfo.ardDev, '%s\r', ['r' num2str(TotTime)]);
                    flushinput(hwInfo.ardDev);
            end
                    runInfo.REWARD.TYPE = [runInfo.REWARD.TYPE 0];
                    runInfo.REWARD.TotalValveOpenTime = runInfo.REWARD.TotalValveOpenTime + abs(expInfo.EXP.BASEvalveTime*rewScale);
            case 'ACTIVE'
                if expInfo.EXP.soundOn
                    play(runInfo.oBeepBASE);
                end
                switch rigInfo.DevType
                case 'NI'
                    hwInfo.rewVal.deliverBackground(abs(expInfo.EXP.ACTVvalveTime*rewScale));
                case 'ARDUINO'
                     %fwrite(hwInfo.ardDev,20,'uint8');
                    flushinput(hwInfo.ardDev);
                    fprintf(hwInfo.ardDev, '%s\r', ['r' num2str(TotTime)]);
                    flushinput(hwInfo.ardDev);
                end
                runInfo.REWARD.TYPE = [runInfo.REWARD.TYPE 2];
                runInfo.REWARD.TotalValveOpenTime = runInfo.REWARD.TotalValveOpenTime + abs(expInfo.EXP.ACTVvalveTime*rewScale);
            case 'PASSIVE'
                if expInfo.EXP.soundOn
                    play(runInfo.oBeepBASE);
                end
                switch rigInfo.DevType
                case 'NI'
                    hwInfo.rewVal.deliverBackground(abs(expInfo.EXP.PASSvalveTime*rewScale));
                case 'ARDUINO'
                     %fwrite(hwInfo.ardDev,20,'uint8');
                    flushinput(hwInfo.ardDev);
                    fprintf(hwInfo.ardDev, '%s\r', ['r' num2str(TotTime)]);
                    flushinput(hwInfo.ardDev);
                end
                runInfo.REWARD.TYPE = [runInfo.REWARD.TYPE 1];
                runInfo.REWARD.TotalValveOpenTime = runInfo.REWARD.TotalValveOpenTime + abs(expInfo.EXP.PASSvalveTime*rewScale);
            case 'BASE'
                if expInfo.EXP.soundOn
                    play(runInfo.oBeepBASE);
                end
                switch rigInfo.DevType
                case 'NI'
                    hwInfo.rewVal.deliverBackground(abs(expInfo.EXP.BASEvalveTime*rewScale));
                case 'ARDUINO'
                     %fwrite(hwInfo.ardDev,20,'uint8');
                    flushinput(hwInfo.ardDev);
                    fprintf(hwInfo.ardDev, '%s\r', ['r' num2str(TotTime)]);
                    flushinput(hwInfo.ardDev);
                end
                runInfo.REWARD.TYPE = [runInfo.REWARD.TYPE 1];
                runInfo.REWARD.TotalValveOpenTime = runInfo.REWARD.TotalValveOpenTime + abs(expInfo.EXP.BASEvalveTime*rewScale);
            case 'USER'
                if expInfo.EXP.soundOn
                    play(runInfo.oBeepBASE);
                end
                switch rigInfo.DevType
                case 'NI'
                    hwInfo.rewVal.deliverBackground(abs(expInfo.EXP.BASEvalveTime*rewScale));
                case 'ARDUINO'
                     %fwrite(hwInfo.ardDev,20,'uint8');
                    flushinput(hwInfo.ardDev);
                    fprintf(hwInfo.ardDev, '%s\r', ['r' num2str(TotTime)])
                    flushinput(hwInfo.ardDev);
                end
                runInfo.REWARD.TYPE = [runInfo.REWARD.TYPE 0];
                runInfo.REWARD.TotalValveOpenTime = runInfo.REWARD.TotalValveOpenTime + abs(expInfo.EXP.BASEvalveTime*rewScale);
            otherwise
                display('!!!!!!!!!!!No such sound!!!!!!!!!!!!!')
        end
        if ~isempty(rigInfo.comms)
            rigInfo.comms.send('reward', runInfo.REWARD.TotalValveOpenTime);
        end
    end
end

end