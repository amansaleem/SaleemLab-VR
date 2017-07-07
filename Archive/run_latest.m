function [fhandle, runInfo] = run(rigInfo, hwInfo, expInfo, runInfo)

global GL;
global TRIAL;

runInfo.reset_textures = 1;
ListenChar(2);

%% First trial settings
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
%% shit to initialise so that we can load textures later
textures = []; y1 = [];Imf = [];ans = [];filt1 = [];filt2 = [];
filtSize = [];n = [];sf = [];sigma = [];sigma1 = [];texsize = [];
textures = [];x = [];x2= [];
% end

BALL_TO_DEGREE =1/300;%1/20000*360;

BALL_TO_ROOM = 1.11; %1.11 calculated to equate the cm and the distance travelled

PI_OVER_180 = pi/180;

runInfo.REWARD.TRIAL = [];
runInfo.REWARD.count = [];
runInfo.REWARD.TYPE  = [];
runInfo.REWARD.TotalValveOpenTime = 0;
runInfo.REWARD.STOP_VALVE_TIME = expInfo.EXP.STOPvalveTime;
runInfo.REWARD.BASE_VALVE_TIME = expInfo.EXP.BASEvalveTime;
runInfo.REWARD.PASS_VALVE_TIME = expInfo.EXP.PASSvalveTime;
runInfo.REWARD.ACTV_VALVE_TIME = expInfo.EXP.ACTVvalveTime;
runInfo.REWARD.USER_VALVE_TIME = expInfo.EXP.BASEvalveTime;

X=1; %x coordinate
Y=2; %y coordinate
Z=3; %z coordinate
T=4; %T: theta (viewangle)
% S=5; %S: speed

STOP = 1;
BASE = 1;


%% Is the script running in OpenGL Psychtoolbox?
% AssertOpenGL;

Screen('BeginOpenGL', hwInfo.MYSCREEN.windowPtr(1));
% Get the aspect ratio of the screen:
ar=hwInfo.MYSCREEN.screenRect(1,4)/(hwInfo.MYSCREEN.screenRect(1,3));

display(['Monitor aspect ratio is: ' num2str(1/ar) ', and fov is: ' ...
    num2str(atan(hwInfo.MYSCREEN.MonitorHeight/(2*hwInfo.MYSCREEN.Dist))*360/pi) ...
    ' vertical and ' num2str((1/ar)*atan(hwInfo.MYSCREEN.MonitorHeight/(2*hwInfo.MYSCREEN.Dist))*360/pi) ...
    ' horizontal']);

%[fbo , texids] = moglCreateFBO(1280, 800);%, 1, 4, GL.RGBA_FLOAT32_APPLE, 0, 0);

% Turn on OpenGL local lighting model: The lighting model supported by
% OpenGL is a local Phong model with Gouraud shading.
glEnable(GL.LIGHTING);

% Enable the first local light source GL.LIGHT_0. Each OpenGL
% implementation is guaranteed to support at least 8 light sources.
glEnable(GL.LIGHT0);

% Enable two-sided lighting - Back sides of polygons are lit as well.
% glLightModelfv(GL.LIGHT_MODEL_TWO_SIDE,GL.TRUE);
glLightModelfv(GL.LIGHT_MODEL_AMBIENT,[0.5 0.5 0.5 1]);
% glLightModelfv(GL.LIGHT_MODEL_LOCAL_VIEWER,0.0);

% glShadeModel(GL.SMOOTH);
% Enable proper occlusion handling via depth tests:
glEnable(GL.DEPTH_TEST);

% Define the walls light reflection properties by setting up reflection
% coefficients for ambient, diffuse and specular reflection:
glMaterialfv(GL.FRONT_AND_BACK,GL.AMBIENT, [ 1 1 1 1 ]);
% glMaterialfv(GL.FRONT_AND_BACK,GL.AMBIENT_AND_DIFFUSE, [ .5 .5 .5 1 ]);
% glMaterialfv(GL.FRONT_AND_BACK,GL.SPECULAR, [ .5 .5 .5 1 ]);
load(expInfo.EXP.textureFile);

%% Set start position

