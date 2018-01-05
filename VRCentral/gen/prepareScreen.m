function myscreen = prepareScreen(whichScreen,rigInfo,expInfo)
% initializes screen: ltScreenInitialize [Screen('OpenWindow',...)]
% loads calibration: ltLoadCalibration
% asks for screen distance

% screen distance
myscreen.Dist = rigInfo.screenDist;
Dist = rigInfo.screenDist;
% Dist = input(['Enter screen distance (' num2str(rigInfo.screenDist) ' cm is usual): ']);

screens=Screen('Screens');
try
    myscreen = initializeScreen(whichScreen, rigInfo, expInfo);
catch
    Screen('CloseAll');
    psychrethrow(psychlasterror);
    return
end

if ~isnumeric(Dist) || isempty(Dist)
    fprintf('<prepareScreen> Using default screen distance\n');
else
    myscreen.Dist = Dist;
end

% when monitor is calibrated
% load new gamma table, which linearizes monitor luminance
% if ~expInfo.OFFLINE %& ~strcmp(rigInfo.computerName,'ZOOROPA') & ~strcmp(rigInfo.computerName,'ZURPRISE')
%     try
%         Calibration.Load(myscreen);
%         display('*********** Loaded calibration file ************')
%     catch
%         try
%             Calibration.Load;
%             display('*********** Loaded calibration file ************')
%         catch
            display('No Gamma correction detected');
%         end
%     end
% end

% if ~expInfo.OFFLINE
%     % to get fish-eye transform: uncomment previous statement to remove
%     transformFile = [rigInfo.dirScreenCalib rigInfo.filenameScreenCalib];
%     display(['Using transform file: ' transformFile]);
%     PsychImaging('PrepareConfiguration');
%     PsychImaging('AddTask', 'AllViews', 'GeometryCorrection', transformFile);
%     %     On zuperduper: 'C:\Users\experimenter\AppData\Roaming\Psychtoolbox\GeometryCalibration\HalfCylinderCalibdata_1_2400_600.mat'
%     %     on zupervision: C:\Documents and Settings\experiment.ZUPERVISION\Application Data\Psychtoolbox\GeometryCalibration\HalfCylinderCalibdata_2_2400_600.mat
%     PsychImaging('AddTask', 'AllViews', 'FlipHorizontal');
%     [myscreen.windowPtr, myscreen.screenRect] = PsychImaging('OpenWindow', whichScreen, myscreen.grayIndex);
% end
fprintf('done\n');