classdef VRRigInfo < handle
    
    properties
        % Local computer info (basic)
        computerName;
        screenNumber;
        screenDist = 20;
        photodiodePos = 'left';
        photodiodeSize;
        photodiodeRect = [0 0 1 1];
        % NI card info
        DevType = 'NI'; %('NI' / 'ARDUINO')
        NIdevID = 'Dev1';
        NIsessRate = 10000;
        NIRotEnc = 'ctr0';
        NILicEnc = 'ctr1';
        NIRewVal = 'ao0';
        ARDrotCountPos = 1;
        ARDCOMPort = 7;
        ARDHistory = [0 0];
        % Other
        rotEncPos = 'left';
        % Saving directories
        dirSave = 'C:\Behaviour';
        dirCode = '\\zserver.cortexlab.net\Code\MouseRoom\VRCentral\';
        % Screen related info
        screenCalibration = true;
        dirScreenCalib;
        filenameScreenCalib;
        screenType = '3SCREEN'; %'3SCREEN', 'DOME'
        numCameras = 1; %
        % External computer connection info
        % (These are optinal)
        numConnect = 0;
        connectIPs = [];
        connectPCs = [];
        activePorts = [];
        sendTTL = 0;
        TTLchannel = [];
        dialogueXYPosition = [100 100];
        runTimeLine = 0;
        comms = [];
    end
    
    methods
        function RigInfo = VRRigInfo
            
            [foo,hostname] = system('hostname'); %#ok<ASGLU>
            hostname = upper(hostname(1:end-1));
            fprintf('Host name is %s\n', hostname);
            
            switch upper(hostname)
                %%
                case 'ZUPERVISION'
                    % Local computer info (basic)
                    %
                    %%
                 case 'SALEEM01'
                    % Local computer info (basic)
                    RigInfo.computerName = 'SALEEM01';
                    RigInfo.screenNumber = 2;
                    RigInfo.screenDist = 60; % in cm
                    RigInfo.dialogueXYPosition = [440 150];
                    
                    RigInfo.screenType = '3SCREEN';
                    RigInfo.numCameras = 3;
                    
                    RigInfo.DevType = 'ARDUINO';
                    RigInfo.ARDrotCountPos = 1;
                    RigInfo.ARDCOMPort = 3;
                    RigInfo.ARDHistory = [0 0];
                    
                    RigInfo.NIdevID = 'Dev1';
                    RigInfo.NIsessRate = 10000;
                    RigInfo.NIRotEnc = 'ctr0';
                    RigInfo.NILicEnc = 'ctr1';
                    RigInfo.NIRewVal = 'ao1';
                    RigInfo.photodiodePos  = 'right';
                    RigInfo.photodiodeSize = [75 75];
                    RigInfo.rotEncPos = 'left';
                    % Saving directories
                    % local
%                     serverName    = 'zserver';
%                     serverDataDir = [filesep filesep serverName filesep 'Data' filesep];
                    RigInfo.dirSave = ['C:\Home\Data\ball'];
                    RigInfo.dirCode = ['C:\Home\Code\VR-Stimulus-master\SaleemLab-VR\VRCentral'];
                    % Screen related info
                    RigInfo.screenCalibration = false;
                    RigInfo.dirScreenCalib = 'C:\Home\Code\VR-Stimulus-master\Linear Track Behav - 2pNew - Dev Version - Copy\'%'C:\Users\Aman\AppData\Roaming\Psychtoolbox\GeometryCalibration\';%'C:\Users\experimenter\AppData\Roaming\Psychtoolbox\GeometryCalibration\';
                    RigInfo.filenameScreenCalib = 'geometricCorr_2.mat';%'test.mat';%'HalfCylinderCalibdata_2_2695_1024.mat';%'HalfCylinderCalibdata_1_2400_600.mat';
                    % External computer connection info
                    % (These are optinal)
                    RigInfo.connectIPs{1} = []; % 'Zirkus'
                    RigInfo.connectPCs{1} = [];
%                     
%                     RigInfo.connectIPs{2} = '144.82.135.51'; % 'Zankh'
%                     RigInfo.connectPCs{2} = 'Zankh';
%                     
%                     RigInfo.connectIPs{3} = '144.82.135.117'; % 'Zankh'
%                     RigInfo.connectPCs{3} = 'Zoo';
                    
                    RigInfo.numConnect = length(RigInfo.connectIPs);
                    RigInfo.sendTTL = 0;
                    RigInfo.TTLchannel = [];
                    RigInfo.runTimeLine = 0;
                
                case 'SALEEM04'
                    % Local computer info (basic)
                    RigInfo.computerName = 'SALEEM04';
                    RigInfo.screenNumber = 2;
                    RigInfo.screenDist = 60; % in cm
                    RigInfo.dialogueXYPosition = [440 150];
                    
                    RigInfo.screenType = 'DOME';
                    RigInfo.numCameras = 3;
                    
                    RigInfo.DevType = 'ARDUINO';
                    RigInfo.ARDrotCountPos = 1;
                    RigInfo.ARDCOMPort = 3;
                    RigInfo.ARDHistory = [0 0];
                    
                    RigInfo.NIdevID = 'Dev1';
                    RigInfo.NIsessRate = 10000;
                    RigInfo.NIRotEnc = 'ctr0';
                    RigInfo.NILicEnc = 'ctr1';
                    RigInfo.NIRewVal = 'ao1';
                    RigInfo.photodiodePos  = 'right';
                    RigInfo.photodiodeSize = [75 75];
                    RigInfo.rotEncPos = 'left';
                    % Saving directories
                    % local