TRIAL.posdata(runInfo.currTrial,1,Z) = 0;            % starting at the corner 1: (or) expInfo.EXP.l
TRIAL.posdata(runInfo.currTrial,1,X) = 0;
TRIAL.posdata(runInfo.currTrial,1,T) = 0;
TRIAL.posdata(runInfo.currTrial,1,Y) = expInfo.EXP.c3;

isLazy = 0; % for timeout
lazyStart = [];
lazyDur = 0;

runInfo.count = 1; % This is a counter per trial
gcount = 1; % This is a global counter
lastActiveBase=0;

%% open udp port
if ~expInfo.OFFLINE
    myPort = pnet('udpsocket', hwInfo.BALLPort);
end

if expInfo.OFFLINE
    runInfo.MOUSEXY.dax = 0;
    runInfo.MOUSEXY.day = 0;
    runInfo.MOUSEXY.dbx = 0;
    runInfo.MOUSEXY.dby = 0;
    
end
timeIsUp =0;
TRIAL.info.start = clock;
runInfo.t1= tic;

% start acquiring data
if ~expInfo.OFFLINE
    VRmessage = ['BlockStart ' expInfo.animalName ' ' expInfo.dateStr ' ' expInfo.sessionName];
    rigInfo.sendUDPmessage(VRmessage);
    VRLogMessage(expInfo, VRmessage);
    VRmessage = ['StimStart ' expInfo.animalName ' ' expInfo.dateStr ' ' expInfo.sessionName ' 1 1 ' num2str(round(expInfo.EXP.maxTrialDuration*10))];
    rigInfo.sendUDPmessage(VRmessage); %%% Check this
    VRLogMessage(expInfo, VRmessage);
    if rigInfo.sendTTL
        hwInfo.session.outputSingleScan(true);
        pause(1);
    end
end


