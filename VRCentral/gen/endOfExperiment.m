function [fhandle, runInfo] = endOfExperiment(rigInfo, hwInfo, expInfo, runInfo)

global GL;

% cleans up and exits state system

fprintf('<stateSystem> endOfExperiment\n'); % debug
Priority(0);

if ~expInfo.OFFLINE
    VRmessage = ['VR_ExpEnd ' expInfo.animalName ' ' expInfo.dateStr ' ' expInfo.sessionName];
    rigInfo.sendUDPmessage(VRmessage);
    VRLogMessage(expInfo, VRmessage);
    pause(1)
    
    VRmessage = ['ExpEnd ' expInfo.animalName ' ' expInfo.dateStr ' ' expInfo.sessionName];
    rigInfo.sendUDPmessage(VRmessage);
    
    bothLogs = 'true';
    VRLogMessage(expInfo, VRmessage, bothLogs);
    emptyMessage = [];
    VRLogMessage(expInfo, emptyMessage, bothLogs);
    
    VRLogMessage(expInfo);
    
    if ~isempty(rigInfo.comms) %send message again in case there was an error
        rigInfo.comms.send('Bye','Bye');
    end
    
    rigInfo.closeUDPports;
end

pause(2)

Screen('CloseAll');

heapTotalMemory = java.lang.Runtime.getRuntime.totalMemory;
heapFreeMemory = java.lang.Runtime.getRuntime.freeMemory;

if(heapFreeMemory < (heapTotalMemory*0.1))
    java.lang.Runtime.getRuntime.gc;
    fprintf('\n garbage collection \n');
end

fhandle = []; % exit state system
if strcmp(rigInfo.DevType,'ARDUINO')
    fclose(hwInfo.ardDev);
end
clear mex;

end
