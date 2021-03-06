classdef chooseAnimal < handle
    
    properties
        dataDir
        codeDir
        mazDir
        VRchoose
        isChosen = 0;
        animal
        numCond = 9;
        VRType
        replay = 0;
        replay_list = [{'No'},{'Yes'}];
        animal_list = [];
        list_maz
    end
    
    methods
        function createUI(v)
            %% Get the list of animals
            dir_list = dir(v.dataDir);
            v.animal_list = [];
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
                v.animal_list = [v.animal_list, {dir_list(dorder(n)).name}];
            end
            numCond = 9;
            
            %% Get the list of mazes
            v.mazDir = [v.codeDir filesep 'Mazes'];
%             rmpath(genpath(v.mazDir));
            maz_list = dir(v.mazDir);
            maz_list(1) = [];
            maz_list(1) = [];
            list_maz = [];
            for n = 1:length(maz_list)
                list_maz = [list_maz, {maz_list(n).name}];
            end
            VRType = list_maz{1};
            v.list_maz = list_maz;
            
            %% Make the small GUI
            v.VRchoose.animalChoice.secA = uiextras.HBox('Parent',v.VRchoose.chooseAnimal,'Spacing',10,'Padding',5);
            v.VRchoose.animalChoice.secB = uiextras.HBox('Parent',v.VRchoose.chooseAnimal,'Spacing',10,'Padding',5);
            v.VRchoose.animalChoice.chooseAnimal.Sizes = [-2 -1];
            
            v.VRchoose.animalChoice.animalNameBox = uiextras.VBox('Parent',v.VRchoose.animalChoice.secA,'Spacing',10,'Padding',2);
            v.VRchoose.animalChoice.mazeTypeBox = uiextras.VBox('Parent',v.VRchoose.animalChoice.secB,'Spacing',10,'Padding',5);
            v.VRchoose.animalChoice.numCondBox  = uiextras.VBox('Parent',v.VRchoose.animalChoice.secB,'Spacing',10,'Padding',5);
            v.VRchoose.animalChoice.secB.Sizes  = [-1 -1];
            %     v.VRchoose.animalChoice.startExp      = uiextras.VBox('Parent',v.VRchoose.animalChoice.secA,'Spacing',10,'Padding',5);
            
            % Start button
            v.VRchoose.animalChoice.button = uicontrol('Style','pushbutton',...
                'Parent',v.VRchoose.animalChoice.secA,...
                ...'Position', [165 100 80 80],...
                'background','white','fontsize',14,...
                'String','LOAD','Callback', @(~,~) v.okGo, 'Enable','off');
            
            % f = figure('Name','Choose animal','NumberTitle','off',...
            %     'MenuBar','none',...
            %     'OuterPosition',[200 300 300 250]);
            
            % Animal Choice Area
            v.VRchoose.animalChoice.textA = uicontrol('Style','text',...
                'Parent',v.VRchoose.animalChoice.animalNameBox,...
                ...'Position', [5 160 150 25],...
                ...'background','white',...
                'String','Choose animal:',...
                'fontsize',10,...
                'HorizontalAlignment','left');
            v.VRchoose.animalChoice.popup = uicontrol('Style','popup',...
                'Parent',v.VRchoose.animalChoice.animalNameBox,...
                'String', v.animal_list,...
                ...'Position', [5 135 150 25],...
                ...'background','white',
                'fontsize',10,...
                'Value',1,'Callback', @(~,~) v.animal_chosen);
            v.VRchoose.animalChoice.textB = uicontrol('Style','text',...
                'Parent',v.VRchoose.animalChoice.animalNameBox,...
                ...'Position', [5 95 150 25],...
                ...'background','white',...
                'String','(or) New animal:',...
                'fontsize',10,...
                'HorizontalAlignment','left');
            v.VRchoose.animalChoice.editA = uicontrol('Style','edit',...
                'Parent',v.VRchoose.animalChoice.animalNameBox,...
                ...'Position', [15 70 130 25],...
                ...'background','white',
                'fontsize',10,...
                'String','?','Callback', @(~,~) v.new_animal);
            
            v.VRchoose.animalChoice.animalNameBox.Sizes = [-1 -1 -1 -1];
            v.VRchoose.animalChoice.secA.Sizes = [-3 -1];
            
            
            v.VRchoose.animalChoice.textC = uicontrol('Style','text',...
                'Parent',v.VRchoose.animalChoice.numCondBox,...
                ...'Position', [125 35 100 25],...
                ...'background','white',...
                'String','Number of cond.',...
                'fontsize',10,...
                'HorizontalAlignment','left');
            v.VRchoose.animalChoice.editB = uicontrol('Style','edit',...
                'Parent',v.VRchoose.animalChoice.numCondBox,...
                ...'Position', [125 10 100 25],...
                ...'background','white',
                'fontsize',10,...
                'String','9','Callback', @(~,~) v.num_trial);
            v.VRchoose.animalChoice.textD = uicontrol('Style','text',...
                'Parent',v.VRchoose.animalChoice.mazeTypeBox,...
                ...'Position', [5 35 100 25],...
                ...'BackgroundColor','white',...
                'String','Maze:',...
                'fontsize',10,...
                'HorizontalAlignment','left');
            v.VRchoose.animalChoice.popup2 = uicontrol('Style','popup',...
                'Parent',v.VRchoose.animalChoice.mazeTypeBox,...
                'String', v.list_maz,...
                ...'Position', [5 10 100 25],...
                ...'background','white',
                'fontsize',10,...
                'Value',1,'Callback', @(~,~) v.maze_chosen);
            v.VRchoose.animalChoice.textE = uicontrol('Style','text',...
                'Parent',v.VRchoose.animalChoice.mazeTypeBox,...
                ...'Position', [5 35 100 25],...
                ...'BackgroundColor','white',...
                'String','Replay:',...
                'fontsize',10,...
                'HorizontalAlignment','left');
            v.VRchoose.animalChoice.popup_replay = uicontrol('Style','popup',...
                'Parent',v.VRchoose.animalChoice.mazeTypeBox,...
                'String', v.replay_list,...
                ...'Position', [5 10 100 25],...
                ...'background','white',
                'fontsize',10,...
                'Value',1,'Callback', @(~,~) v.replayChosen);
            uiwait;
            % close(MainFig);
        end
        function animal_chosen(v)
            v.animal = v.animal_list{v.VRchoose.animalChoice.popup.Value};
            AnimalDir = fullfile(v.dataDir, v.animal);
            if ~exist(AnimalDir); mkdir(AnimalDir); end
            set(v.VRchoose.animalChoice.button, 'Enable', 'on', 'BackgroundColor', [0.5 1 0.5]);
