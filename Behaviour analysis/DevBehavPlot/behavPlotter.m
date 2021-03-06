classdef (InferiorClasses = {?expSelector}) behavPlotter < handle
    
    properties
        expObject
        AnimalObject = [];
                
        figHandle
        es
        VR
        esLoaded = false;
        totalReward = [];
        trialStart = [];
        trialEnd = [];
    end
    
    methods
        function obj = behavPlotter
            obj.createUI;
        end
        
        function createUI(obj)
            obj.figHandle.MainFig = figure('Name', 'Behaviour PLotter',...
                'Toolbar', 'none',...
                'NumberTitle', 'off',...
                'Units', 'pixels',...
                'OuterPosition', get(0, 'Screensize'), ...
                'Color', [0 0 0]);%...
            
            obj.figHandle.Full = uiextras.VBox('Parent',obj.figHandle.MainFig,'Spacing',5,'Padding',2);
            
            VerSplit = -1/8;
            
            %Splitting to three rows of plots
            obj.figHandle.Top = uiextras.HBox('Parent',obj.figHandle.Full,'Spacing',5,'Padding',2);
            obj.figHandle.Middle = uiextras.HBox('Parent',obj.figHandle.Full,'Spacing',5,'Padding',2);
            obj.figHandle.Bottom = uiextras.HBox('Parent',obj.figHandle.Full,'Spacing',5,'Padding',2);
            
            %Spliting the top
            obj.figHandle.expSelectorPanel = uipanel('Parent',obj.figHandle.Top);
            obj.figHandle.PositionTimePlot = uipanel('Parent',obj.figHandle.Top,'BorderType','none');
            obj.figHandle.Top.Widths = [2*VerSplit 6*VerSplit];
            
            % Splitting the Middle
            obj.figHandle.animalInfoPanel  = uipanel('Parent',obj.figHandle.Middle);
            obj.figHandle.HistSpdPlot   = uipanel('Parent',obj.figHandle.Middle,'BorderType','none');
            obj.figHandle.HistPosPlot   = uipanel('Parent',obj.figHandle.Middle,'BorderType','none');
            %obj.figHandle.VRPosPlot     = uipanel('Parent',obj.figHandle.Middle,'BorderType','none');
            obj.figHandle.SpdProfilePlot = uipanel('Parent',obj.figHandle.Middle,'BorderType','none');
            obj.figHandle.HistLickPlot   = uipanel('Parent',obj.figHandle.Middle,'BorderType','none');
            obj.figHandle.Middle.Sizes  = [ 2*VerSplit 6/4*VerSplit 6/4*VerSplit 6/4*VerSplit 6/4*VerSplit ];
            
            % Splitting the bottom
            obj.figHandle.SomethingElse = uipanel('Parent',obj.figHandle.Bottom,'BorderType','none');
            obj.figHandle.BeahvEventsTime   = uipanel('Parent',obj.figHandle.Bottom,'BorderType','none');
            obj.figHandle.PSTHLicksSpeed    = uipanel('Parent',obj.figHandle.Bottom,'BorderType','none');
            obj.figHandle.Bottom.Sizes  = [2*VerSplit 6/2*VerSplit 6/2*VerSplit];
            
            obj.getAnimalObj;
        end
        
        function getAnimalObj(obj)
            if isempty(obj.AnimalObject)
                obj.AnimalObject = expSelector(obj);
            end
            obj.AnimalObject.embeddedObj = true;
            obj.AnimalObject.createUI_es(obj.figHandle.expSelectorPanel);
            
        end
        
        function doAllPlots(obj)
            obj.expObject = obj.AnimalObject.expObject;
            [obj.es, obj.totalReward obj.VR] = obj.expObject.loadBehav;
            obj.esLoaded = true;
            
            AnimalSessionInfo = GetSessionInfo(obj);

            %% TOP            
            % Position VS Time
            axes(obj.figHandle.PositionTimePlot);
            PositionVSTime(obj, AnimalSessionInfo);
            
            %% MIDDLE
            % Animal Info Panel
            DisplayInfoPanel(obj, AnimalSessionInfo);
            
            % Position Probability Distribution
            axes(obj.figHandle.HistPosPlot);
            PositionDistribution(obj, AnimalSessionInfo);
            
            % Mean Speed Distribution
            axes(obj.figHandle.SpdProfilePlot);
            SpeedTrackDistribution(obj, AnimalSessionInfo);
            
            % Lick Count Distribution
            axes(obj.figHandle.HistLickPlot);
            LicksDistribution(obj, AnimalSessionInfo);
            
            % Speed his plot
            axes(obj.figHandle.HistSpdPlot)
            SpeedProfileHist(obj, AnimalSessionInfo);
            
            %% BOTTOM
            % Lick temporal Distribution
            axes(obj.figHandle.BeahvEventsTime);
            BehavParamTemporalDistribution(obj, AnimalSessionInfo);
            
            % PSTH of of speed and licking before rewards
            axes(obj.figHandle.PSTHLicksSpeed);
            PSTHLicksSpeed(obj, AnimalSessionInfo);
            
        end
        
        function load(obj)
            % load / reload the data
            [obj.es, obj.totalReward] = obj.expObject.loadBehav;
        end
        
        function run(obj, animal, iseries, iexp)
            % Takes in the details directly
            obj.expObject.animal = animal;
            obj.expObject.iseries = iseries;
            obj.expObject.exp_list = iexp;
            obj.run_rest;
        end
        
        function runFromExpSelector(obj, eo)
            % Takes in experiment object from the expSelector
            obj.expObject = eo;
            obj.run_rest;
        end
           
        function run_rest(obj)
            % This is the main plotting function
            obj.load;
            obj.createUI;
        end
        
        function DisplayInfoPanel(obj, AnimalSessionInfo)
                        
            InfoType = {'MOUSE: ';...
                        'Session: '; ...
                        'Training day nr: '; ...
                        'Duration: '; ...
                        'Total nr of trials: '; ...
                        'Nr of trials completed: '; ...
                        'VR type: '; ...
                        'Avg. trial duration (seconds): '; ...
                        'Avg. moving speed (cm/s): '; ...
                        'Max moving speed (cm/s): '; ...
                        'Percent time spent moving (>2cm/s): '; ...
                        'Rewards released by user: '; ...
                        'Rewards released passive: '; ...
                        'Rewards released active: '; ...
                        'Licks per trial: '; ...
                        'Licks before reward location: '
                        'Licks after reward location: '
                        };
            MapInfo2Animal = [1 5 3 6 7 10 8 11 13 14 15 16 17 18 19 20 21];   
            
            NrRows = length(InfoType);
            for kk = 1:NrRows
                obj.figHandle.animalText = uicontrol('Style','text',...
                    'Parent',obj.figHandle.animalInfoPanel,...
                    'fontweight','bold', ...
                    'Units','normalized', ...
                    'Position', [0.05 1-1/NrRows*kk 0.4 1/NrRows], ...
                    'String', InfoType{kk} ,...  %AnimalSessionInfo{1}
                    'HorizontalAlignment','right');
                if isstr(AnimalSessionInfo{MapInfo2Animal(kk)})
                    obj.figHandle.animalText1 = uicontrol('Style','text',...
                        'Parent',obj.figHandle.animalInfoPanel,...
                        'Units','normalized', ...
                        'Position', [0.5 1-1/NrRows*kk 0.4 1/NrRows], ...
                        'String', AnimalSessionInfo{MapInfo2Animal(kk)},...
                        'HorizontalAlignment','left');
                else
                    obj.figHandle.animalText1 = uicontrol('Style','text',...
                    'Parent',obj.figHandle.animalInfoPanel,...
                    'Units','normalized', ...
                    'Position', [0.5 1-1/NrRows*kk 0.4 1/NrRows], ...
                    'String', num2str(AnimalSessionInfo{MapInfo2Animal(kk)}),...
                    'HorizontalAlignment','left');
                end
            end
                    
            % to add spatial frequency info of the textures for DIT task or
            % other task specific details
            
        end

    end
end