%% The main programme
try
    while (~timeIsUp && ~TRIAL.info.abort)
        if runInfo.reset_textures
            setupTextures(textures);
        end
        Screen('EndOpenGL', hwInfo.MYSCREEN.windowPtr(1));
        % Show rendered image at next vertical retrace:
        %         Screen('Flip', hwInfo.MYSCREEN.windowPtr(1));
        % Switch to OpenGL rendering again for drawing of next frame:
        Screen('BeginOpenGL', hwInfo.MYSCREEN.windowPtr(1));
        if ~runInfo.blank_screen
            % Camera showing 180 degrees of the VR world onto a screen
            % surface of same angular span
            %             glViewport((1280-1280/240*180)/2,0,(1280/240*180),800);
            for icam = 1:rigInfo.numCameras
                switch rigInfo.screenType
                    case 'DOME'
                        if icam==rigInfo.numCameras
                            glViewport(round(1280/rigInfo.numCameras)*(icam-1)+1,0,1279-(round(1280/rigInfo.numCameras)*(icam-1)),800);
                        else
                            glViewport(round(1280/rigInfo.numCameras)*(icam-1)+1,0,round(1280/rigInfo.numCameras),800);
                        end
                        glMatrixMode(GL.PROJECTION);
                        glLoadIdentity;
                        glFrustum( -sind((240/rigInfo.numCameras/2)*(1/3))*0.1, ...
                                    sind((240/rigInfo.numCameras/2)*(1/3))*0.1, ...
                                   -sind(30*(1/3))*0.1, sind(90*(1/3))*0.1, 0.1,expInfo.EXP.visibleDepth)
                    case '3SCREEN'
                        glMatrixMode(GL.PROJECTION);
                        glLoadIdentity;
                        glFrustum( -sind(30)*0.1, sind(30)*0.1, -sind(30)*0.1, sind(90)*0.1, 0.1,expInfo.EXP.visibleDepth)
                end
                glMatrixMode(GL.MODELVIEW);
                glLoadIdentity;
                glClear(GL.DEPTH_BUFFER_BIT);
                if strcmp(rigInfo.screenType,'DOME')
                    glRotated((-(240/2)+(240/2/rigInfo.numCameras)+((icam-1)*(240/rigInfo.numCameras)))*(1/3),0.0,1.0,0.0); % 0.333 is a parameter to get the desired rotation in degrees
                else
                    glRotated (0,1,0,0); % to look a little bit downward 
                    glRotated (TRIAL.posdata(runInfo.currTrial,runInfo.count,T)/pi*180,0,1,0);
                end
                
                 %% get movement and draw
                %         if ~runInfo.blank_screen
                if icam==1
                    getVRMovement
                    runInfo = getTrajectory(dbx, X, Y, Z, T, rigInfo, hwInfo, expInfo, runInfo);
                end

                
                % Set background color to 'gray':
                glClearColor(0.5,0.5,0.5,1);
                glLightfv(GL.LIGHT0,GL.AMBIENT, [ 0.5 0.5 0.5 1 ]);
                glShadeModel(GL.SMOOTH);
                glPushMatrix;
                glRotated (0,1,0,0); % to look a little bit downward
                glRotated (TRIAL.posdata(runInfo.currTrial,runInfo.count,T)/pi*180,0,1,0);
                glTranslated (-TRIAL.posdata(runInfo.currTrial,runInfo.count,X),-expInfo.EXP.c3,-TRIAL.posdata(runInfo.currTrial,runInfo.count,Z));
                DrawTextures
                glPushMatrix;
                glPopMatrix;
                glPopMatrix;
            end %%% end of for loop of viewports
        end
                
            if expInfo.REPLAY
                endExpt = 0;
                if (runInfo.currTrial>=expInfo.EXP.maxTraj)
                    endExpt = 1;
                elseif (TRIAL.time(runInfo.currTrial,runInfo.count) == 0 && TRIAL.time(runInfo.currTrial+1,2) == 0)
                    endExpt = 1;
                    display(['Reached global end @ trial: ' num2str(runInfo.currTrial)]);
                end
                if endExpt
                    display('Reached global end');
                    if ~expInfo.OFFLINE
                        VRmessage = ['StimStart ' expInfo.animalName ' ' expInfo.dateStr ...
                            ' ' expInfo.sessionName ' ' num2str(TRIAL.nCompTraj) ' 1 ' ...
                            num2str(round(expInfo.EXP.maxTrialDuration*10))];
                        rigInfo.sendUDPmessage(VRmessage); %%%
                        VRLogMessage(expInfo, VRmessage);
                        if rigInfo.sendTTL
                            session.outputSingleScan(true);
                            pause(1);
                        end
                    end
                    runInfo.currTrial = runInfo.currTrial + 1;
                    fhandle = @trialEnd;
                    TRIAL.info.abort =1;
                    break
                end
            end
            if expInfo.REPLAY
                TRIAL.currTime(runInfo.currTrial,runInfo.count) = GetSecs;
            else
                TRIAL.time(runInfo.currTrial,runInfo.count) = GetSecs;
            end
            TRIAL.info.epoch = runInfo.count;
            
            if ~runInfo.blank_screen
                % update x, z positions and viewangle
                
                if ~expInfo.REPLAY
                    TRIAL.traj(runInfo.currTrial,runInfo.count) = runInfo.TRAJ;
                    %                 disp(['Traj is ' num2str(runInfo.TRAJ*10)]);
                end
                
                if TRIAL.nCompTraj > expInfo.EXP.maxTraj
                    if ~expInfo.OFFLINE
                        VRmessage = ['StimStart ' expInfo.animalName ' ' expInfo.dateStr ' ' ...
                            expInfo.sessionName ' ' num2str(TRIAL.nCompTraj) ' 1 ' num2str(round(expInfo.EXP.maxTrialDuration*10))];
                        rigInfo.sendUDPmessage(VRmessage); %%%
                        VRLogMessage(expInfo, VRmessage);
                        if rigInfo.sendTTL
                            hwInfo.session.outputSingleScan(true);
                        end
                    end
                    fhandle = @trialEnd;
                    break
                end
                currentPos = [TRIAL.posdata(runInfo.currTrial,runInfo.count,X) TRIAL.posdata(runInfo.currTrial,runInfo.count,Y) TRIAL.posdata(runInfo.currTrial,runInfo.count,Z)];
            end
            % start drawing
            if runInfo.blank_screen
                glClear;
            end
            % get new coordinates
            runInfo.count = runInfo.count + 1;
            gcount = gcount + 1;
            
            % Finish OpenGL rendering into PTB window and check for OpenGL errors.
            Screen('EndOpenGL', hwInfo.MYSCREEN.windowPtr(1));
            % Show rendered image at next vertical retrace:
            % Show the sync square
            % alternate between black and white with every frame
            
            Screen('FillRect', hwInfo.MYSCREEN.windowPtr(1), mod(gcount,2)*255, rigInfo.photodiodeRect.rect);
            %         glFlush;
            Screen('Flip', hwInfo.MYSCREEN.windowPtr(1));
            % Switch to OpenGL rendering again for drawing of next frame:
            Screen('BeginOpenGL', hwInfo.MYSCREEN.windowPtr(1));
        if runInfo.blank_screen
            runInfo.blank_screen_count = runInfo.blank_screen_count + 1;