%                     serverName    = 'zserver';
%                     serverDataDir = [filesep filesep serverName filesep 'Data' filesep];
                    RigInfo.dirSave = ['C:\Home\Data\ball'];
                    RigInfo.dirCode = ['C:\Home\Code\VR-Stimulus-master\SaleemLab-VR\VRCentral'];
                    % Screen related info
                    RigInfo.dirScreenCalib = 'C:\Home\Code\VR-Stimulus-master\Linear Track Behav - 2pNew - Dev Version - Copy\'%'C:\Users\Aman\AppData\Roaming\Psychtoolbox\GeometryCalibration\';%'C:\Users\experimenter\AppData\Roaming\Psychtoolbox\GeometryCalibration\';
                    RigInfo.filenameScreenCalib = 'geometricCorr_2.mat';%'test.mat';%'HalfCylinderCalibdata_2_2695_1024.mat';%'HalfCylinderCalibdata_1_2400_600.mat';
                    % External computer connection info
                    % (These are optinal)
                    RigInfo.connectIPs{1} = []; % 'Zirkus'
                    RigInfo.connectPCs{1} = [];
%                     
%                     RigInfo.connectIPs{2} = '144.82.135.51'; % 'Zankh'
%                     RigInfo.connectPCs{2} = 'Zankh';
%                     
%                     RigInfo.connectIPs{3} = '144.82.135.117'; % 'Zankh'
%                     RigInfo.connectPCs{3} = 'Zoo';
                    
                    RigInfo.numConnect = length(RigInfo.connectIPs);
                    RigInfo.sendTTL = 0;
                    RigInfo.TTLchannel = [];
                    RigInfo.runTimeLine = 0;
                    
                case 'ZUPERDUPER'
                    % Local computer info (basic)
                    RigInfo.computerName = 'ZUPERDUPER';
                    RigInfo.screenNumber = 1;
                    RigInfo.screenDist = 34;
                    RigInfo.dialogueXYPosition = [2600 -200];
                    
                    RigInfo.NIdevID = 'Dev1';
                    RigInfo.NIsessRate = 10000;
                    RigInfo.NIRotEnc = 'ctr0';
                    RigInfo.NILicEnc = 'ctr1';
                    RigInfo.NIRewVal = 'ao1';
                    RigInfo.photodiodePos  = 'left';
                    RigInfo.photodiodeSize = [250 75];
                    RigInfo.rotEncPos = 'left';
                    % Saving directories
                    % remote
                    serverName    = 'zserver';
                    serverDataDir = [filesep filesep serverName filesep 'Data' filesep];
                    RigInfo.dirSave = [serverDataDir 'ball'];
                    % Screen related info
                    RigInfo.dirScreenCalib = 'C:\Users\experimenter\AppData\Roaming\Psychtoolbox\GeometryCalibration\';
                    RigInfo.filenameScreenCalib = 'HalfCylinderCalibdata_1_2400_600.mat';
                    % External computer connection info
                    % (These are optinal)
                    RigInfo.connectIPs{1} = '144.82.135.308'; % 'Zirkus'
                    RigInfo.connectPCs{1} = 'Zirkus';
                    
                    RigInfo.connectIPs{2} = '144.82.135.51'; % 'Zankh'
                    RigInfo.connectPCs{2} = 'Zankh';
                    
                    RigInfo.connectIPs{3} = '144.82.135.117'; % 'Zankh'
                    RigInfo.connectPCs{3} = 'Zoo';
                    
                    RigInfo.numConnect = length(RigInfo.connectIPs);
                    RigInfo.sendTTL = 0;
                    RigInfo.TTLchannel = [];
                case 'ZOOROPA'
                    % Local computer info (basic)
                    RigInfo.computerName = 'ZOOROPA';
                    RigInfo.screenNumber = 2;
                    RigInfo.screenDist = 15;
                    RigInfo.dialogueXYPosition = [3950 300];
                    
                    RigInfo.NIdevID = 'Dev1';
                    RigInfo.NIsessRate = 5000;
                    RigInfo.NIRotEnc = 'ctr0';
                    RigInfo.NILicEnc = 'ctr2';
                    RigInfo.NIRewVal = 'ao1';
                    RigInfo.photodiodePos  = 'left';
                    RigInfo.photodiodeSize =  [400 75];     %[250 75];
                    RigInfo.rotEncPos = 'right';
                    % Saving directories
                    % remote
                    serverName    = 'zserver';
                    serverDataDir = [filesep filesep serverName filesep 'Data' filesep];
                    RigInfo.dirSave = [serverDataDir 'ball'];
                    % Screen related info
                    rect = Screen('Rect',RigInfo.screenNumber);
                    
                    RigInfo.dirScreenCalib = 'C:\Users\Experiment\AppData\Roaming\Psychtoolbox\GeometryCalibration\';
                    if rect(4)==600
                        RigInfo.filenameScreenCalib = 'HalfCylinderCalibdata_2_2400_600.mat';
                    else
                        RigInfo.filenameScreenCalib = 'HalfCylinderCalibdata_2_3840_1024.mat';
                    end
                    % External computer connection info
                    % (These are optinal)
                    RigInfo.connectIPs{1} = '144.82.135.104';
                    RigInfo.connectPCs{1} = 'Zamera1';
                    
                    RigInfo.connectIPs{2} = '144.82.135.105';
                    RigInfo.connectPCs{2} = 'Zamera2';
                    
                    RigInfo.connectIPs{3} = '144.82.135.103';
                    RigInfo.connectPCs{3} = 'ZI';
                    
                    RigInfo.numConnect = length(RigInfo.connectIPs);
                    RigInfo.sendTTL = 1;
                    RigInfo.TTLchannel = 'Port0/Line0';
                case 'ZURPRISE'
                    % Local computer info (basic)
                    RigInfo.computerName = 'ZURPRISE';
                    RigInfo.screenNumber = 2;
                    RigInfo.screenDist = 19;
                    RigInfo.dialogueXYPosition = [200 300];
                    
                    RigInfo.NIdevID = 'Dev1';
                    RigInfo.NIsessRate = 5000;
                    RigInfo.NIRotEnc = 'ctr1';
                    RigInfo.NILicEnc = 'ctr2';
                    RigInfo.NIRewVal = 'ao1';
                    RigInfo.photodiodePos  = 'left';
                    RigInfo.photodiodeSize =  [400 75];     %[250 75];
                    RigInfo.rotEncPos = 'right';
                    % Saving directories
                    % remote
                    serverName    = 'zserver';
                    serverDataDir = [filesep filesep serverName filesep 'Data' filesep];
                    RigInfo.dirSave = [serverDataDir 'ball'];
                    % Screen related info
                    rect = Screen('Rect',RigInfo.screenNumber);
                    
                    RigInfo.dirScreenCalib = 'C:\Users\Experiment\AppData\Roaming\Psychtoolbox\GeometryCalibration\';
                    RigInfo.filenameScreenCalib = 'HalfCylinderCalibdata_2_3840_1024.mat';
                    
                    % External computer connection info
                    % (These are optinal)
                    RigInfo.connectIPs{1} = '144.82.135.91';
                    RigInfo.connectPCs{1} = 'ZYLVIA';
                    
                    RigInfo.connectIPs{2} = '144.82.135.100';
                    RigInfo.connectPCs{2} = 'ZIMAGE';
