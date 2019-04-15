function varargout = VRBehaviourAnalysisGUI(varargin)

% 1. listbox1: Animal ID
% 2. listbox2: Date
% 3. popmenu1: Session
% 4. popmenu4: Start Trial
% 5. popmenu3: End Trial
% 6. radiobutton5: Alternate trials
% 7. popmenu5: Variable X (pos, VR, Run, default Position)
% 8. axes7:    X in time
% 9. axes1:    Position in time (per trial)
% 10.axes6:    position and speed (per trial) default: VR speed
% 11.radiobutton5: Run speed (default off)
% 12.axes5:    VR speed and Run speed
% 13.axes2:    Histogram of Run speeds
% 14.axes4:    Histogram of VR speeds

% addpath('\\zserver\Code\Spikes\')
% addpath(genpath('..\General\'))
% SetDirs

clear global CHOICE
clear global CHOICE_IDX

global CHOICE
global DIRS
% global handles
global EXPORT


%     [~,b] = system('hostname');
%     b = b(1:end-1);
DIRS.ball = 'X:\Archive - saleemlab\Data\Behav';
if ~exist(DIRS.ball)
    DIRS.ball = 'X:\ibn-vision\Archive - saleemlab\Data\Behav';
end

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @VRBehaviourAnalysisGUI_OpeningFcn, ...
    'gui_OutputFcn',  @VRBehaviourAnalysisGUI_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
a = varargin;
if nargin && ischar(a{1})
    gui_State.gui_Callback = str2func(a{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, a{:});
else
    gui_mainfcn(gui_State, a{:});
end

% --- Executes just before VRBehaviourAnalysisGUI is made visible.
function VRBehaviourAnalysisGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to VRBehaviourAnalysisGUI (see VARARGIN)

% Choose default command line output for VRBehaviourAnalysisGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes VRBehaviourAnalysisGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = VRBehaviourAnalysisGUI_OutputFcn(hObject, eventdata, handles)
global DIRS

varargout{1} = handles.output;

%     [index, ok] = listdlg('PromptString', 'Select the animal:',...
%         'ListSize', [500 150], 'SelectionMode','single', 'ListString', animal_list);
%     animal = animal_list(index);
%     animal = animal{1};
dir_list = dir(DIRS.ball);
animal_list = [];
for n = 3:length(dir_list)
    mdate(n-2) = dir_list(n).datenum;
end
[~, dorder] = sort(mdate);
for n = length(dorder):-1:1
    animal_list = [animal_list, {dir_list(dorder(n)+2).name}];
end

set(handles.listbox1, 'String', animal_list);
set(handles.edit1, 'String','')
set(handles.edit2, 'String','')



% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)

global animal

list_entries = get(handles.listbox1,'String');
index_selected = get(handles.listbox1,'Value');
animal = list_entries(index_selected);
animal = animal{1};
animal_selected(handles)

function animal_selected(handles)

global infoAll
global animal

infoAll = getDataInfo(animal);
date_list = [];
for n = 1:length(infoAll)
    date_list = [date_list, {infoAll(n).date}];
end

set(handles.edit1, 'String', animal)
set(handles.listbox3, 'String', date_list);
set(handles.popupmenu1, 'String', 'Choose date');

% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in listbox3.
function listbox3_Callback(hObject, eventdata, handles)

global infoAll
global info
global animal
global EXPORT
global iseries

% clear info;

list_entries = get(handles.listbox3,'String');
index_selected = get(handles.listbox3,'Value');
date = list_entries(index_selected);
iseries = date{1};

series_selected(handles)

function series_selected(handles)
global infoAll
global info
global animal
global EXPORT
global iseries

for i=1:numel(infoAll)
    whichdate = iseries;
    if strcmpi(infoAll(i).date,whichdate)==1
        info = infoAll(i);
        break;
    end
end

set(handles.edit2, 'String',num2str(iseries))
set(handles.popupmenu1, 'Value', 1);
set(handles.popupmenu1, 'String', info.sessions);
% set(handles.popupmenu1, 'Value',  info.sessions(1));

% if (EXPORT)
%     f1 = figure(1);
%     plotDatePerformance_gui(animal,info, gca)
% end
%
% plotDatePerformance_gui(animal,info, handles.axes7)
% --- Executes during object creation, after setting all properties.
function listbox3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)

global info;
global animal;
global iseries

global VRdata
global VRdata_all
global startTrial
global endTrial
global altTrial
global isRun
global X
global numTrials
global swin
global contVal
global gainVal
global lengthVal
global contTrials
global gainTrials
global lengthTrials
global locTrials
global activeTrials
global outcomeTrials

global ltexist
global rewOexist
global plot_log
global rewOutcome
global rewRewPos
global rewActive

swin = 1.01;
X = 1;
plot_log = 1;

list_entries = get(handles.popupmenu1,'String');
index_selected = get(handles.popupmenu1,'Value');
iexp = str2num(list_entries(index_selected,:));

[VRdata_all, VRdata_o] = VRWheelLoad_SL(animal, iseries, iexp);

ltexist = isfield(VRdata_all.TRIAL,'trialRL');
rewOexist = isfield(VRdata_all.TRIAL,'trialOutcome');
numTrials = size(VRdata_all.traj,1);

contTrials = ones(1,numTrials);
gainTrials = ones(1,numTrials);
lengthTrials = ones(1,numTrials);
locTrials = ones(1,numTrials);
activeTrials = ones(1,numTrials);
outcomeTrials = ones(1,numTrials);

startTrial = 1;
endTrial   = numTrials;
altTrial = 1;
isRun = false;

contVal = double(unique(VRdata_all.TRIAL.trialContr(~isnan(VRdata_all.TRIAL.trialContr))));
gainVal = double(unique(VRdata_all.TRIAL.trialGain(~isnan(VRdata_all.TRIAL.trialGain))));

if ltexist
    lengthVal = double(unique(VRdata_all.TRIAL.trialRL(~isnan(VRdata_all.TRIAL.trialRL))));
end

if rewOexist
    rewActive = double(unique(VRdata_all.TRIAL.trialActive(~isnan(VRdata_all.TRIAL.trialActive(1:numTrials)))));
    rewRewPos = double(unique(VRdata_all.TRIAL.trialRewPos(~isnan(VRdata_all.TRIAL.trialRewPos(1:numTrials)))));
    rewOutcome = double(unique(VRdata_all.TRIAL.trialOutcome(~isnan(VRdata_all.TRIAL.trialOutcome(1:numTrials)))));
end
set(handles.popupmenu4, 'String', 1:endTrial);
set(handles.popupmenu3, 'String', startTrial:numTrials);
set(handles.popupmenu5, 'String',[{'Position'},{'VR speed'},{'Run speed'}]);
set(handles.popupmenu4, 'Value', 1);
set(handles.popupmenu3, 'Value', numTrials);
set(handles.popupmenu5, 'Value', 1);
set(handles.popupmenu6, 'String', contVal);
set(handles.popupmenu7, 'String', gainVal);
if ltexist; set(handles.popupmenu8, 'String', lengthVal); end
if rewOexist;
    set(handles.popupmenu9, 'String', rewActive);
    set(handles.popupmenu10, 'String', rewRewPos);
    set(handles.popupmenu11, 'String', rewOutcome);
end

getVRsubset(handles)
set(handles.radiobutton6,'Value',false)
set(handles.radiobutton1,'Value',false)
set(handles.radiobutton7,'Value',true)

function getVRsubset(handles)

global VRdata
global VRdata_all
global startTrial
global endTrial
global altTrial
global swin
global numTrials
global contTrials
global gainTrials
global locTrials
global activeTrials
global outcomeTrials

global lengthTrials
global es_subset

VRdata = [];

selection = zeros(1,numTrials);
selection(startTrial:altTrial:endTrial) = 1;

if length(contTrials) == length(selection) + 1; contTrials(end) = []; end

selection = selection & contTrials & gainTrials ...
    & lengthTrials & locTrials & activeTrials & outcomeTrials;

subset = find(selection);

%Filtering

sGrid = 100;
s = (-sGrid:sGrid)/sGrid;
sfilt = exp(-s.^2/(1/swin)^2/2);
sfilt = sfilt./sum(sfilt);


% Getting rid of some of the NaNs
[k,timeIdx] = sort(VRdata_all.TRIAL.time(:));
mTime = max(find(~isnan(k)));
idx = 1;
while sum(isnan(VRdata_all.ballspeed(timeIdx(1:mTime))))~=0 && idx<4
    VRdata_all.ballspeed(timeIdx(find(isnan(VRdata_all.ballspeed(timeIdx(1:mTime)))))) = VRdata_all.ballspeed(timeIdx(find(isnan(VRdata_all.ballspeed(timeIdx(1:mTime))))+1));
    idx = idx + 1;
end
while sum(isnan(VRdata_all.trajspeed(timeIdx(1:mTime))))~=0 && idx<4
    VRdata_all.trajspeed(timeIdx(find(isnan(VRdata_all.trajspeed(timeIdx(1:mTime)))))) = VRdata_all.trajspeed(timeIdx(find(isnan(VRdata_all.trajspeed(timeIdx(1:mTime))))+1));
    idx = idx + 1;
end

VRdata.traj        = (VRdata_all.traj(subset,:));
VRdata.trajspeed   = (VRdata_all.trajspeed(subset,:));
VRdata.ballspeed   = (VRdata_all.ballspeed(subset,:));
VRdata.contr = VRdata_all.TRIAL.trialContr(subset);
VRdata.gain = VRdata_all.TRIAL.trialGain(subset);

VRdata.EXP = VRdata_all.EXP;
VRdata.REWARD = VRdata_all.REWARD;

VRdata.TRIAL.currTime = VRdata_all.TRIAL.currTime(subset,:);
VRdata.TRIAL.time = VRdata_all.TRIAL.time(subset,:);
VRdata.TRIAL.trialIdx = VRdata_all.TRIAL.trialIdx(subset,:);
if isfield(VRdata_all.TRIAL,'lick')
    VRdata.lick        = (VRdata_all.TRIAL.lick(subset,:));
end

rewTrials = [];
for ridx = 1:length(VRdata_all.REWARD.TRIAL)
    if sum(VRdata_all.REWARD.TRIAL(ridx) == subset);
        rewTrials = [rewTrials ridx];
    end
end

VRdata.REWARD.rewTrials = rewTrials;

es = VREvenSample(VRdata_all);
es_subset.subset = zeros(size(es.trialID));
for iTrial = subset
    es_subset.subset(es.trialID==iTrial) = 1;
end

if swin>1
    k = 1;
    VRdata.traj      = nan*ones(length(subset),size(VRdata_all.traj,2));
    VRdata.trajspeed = nan*ones(length(subset),size(VRdata_all.traj,2));
    VRdata.ballspeed = nan*ones(length(subset),size(VRdata_all.traj,2));
    
    [~,timeIdx] = sort(VRdata_all.TRIAL.time(:));
    trajspeed = conv_AS(VRdata_all.trajspeed(timeIdx),sfilt);
    ballspeed = conv_AS(VRdata_all.ballspeed(timeIdx),sfilt);
    
    VRdata_all.trajspeed(timeIdx) = trajspeed;
    VRdata_all.ballspeed(timeIdx) = ballspeed;
    
    for idx = 1:length(subset)
        VRdata.traj(k,~(VRdata_all.traj(subset(idx),:)==0) | ~isnan(VRdata_all.traj(subset(idx),:)))         = (VRdata_all.traj(subset(idx),~(VRdata_all.traj(subset(idx),:)==0) | ~isnan(VRdata_all.traj(subset(idx),:))));
        VRdata.trajspeed(k,~(VRdata_all.trajspeed(subset(idx),:)==0) | ~isnan(VRdata_all.trajspeed(subset(idx),:)))         = (VRdata_all.trajspeed(subset(idx),~(VRdata_all.trajspeed(subset(idx),:)==0) | ~isnan(VRdata_all.trajspeed(subset(idx),:))));
        VRdata.ballspeed(k,~(VRdata_all.ballspeed(subset(idx),:)==0) | ~isnan(VRdata_all.ballspeed(subset(idx),:)))         = (VRdata_all.ballspeed(subset(idx),~(VRdata_all.ballspeed(subset(idx),:)==0) | ~isnan(VRdata_all.ballspeed(subset(idx),:))));
        %         VRdata.traj(k,~(VRdata_all.traj(subset(idx),:)==0) | ~isnan(VRdata_all.traj(subset(idx),:)))         = conv_AS(VRdata_all.traj(subset(idx),~(VRdata_all.traj(subset(idx),:)==0) | ~isnan(VRdata_all.traj(subset(idx),:))), sfilt);
        %         VRdata.trajspeed(k,VRdata_all.traj(subset(idx),:)~=0 | ~isnan(VRdata_all.trajspeed(subset(idx),:)))    = conv_AS(VRdata_all.trajspeed(subset(idx),VRdata_all.traj(subset(idx),:)~=0 | ~isnan(VRdata_all.trajspeed(subset(idx),:))), sfilt);
        %         VRdata.ballspeed(k,~isnan(VRdata_all.ballspeed(subset(idx),:)))    = conv_AS(VRdata_all.ballspeed(subset(idx),~isnan(VRdata_all.ballspeed(subset(idx),:))), sfilt);
        k = k + 1;
    end
end

plot_all_handles(handles)

function out = conv_AS(in, sfilt)
in_mean = nanmean(in);
out = conv(in-in_mean, sfilt, 'same') + in_mean;


function plot_all_handles(handles)

global VRdata
global VRdata_all
global isRun
global X
global plot_log

% global handles

% Position vs. time
if isfield(VRdata,'lick')
    likTimes = find(VRdata.lick==1);
end

axes(handles.axes7);
switch X
    case 1
        plot(handles.axes7, (VRdata.TRIAL.time')./60, VRdata.traj','k');
        if isfield(VRdata,'lick')
            hold on;
            plot(handles.axes7, (VRdata.TRIAL.time(likTimes))./60, VRdata.traj(likTimes),'+r');
            hold off;
        end
%         set(handles.axes7, 'YTick', [VRdata.EXP.tc1 VRdata.EXP.tc2 VRdata.EXP.tc3 VRdata.EXP.tc4]);
    case 2
        plot(handles.axes7, (VRdata.TRIAL.time')./60, VRdata.trajspeed');
        if isfield(VRdata,'lick')
            hold on;
            plot(handles.axes7, (VRdata.TRIAL.time(likTimes))./60, VRdata.trajspeed(likTimes),'+r');
            hold off;
        end
    case 3
        plot(handles.axes7, (VRdata.TRIAL.time')./60, VRdata.ballspeed');
        if isfield(VRdata,'lick')
            hold on;
            plot(handles.axes7, (VRdata.TRIAL.time(likTimes))./60, VRdata.ballspeed(likTimes),'+r');
            hold off;
        end
end

if isfield(VRdata.REWARD, 'count');
    axes(handles.axes7);
    hold on;
    for rewID = (VRdata.REWARD.rewTrials)
        rewType = VRdata.REWARD.TYPE(rewID);
        switch X
            case 1
                if rewType == 1
                    plot(handles.axes7, ...
                        VRdata_all.TRIAL.time(VRdata.REWARD.TRIAL(rewID),VRdata.REWARD.count(rewID)-1)/60,...
                        VRdata_all.traj(VRdata.REWARD.TRIAL(rewID),VRdata.REWARD.count(rewID)-1),'ko');
                elseif rewType == 2
                    plot(handles.axes7, ...
                        VRdata_all.TRIAL.time(VRdata.REWARD.TRIAL(rewID),VRdata.REWARD.count(rewID)-1)/60,...
                        VRdata_all.traj(VRdata.REWARD.TRIAL(rewID),VRdata.REWARD.count(rewID)-1),'go');
                    plot(handles.axes7, ...
                        VRdata_all.TRIAL.time(VRdata.REWARD.TRIAL(rewID),VRdata.REWARD.count(rewID)-1)/60,...
                        VRdata_all.traj(VRdata.REWARD.TRIAL(rewID),VRdata.REWARD.count(rewID)-1),'g.');
                elseif rewType == 0
                    plot(handles.axes7, ...
                        VRdata_all.TRIAL.time(VRdata.REWARD.TRIAL(rewID),VRdata.REWARD.count(rewID)-1)/60,...
                        VRdata_all.traj(VRdata.REWARD.TRIAL(rewID),VRdata.REWARD.count(rewID)-1),'o', 'Color',[.5 .5 .5]);
                end
%                 line(xlim, [VRdata.EXP.tc1 VRdata.EXP.tc1],'linestyle','--','color',[0.7 0.7 0.7])
%                 line(xlim, [VRdata.EXP.tc2 VRdata.EXP.tc2],'linestyle','--','color',[0.7 0.7 0.7])
%                 line(xlim, [VRdata.EXP.tc3 VRdata.EXP.tc3],'linestyle','--','color',[0.7 0.7 0.7])
%                 line(xlim, [VRdata.EXP.tc4 VRdata.EXP.tc4],'linestyle','--','color',[0.7 0.7 0.7])
            case 2
                plot(handles.axes7, ...
                    VRdata_all.TRIAL.time(VRdata.REWARD.TRIAL(rewID),VRdata.REWARD.count(rewID)-1)/60,...
                    VRdata_all.trajspeed(VRdata.REWARD.TRIAL(rewID),VRdata.REWARD.count(rewID)-1),'ko');
            case 3
                plot(handles.axes7, ...
                    VRdata_all.TRIAL.time(VRdata.REWARD.TRIAL(rewID),VRdata.REWARD.count(rewID)-1)/60,...
                    VRdata_all.ballspeed(VRdata.REWARD.TRIAL(rewID),VRdata.REWARD.count(rewID)-1),'ko');
        end
    end
    hold off;
end
set(handles.axes7, 'TickDir','out', 'box','off','color','none'); axis tight
set(handles.axes7, 'XLim', [0 max(VRdata.TRIAL.time(:)/60)]);

% Time spent running
pie(handles.axes8,[sum(VRdata.ballspeed(:)<=1) sum(VRdata.ballspeed(:)>1)],{'Sit','Run'});
colormap(handles.axes8, gray)

if ~plot_log
    [all_spd, spd_sample] = hist(VRdata_all.trajspeed(VRdata_all.trajspeed>1),30);
    spd_lim = max(all_spd./sum(all_spd));
    
    % Position vs. time (per trial)
    plot(handles.axes1, VRdata.TRIAL.currTime', VRdata.traj');
    set(handles.axes1, 'TickDir','out', 'box','off','color','none',...
        'YTick', [VRdata.EXP.tc1 VRdata.EXP.tc2 VRdata.EXP.tc3 VRdata.EXP.tc4]); axis tight
    
    
    % Histogram of Run speeds
    k = hist(VRdata.ballspeed(VRdata.ballspeed>1),spd_sample);
    
    bar(handles.axes2, spd_sample, k./sum(k));
    axes(handles.axes2); axis tight;
    set(handles.axes2, 'TickDir','out', 'box','off','color','none', 'YLim',[0 max([spd_lim+0.1 max(ylim)])]);
    m = mean(VRdata.ballspeed(VRdata.ballspeed>1));
    line([m m],ylim,'color','k','linestyle','--')
    
    % Histogram of VR speeds
    k = hist(VRdata.trajspeed(VRdata.trajspeed>1),spd_sample);
    
    bar(handles.axes4,  spd_sample, k./sum(k));
    axes(handles.axes4); axis tight;
    set(handles.axes4, 'TickDir','out', 'box','off','color','none', 'YLim',[0 max([spd_lim+0.1 max(ylim)])]);
    m = mean(VRdata.trajspeed(VRdata.trajspeed>1));
    line([m m],ylim,'color','k','linestyle','--')
    
else
    [all_spd, spd_sample] = hist(log(VRdata_all.trajspeed(VRdata_all.trajspeed>1)),30);
    spd_lim = max(all_spd./sum(all_spd));
    
    % Position vs. time (per trial)
    plot(handles.axes1, VRdata.TRIAL.currTime', VRdata.traj');
% <<<<<<< HEAD
% <<<<<<< HEAD
    set(handles.axes1, 'TickDir','out', 'box','off','color','none'); axis tight
% =======
% %     set(handles.axes1, 'TickDir','out', 'box','off','color','none',...
% %         'YTick', [VRdata.EXP.tc1 VRdata.EXP.tc2 VRdata.EXP.tc3 VRdata.EXP.tc4]); axis tight
% >>>>>>> 294dfdcdce3624f79b966810e11f70c6a357e9ef
% =======
% %     set(handles.axes1, 'TickDir','out', 'box','off','color','none',...
% %         'YTick', [VRdata.EXP.tc1 VRdata.EXP.tc2 VRdata.EXP.tc3 VRdata.EXP.tc4]); axis tight
% >>>>>>> 294dfdcdce3624f79b966810e11f70c6a357e9ef
%     
    % Histogram of Run speeds
    k = hist(log(VRdata.ballspeed(VRdata.ballspeed>1)),spd_sample);
    plot(handles.axes2, exp(spd_sample), k./sum(k),'ko-');
    axes(handles.axes2); axis tight;
    set(handles.axes2, 'TickDir','out', 'box','off','color','none', ...
        'XScale','log','YLim',[0 max([spd_lim+0.1 max(ylim)])]);
    m = mean(VRdata.ballspeed(VRdata.ballspeed>1));
    line([m m],ylim,'color','k','linestyle','--')
    
    % Histogram of VR speeds
    k = hist(log(VRdata.trajspeed(VRdata.trajspeed>1)),spd_sample);
    plot(handles.axes4,  exp(spd_sample), k./sum(k),'ko-');
    axes(handles.axes4); axis tight;
    set(handles.axes4, 'TickDir','out', 'box','off','color','none',  ...
        'XScale','log','YLim',[0 max([spd_lim+0.1 max(ylim)])]);
    m = mean(VRdata.trajspeed(VRdata.trajspeed>1));
    line([m m],ylim,'color','k','linestyle','--')
    
end

for itrial = 1:size(VRdata.traj,1)
    if isRun
        % Position vs. speed (per trial)
        plot(handles.axes6, VRdata.ballspeed(itrial,VRdata.traj(itrial,:)~=0)', VRdata.traj(itrial,VRdata.traj(itrial,:)~=0)');
        hold(handles.axes6, 'on');
    else
        plot(handles.axes6, VRdata.trajspeed(itrial,VRdata.traj(itrial,:)~=0)', VRdata.traj(itrial,VRdata.traj(itrial,:)~=0)')
        hold(handles.axes6, 'on');
    end
end
hold(handles.axes6,'off');
% set(handles.axes6, 'TickDir','out', 'box','off','color','none',...
%     'YTick', [VRdata.EXP.tc1 VRdata.EXP.tc2 VRdata.EXP.tc3 VRdata.EXP.tc4]);
axes(handles.axes6); axis tight

% VR speed vs. Run speed (per trial)
plot(handles.axes5, VRdata.trajspeed', VRdata.ballspeed');
axes(handles.axes5);
set(handles.axes5, 'TickDir','out', 'box','off','color','none'); axis equal;
line([0 max([xlim, ylim])],[0 max([xlim, ylim])], 'color','k','linestyle','--')

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
global isRun
isRun = get(hObject, 'Value');
getVRsubset(handles)

% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)

global startTrial
global endTrial
global altTrial
global numTrials

list_entries = get(handles.popupmenu3,'String');
index_selected = get(handles.popupmenu3,'Value');
endTrial = str2num(list_entries(index_selected,:));

set(handles.popupmenu4, 'String', 1:endTrial);
getVRsubset(handles)

% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4
global startTrial
global numTrials

list_entries = get(handles.popupmenu4,'String');
index_selected = get(handles.popupmenu4,'Value');
startTrial = str2num(list_entries(index_selected,:));

set(handles.popupmenu3, 'String', startTrial:numTrials);
set(handles.popupmenu3,'Value',numTrials-startTrial+1);
getVRsubset(handles)

% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
function radiobutton3_Callback(hObject, eventdata, handles)
function radiobutton4_Callback(hObject, eventdata, handles)
function popupmenu5_Callback(hObject, eventdata, handles)

global X

X = get(handles.popupmenu5,'Value');
plot_all_handles(handles)

% --- Executes during object creation, after setting all properties.
function popupmenu5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)



% --- Executes on button press in radiobutton6.
function radiobutton6_Callback(hObject, eventdata, handles)
global altTrial
isOn = get(hObject,'Value');
if isOn
    altTrial = 2;
else
    altTrial = 1;
end
getVRsubset(handles)



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
global animal

animal = get(hObject, 'String');
animal_selected(handles)
% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
global iseries
iseries = (get(hObject,'String'));
series_selected(handles)

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
global swin

swin = str2num(get(hObject, 'String'))./33.33;
getVRsubset(handles);

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu6.
function popupmenu6_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu6
% global contVal
% global gainVal
global contTrials
global VRdata_all
% global gainTrials

list_entries = get(handles.popupmenu6,'String');
index_selected = get(handles.popupmenu6,'Value');
contrSelected = str2num(list_entries(index_selected,:));

contTrials(:) = 0;
contTrials(VRdata_all.TRIAL.trialContr==contrSelected)= 1;
getVRsubset(handles);

% --- Executes during object creation, after setting all properties.
function popupmenu6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu7.
function popupmenu7_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu7 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu7
% global contVal
% global gainVal
% global contTrials
global gainTrials
global VRdata_all

list_entries = get(handles.popupmenu7,'String');
index_selected = get(handles.popupmenu7,'Value');
gainSelected = str2num(list_entries(index_selected,:));

gainTrials(:) = 0;
gainTrials(VRdata_all.TRIAL.trialGain==gainSelected)=1;
getVRsubset(handles);


% --- Executes during object creation, after setting all properties.
function popupmenu7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton7.
function radiobutton7_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton7
global plot_log

plot_log = get(hObject,'Value');
plot_all_handles(handles);


% --- Executes on selection change in popupmenu8.
function popupmenu8_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu8 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu8
global lengthTrials
global VRdata_all

list_entries = get(handles.popupmenu8,'String');
index_selected = get(handles.popupmenu8,'Value');
lengthSelected = str2num(list_entries(index_selected,:));

lengthTrials(:) = 0;
lengthTrials(VRdata_all.TRIAL.trialRL==lengthSelected)=1;
getVRsubset(handles);

% --- Executes during object creation, after setting all properties.
function popupmenu8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu9.
function popupmenu9_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu9 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu9
global activeTrials
global VRdata_all
global numTrials

list_entries = get(handles.popupmenu9,'String');
index_selected = get(handles.popupmenu9,'Value');
activeSelected = str2num(list_entries(index_selected,:));

activeTrials(:) = 0;
activeTrials(VRdata_all.TRIAL.trialActive(1:numTrials)==activeSelected)=1;
getVRsubset(handles);

% --- Executes during object creation, after setting all properties.
function popupmenu9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu10.
function popupmenu10_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu10 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu10
global locTrials
global VRdata_all
global numTrials

list_entries = get(handles.popupmenu10,'String');
index_selected = get(handles.popupmenu10,'Value');
locSelected = str2num(list_entries(index_selected,:));

locTrials(:) = 0;
locTrials(VRdata_all.TRIAL.trialRewPos(1:numTrials)==locSelected)=1;
getVRsubset(handles);

% --- Executes during object creation, after setting all properties.
function popupmenu10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu11.
function popupmenu11_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu11 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu11
global outcomeTrials
global VRdata_all
global numTrials

list_entries = get(handles.popupmenu11,'String');
index_selected = get(handles.popupmenu11,'Value');
outcomeSelected = str2num(list_entries(index_selected,:));

outcomeTrials(:) = 0;
outcomeTrials(VRdata_all.TRIAL.trialOutcome(1:numTrials)==outcomeSelected)=1;
getVRsubset(handles);


% --- Executes during object creation, after setting all properties.
function popupmenu11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