%             display(num2str(runInfo.blank_screen_count));
        end
        
        if runInfo.blank_screen_count > TRIAL.trialBlanks(runInfo.currTrial)
            runInfo.blank_screen = 0;
            runInfo.blank_screen_count = 1;
            display(['Num blanks: ' num2str(TRIAL.trialBlanks(runInfo.currTrial))]);
            
            %             if ~REPLAY
            %% Set trial parameters
            % Room Length
            if length(expInfo.EXP.lengthSet)>1
                if expInfo.EXP.randScale
                    roomLength = expInfo.EXP.lengthSet(randi(length(expInfo.EXP.lengthSet)));
                else
                    idx = runInfo.currTrial;
                    if idx>length(expInfo.EXP.lengthSet)
                        idx = rem(runInfo.currTrial, length(expInfo.EXP.lengthSet));
                        if idx==0
                            idx = length(expInfo.EXP.lengthSet);
                        end
                    end
                    roomLength = expInfo.EXP.lengthSet(idx);
                end
            else
                roomLength = 1;
            end
            TRIAL.trialRL(runInfo.currTrial) = roomLength;
            
            % Start Position
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
            
            % Room scaling
            if length(expInfo.EXP.scaleSet)>1
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
            runInfo.ROOM = getRoomData(expInfo.EXP,TRIAL.trialRL(runInfo.currTrial));
            
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
            idx = runInfo.currTrial;
            if idx>length(expInfo.EXP.rew_pos)
                idx = rem(runInfo.currTrial, length(expInfo.EXP.rew_pos));
                if idx==0
                    idx = length(expInfo.EXP.rew_pos);
                end
            end
            
            TRIAL.trialRewPos(runInfo.currTrial) = expInfo.EXP.rew_pos(idx).*TRIAL.trialRL(runInfo.currTrial);
            expInfo.EXP.punishZone = TRIAL.trialRewPos(runInfo.currTrial) - expInfo.EXP.punishLim;
            %             end TRIAL.trialActive(runInfo.currTrial) TRIAL.trialRewPos(runInfo.currTrial)
            p = runInfo.TRAJ;
            
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
            
            TRIAL.trialGain(runInfo.currTrial) = scaling_factor;
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
            runInfo.t1 = tic;
            if ~expInfo.OFFLINE
                VRmessage = ['StimStart ' expInfo.animalName ' ' expInfo.dateStr ' ' ...
                    expInfo.sessionName ' ' num2str(TRIAL.nCompTraj) ' 1 ' num2str(round(expInfo.EXP.maxTrialDuration*10))];
                rigInfo.sendUDPmessage(VRmessage); %%%
                VRLogMessage(expInfo, VRmessage);
                if rigInfo.sendTTL
                    hwInfo.session.outputSingleScan(true);
                    pause(1);
                end
            end
            
            if TRIAL.nCompTraj > runInfo.SAVE_COUNT + 5
                s = sprintf('%s_trial%03d', expInfo.SESSION_NAME, TRIAL.info.no);
                EXP    = expInfo.EXP;
                REWARD = runInfo.REWARD;
                %                 TRIAL  = runInfo.TRIAL;
                ROOM   = runInfo.ROOM;
                save(s, 'TRIAL', 'EXP', 'REWARD','ROOM');
                runInfo.SAVE_COUNT = TRIAL.nCompTraj;
            end
            
            %             hwInfo.rotEnc.zero;
        end
        
        keyPressed = checkKeyboard(rigInfo);
        if keyPressed == 1
            TRIAL.info.abort =1;
            if ~expInfo.OFFLINE
                VRmessage = ['StimEnd ' expInfo.animalName ' ' expInfo.dateStr ' ' ...
                    expInfo.sessionName ' ' num2str(TRIAL.nCompTraj) ' 1 ' num2str(round(expInfo.EXP.maxTrialDuration*10))];
                rigInfo.sendUDPmessage(VRmessage); %%%Check this
                VRLogMessage(expInfo, VRmessage);
                if rigInfo.sendTTL
                    hwInfo.session.outputSingleScan(false);
                end
            end
            fhandle = @trialEnd;
        elseif keyPressed == 2
            runInfo = giveReward(runInfo.count,'USER',runInfo.currTrial,1, expInfo, runInfo, hwInfo, rigInfo);
        end
        
        
    end
    
