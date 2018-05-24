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
        RewardCal = []; % property for reward calibration
        rotEncPos = 'left';
        % Saving directories
        dirSave = 'C:\Behaviour';
        dirCode = '\\zserver.cortexlab.net\Code\MouseRoom\VRCentral\';
        dirSaveLocal = 'C:\Behaviour'; %'S:\Data\Behav';
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
                    RigInfo.dirSave = 'S:\Data\Behav';%['C:\Home\Data\ball'];
                    RigInfo.dirCode = 'S:\Code\VRCentral';%['E:\Dropbox\Work\Code\VR code\SaleemLab-VR\VRCentral'];
                %%%%%%%%%%%%%%%%%%%%%%%%%%
                case 'SALEEM12'
                    RigInfo.dirSave = 'Y:\Saleem Lab\Data\Behav';%['C:\Home\Data\ball'];
                    RigInfo.dirCode = 'D:\Dropbox\Work\Code\Model Neurons\SaleemLab-VR\VRCentral';%['E:\Dropbox\Work\Code\VR code\SaleemLab-VR\VRCentral'];
                %%%%%%%%%%%%%%%%%%%%%%%%%%
                case 'SALEEM08' %NEO
                    % Local computer info (basic)
                    RigInfo.computerName = 'SALEEM08';
                    RigInfo.screenNumber = 2;
                    RigInfo.screenDist = 60; % in cm
                    RigInfo.dialogueXYPosition = [440 150];
                    
                    RigInfo.dirSave = ['S:\Data\Behav'];
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
                    RigInfo.rotEncPos = 'left';
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
                    RigInfo.dirSave = 'S:\Data\Behav';%['C:\Home\Data\ball'];
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
                    RigInfo.dirSave = 'S:\Data\Behav';%['C:\Home\Data\ball'];
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
                    %RigInfo.dirSaveRemote = ['S:\Data\Behav'];
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
                    
                case 'SALEEM04'
                    % Local computer info (basic)
                    RigInfo.computerName = 'SALEEM04';
                    RigInfo.screenNumber = 2;
                    RigInfo.screenDist = 60; % in cm
                    RigInfo.dialogueXYPosition = [440 150];
                    
                    RigInfo.screenType = 'DOME';
                    RigInfo.numCameras = 7;
                    
                    RigInfo.DevType = 'NI';
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
                    RigInfo.rotEncPos = 'right';
                    % Saving directories
                    % local
                    %                     serverName    = 'zserver';
                    %                     serverDataDir = [filesep filesep serverName filesep 'Data' filesep];
                    RigInfo.dirSave = ['S:\Data\Behav'];
                    RigInfo.dirSaveLocal = ['C:\Home\Data\ball'];
                    RigInfo.dirCode = ['C:\Home\Code\VR-Stimulus-master\SaleemLab-VR\VRCentral'];
                    % Screen related info
                    RigInfo.dirScreenCalib = 'C:\Home\Code\VR-Stimulus-master\SaleemLab-VR\VRCentral\gen\' % same directory as current file
                    RigInfo.filenameScreenCalib = 'MeshMapping_VR.mat'; %
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
                    RigInfo.computerName = 'SWITCH'; % dummy name for eventual use
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
                    RigInfo.dirSave = 'Y:\Saleem Lab\Data\Behav';%['C:\Home\Data\ball'];
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