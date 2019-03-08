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
        DevType = 'NI'; %('NI' / 'ARDUINO' /'KEYBRD')
        NIdevID = 'Dev1';
        NIsessRate = 10000;
        NIRotEnc = 'ctr0';
        NILicEnc = 'ctr1';
        NIRewVal = 'ao0';
        ARDrotCountPos = 1;
        ARDCOMPort = 7;
        ARDHistory = [0 0];
        % Other
        RewardCal = []; % property for reward calibration
        rotEncPos = 'left';
        % Saving directories
        dirSave = 'X:\ibn-vision\Archive - saleemlab\Data\Behav';%['C:\Home\Data\ball'];
        dirCode = 'C:\Home\Code\SaleemLab-VR\VRCentral';%['E:\Dropbox\Work\Code\VR code\SaleemLab-VR\VRCentral'];
        dirSaveLocal = 'C:\Home\Data\Behaviour'; %'X:\ibn-vision\Archive - saleemlab\Data\Behav';
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
                %%%
                case 'ZUPERVISION'
                    % Local computer info (basic)
                    %
                    %%
                    %%%%%%%%%%%%%%%%%%%%%%%%%%
                case 'SALEEM02'
                    RigInfo.computerName = 'SALEEM02';
                    RigInfo.dirSave = 'X:\ibn-vision\Archive - saleemlab\Data\Behav';%['C:\Home\Data\ball'];
                    RigInfo.dirCode = 'S:\Code\VRCentral';%['E:\Dropbox\Work\Code\VR code\SaleemLab-VR\VRCentral'];
                    %%%%%%%%%%%%%%%%%%%%%%%%%%
                case 'SALEEM08' %NEO
                    % Local computer info (basic)
                    RigInfo.computerName = 'NEO';
                    RigInfo.screenNumber = 2;
                    RigInfo.screenDist = 60; % in cm
                    RigInfo.dialogueXYPosition = [440 150];
                    
                    RigInfo.dirSave = ['X:\ibn-vision\Archive - saleemlab\Data\Behav'];
                    RigInfo.dirCode = ['C:\Home\Code\SaleemLab-VR\VRCentral'];
                    
                    RigInfo.DevType = 'ARDUINO';
                    RigInfo.ARDrotCountPos = 1;
                    RigInfo.ARDCOMPort = 6;
                    RigInfo.ARDHistory = [0 0];
                    
                    RigInfo.screenType = 'DOME';
                    RigInfo.numCameras = 7;
                    
                    RigInfo.NIdevID = 'Dev1';
                    RigInfo.NIsessRate = 10000;
                    RigInfo.NIRotEnc = 'ctr0';
                    RigInfo.NILicEnc = 'ctr1';
                    RigInfo.NIRewVal = 'ao1';
                    RigInfo.photodiodePos  = 'right';
                    RigInfo.photodiodeSize = [75 75];
                    RigInfo.rotEncPos = 'right';
                    % Saving directories
                    % local
                    %                     serverName    = 'zserver';
                    %                     serverDataDir = [filesep filesep serverName filesep 'Data' filesep];
                    %                     RigInfo.dirSave = ['C:\Home\Data'];
                    %                     RigInfo.dirCode = ['E:\Dropbox\Work\Code\VR code\SaleemLab-VR\VRCentral'];
                    % Screen related info
                    %RigInfo.screenCalibration = false;
                    RigInfo.dirScreenCalib = 'C:\Home\Code\SaleemLab-VR\VRCentral\gen\';%'C:\Home\Code\VR-Stimulus-master\Linear Track Behav - 2pNew - Dev Version - Copy\'%'C:\Users\Aman\AppData\Roaming\Psychtoolbox\GeometryCalibration\';%'C:\Users\experimenter\AppData\Roaming\Psychtoolbox\GeometryCalibration\';
                    RigInfo.filenameScreenCalib =  'MeshMapping_VR.mat';%'geometricCorr_2.mat';%'test.mat';%'HalfCylinderCalibdata_2_2695_1024.mat';%'HalfCylinderCalibdata_1_2400_600.mat';
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
                    % load reward calibration file
                    list = dir([RigInfo.dirCode '\data\']);
                    RigInfo.RewardCal = 0;
                    try
                        Temp = load([RigInfo.dirCode '\data\' list(strcmp(['RewardCal_' hostname '.mat'],{list.name})).name]);
                        varname = fieldnames(Temp);
                        RigInfo.RewardCal = Temp.(varname{1})
                        clear Temp varname;
                    catch
                        RigInfo.RewardCal = [linspace(1,300,100); linspace(1,10,100)]';
                        display('No reward calibration file found. Using dummy values. Please calibrate your rig!');
                    end
                    
                    %%%%%%%%%%%%%%%%%%%%%%%%%%
               case 'SALEEM04' %TRON
                    % Local computer info (basic)
                    RigInfo.computerName = 'TRON';
                    RigInfo.screenNumber = 2;
                    RigInfo.screenDist = 60; % in cm
                    RigInfo.dialogueXYPosition = [440 150];
                    
                    RigInfo.dirSave = ['X:\Archive - saleemlab\Data\Behav'];
                    RigInfo.dirCode = ['C:\Users\Saleem Lab\Documents\GitHub\SaleemLab-VR\VRCentral'];
                    
                    RigInfo.DevType = 'ARDUINO';
                    RigInfo.ARDrotCountPos = 1;
                    RigInfo.ARDCOMPort = 3; % com port
                    RigInfo.ARDHistory = [0 0];
                    
                    RigInfo.screenType = 'DOME';
                    RigInfo.numCameras = 7;
                    
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
                    %                     RigInfo.dirSave = ['C:\Home\Data'];
                    %                     RigInfo.dirCode = ['E:\Dropbox\Work\Code\VR code\SaleemLab-VR\VRCentral'];
                    % Screen related info
                    %RigInfo.screenCalibration = false;
                    RigInfo.dirScreenCalib = 'X:\Archive - saleemlab\Code\MeshMapping\';%'C:\Home\Code\VR-Stimulus-master\Linear Track Behav - 2pNew - Dev Version - Copy\'%'C:\Users\Aman\AppData\Roaming\Psychtoolbox\GeometryCalibration\';%'C:\Users\experimenter\AppData\Roaming\Psychtoolbox\GeometryCalibration\';
                    RigInfo.filenameScreenCalib =  'MeshMapping_Tron2.mat';%'geometricCorr_2.mat';%'test.mat';%'HalfCylinderCalibdata_2_2695_1024.mat';%'HalfCylinderCalibdata_1_2400_600.mat';
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
                    % load reward calibration file
                    list = dir([RigInfo.dirCode '\data\']);
                    RigInfo.RewardCal = 0;
                    try
                        Temp = load([RigInfo.dirCode '\data\' list(strcmp(['RewardCal_' hostname '.mat'],{list.name})).name]);
                        varname = fieldnames(Temp);
                        RigInfo.RewardCal = Temp.(varname{1})
                        clear Temp varname;
                    catch
                        RigInfo.RewardCal = [linspace(1,300,100); linspace(1,10,100)]';
                        display('No reward calibration file found. Using dummy values. Please calibrate your rig!');
                    end
                    
                    %%%%%%%%%%%%%%%%%%%%%%%%%%
                case 'SALEEM03' %MORPHEUS
                    % Local computer info (basic)
                    RigInfo.computerName = 'MORPHEUS';
                    RigInfo.screenNumber = 2;
                    RigInfo.screenDist = 13; % in cm
                    RigInfo.dialogueXYPosition = [680 160];
                    
                    RigInfo.DevType = 'ARDUINO';
                    RigInfo.ARDrotCountPos = 1;
                    RigInfo.ARDCOMPort = 3;
                    RigInfo.ARDHistory = [0 0];
                    
                    RigInfo.screenType = '3SCREEN';
                    RigInfo.numCameras = 3;
                    
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
                    RigInfo.dirSave = 'X:\Archive - saleemlab\Data\Behav';%['C:\Home\Data\ball'];
                    RigInfo.dirCode = 'C:\Home\Code\SaleemLab-VR\VRCentral';%['E:\Dropbox\Work\Code\VR code\SaleemLab-VR\VRCentral'];
                    % Screen related info
                    RigInfo.screenCalibration = false;
                    RigInfo.dirScreenCalib = '';%'C:\Home\Code\VR-Stimulus-master\Linear Track Behav - 2pNew - Dev Version - Copy\'%'C:\Users\Aman\AppData\Roaming\Psychtoolbox\GeometryCalibration\';%'C:\Users\experimenter\AppData\Roaming\Psychtoolbox\GeometryCalibration\';
                    RigInfo.filenameScreenCalib =  '';%'geometricCorr_2.mat';%'test.mat';%'HalfCylinderCalibdata_2_2695_1024.mat';%'HalfCylinderCalibdata_1_2400_600.mat';
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
                    % load reward calibration file
                    list = dir([RigInfo.dirCode '\data\']);
                    RigInfo.RewardCal = 0;
                    try
                        Temp = load([RigInfo.dirCode '\data\' list(strcmp(['RewardCal_' hostname '.mat'],{list.name})).name]);
                        varname = fieldnames(Temp);
                        RigInfo.RewardCal = Temp.(varname{1})
                        clear Temp varname;
                    catch
                        RigInfo.RewardCal = [linspace(1,300,100); linspace(1,10,100)]';
                        display('No reward calibration file found. Using dummy values. Please calibrate your rig!');
                    end
                    %%%%%%%%%%%%%%%%%%%%%%%%%%
                case 'SALEEM06'  % TRINITY
                    % Local computer info (basic)
                    RigInfo.computerName = 'TRINITY';
                    RigInfo.screenNumber = 2;
                    RigInfo.screenDist = 13; % in cm
                    RigInfo.dialogueXYPosition = [680 160];
                    
                    RigInfo.DevType = 'ARDUINO';
                    RigInfo.ARDrotCountPos = 1;
                    RigInfo.ARDCOMPort = 3;
                    RigInfo.ARDHistory = [0 0];
                    
                    RigInfo.screenType = '3SCREEN';
                    RigInfo.numCameras = 3;
                    
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
                    RigInfo.dirSave = 'X:\ibn-vision\Archive - saleemlab\Data\Behav';%['C:\Home\Data\ball'];
                    RigInfo.dirCode = 'C:\Home\Code\SaleemLab-VR\VRCentral';%['E:\Dropbox\Work\Code\VR code\SaleemLab-VR\VRCentral'];
                    % Screen related info
                    RigInfo.screenCalibration = false;
                    RigInfo.dirScreenCalib = '';%'C:\Home\Code\VR-Stimulus-master\Linear Track Behav - 2pNew - Dev Version - Copy\'%'C:\Users\Aman\AppData\Roaming\Psychtoolbox\GeometryCalibration\';%'C:\Users\experimenter\AppData\Roaming\Psychtoolbox\GeometryCalibration\';
                    RigInfo.filenameScreenCalib =  '';%'geometricCorr_2.mat';%'test.mat';%'HalfCylinderCalibdata_2_2695_1024.mat';%'HalfCylinderCalibdata_1_2400_600.mat';
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
                    % load reward calibration file
                    list = dir([RigInfo.dirCode '\data\']);
                    RigInfo.RewardCal = 0;
                    try
                        Temp = load([RigInfo.dirCode '\data\' list(strcmp(['RewardCal_' hostname '.mat'],{list.name})).name]);
                        varname = fieldnames(Temp);
                        RigInfo.RewardCal = Temp.(varname{1})
                        clear Temp varname;
                    catch
                        RigInfo.RewardCal = [linspace(1,300,100); linspace(1,10,100)]';
                        display('No reward calibration file found. Using dummy values. Please calibrate your rig!');
                    end
                    %%%%%%%%%%%%%%%%%%%%%%%%%%
                case 'SALEEM10' %SWITCH
                    % Local computer info (basic)
                    RigInfo.computerName = 'SWITCH';
                    RigInfo.screenNumber = 1;
                    RigInfo.screenDist = 13; % in cm
                    RigInfo.dialogueXYPosition = [680 160];
                    
                    RigInfo.DevType = 'ARDUINO';
                    RigInfo.ARDrotCountPos = 1;
                    RigInfo.ARDCOMPort = 3;
                    RigInfo.ARDHistory = [0 0];
                    
                    RigInfo.screenType = '3SCREEN';
                    RigInfo.numCameras = 3;
                    
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
                    RigInfo.dirSave = 'Y:\Data\Behav';%['C:\Home\Data\ball'];
                    RigInfo.dirCode = 'C:\Home\Code\SaleemLab-VR\VRCentral';%['E:\Dropbox\Work\Code\VR code\SaleemLab-VR\VRCentral'];
                    % Screen related info
                    RigInfo.screenCalibration = false;
                    RigInfo.dirScreenCalib = '';%'C:\Home\Code\VR-Stimulus-master\Linear Track Behav - 2pNew - Dev Version - Copy\'%'C:\Users\Aman\AppData\Roaming\Psychtoolbox\GeometryCalibration\';%'C:\Users\experimenter\AppData\Roaming\Psychtoolbox\GeometryCalibration\';
                    RigInfo.filenameScreenCalib =  '';%'geometricCorr_2.mat';%'test.mat';%'HalfCylinderCalibdata_2_2695_1024.mat';%'HalfCylinderCalibdata_1_2400_600.mat';
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
                    % load reward calibration file
                    list = dir([RigInfo.dirCode '\data\']);
                    RigInfo.RewardCal = 0;
                    try
                        Temp = load([RigInfo.dirCode '\data\' list(strcmp(['RewardCal_' hostname '.mat'],{list.name})).name]);
                        varname = fieldnames(Temp);
                        RigInfo.RewardCal = Temp.(varname{1})
                        clear Temp varname;
                    catch
                        RigInfo.RewardCal = [linspace(1,300,100); linspace(1,10,100)]';
                        display('No reward calibration file found. Using dummy values. Please calibrate your rig!');
                    end
                    %%%%%%%%%%%%%%%%%%%%%%%%%%
                case 'SALEEM09' %TANK
                    % Local computer info (basic)
                    RigInfo.computerName = 'TANK';
                    RigInfo.screenNumber = 1;
                    RigInfo.screenDist = 13; % in cm
                    RigInfo.dialogueXYPosition = [680 160];
                    
                    RigInfo.DevType = 'ARDUINO';
                    RigInfo.ARDrotCountPos = 1;
                    RigInfo.ARDCOMPort = 3;
                    RigInfo.ARDHistory = [0 0];
                    
                    RigInfo.screenType = '3SCREEN';
                    RigInfo.numCameras = 3;
                    
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
                    RigInfo.dirSave = 'Z:\Data\Behav';%['C:\Home\Data\ball'];
                    RigInfo.dirCode = 'C:\Home\Code\SaleemLab-VR\VRCentral';%['E:\Dropbox\Work\Code\VR code\SaleemLab-VR\VRCentral'];
                    % Screen related info
                    RigInfo.screenCalibration = false;
                    RigInfo.dirScreenCalib = '';%'C:\Home\Code\VR-Stimulus-master\Linear Track Behav - 2pNew - Dev Version - Copy\'%'C:\Users\Aman\AppData\Roaming\Psychtoolbox\GeometryCalibration\';%'C:\Users\experimenter\AppData\Roaming\Psychtoolbox\GeometryCalibration\';
                    RigInfo.filenameScreenCalib =  '';%'geometricCorr_2.mat';%'test.mat';%'HalfCylinderCalibdata_2_2695_1024.mat';%'HalfCylinderCalibdata_1_2400_600.mat';
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
                    % load reward calibration file
                    list = dir([RigInfo.dirCode '\data\']);
                    RigInfo.RewardCal = 0;
                    try
                        Temp = load([RigInfo.dirCode '\data\' list(strcmp(['RewardCal_' hostname '.mat'],{list.name})).name]);
                        varname = fieldnames(Temp);
                        RigInfo.RewardCal = Temp.(varname{1})
                        clear Temp varname;
                    catch
                        RigInfo.RewardCal = [linspace(1,300,100); linspace(1,10,100)]';
                        display('No reward calibration file found. Using dummy values. Please calibrate your rig!');
                    end
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
                    %RigInfo.dirSaveRemote = ['X:\ibn-vision\Archive - saleemlab\Data\Behav'];
                    RigInfo.dirCode = ['E:\Dropbox\Work\Code\VR code\SaleemLab-VR\VRCentral'];
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
                    
                case 'SALEEM05' % Tomaso's desk computer
                    % Local computer info (basic)
                    RigInfo.computerName = 'Saleem05'; % dummy name for eventual use
                    RigInfo.screenNumber = 1;
                    RigInfo.screenDist = 60; % in cm
                    RigInfo.dialogueXYPosition = [680 160];
                    
                    RigInfo.DevType = 'ARDUINO';
                    RigInfo.ARDrotCountPos = 1;
                    RigInfo.ARDCOMPort = 3;
                    RigInfo.ARDHistory = [0 0];
                    
                    RigInfo.screenType = '3SCREEN';
                    RigInfo.numCameras = 1;
                    
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
                    RigInfo.dirSave = ['Y:\Saleem Lab\Data\Behav'];%['C:\Home\Data\ball'];
                    RigInfo.dirCode = ['C:\Home\Code\SaleemLab-VR\VRCentral'];%['E:\Dropbox\Work\Code\VR code\SaleemLab-VR\VRCentral'];
                    % Screen related info
                    RigInfo.screenCalibration = false;
                    RigInfo.dirScreenCalib = '';%'C:\Home\Code\VR-Stimulus-master\Linear Track Behav - 2pNew - Dev Version - Copy\'%'C:\Users\Aman\AppData\Roaming\Psychtoolbox\GeometryCalibration\';%'C:\Users\experimenter\AppData\Roaming\Psychtoolbox\GeometryCalibration\';
                    RigInfo.filenameScreenCalib =  '';%'geometricCorr_2.mat';%'test.mat';%'HalfCylinderCalibdata_2_2695_1024.mat';%'HalfCylinderCalibdata_1_2400_600.mat';
                    % External computer connection info
                    % (These are optinal)
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
                    % load reward calibration file
                    list = dir([RigInfo.dirCode '\data\']);
                    RigInfo.RewardCal = 0;
                    
                    try
                        Temp = load([RigInfo.dirCode '\data\' list(strcmp(['RewardCal_' hostname '.mat'],{list.name})).name]);
                        varname = fieldnames(Temp);
                        RigInfo.RewardCal = Temp.(varname{1})
                        clear Temp varname;
                    catch
                        RigInfo.RewardCal = [linspace(1,300,100); linspace(1,10,100)]';
                        display('No reward calibration file found. Using dummy values. Please calibrate your rig!');
                    end
                case 'SALEEM12' %Aman Desktop
                    % Local computer info (basic)
                    RigInfo.computerName = 'SALEEM12'; % dummy name for eventual use
                    RigInfo.screenNumber = 2;
                    RigInfo.screenDist = 13; % in cm
                    RigInfo.dialogueXYPosition = [680 160];
                    
                                        RigInfo.DevType = 'KEYBRD';
                    %                     RigInfo.ARDrotCountPos = 1;
                    %                     RigInfo.ARDCOMPort = 3;
                    %                     RigInfo.ARDHistory = [0 0];
                    %
                    %                     RigInfo.screenType = '3SCREEN';
                    %                     RigInfo.numCameras = 3;
                    %
                    %                     RigInfo.NIdevID = 'Dev1';
                    %                     RigInfo.NIsessRate = 10000;
                    %                     RigInfo.NIRotEnc = 'ctr0';
                    %                     RigInfo.NILicEnc = 'ctr1';
                    %                     RigInfo.NIRewVal = 'ao1';
                    RigInfo.photodiodePos  = 'right';
                    RigInfo.photodiodeSize = [75 75];
                    RigInfo.rotEncPos = 'left';
                    % Saving directories
                    % local
                    %                     serverName    = 'zserver';
                    %                     serverDataDir = [filesep filesep serverName filesep 'Data' filesep];
                    RigInfo.dirSave = 'Y:\Saleem Lab\Data\Behav';
                    RigInfo.dirCode = 'D:\Dropbox\Work\Code\Model Neurons\SaleemLab-VR\VRCentral';
                    % Screen related info
                    RigInfo.screenCalibration = false;
                    RigInfo.dirScreenCalib = '';%'C:\Home\Code\VR-Stimulus-master\Linear Track Behav - 2pNew - Dev Version - Copy\'%'C:\Users\Aman\AppData\Roaming\Psychtoolbox\GeometryCalibration\';%'C:\Users\experimenter\AppData\Roaming\Psychtoolbox\GeometryCalibration\';
                    RigInfo.filenameScreenCalib =  '';%'geometricCorr_2.mat';%'test.mat';%'HalfCylinderCalibdata_2_2695_1024.mat';%'HalfCylinderCalibdata_1_2400_600.mat';
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
                    % load reward calibration file
                    list = dir([RigInfo.dirCode '\data\']);
                    RigInfo.RewardCal = 0;
                    try
                        Temp = load([RigInfo.dirCode '\data\' list(strcmp(['RewardCal_' hostname '.mat'],{list.name})).name]);
                        varname = fieldnames(Temp);
                        RigInfo.RewardCal = Temp.(varname{1})
                        clear Temp varname;
                    catch
                        RigInfo.RewardCal = [linspace(1,300,100); linspace(1,10,100)]';
                        display('No reward calibration file found. Using dummy values. Please calibrate your rig!');
                    end
                case 'POSTGRAD198' %Karolina Desktop
                    % Local computer info (basic)
                    RigInfo.computerName = 'SWITCH'; % dummy name for eventual use
                    RigInfo.screenNumber = 2;
                    RigInfo.screenDist = 13; % in cm
                    RigInfo.dialogueXYPosition = [680 160];
                    
                                        RigInfo.DevType = 'KEYBRD';
                    %                     RigInfo.ARDrotCountPos = 1;
                    %                     RigInfo.ARDCOMPort = 3;
                    %                     RigInfo.ARDHistory = [0 0];
                    %
                    %                     RigInfo.screenType = '3SCREEN';
                    %                     RigInfo.numCameras = 3;
                    %
                    %                     RigInfo.NIdevID = 'Dev1';
                    %                     RigInfo.NIsessRate = 10000;
                    %                     RigInfo.NIRotEnc = 'ctr0';
                    %                     RigInfo.NILicEnc = 'ctr1';
                    %                     RigInfo.NIRewVal = 'ao1';
                    RigInfo.photodiodePos  = 'right';
                    RigInfo.photodiodeSize = [75 75];
                    RigInfo.rotEncPos = 'left';
                    % Saving directories
                    % local
                    %                     serverName    = 'zserver';
                    %                     serverDataDir = [filesep filesep serverName filesep 'Data' filesep];
                    RigInfo.dirSave = 'X:\ibn-vision\Archive - saleemlab\Data\Behav';
                    RigInfo.dirCode = 'C:\Users\karolina.farrell\Documents\GitHub\SaleemLab-VR\VRCentral';
                    % Screen related info
                    RigInfo.screenCalibration = false;
                    RigInfo.dirScreenCalib = '';%'C:\Home\Code\VR-Stimulus-master\Linear Track Behav - 2pNew - Dev Version - Copy\'%'C:\Users\Aman\AppData\Roaming\Psychtoolbox\GeometryCalibration\';%'C:\Users\experimenter\AppData\Roaming\Psychtoolbox\GeometryCalibration\';
                    RigInfo.filenameScreenCalib =  '';%'geometricCorr_2.mat';%'test.mat';%'HalfCylinderCalibdata_2_2695_1024.mat';%'HalfCylinderCalibdata_1_2400_600.mat';
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
                    % load reward calibration file
                    list = dir([RigInfo.dirCode '\data\']);
                    RigInfo.RewardCal = 0;
                    try
                        Temp = load([RigInfo.dirCode '\data\' list(strcmp(['RewardCal_' hostname '.mat'],{list.name})).name]);
                        varname = fieldnames(Temp);
                        RigInfo.RewardCal = Temp.(varname{1})
                        clear Temp varname;
                    catch
                        RigInfo.RewardCal = [linspace(1,300,100); linspace(1,10,100)]';
                        display('No reward calibration file found. Using dummy values. Please calibrate your rig!');
                    end
                    %%%%
                case 'SALEEM12' %Aman Desktop
                    % Local computer info (basic)
                    RigInfo.computerName = 'AmanDesk'; % dummy name for eventual use
                    RigInfo.screenNumber = 2;
                    RigInfo.screenDist = 13; % in cm
                    RigInfo.dialogueXYPosition = [680 160];
                    
                    %                     RigInfo.DevType = 'ARDUINO';
                    %                     RigInfo.ARDrotCountPos = 1;
                    %                     RigInfo.ARDCOMPort = 3;
                    %                     RigInfo.ARDHistory = [0 0];
                    %
                    %                     RigInfo.screenType = '3SCREEN';
                    %                     RigInfo.numCameras = 3;
                    %
                    %                     RigInfo.NIdevID = 'Dev1';
                    %                     RigInfo.NIsessRate = 10000;
                    %                     RigInfo.NIRotEnc = 'ctr0';
                    %                     RigInfo.NILicEnc = 'ctr1';
                    %                     RigInfo.NIRewVal = 'ao1';
                    RigInfo.photodiodePos  = 'right';
                    RigInfo.photodiodeSize = [75 75];
                    RigInfo.rotEncPos = 'left';
                    % Saving directories
                    % local
                    %                     serverName    = 'zserver';
                    %                     serverDataDir = [filesep filesep serverName filesep 'Data' filesep];
                    RigInfo.dirSave = 'Y:\Saleem Lab\Data\Behav';
                    RigInfo.dirCode = 'D:\Dropbox\Work\Code\Model Neurons\SaleemLab-VR\VRCentral';
                    % Screen related info
                    RigInfo.screenCalibration = false;
                    RigInfo.dirScreenCalib = '';%'C:\Home\Code\VR-Stimulus-master\Linear Track Behav - 2pNew - Dev Version - Copy\'%'C:\Users\Aman\AppData\Roaming\Psychtoolbox\GeometryCalibration\';%'C:\Users\experimenter\AppData\Roaming\Psychtoolbox\GeometryCalibration\';
                    RigInfo.filenameScreenCalib =  '';%'geometricCorr_2.mat';%'test.mat';%'HalfCylinderCalibdata_2_2695_1024.mat';%'HalfCylinderCalibdata_1_2400_600.mat';
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
                    % load reward calibration file
                    list = dir([RigInfo.dirCode '\data\']);
                    RigInfo.RewardCal = 0;
                    try
                        Temp = load([RigInfo.dirCode '\data\' list(strcmp(['RewardCal_' hostname '.mat'],{list.name})).name]);
                        varname = fieldnames(Temp);
                        RigInfo.RewardCal = Temp.(varname{1})
                        clear Temp varname;
                    catch
                        RigInfo.RewardCal = [linspace(1,300,100); linspace(1,10,100)]';
                        display('No reward calibration file found. Using dummy values. Please calibrate your rig!');
                    end
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