catch ME
    fprintf(['exception : ' ME.message '\n']);
    fprintf(['line #: ' num2str(ME.stack(1,1).line)]);
    TRIAL.info.abort = 1;
    fhandle = @trialEnd;
    
end


%% close udp port and reset priority level
if ~expInfo.OFFLINE
    pnet(myPort,'close');
end

ListenChar(0);
Priority(0);

%% Delete all allocated OpenGL textures:
if ~runInfo.blank_screen
    glDeleteTextures(length(texname),texname);
    Screen('EndOpenGL', hwInfo.MYSCREEN.windowPtr(1));
end

heapTotalMemory = java.lang.Runtime.getRuntime.totalMemory;
heapFreeMemory = java.lang.Runtime.getRuntime.freeMemory;

if(heapFreeMemory < (heapTotalMemory*0.1))
    java.lang.Runtime.getRuntime.gc;
    fprintf('\n garbage collection \n');
end
%% Setup textures for all six sides of cube:
    function setupTextures(textures)
        
        runInfo.reset_textures = 0;
        %         if ~REPLAY
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
        %         else
        %             contrLevel = TRIAL.trialContr(runInfo.currTrial);
        %         end
        
        % Enable 2D texture mapping,
        glEnable(GL.TEXTURE_2D);
        
        % Generate textures and store their handles in vecotr 'texname'
        texname=glGenTextures(length(textures));
        
        for i=1:length(textures),
            % Enable i'th texture by binding it:
            glBindTexture(GL.TEXTURE_2D,texname(i));
            
            f=max(min(255*(textures(i).matrix),255),0);
            %             f=round(contrLevel.*(f-128) + 128);
            if i>5 % change to 5
                f=round(contrLevel.*(f-128) + 128);
                tx=repmat(flipdim(f,1),[ 1 1 3 ]);
            else
                if expInfo.EXP.contrWalls
                    f=round(contrLevel.*(f-128) + 128);
                end
                tx=repmat(flipdim(f',1),[ 1 1 3 ]);
            end
            
            if i==9;
                tx(:,:,2:3) = 128;
            elseif i ==10
                tx(:,:,1:2) = 128;
            end
            tx=permute(flipdim(uint8(tx),1),[ 3 2 1 ]);
            % Assign image in matrix 'tx' to i'th texture:
            glTexImage2D(GL.TEXTURE_2D,0,GL.RGB,size(f,1),size(f,2),0,GL.RGB,GL.UNSIGNED_BYTE,tx);
            %    glTexImage2D(GL.TEXTURE_2D,0,GL.ALPHA,256,256,1,GL.ALPHA,GL.UNSIGNED_BYTE,noisematrix);
            
            % Setup texture wrapping behaviour:
            glTexParameterfv(GL.TEXTURE_2D,GL.TEXTURE_WRAP_S,GL.CLAMP);%GL.CLAMP_TO_EDGE);%GL.REPEAT);%
            glTexParameterfv(GL.TEXTURE_2D,GL.TEXTURE_WRAP_T,GL.CLAMP);%GL.CLAMP_TO_EDGE);
            glTexParameterfv(GL.TEXTURE_2D,GL.TEXTURE_WRAP_R,GL.CLAMP);%GL.CLAMP_TO_EDGE);
            
            %     % Setup filtering for the textures:
            glTexParameterfv(GL.TEXTURE_2D,GL.TEXTURE_MAG_FILTER,GL.NEAREST);
            glTexParameterfv(GL.TEXTURE_2D,GL.TEXTURE_MIN_FILTER,GL.NEAREST);
            % Choose texture application function: It will modulate the light
            % reflection properties of the the cubes face:
            glTexEnvfv(GL.TEXTURE_ENV,GL.TEXTURE_ENV_MODE,GL.MODULATE);
        end
    end
