classdef VRClientConnector < handle %(VRchoose, VRparameters)
    
    properties
        VRchoose
        VRparameters
        client
        list_servers
        currExp = 1;
        changeButton = true;
        local = false;
    end
        
    methods
        function addExp(v)
            v.currExp = v.currExp + 1;
            v.client{v.currExp} = VRclient;
            set(v.VRchoose.clientUI.popup, 'Enable','on');
        end
        
        function [v] = createUI(v, VRchoose, VRparameters)
            v.client{v.currExp} = VRclient;
            v.list_servers = v.client{v.currExp}.listServers;
            v.VRchoose = VRchoose;
            v.VRparameters = VRparameters;
            
            v.VRchoose.clientUI.all   = uiextras.HBox('Parent',v.VRchoose.serverPanel,'Spacing', 10, 'Padding',5);
            v.VRchoose.clientUI.left  = uiextras.VBox('Parent',v.VRchoose.clientUI.all,'Spacing', 10, 'Padding',5);
            v.VRchoose.clientUI.right = uiextras.VBox('Parent',v.VRchoose.clientUI.all,'Spacing', 10, 'Padding',5);
            
            v.VRchoose.clientUI.textA = uicontrol('Style','text',...
                'Parent',v.VRchoose.clientUI.left,...
                ...'Position', [5 160 150 25],...'background','white',...
                'String','Connect to server:',...
                'fontsize',12,'HorizontalAlignment','left');
            v.VRchoose.clientUI.popup = uicontrol('Style','popup',...
                'Parent',v.VRchoose.clientUI.left,...
                'String', v.list_servers,...
                ...'Position', [5 135 150 25],...
                ...'background','white',...
                'fontsize',12,...
                'Value',1,'Callback', @(~,~) v.server_chosen);
            v.VRchoose.clientUI.StatusButton = uicontrol('Style','pushbutton',...
                'Parent',v.VRchoose.clientUI.right,...
                ...'Position', [165 100 80 80],...
                'background','white',...
                'fontsize',12,...
                'String','Check Status','Callback', @(~,~) v.status, 'Enable','on');
            v.VRchoose.clientUI.textB = uicontrol('Style','pushbutton',...
                'Parent',v.VRchoose.clientUI.right,...
                ...'Position', [5 160 150 25],...,...
                'BackgroundColor',[1 0.5 0.5],...
                'String','Disconnected',...
                'fontsize',14,'Enable','off');...'HorizontalAlignment','center');...
                ...'VerticalAlignment','center');
            v.VRchoose.clientUI.DisconButton = uicontrol('Style','pushbutton',...
                'Parent',v.VRchoose.clientUI.left,...
                ...'Position', [165 100 80 80],...
                'background','white',...
                'fontsize',12,...
                'String','Disconnect','Callback', @(~,~) v.discon, 'Enable','on');
        end
        
        function server_chosen(v)
            serverID = v.VRchoose.clientUI.popup.Value;
            if ~strcmp(v.list_servers(serverID), 'LOCAL')
                v.local = false;
                v.client{v.currExp}.connect(serverID);
                pause(1e-2)
                v.status
                set(v.VRchoose.clientUI.StatusButton,'Enable','on')
                set(v.VRchoose.clientUI.popup,'Enable','off')
            else
                v.local = true;
                v.client{v.currExp}.local = true;
                set(v.VRchoose.clientUI.textB, 'String','LOCAL!',...
                    'BackgroundColor',[0.5 1 0.5]);
%                 set(v.VRchoose.clientUI.popup,'Enable','off')
                v.status
            end    
        end
        
        function status(v)
            if ~v.local
                state = v.client{v.currExp}.status;
                if state==0
                    set(v.VRchoose.clientUI.textB, 'String','Disconnected',...
                        'BackgroundColor',[1 0.5 0.5]);
                elseif state==1
                    set(v.VRchoose.clientUI.textB, 'String','Connected!',...
                        'BackgroundColor',[0.5 1 0.5]);
                    if v.changeButton
                        set(v.VRparameters.runButton,'Enable','on', 'BackgroundColor', [0.5 1 0.5])
                    end
                end
            else
                set(v.VRchoose.clientUI.textB, 'String','LOCAL!',...
                    'BackgroundColor',[0.5 1 0.5]);
                if v.changeButton
                    set(v.VRparameters.runButton,'Enable','on', 'BackgroundColor', [0.5 1 0.5])
                end
                set(v.VRchoose.clientUI.DisconButton, 'Enable', 'off');
            end
        end
        
        function discon(v)
            v.client{v.currExp}.close;
            set(v.VRchoose.clientUI.textB, 'String','Disconnected',...
                'BackgroundColor',[1 0.5 0.5]);
            set(v.VRchoose.clientUI.popup,'Enable','on')
            if v.changeButton
                set(v.VRparameters.runButton,'Enable','off', 'BackgroundColor', [1 0.5 0.5])
            end
        end
    end
end