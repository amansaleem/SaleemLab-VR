classdef behavPlotter < handle
    
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
        function createUI(obj)
            obj.figHandle.MainFig = figure('Name', 'Behaviour PLotter',...
                'Toolbar', 'none',...
                'NumberTitle', 'off',...
                'Units', 'normalized',...
                'OuterPosition', [0.1 0.1 0.5 0.7]);%...
            
            obj.figHandle.Full = uiextras.VBox('Parent',obj.figHandle.MainFig,'Spacing',5,'Padding',2);
            
            %Splitting to three rows of plots
            obj.figHandle.Top = uiextras.HBox('Parent',obj.figHandle.Full,'Spacing',5,'Padding',2);
            obj.figHandle.Middle = uiextras.HBox('Parent',obj.figHandle.Full,'Spacing',5,'Padding',2);
            obj.figHandle.Bottom = uiextras.HBox('Parent',obj.figHandle.Full,'Spacing',5,'Padding',2);
            
            %Spliting the top
            obj.figHandle.expSelectorPanel = uipanel('Parent',obj.figHandle.Top);
            obj.figHandle.PositionTimePlot = uipanel('Parent',obj.figHandle.Top,'BorderType','none');
            obj.figHandle.Top.Widths = [-1 -5];
            
            % Splitting the Middle
            obj.figHandle.animalInfoPanel  = uiextras.VBox('Parent',obj.figHandle.Middle);
            obj.figHandle.HistPosPlot   = uipanel('Parent',obj.figHandle.Middle,'BorderType','none');
            obj.figHandle.VRPosPlot     = uipanel('Parent',obj.figHandle.Middle,'BorderType','none');
            obj.figHandle.SpdProfilePlot = uipanel('Parent',obj.figHandle.Middle,'BorderType','none');
            %obj.figHandle.HistSpdPlot   = uipanel('Parent',obj.figHandle.Middle,'BorderType','none');
            obj.figHandle.HistLickPlot   = uipanel('Parent',obj.figHandle.Middle,'BorderType','none');
            obj.figHandle.Middle.Sizes  = [-1 -1 -1 -1 -1];
            
            % Splitting the bottom
            obj.figHandle.BeahvEventsTime   = uipanel('Parent',obj.figHandle.Bottom,'BorderType','none');
            obj.figHandle.PSTHLicks     = axes('Parent',obj.figHandle.Bottom);
            obj.figHandle.PSTHSpeed = axes('Parent',obj.figHandle.Bottom);
            obj.figHandle.Bottom.Sizes  = [-1 -1 -1];
        end
        
        function doAllPlots(obj)
            [obj.es, obj.totalReward obj.VR] = obj.expObject.loadBehav;
            obj.esLoaded = true;
            
            if isempty(obj.AnimalObject)
                obj.AnimalObject = expSelector(1);
            end
            obj.AnimalObject.createUI(obj.figHandle.expSelectorPanel);
            obj.AnimalObject.embeddedObj = true;
 
            AnimalSessionInfo = GetSessionInfo(obj);

            %% TOP            
            % Position VS Time
            axes(obj.figHandle.PositionTimePlot);
            PositionVSTime(obj, AnimalSessionInfo);
            obj.figHandle.Top.Widths = [-1 -5];
            
            %% MIDDLE
            % Animal Info Panel
            DisplayInfoPanel(obj, AnimalSessionInfo);
            obj.figHandle.Middle.Sizes  = [-1 -1 -1 -1 -1];
            
            % Position Probability Distribution
            axes(obj.figHandle.HistPosPlot);
            PositionDistribution(obj, AnimalSessionInfo);
            obj.figHandle.Middle.Sizes  = [-1 -1 -1 -1 -1];
            
            % Mean Speed Distribution
            axes(obj.figHandle.SpdProfilePlot);
            SpeedDistribution(obj, AnimalSessionInfo);
            obj.figHandle.Middle.Sizes  = [-1 -1 -1 -1 -1];
            
            % Lick Count Distribution
            axes(obj.figHandle.HistLickPlot);
            LicksDistribution(obj, AnimalSessionInfo);
            obj.figHandle.Middle.Sizes  = [-1 -1 -1 -1 -1];
            
            %% BOTTOM
            % Lick temporal Distribution
            axes(obj.figHandle.BeahvEventsTime);
            BehavParamTemporalDistribution(obj, AnimalSessionInfo);
            %obj.figHandle.Bottom.Widths  = [-1 -1 -1];
            
%             axes(obj.figHandle.BeahvEventsTime);
%             cla reset;
%             axes(obj.figHandle.BeahvEventsTime);
%             cla reset;
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