%% Draw textures
    function DrawTextures
        for k=1:runInfo.ROOM.nOfWalls
            switch k
                case 1
                    wallface (runInfo.ROOM.v, runInfo.ROOM.order(k,:),runInfo.ROOM.normals(k,:),texname(getTextureIndex(expInfo.EXP.farWallText)),runInfo.ROOM.wrap(k,:));
                case 2
                    wallface (runInfo.ROOM.v, runInfo.ROOM.order(k,:),runInfo.ROOM.normals(k,:),texname(getTextureIndex(expInfo.EXP.nearWallText)),runInfo.ROOM.wrap(k,:));
                case 3
                    wallface (runInfo.ROOM.v, runInfo.ROOM.order(k,:),runInfo.ROOM.normals(k,:),texname(getTextureIndex(expInfo.EXP.leftWallText)),runInfo.ROOM.wrap(k,:));
                case 4
                    wallface (runInfo.ROOM.v, runInfo.ROOM.order(k,:),runInfo.ROOM.normals(k,:),texname(getTextureIndex(expInfo.EXP.rightWallText)),runInfo.ROOM.wrap(k,:));
                case 5
                    wallface (runInfo.ROOM.v, runInfo.ROOM.order(k,:),runInfo.ROOM.normals(k,:),texname(getTextureIndex(expInfo.EXP.ceilingText)),runInfo.ROOM.wrap(k,:));
                case 6
                    wallface (runInfo.ROOM.v, runInfo.ROOM.order(k,:),runInfo.ROOM.normals(k,:),texname(getTextureIndex(expInfo.EXP.floorText)),runInfo.ROOM.wrap(k,:));
                    ... Texture 1
                case 7
                wallface (runInfo.ROOM.v, runInfo.ROOM.order(k,:),runInfo.ROOM.normals(k,:),texname(getTextureIndex(expInfo.EXP.Leg1Text1)),runInfo.ROOM.wrap(k,:));
                case 8
                    wallface (runInfo.ROOM.v, runInfo.ROOM.order(k,:),runInfo.ROOM.normals(k,:),texname(getTextureIndex(expInfo.EXP.Leg1Text2)),runInfo.ROOM.wrap(k,:));
                case 9
                    wallface (runInfo.ROOM.v, runInfo.ROOM.order(k,:),runInfo.ROOM.normals(k,:),texname(getTextureIndex(expInfo.EXP.Leg1Text3)),runInfo.ROOM.wrap(k,:));
                case 10
                    wallface (runInfo.ROOM.v, runInfo.ROOM.order(k,:),runInfo.ROOM.normals(k,:),texname(getTextureIndex(expInfo.EXP.Leg1Text4)),runInfo.ROOM.wrap(k,:));
                    ... Texture 2
                case 11
                wallface (runInfo.ROOM.v, runInfo.ROOM.order(k,:),runInfo.ROOM.normals(k,:),texname(getTextureIndex(expInfo.EXP.Leg2Text1)),runInfo.ROOM.wrap(k,:));
                case 12
                    wallface (runInfo.ROOM.v, runInfo.ROOM.order(k,:),runInfo.ROOM.normals(k,:),texname(getTextureIndex(expInfo.EXP.Leg2Text2)),runInfo.ROOM.wrap(k,:));
                case 13
                    wallface (runInfo.ROOM.v, runInfo.ROOM.order(k,:),runInfo.ROOM.normals(k,:),texname(getTextureIndex(expInfo.EXP.Leg2Text3)),runInfo.ROOM.wrap(k,:));
                case 14
                    wallface (runInfo.ROOM.v, runInfo.ROOM.order(k,:),runInfo.ROOM.normals(k,:),texname(getTextureIndex(expInfo.EXP.Leg2Text4)),runInfo.ROOM.wrap(k,:));
                    ... Texture 3
                case 15
                wallface (runInfo.ROOM.v, runInfo.ROOM.order(k,:),runInfo.ROOM.normals(k,:),texname(getTextureIndex(expInfo.EXP.Leg3Text1)),runInfo.ROOM.wrap(k,:));
                case 16
                    wallface (runInfo.ROOM.v, runInfo.ROOM.order(k,:),runInfo.ROOM.normals(k,:),texname(getTextureIndex(expInfo.EXP.Leg3Text2)),runInfo.ROOM.wrap(k,:));
                case 17
                    wallface (runInfo.ROOM.v, runInfo.ROOM.order(k,:),runInfo.ROOM.normals(k,:),texname(getTextureIndex(expInfo.EXP.Leg3Text3)),runInfo.ROOM.wrap(k,:));
                case 18
                    wallface (runInfo.ROOM.v, runInfo.ROOM.order(k,:),runInfo.ROOM.normals(k,:),texname(getTextureIndex(expInfo.EXP.Leg3Text4)),runInfo.ROOM.wrap(k,:));
                    ... Texture 4
                case 19
                wallface (runInfo.ROOM.v, runInfo.ROOM.order(k,:),runInfo.ROOM.normals(k,:),texname(getTextureIndex(expInfo.EXP.Leg4Text1)),runInfo.ROOM.wrap(k,:));
                case 20
                    wallface (runInfo.ROOM.v, runInfo.ROOM.order(k,:),runInfo.ROOM.normals(k,:),texname(getTextureIndex(expInfo.EXP.Leg4Text2)),runInfo.ROOM.wrap(k,:));
                case 21
                    wallface (runInfo.ROOM.v, runInfo.ROOM.order(k,:),runInfo.ROOM.normals(k,:),texname(getTextureIndex(expInfo.EXP.Leg4Text3)),runInfo.ROOM.wrap(k,:));
                case 22
                    wallface (runInfo.ROOM.v, runInfo.ROOM.order(k,:),runInfo.ROOM.normals(k,:),texname(getTextureIndex(expInfo.EXP.Leg4Text4)),runInfo.ROOM.wrap(k,:));
                    ... End Texture 1
                case 19+4
                wallface (runInfo.ROOM.v, runInfo.ROOM.order(k,:),runInfo.ROOM.normals(k,:),texname(getTextureIndex(expInfo.EXP.End1Text1)),runInfo.ROOM.wrap(k,:));
                case 20+4
                    wallface (runInfo.ROOM.v, runInfo.ROOM.order(k,:),runInfo.ROOM.normals(k,:),texname(getTextureIndex(expInfo.EXP.End1Text2)),runInfo.ROOM.wrap(k,:));
                case 21+4
                    wallface (runInfo.ROOM.v, runInfo.ROOM.order(k,:),runInfo.ROOM.normals(k,:),texname(getTextureIndex(expInfo.EXP.End1Text3)),runInfo.ROOM.wrap(k,:));
                case 22+4
                    wallface (runInfo.ROOM.v, runInfo.ROOM.order(k,:),runInfo.ROOM.normals(k,:),texname(getTextureIndex(expInfo.EXP.End1Text4)),runInfo.ROOM.wrap(k,:));
                    ... End Texture 2
                case 23+4
                wallface (runInfo.ROOM.v, runInfo.ROOM.order(k,:),runInfo.ROOM.normals(k,:),texname(getTextureIndex(expInfo.EXP.End2Text1)),runInfo.ROOM.wrap(k,:));
                case 24+4
                    wallface (runInfo.ROOM.v, runInfo.ROOM.order(k,:),runInfo.ROOM.normals(k,:),texname(getTextureIndex(expInfo.EXP.End2Text2)),runInfo.ROOM.wrap(k,:));
                case 25+4
                    wallface (runInfo.ROOM.v, runInfo.ROOM.order(k,:),runInfo.ROOM.normals(k,:),texname(getTextureIndex(expInfo.EXP.End2Text3)),runInfo.ROOM.wrap(k,:));
                case 26+4
                    wallface (runInfo.ROOM.v, runInfo.ROOM.order(k,:),runInfo.ROOM.normals(k,:),texname(getTextureIndex(expInfo.EXP.End2Text4)),runInfo.ROOM.wrap(k,:));
                    ...
                otherwise
                wallface (runInfo.ROOM.v, runInfo.ROOM.order(k,:),runInfo.ROOM.normals(k,:),texname(getTextureIndex('WHITENOISE')),runInfo.ROOM.wrap(k,:));
            end
        end
    end

    function getVRMovement
        if ~expInfo.OFFLINE
            switch expInfo.EXP.wheelType
                case 'BALL'
                    [ballTime, dax, dbx, day, dby] = getBallDeltas(myPort);
                    TRIAL.balldata(runInfo.currTrial,runInfo.count,:) = [ballTime, dax, dbx, day, dby];
                    %         dax = nansum([dax 0]).*BALL_TO_ROOM.*expInfo.EXP.xGain;
                    feedback_gain = expInfo.EXP.zGain*scaling_factor;
                    dbx = nansum([dbx 0]).*BALL_TO_ROOM.*feedback_gain;
                    
                case 'WHEEL'
                    ballTime = TRIAL.time(runInfo.currTrial,runInfo.count);
                    dax = 0; day = 0; dby = 0;
                    switch rigInfo.DevType
                        case 'NI'
                            scan_input = (hwInfo.rotEnc.readPosition);
                            hwInfo.rotEnc.zero;
                        case 'ARDUINO'
                            scan_input = fscanf(hwInfo.ardDev, '%d\t%d');
                            while length(scan_input)~=2
                                scan_input = fscanf(hwInfo.ardDev, '%d\t%d');
                            end
                            %                             hwInfo.ardDev.zero
                            % rotary encoder
                            temp = scan_input(1) - rigInfo.ARDHistory(1);
                            rigInfo.ARDHistory(1) = scan_input(1);
                            scan_input(1) = temp;
                            % lick detector
                            temp = scan_input(2) - rigInfo.ARDHistory(2);
                            rigInfo.ARDHistory(2) = scan_input(2);
                            scan_input(2) = temp;
                            %                             display(num2str(scan_input));
                            flushinput(hwInfo.ardDev);
                    end
                    if ~strcmp(rigInfo.rotEncPos,'right')
                        dbx = -scan_input(1);
                    else
                        dbx = scan_input(1);
                    end
                    % convert to cm
                    dbx = dbx*((2*pi*expInfo.EXP.wheelRadius)./(1024*4)); % (cm)% because it is a 4 x 1024 unit encoder
                    % dbx = 50*dbx; % to be removed when the room is better calibrated
                    TRIAL.balldata(runInfo.currTrial,runInfo.count,:) = [ballTime, dax, dbx, day, dby];
                    dbx = nansum([dbx 0]).*scaling_factor.*expInfo.EXP.wheelToVR;
                    % Remove 'BALL_TO_ROOM' after this set of animals (28th
                    % Feb)
                    currLikStatus = scan_input(2);
                    if currLikStatus
                        TRIAL.lick(runInfo.currTrial,runInfo.count) = 1;
                    else
                        TRIAL.lick(runInfo.currTrial,runInfo.count) = 0;
                    end
                case 'KEYBRD'
                    getNonBallDeltas;
                    ballTime = TRIAL.time(runInfo.currTrial,runInfo.count);
                    dax = runInfo.MOUSEXY.dax;
                    day = runInfo.MOUSEXY.day;
                    dbx = runInfo.MOUSEXY.dbx;
                    dby = runInfo.MOUSEXY.dby;
            end
        else
            getNonBallDeltas;
            ballTime = TRIAL.time(runInfo.currTrial,runInfo.count);
            dax = runInfo.MOUSEXY.dax;
            day = runInfo.MOUSEXY.day;
            dbx = runInfo.MOUSEXY.dbx;
            dby = runInfo.MOUSEXY.dby;
        end
    end
end