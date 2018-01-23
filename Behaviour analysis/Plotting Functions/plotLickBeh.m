function output = plotLickBeh(es,type,firstLickOnly,plot_flag)

% plotLickBeh(es,type)
% where type can be:
% SHOWALL:
% NOVISION:
% CONTRAST:
% ROOMLENGTH:
% GAIN:
% Aman
% 2013

if nargin<4
    plot_flag = 1;
end

if nargin<3
    firstLickOnly = 1;
end

if nargin<2
    type = 'SHOWALL';
end

trialIDs = unique(es.trialID(~isnan(es.trialID)));
numTrials = length(trialIDs);
for itrial = 1:numTrials
    %     display([num2str(itrial) '  '
    if length(min(find(es.trialID==trialIDs(itrial) & es.traj~=0 ...
            & ~isnan(es.roomLength) & ~isnan(es.contrast)))) == 1
        trial_starts(itrial) = min(find(es.trialID==trialIDs(itrial) & es.traj~=0));
    else
        trial_starts(itrial) = min(find(es.trialID==trialIDs(itrial)));
    end
    %...         & ~isnan(es.roomLength) & ~isnan(es.contrast)));
end

contrast_vals = es.contrast(trial_starts);
contrast_list = unique(contrast_vals(~isnan(contrast_vals)));
[~,cidx]      = max(histc(es.contrast, contrast_list));
common_contrast = contrast_list(cidx);

length_vals   = es.roomLength(trial_starts);
length_list   = unique(length_vals(~isnan(length_vals)));
[~,lidx] = max(histc(es.roomLength, length_list));
common_length = length_list(lidx);

try
    gain_vals   = es.gain(trial_starts);
    gain_list   = unique(gain_vals(~isnan(gain_vals)));
    [~,gidx] = max(histc(es.gain, gain_list));
    common_gain = gain_list(lidx);
catch
    gain_vals   = ones(size(length_vals));
    gain_list   = unique(gain_vals(~isnan(gain_vals)));
    common_gain = 1;
end

