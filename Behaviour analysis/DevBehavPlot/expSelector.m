classdef expSelector < handle
    
    properties
        dataDir
        codeDir
        
        animalFullList
        animalShortList
        animalFilter =[];
        
        seriesList = [];
        expList = [];
        
        expObject
        figHandle
        embeddedObj = false;
        behavGuiObj = [];
    end
    
    methods
        % https://uk.mathworks.com/help/matlab/matlab_oop/method-invocation.html
        function obj = expSelector(fromGUIobj)
            if nargin<1
                obj.createUI_es;
            end
            obj.expObject = expObject;
            obj.behavGuiObj = fromGUIobj;
        end
        function createUI_es(obj, figInput)
            if nargin~=1
                obj.figHandle.MainFig = figInput;
            else
                obj.figHandle.MainFig = figure('Name', 'Experiment Selector',...
                    'MenuBar', 'none', ...
                    'Toolbar', 'none',...
                    'NumberTitle', 'off',...
                    'Units', 'normalized',...
                    'OuterPosition', [0.1 0.1 0.2 0.3]);%...
            end
            obj.figHandle.Full = uiextras.VBox('Parent',obj.figHandle.MainFig,'Spacing',10,'Padding',5);
            
            %Splitting to top and bottom sections
            obj.figHandle.Top = uiextras.HBox('Parent',obj.figHandle.Full,'Spacing',10,'Padding',5);
            obj.figHandle.Bottom = uiextras.HBox('Parent',obj.figHandle.Full,'Spacing',10,'Padding',5);
            obj.figHandle.Full.Sizes = [-1 -1];
            
            %Spliting the top
            obj.figHandle.animalFilterPanel = uiextras.VBox('Parent',obj.figHandle.Top,'Spacing',10,'Padding',5);
            obj.figHandle.animalListPanel = uiextras.VBox('Parent',obj.figHandle.Top,'Spacing',10,'Padding',5);
            obj.figHandle.seriesListPanel = uiextras.VBox('Parent',obj.figHandle.Top,'Spacing',10,'Padding',5);
            obj.figHandle.Top.Sizes = [-1 -1 -1];
            
            % Splitting the bottom
            obj.figHandle.expPanelA = uiextras.VBox('Parent',obj.figHandle.Bottom,'Spacing',10,'Padding',5);
            obj.figHandle.expPanelB = uiextras.VBox('Parent',obj.figHandle.Bottom,'Spacing',10,'Padding',5);
            obj.figHandle.runPanel  = uiextras.VBox('Parent',obj.figHandle.Bottom,'Spacing',10,'Padding',5);
            obj.figHandle.Top.Sizes = [-1 -1 -1];
            
            %% Splitting the animal panel
            obj.figHandle.animalText = uicontrol('Style','text',...
                'Parent',obj.figHandle.animalFilterPanel,...
                'String','Animal list:',...
                'fontsize',14, 'HorizontalAlignment','left');
            obj.figHandle.FilterText = uicontrol('Style','text',...
                'Parent',obj.figHandle.animalFilterPanel,...
                'String','Filter animal list:',...
                'fontsize',9, 'HorizontalAlignment','left');
            obj.figHandle.FilterTextBox = uicontrol('Style','edit',...
                'Parent',obj.figHandle.animalFilterPanel,...
                'fontsize',10,...
                'String','','Callback', @(~,~) obj.filterAnimals);
            obj.figHandle.animalFilterPanel.Sizes = [-2 -1 -1];
            
            % Animal list panel
            obj.figHandle.animalListText = uicontrol('Style','text',...
                'Parent',obj.figHandle.animalListPanel,...
                'String','Choose one:',...
                'fontsize',9, 'HorizontalAlignment','left');
            obj.figHandle.animalListBox = uicontrol('Style','listbox',...
                'Parent',obj.figHandle.animalListPanel,...
                'fontsize',9, 'HorizontalAlignment','left',...
                'Callback', @(~,~) obj.animalSelected);
            obj.getAnimals;
            set(obj.figHandle.animalListBox, 'String', obj.animalShortList);
            obj.figHandle.animalListPanel.Sizes = [-1 -6];
            
            %% Series list panel
            obj.figHandle.seriesListText = uicontrol('Style','text',...
                'Parent',obj.figHandle.seriesListPanel,...
                'String','Choose a series:',...
                'fontsize',9, 'HorizontalAlignment','left');
            obj.figHandle.seriesListBox = uicontrol('Style','listbox',...
                'Parent',obj.figHandle.seriesListPanel,...
                'fontsize',9, 'HorizontalAlignment','left',...
                'Callback', @(~,~) obj.seriesSelected);
            set(obj.figHandle.seriesListBox, 'String', '', 'Enable','off');
            obj.figHandle.seriesListPanel.Sizes = [-1 -6];
            
            %% Bottom panels
            obj.figHandle.expText = uicontrol('Style','text',...
                'Parent',obj.figHandle.expPanelA,...
                'String','Exp list:',...
                'fontsize',12, 'HorizontalAlignment','left');
            obj.figHandle.expListText = uicontrol('Style','text',...
                'Parent',obj.figHandle.expPanelA,...
                'String','Choose 1-5 experiment(s):',...
                'fontsize',10, 'HorizontalAlignment','center');
            obj.figHandle.expPanelA.Sizes = [-1 -1]; 
            
            obj.figHandle.expListBox = uicontrol('Style','listbox',...
                'Parent',obj.figHandle.expPanelB,...
                'fontsize',9, 'HorizontalAlignment','left',...
                'Callback', @(~,~) obj.expsSelected);
            set(obj.figHandle.expListBox, 'String', '', 'Enable','off');
            
            
            
            obj.figHandle.goButton = uicontrol('Style','pushbutton',...
                'Parent',obj.figHandle.runPanel,...
                'background','white','fontsize',14,...
                'String','GO','Callback', @(~,~) obj.triggerPlots, 'Enable','off');
        end
        
        function getAnimals(obj)
            RigInfo = VRRigInfo;
            
            obj.dataDir = RigInfo.dirSave;
            obj.codeDir = RigInfo.dirCode;
            dir_list = dir(obj.dataDir);
            
            obj.animalFullList = [];
            dir_list(1) = [];
            dir_list(1) = [];
            temp = [];
            for n = 1:length(dir_list)
                if ~dir_list(n).isdir
                    temp = [temp n];
                end
            end
            dir_list(temp) = [];
            for n = 1:length(dir_list)
                mdate(n) = dir_list(n).datenum;
            end
            [~, dorder] = sort(mdate);
            for n = length(dorder):-1:1
                obj.animalFullList = [obj.animalFullList, {dir_list(dorder(n)).name}];
            end
            obj.animalShortList = obj.animalFullList;
        end
        
        function filterAnimals(obj)
            % to create a shortlist of animals (Called hen the shortlist is
            % filled)
            obj.animalFilter = obj.figHandle.FilterTextBox.String;
            shortListIdx = contains(obj.animalFullList, obj.animalFilter,'IgnoreCase',true);
            obj.animalShortList = obj.animalFullList(shortListIdx);
            set(obj.figHandle.animalListBox, 'String', obj.animalShortList);
        end
        
        function animalSelected(obj)
            % called when animal is selected, list all series available
            obj.expObject.animal = obj.animalShortList{obj.figHandle.animalListBox.Value};
            AnimalDir = fullfile(obj.dataDir, obj.expObject.animal);
            series_list = dir(AnimalDir);
            
            obj.seriesList = [];
            series_list(1) = [];
            series_list(1) = [];
            temp = [];
            for n = 1:length(series_list)
                if ~series_list(n).isdir
                    temp = [temp n];
                end
            end
            series_list(temp) = [];
            for n = 1:length(series_list)
                mdate(n) = series_list(n).datenum;
            end
            [~, dorder] = sort(mdate);
            for n = length(dorder):-1:1
                obj.seriesList = [obj.seriesList, {series_list(dorder(n)).name}];
            end
            
            set(obj.figHandle.seriesListBox, 'String', obj.seriesList);
            set(obj.figHandle.seriesListBox, 'Enable', 'on');%...
        end
        
        function seriesSelected(obj)
            % called when series is selected, list all exp available
            obj.expObject.iseries = str2num(obj.seriesList{obj.figHandle.seriesListBox.Value});
            SeriesDir = fullfile(obj.dataDir, obj.expObject.animal, num2str(obj.expObject.iseries));
            exptFileList = dir(SeriesDir);
            
            exptFileNames = [];
            exptFileList(1) = [];
            exptFileList(1) = [];
            
            obj.expList = [];
            temp = [];
            for n = 1:length(exptFileList)
                if exptFileList(n).isdir
                    temp = [temp n];
                end
            end
            exptFileList(temp) = [];
            for n = 1:length(exptFileList)
                mdate(n) = exptFileList(n).datenum;
            end
            [~, dorder] = sort(mdate);
            tempStart = [obj.expObject.animal '_' num2str(obj.expObject.iseries) '_session_'];
            tempEnd   = '_trial001.mat';
            for n = 1:length(dorder)
                exptFileName = (exptFileList(dorder(n)).name((length(tempStart)+1):(end-length(tempEnd))));
                obj.expList = [obj.expList {exptFileName}];
            end
            
            set(obj.figHandle.expListBox, 'String', obj.expList);
            set(obj.figHandle.expListBox, 'Enable', 'on');
            set(obj.figHandle.expListBox, 'Max',5,'Min',0);
        end
        
        function expsSelected(obj)
            % called when series is selected, list all plot functions
            % available
            obj.expObject.iexp = []
            for iexp = 1:length(obj.figHandle.expListBox.Value)
                obj.expObject.iexp = [obj.expObject.iexp str2num(obj.expList{obj.figHandle.expListBox.Value(iexp)})];
            end
%             obj.expObject.iseries = str2num(obj.expObject.iseries);
            obj.expObject
            set(obj.figHandle.goButton, 'Enable','on','Background','g');
        end
        
        function triggerPlots(obj)
            set(obj.figHandle.goButton, 'Enable','off','Background','r');
            
            if ~obj.embeddedObj
                bp = behavPlotter;
                bp.expObject = obj.expObject;
                bp.AnimalObject = obj;
                bp.createUI;
                bp.doAllPlots;
            else
                obj.behavGuiObj.doAllPlots;
            end
            
        end
    end
end