%             exp = load([AnimalDir filesep 'EXP']);
%             for iStim = 1:length(exp.exp.StimVar)
%                 if v.numCond<length(exp.exp.StimVar(iStim).trialVal)
%                     v.numCond=length(exp.exp.StimVar(iStim).trialVal);
%                 end
%             end
%             v.VRchoose.animalChoice.editB.String = num2str(v.numCond);
%             set(v.VRchoose.animalChoice.button, 'Enable', 'on', 'BackgroundColor', [0.5 1 0.5]);
            %         uiresume
        end
        function new_animal(v)
            v.animal = v.VRchoose.animalChoice.editA.String;
            AnimalDir = fullfile(v.dataDir, v.animal);
            if ~exist(AnimalDir); mkdir(AnimalDir); end
            set(v.VRchoose.animalChoice.button, 'Enable', 'on', 'BackgroundColor', [0.5 1 0.5]);
            %         uiresume
        end
        function num_trial(v)
            v.numCond = str2num(v.VRchoose.animalChoice.editB.String);
        end
        function okGo(v)
            set(v.VRchoose.animalChoice.button, 'Enable', 'off', 'background', [.5 .5 1], 'String', 'RELOAD');
%             set(v.VRchoose.animalChoice.popup, 'Enable', 'off', 'background', 'white');
%             set(v.VRchoose.animalChoice.popup2, 'Enable', 'off', 'background', 'white');
%             set(v.VRchoose.animalChoice.editB, 'Enable', 'off', 'background', 'white');
%             set(v.VRchoose.animalChoice.editA, 'Enable', 'off', 'background', 'white');
            if ~v.isChosen
                uiresume
            end
            v.isChosen = 1;
        end
        function maze_chosen(v)
            v.VRType = v.list_maz{v.VRchoose.animalChoice.popup2.Value};
            addpath([v.mazDir filesep v.VRType]);
        end
        function replayChosen(v)
            v.replay = v.VRchoose.animalChoice.popup_replay.Value - 1;
        end
    end
end