classdef behavPlotter < handle
    
    properties
        expObject
        
        figHandle
        es
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
            
            obj.figHandle.Full = uiextras.VBox('Parent',obj.figHandle.MainFig,'Spacing',10,'Padding',5);
            
            %Splitting to top and bottom sections
            obj.figHandle.Top = uiextras.HBox('Parent',obj.figHandle.Full,'Spacing',10,'Padding',5);
            obj.figHandle.Middle = uiextras.HBox('Parent',obj.figHandle.Full,'Spacing',10,'Padding',5);
            obj.figHandle.Full.Sizes = [-1 -1];
            
            %Spliting the top
            obj.figHandle.animalInfoPanel = uiextras.VBox('Parent',obj.figHandle.Top,'Spacing',10,'Padding',5);
            obj.figHandle.PositionTimePlot = axes('Parent',obj.figHandle.Top);
            obj.figHandle.Top.Sizes = [-1 -5];
            
            % Splitting the bottom
            obj.figHandle.detailsPanel  = uiextras.VBox('Parent',obj.figHandle.Middle,'Spacing',10,'Padding',5);
            obj.figHandle.HistPosPlot   = axes('Parent',obj.figHandle.Middle);
            obj.figHandle.VRPosPlot     = axes('Parent',obj.figHandle.Middle);
            obj.figHandle.SpdProfilePlot = axes('Parent',obj.figHandle.Middle);
            obj.figHandle.HistSpdPlot   = axes('Parent',obj.figHandle.Middle);
            obj.figHandle.Middle.Sizes  = [-1 -1 -1 -1 -1];
            
            % Animal Info Panel
            obj.figHandle.animalText = uicontrol('Style','text',...
                'Parent',obj.figHandle.animalInfoPanel,...
                'String', obj.expObject.animal,...
                'fontsize',14, 'HorizontalAlignment','left');
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