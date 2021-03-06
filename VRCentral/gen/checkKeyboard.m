function keyType = checkKeyboard(rigInfo)
% keyType -   1 abort
%             2 give water
keyType = 0;
[keyIsDown, secs, keyCode] = KbCheck; % Psychophysics toolbox
if keyIsDown
    if keyCode(32) % space
        keyType = 2;
    elseif keyCode(27) || keyCode(81) % q/Q QUIT or Esc
        keyType = 1;
    end
end
pause(1e-8);
if ~isempty(rigInfo.comms)
    if rigInfo.comms.IsMessageAvailable
        [msgId, data, host] = rigInfo.comms.receive;
        switch msgId
            case 'Reward'
                keyType = 2;
            case 'Quit'
                keyType = 1;
            otherwise
                display(['Recieved message from ' host ', says: ' msgId])
        end
        display(['Recieved message from ' host ', says: ' msgId])
    end
end