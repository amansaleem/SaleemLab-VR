classdef behavPlotter < handle
    
    properties
        expObject
        AnimalObject
                
        figHandle
        es
        VR
        esLoaded = false;
        totalReward = [];
        trialStart = [];
        trialEnd = [];
    end
    
    methods
        function createUI(obj)
            obj.figHandle.MainFig = figure('Name', 'Behaviour PLotter',...
                'Toolbar', 'none',...
                'NumberTitle', 'off',...
                'Units', 'normalized',...
                'OuterPosition', [0.1 0.1 0.5 0.7]);%...
            
            obj.figHandle.Full = uiextras.VBox('Parent',obj.figHandle.MainFig,'Spacing',5,'Padding',2);
            
            %Splitting to top and bottom sections
            obj.figHandle.Top = uiextras.HBox('Parent',obj.figHandle.Full,'Spacing',5,'Padding',2);
            obj.figHandle.Middle = uiextras.HBox('Parent',obj.figHandle.Full,'Spacing',5,'Padding',2);
            obj.figHandle.Bottom = uiextras.HBox('Parent',obj.figHandle.Full,'Spacing',5,'Padding',2);
            
            %Spliting the top
            obj.figHandle.animalInfoPanel = uiextras.VBox('Parent',obj.figHandle.Top,'Spacing',5,'Padding',2);
            obj.figHandle.PositionTimePlot = axes('Parent',obj.figHandle.Top);
            obj.figHandle.Top.Widths = [-1 -5];
            
            % Splitting the Middle
            obj.figHandle.detailsPanel  = uiextras.VBox('Parent',obj.figHandle.Middle,'Spacing',1,'Padding',1);
            obj.figHandle.HistPosPlot   = axes('Parent',obj.figHandle.Middle);
            obj.figHandle.VRPosPlot     = axes('Parent',obj.figHandle.Middle);
            obj.figHandle.SpdProfilePlot = axes('Parent',obj.figHandle.Middle);
            obj.figHandle.HistSpdPlot   = axes('Parent',obj.figHandle.Middle);
            obj.figHandle.HistLickPlot   = axes('Parent',obj.figHandle.Middle);
            obj.figHandle.Middle.Sizes  = [-1 -1 -1 -1 -1 -1];
            
            % Splitting the bottom
            obj.figHandle.BeahvEventsTime   = axes('Parent',obj.figHandle.Bottom);
            obj.figHandle.PSTHLicks     = axes('Parent',obj.figHandle.Bottom);
            obj.figHandle.PSTHSpeed = axes('Parent',obj.figHandle.Bottom);
            obj.figHandle.Bottom.Sizes  = [-1 -1 -1];
            
            [obj.es, obj.totalReward obj.VR] = obj.expObject.loadBehav;
            obj.esLoaded = true;
            
            % Animal Info Panel
            AnimalSessionInfo = GetSessionInfo(obj);
            DisplayInfoPanel(obj, AnimalSessionInfo);
            
            % Position VS Time
            axes(obj.figHandle.PositionTimePlot);
            PositionVSTime(obj, AnimalSessionInfo);
            obj.figHandle.Top.Widths = [-1 -5];
            
            % Position Probability Distribution
            axes(obj.figHandle.HistPosPlot);
            PositionDistribution(obj, AnimalSessionInfo);
            obj.figHandle.Middle.Sizes  = [-1 -1 -1 -1 -1 -1];
            
            % Mean Speed Distribution
            axes(obj.figHandle.SpdProfilePlot);
            SpeedDistribution(obj, AnimalSessionInfo);
            obj.figHandle.Middle.Sizes  = [-1 -1 -1 -1 -1 -1];
            
            % Lick Count Distribution
            axes(obj.figHandle.HistLickPlot);
            LicksDistribution(obj, AnimalSessionInfo);
            obj.figHandle.Middle.Sizes  = [-1 -1 -1 -1 -1 -1];
            
            % Lick temporal Distribution
            axes(obj.figHandle.BeahvEventsTime);
            BehavParamTemporalDistribution(obj, AnimalSessionInfo);
            obj.figHandle.Bottom.Sizes  = [-1 -1 -1];
            
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
    end
end