%                     
%                     RigInfo.connectIPs{3} = '144.82.135.103';
%                     RigInfo.connectPCs{3} = 'ZI';
                    
                    RigInfo.numConnect = length(RigInfo.connectIPs);
                    RigInfo.sendTTL = 1;
                    RigInfo.TTLchannel = 'Port0/Line0';
                otherwise
                    %                     RigInfo.thisScreen=max(screens);
            end
        end
        
        function initialiseUDPports(RigInfo)
            if RigInfo.numConnect>0
                for iIP = 1:RigInfo.numConnect
                    RigInfo.activePorts{iIP} = pnet('udpsocket', 1001);
                    pnet(RigInfo.activePorts{iIP}, 'udpconnect', RigInfo.connectIPs{iIP},1001);
                    display(['Sent message to ' RigInfo.connectPCs{iIP}]);
                end
            end
        end
        function sendUDPmessage(RigInfo, blah)
            if RigInfo.numConnect>0
                for iIP = 1:RigInfo.numConnect
                    pnet(RigInfo.activePorts{iIP},'write',blah);
                    pnet(RigInfo.activePorts{iIP}, 'writePacket');
                end
            end
        end
        function updateTTL(RigInfo,state)
            RigInfo.TTLchannel.outputSingleScan(state);
        end
        function closeUDPports(RigInfo)
            if RigInfo.numConnect>0
                for iIP = 1:RigInfo.numConnect
                    pnet(RigInfo.activePorts{iIP},'close');
                end
            end
        end
        % methods
    end
    % class
end