switch type
    case 'SHOWALL'
        newtrialIDs = es.trialID;
        switch_idx = [];
    case 'NOVISION'
        goodTrials = find((contrast_vals==common_contrast | contrast_vals==0) ...
            & length_vals==common_length & gain_vals==common_gain);
        [~,nvorder] = sort(contrast_vals(goodTrials));
        newTrials = goodTrials(nvorder);
        switch_idx = find(diff(contrast_vals(newTrials))>0);
        switch_idx = [1 switch_idx' length(newTrials)]';
        newtrialIDs = nan*ones(size(es.trialID));
        for itrial = 1:length(newTrials)
            newtrialIDs(es.trialID==newTrials(itrial)) = itrial;
        end
        numTrials = length(newTrials);
        output.outcome.high= [];
        output.outcome.low = [];
        output.outcome.norm= [];

        output.outcome.complete_high= [];
        output.outcome.complete_low = [];
        output.outcome.complete_norm= [];
    case 'CONTRAST'
        goodTrials = find((contrast_vals~=0 & ~isnan(contrast_vals)) ...
            & length_vals==common_length & gain_vals==common_gain);
        [~,corder] = sort(contrast_vals(goodTrials));
        newTrials = goodTrials(corder);
        switch_idx = find(diff(contrast_vals(newTrials))>0);
        switch_idx = [1 switch_idx' length(newTrials)]';
        newtrialIDs = nan*ones(size(es.trialID));
        for itrial = 1:length(newTrials)
            newtrialIDs(es.trialID==newTrials(itrial)) = itrial;
        end
        numTrials = length(newTrials);
        
        trialEnds = [find(diff(es.trialID)>=1)-15];
        temp = zeros(size(es.traj));
        temp(trialEnds) = 1;
        trialEnds = temp;
        output.outcome.high= (es.outcome(trialEnds & es.contrast>0.6 & es.contrast>0));
        output.outcome.low = (es.outcome(trialEnds & es.contrast<0.6 & es.contrast>0));
        output.outcome.norm= (es.outcome(trialEnds & es.contrast==0.6 & es.gain==1 & es.roomLength==1));

        output.outcome.complete_high= (es.trajPercent(trialEnds & es.contrast>0.6 & es.contrast>0)>80);
        output.outcome.complete_low = (es.trajPercent(trialEnds & es.contrast<0.6 & es.contrast>0)>80);
        output.outcome.complete_norm= (es.trajPercent(trialEnds & es.contrast==0.6 & es.gain==1 & es.roomLength==1)>80);
    case 'ROOMLENGTH'
        goodTrials = find(contrast_vals==common_contrast & gain_vals==common_gain);
        [x,lorder] = sort(length_vals(goodTrials));
        newTrials = goodTrials(lorder);
        switch_idx = find(diff(length_vals(newTrials))>0);
        switch_idx = [1 switch_idx' length(newTrials)]';
        newtrialIDs = nan*es.trialID;
        for itrial = 1:length(newTrials)
            newtrialIDs(es.trialID==newTrials(itrial)) = itrial;
        end
        numTrials = length(newTrials);
        
        trialEnds = [find(diff(es.trialID)>=1)-15];
        temp = zeros(size(es.traj));
        temp(trialEnds) = 1;
        trialEnds = temp;
        output.outcome.high= (es.outcome(trialEnds & es.roomLength>1));
        output.outcome.low = (es.outcome(trialEnds & es.roomLength<1));
        output.outcome.norm= (es.outcome(trialEnds & es.contrast==0.6 & es.gain==1 & es.roomLength==1));
      
        output.outcome.complete_high= (es.trajPercent(trialEnds & es.roomLength>1)>80);
        output.outcome.complete_low = (es.trajPercent(trialEnds & es.roomLength<1)>80);
        output.outcome.complete_norm= (es.trajPercent(trialEnds & es.contrast==0.6 & es.gain==1 & es.roomLength==1)>80);
    case 'GAIN'
        goodTrials = find(contrast_vals==common_contrast & length_vals==common_length);
        [x,gorder] = sort(gain_vals(goodTrials));
        newTrials = goodTrials(gorder);
        switch_idx = find(diff(gain_vals(newTrials))>0);
        switch_idx = [1 switch_idx' length(newTrials)]';
        newtrialIDs = nan*es.trialID;
        for itrial = 1:length(newTrials)
            newtrialIDs(es.trialID==newTrials(itrial)) = itrial;
        end
        numTrials = length(newTrials);
        
        trialEnds = [find(diff(es.trialID)>=1)-5];
        temp = zeros(size(es.traj));
        temp(trialEnds) = 1;
        trialEnds = temp;
        output.outcome.high= (es.outcome(trialEnds & es.gain>1));
        output.outcome.low = (es.outcome(trialEnds & es.gain<1));
        output.outcome.norm= (es.outcome(trialEnds & es.contrast==0.6 & es.gain==1 & es.roomLength==1));
        
        output.outcome.complete_high= (es.trajPercent(trialEnds & es.gain>1)>80);
        output.outcome.complete_low = (es.trajPercent(trialEnds & es.gain<1)>80);
        output.outcome.complete_norm= (es.trajPercent(trialEnds & es.contrast==0.6 & es.gain==1 & es.roomLength==1)>80);
end

output.outcome.correct.low = sum(output.outcome.low==2)./length(output.outcome.low);
output.outcome.correct.norm = sum(output.outcome.norm==2 | output.outcome.norm==1)./length(output.outcome.norm);
output.outcome.correct.high = sum(output.outcome.high==2)./length(output.outcome.high);

output.outcome.wrong.low = sum(~output.outcome.complete_low & output.outcome.low==0)./length(output.outcome.complete_low);
output.outcome.wrong.norm = sum(~output.outcome.complete_norm & output.outcome.norm==0)./length(output.outcome.complete_norm);
output.outcome.wrong.high = sum(~output.outcome.complete_high & output.outcome.high==0)./length(output.outcome.complete_high);

output.outcome.TO.low = sum(output.outcome.low==5 | isnan(output.outcome.low))./length(output.outcome.low);
output.outcome.TO.norm = sum(output.outcome.norm==5 | isnan(output.outcome.norm))./length(output.outcome.norm);
output.outcome.TO.high = sum(output.outcome.high==5 | isnan(output.outcome.high))./length(output.outcome.high);

% output.outcome.miss.low     = 1 - (output.outcome.correct.low + output.outcome.wrong.low + output.outcome.TO.low);
% output.outcome.miss.norm    = 1 - (output.outcome.correct.norm + output.outcome.wrong.norm + output.outcome.TO.norm);
% output.outcome.miss.high    = 1 - (output.outcome.correct.high + output.outcome.wrong.high + output.outcome.TO.high);
output.outcome.miss.low = sum(output.outcome.low==0 & output.outcome.complete_low)./length(output.outcome.low);
output.outcome.miss.norm = sum(output.outcome.norm==0 & output.outcome.complete_norm)./length(output.outcome.norm);
output.outcome.miss.high = sum(output.outcome.high==0 & output.outcome.complete_high)./length(output.outcome.high);
%% Plotting bit
if plot_flag
    figure('Position',[500 450 1000 600]);
    subplot(2, 4, [1 2 3])
    plot(newtrialIDs(~isnan(newtrialIDs) & es.lick>0 & es.traj>0), es.traj(~isnan(newtrialIDs) & es.lick>0 & es.traj>0),'k+');
    hold on;
    plot(newtrialIDs(~isnan(newtrialIDs) & es.reward==1), es.traj(~isnan(newtrialIDs) & es.reward==1),'r*')
    plot(newtrialIDs(~isnan(newtrialIDs) & es.reward==2), es.traj(~isnan(newtrialIDs) & es.reward==2),'g*')
    plot(newtrialIDs(~isnan(newtrialIDs) & es.reward==0), es.traj(~isnan(newtrialIDs) & es.reward==0),'ko')
    
    try
        plot(newtrialIDs(~isnan(newtrialIDs) & ~isnan(es.rewardPos)),...
            es.rewardPos(~isnan(newtrialIDs) & ~isnan(es.rewardPos)) + es.rewardTolerance,'cv','MarkerSize',5)
        plot(newtrialIDs(~isnan(newtrialIDs) & ~isnan(es.rewardPos)),...
            es.rewardPos(~isnan(newtrialIDs) & ~isnan(es.rewardPos)) - es.rewardTolerance,'c^','MarkerSize',5)
    catch
    end
    
    axis tight;
    set(gca, 'color','none','TickDir','out','box','off', 'fontsize',10);
    set(gca, 'YLim', [min(es.traj(:)) max(es.traj(:))]);
    set(gca, 'XLim', [0 numTrials]);
    set(gca, 'YTick',[0 20 40 60 80 100]);
    ylabel('Position')
    title(['All licks and rewards, trials sorted by ' type]);
    
    if length(switch_idx)>0
        for iline = 2:length(switch_idx)
            line([switch_idx(iline)+0.5 switch_idx(iline)+0.5],[ylim],'color', 'r', 'linewidth', 1);
        end
    end
    subplot(2,4,4)
    if sum(es.lick==0)>0 & sum(es.reward==0)>1 & sum(es.reward==1)>1 & sum(es.reward==2)>1
        plot(0,0,'k+'); hold on;
        plot(0,0,'r*')
        plot(0,0,'g*')
        plot(0,0,'ko')
        axis([1 2 1 2]); set(gca, 'color','none','TickDir','out','box','off', 'fontsize',10); axis off;
        legend('Lick','Passive reward','Active reward','User reward','Location','Best');
    elseif sum(es.lick==0)>0 & sum(es.reward==1)>1 & sum(es.reward==2)>1
        plot(0,0,'k+'); hold on;
        plot(0,0,'r*')
        plot(0,0,'g*')
        axis([1 2 1 2]); set(gca, 'color','none','TickDir','out','box','off', 'fontsize',10); axis off;
        legend('Lick','Passive reward','Active reward','Location','Best');
    elseif sum(es.lick==0)>0 & sum(es.reward==1)>1
        plot(0,0,'k+'); hold on;
        plot(0,0,'r*')
        axis([1 2 1 2]); set(gca, 'color','none','TickDir','out','box','off', 'fontsize',10); axis off;
        legend('Lick','Passive reward','Location','Best');
    elseif sum(es.lick==0)>0 & sum(es.reward==2)>1
        plot(0,0,'k+'); hold on;
        plot(0,0,'g*')
        axis([1 2 1 2]); set(gca, 'color','none','TickDir','out','box','off', 'fontsize',10); axis off;
        legend('Lick','Active reward','Location','Best');
    end
end
% subplot(4, 4, [5 6 7])
trialIDs = unique(newtrialIDs(~isnan(newtrialIDs)));
numTrails = length(trialIDs);

for itrial = 1:numTrails
    X = min(es.traj(:)):5:max(es.traj(:));
    lickCount(:,itrial) = histc(es.traj(es.lick>0  & es.traj>0 & newtrialIDs==trialIDs(itrial)),X);
end

if length(switch_idx)>0
    for iswitch = 2:length(switch_idx)
        tidx = 1;
        for itrial = switch_idx(iswitch-1):switch_idx(iswitch)
            specificLickCount{iswitch-1}(:,tidx) = histc(es.traj(es.lick>0  & es.traj>0 & newtrialIDs==trialIDs(itrial)),X);
            tidx = tidx + 1;
        end
    end
end

%% getting rid of the pos-reward licks
licks = es.lick;
reward = es.reward;

for itrial = 1:numTrials
    trialBins = es.trialID==newTrials(itrial);
    if sum(~isnan(reward(trialBins & es.traj>0)) )>0
        idx = min(find(~isnan(reward) & trialBins & es.traj>0));
        trialBins = find(trialBins);
        licks(trialBins(trialBins>idx))=0;
    end
    trialBins = es.trialID==newTrials(itrial);
    if ~firstLickOnly
        if sum(licks(trialBins))>0
            %    To keep the first lick after reward position
            idx = (licks & es.traj>es.rewardPos & trialBins & es.traj>0);
            %         idx = (licks & trialBins);
            if sum(idx)>1
                idx = min(find(idx));
                trialBins = find(trialBins);
                licks(trialBins(trialBins>idx))=0;
            end
        end
    else
        if sum(licks(trialBins))>0
            %    To keep the first lick only
            %         idx = (licks & es.traj>es.rewardPos & trialBins);
            idx = (licks & trialBins & es.traj>0);
            if sum(idx)>1
                firstLick_idx = min(find(idx));
                trialBins = find(trialBins);
                licks(trialBins(trialBins>firstLick_idx))=0;
            end
        end
    end
end

if plot_flag
    subplot(2, 4, [5 6 7])
    if ~strcmp(type,'GAIN')
        plot(newtrialIDs(licks>0 & es.traj>0), es.traj(licks>0 & es.traj>0),'k+');
        hold on;
        try
            plot(newtrialIDs(~isnan(newtrialIDs) & ~isnan(es.rewardPos)),...
                es.rewardPos(~isnan(newtrialIDs) & ~isnan(es.rewardPos)) + es.rewardTolerance,'cv','MarkerSize',5)
            plot(newtrialIDs(~isnan(newtrialIDs) & ~isnan(es.rewardPos)),...
                es.rewardPos(~isnan(newtrialIDs) & ~isnan(es.rewardPos)) - es.rewardTolerance,'c^','MarkerSize',5)
        catch
        end
    else
        plot(newtrialIDs(licks>0 & es.traj>0), es.distTrav(licks>0 & es.traj>0),'k+');
        hold on;
        try
            plot(newtrialIDs(~isnan(newtrialIDs) & ~isnan(es.rewardPos)),...
                (1./es.gain(~isnan(newtrialIDs) & ~isnan(es.rewardPos))).*es.rewardPos(~isnan(newtrialIDs) & ~isnan(es.rewardPos)) + es.rewardTolerance,'cv','MarkerSize',5)
            plot(newtrialIDs(~isnan(newtrialIDs) & ~isnan(es.rewardPos)),...
                (1./es.gain(~isnan(newtrialIDs) & ~isnan(es.rewardPos))).*es.rewardPos(~isnan(newtrialIDs) & ~isnan(es.rewardPos)) - es.rewardTolerance,'c^','MarkerSize',5)
        catch
        end
    end
    % plot(newtrialIDs(~isnan(newtrialIDs) & ~isnan(es.rewardPos)),...
    %     es.rewardPos(~isnan(newtrialIDs) & ~isnan(es.rewardPos)),'c.','MarkerSize',5)
    axis tight;
    set(gca, 'color','none','TickDir','out','box','off', 'fontsize',10);
    set(gca, 'YLim', [min(es.traj(:)) max(es.traj(:))]);
    set(gca, 'YTick',[0 20 40 60 80 100]);
    set(gca, 'XLim', [0 numTrials]);
    ylabel('Position')
    title('Only first licks')
    % legend('Lick','Passive reward','Active reward','User reward','Location','Best')
    if length(switch_idx)>0
        for iline = 2:length(switch_idx)
            line([switch_idx(iline)+0.5 switch_idx(iline)+0.5],[ylim],'color', 'r', 'linewidth', 1);
        end
    end
    
    % subplot(4, 4, [13 14 15])
    trialIDs = unique(newtrialIDs(~isnan(newtrialIDs)));
    numTrails = length(trialIDs);
    
    for itrial = 1:numTrails
        X = min(es.traj(:)):5:max(es.traj(:));
        lickCount_cut(:,itrial) = histc(es.distTrav(licks>0  & es.traj>0 & newtrialIDs==trialIDs(itrial)),X);
    end
    if length(switch_idx)>0
        for iswitch = 2:length(switch_idx)
            tidx = 1;
            for itrial = switch_idx(iswitch-1):switch_idx(iswitch)
                specificLickCount_cut{iswitch-1}(:,tidx) = histc(es.distTrav(licks>0  & es.traj>0 & newtrialIDs==trialIDs(itrial)),X);
                tidx = tidx + 1;
            end
        end
    end
    % imagesc(trialIDs,X,lickCount_cut);
    % axis xy;
    % hold on;
    % colormap gray;
    % plot(newtrialIDs(~isnan(newtrialIDs) & ~isnan(es.rewardPos)),...
    %     es.rewardPos(~isnan(newtrialIDs) & ~isnan(es.rewardPos)),'c.','MarkerSize',5)
    %
    % plot(newtrialIDs(~isnan(newtrialIDs) & ~isnan(es.rewardPos)),...
    %     es.rewardPos(~isnan(newtrialIDs) & ~isnan(es.rewardPos)) + es.rewardTolerance,'cv','MarkerSize',5)
    % plot(newtrialIDs(~isnan(newtrialIDs) & ~isnan(es.rewardPos)),...
    %     es.rewardPos(~isnan(newtrialIDs) & ~isnan(es.rewardPos)) - es.rewardTolerance,'c^','MarkerSize',5)
    %
    % set(gca, 'color','none','TickDir','out','box','off', 'fontsize',10);
    % set(gca, 'YTick',[0 20 40 60 80 100]);
    % set(gca, 'XLim', [0 numTrials]);
    % ylabel('Position')
    % xlabel('TrialID')
    % if length(switch_idx)>0
    %     for iline = 2:length(switch_idx)
    %         line([switch_idx(iline)+0.5 switch_idx(iline)+0.5],[ylim],'color', 'r', 'linewidth', 1);
    %     end
    % end
    
    subplot(2, 4, 8)
    if length(switch_idx)==0
        plot(sum(lickCount_cut,2)./numTrails,X,'linewidth',1.5);
        output.licks = lickCount_cut;
        output.centres = X;
        output.lickPos = repmat(output.centres',1,size(output.licks,2)).*output.licks;
        output.lickPos = reshape(output.lickPos(output.lickPos>0),1,[]);
    else
        %     plot(sum(lickCount,2)./numTrails,X,'r--');
        hold on;
        output.centres = X;
        numS = length(specificLickCount_cut);
        for iswitch = 1:numS
            plot(sum(specificLickCount_cut{iswitch},2)./size(specificLickCount_cut{iswitch},2),X,'color',(1 - [1 1 1].*(iswitch/numS)),'linewidth',1.5);
            output.lickPos{iswitch} = repmat(output.centres',1,size(specificLickCount_cut{iswitch},2)).*specificLickCount_cut{iswitch};
            output.lickPos{iswitch} = reshape(output.lickPos{iswitch}(output.lickPos{iswitch}>0),1,[]);
        end
        output.licks = specificLickCount_cut;
    end
    line(xlim,[50 50]);
    hold on;
    % plot(xlim,[es.rewardPos(1) es.rewardPos(1)],'c-');
    % plot(xlim,[es.rewardPos(1) es.rewardPos(1)]-es.rewardTolerance,'c--');
    % plot(xlim,[es.rewardPos(1) es.rewardPos(1)]+es.rewardTolerance,'c--');
    % plot(sum(lickCount_cut,2)./numTrails,X,'k','linewidth',1.5);
    
    set(gca, 'color','none','TickDir','out','box','off', 'fontsize',10);
    set(gca, 'YTick',[0 20 40 60 80 100]);
    xlabel('No.of Licks / trial')
    title('Density of first licks')
end