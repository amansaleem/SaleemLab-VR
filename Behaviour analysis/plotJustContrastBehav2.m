function plotJustContrastBehav2(animalIdx, Posterior_all)

%% defining the animal indices
idx = 0;
idx = idx + 1;
expt_list(idx).animal     = 'M130920_BALL';
expt_list(idx).iseries    = 1025;
expt_list(idx).expt_list  = 102:103;
idx = idx + 1;
expt_list(idx).animal     = 'M130918_BALL';
expt_list(idx).iseries    = 1030;
expt_list(idx).expt_list  = 103:105;
idx = idx + 1;
expt_list(idx).animal     = 'M140501_BALL';
expt_list(idx).iseries    = 530;
expt_list(idx).expt_list  = 104:106;
idx = idx + 1;
expt_list(idx).animal     = 'M140501_BALL';
expt_list(idx).iseries    = 531;
expt_list(idx).expt_list  = 103:106;
idx = idx + 1;
expt_list(idx).animal     = 'M140501_BALL';
expt_list(idx).iseries    = 601;
expt_list(idx).expt_list  = 103:106;
idx = idx + 1;
expt_list(idx).animal     = 'M140501_BALL';
expt_list(idx).iseries    = 602;
expt_list(idx).expt_list  = 102:106;
idx = idx + 1;
expt_list(idx).animal     = 'M140502_BALL';
expt_list(idx).iseries    = 603;
expt_list(idx).expt_list  = 107:110;
idx = idx + 1;
expt_list(idx).animal     = 'M140502_BALL';
expt_list(idx).iseries    = 604;
expt_list(idx).expt_list  = 107:110;

%% Loading the right files

type = 0;

es = VRLoadMultipleExpts(expt_list(animalIdx).animal, ...
    expt_list(animalIdx).iseries, expt_list(animalIdx).expt_list);

es = redefineOutcome(es);
fullTrialList = unique(es.trialID);
[trialIDs] = reorderTrialByVariance(Posterior_all);
trialIDs = trialIDs(animalIdx);

trialIDs.trial_list(isnan(trialIDs.variance_val)) = [];
trialIDs.contrast_val(isnan(trialIDs.variance_val)) = [];
trialIDs.variance_val(isnan(trialIDs.variance_val)) = [];
for itrial = 1:length(trialIDs.trial_list)
    if nanmedian(es.outcome(es.trialID==trialIDs.trial_list(itrial)))==2
        trialIDs.numEarlyLicks(itrial) = nansum(es.lick(es.trialID==trialIDs.trial_list(itrial) ...
            & es.traj<50));
    else
        trialIDs.numEarlyLicks(itrial) = nan;
    end
end
figure(1)
subplot(3,3,animalIdx)
plot(trialIDs.numEarlyLicks+0.1*randn(1,1),trialIDs.variance_val,'ko');
subplot(3,3,9)
plot(trialIDs.numEarlyLicks+0.1*randn(1,1),trialIDs.variance_val,'ko');
hold on;

figure('Position',[969    49   944   488]);
[~,X] = hist(trialIDs.variance_val,10);
l_distr = hist(trialIDs.variance_val(trialIDs.contrast_val==0.18),X);
h_distr = hist(trialIDs.variance_val(trialIDs.contrast_val==0.72),X);
n_distr = hist(trialIDs.variance_val(trialIDs.contrast_val==0.60),X);
% l_distr = l_distr./sum(l_distr);
% n_distr = n_distr./sum(n_distr);
% h_distr = h_distr./sum(h_distr);
plot(X, l_distr,'b', X, n_distr, 'k', X,h_distr, 'r', 'linewidth',2);
hold on;
title(['Animal :' num2str(Posterior_all(animalIdx).iseries)])
plot(nanmean(trialIDs.variance_val(trialIDs.contrast_val==0.18)), 3, 'bd',...
    nanmean(trialIDs.variance_val(trialIDs.contrast_val==0.60)) , 3, 'kd',...
    nanmean(trialIDs.variance_val(trialIDs.contrast_val==0.72)) , 3, 'rd');
% plot(nanmean(trialIDs.variance_val(trialIDs.contrast_val==0.18)), 0.15, 'bd',...
%     nanmean(trialIDs.variance_val(trialIDs.contrast_val==0.60)) , 0.15, 'kd',...
%     nanmean(trialIDs.variance_val(trialIDs.contrast_val==0.72)) , 0.15, 'rd');
drawnow;

newTrialOrder = nan*ones(size(es.trialID));
[~, neworder] = sort(trialIDs.variance_val');

for itrial = 1:length(fullTrialList)
    if sum(trialIDs.trial_list==itrial)==1
       newTrialOrder(es.trialID==itrial) = neworder(trialIDs.trial_list==itrial);
    end
end
es.trialID = newTrialOrder;

base = ~isnan(es.trialID) & es.traj~=0   & es.gain==1 & es.roomLength==1 & es.outcome~=0 & es.outcome~=5;
t = base & es.contrast==0.6; 
t_high = base & es.contrast>0 & es.contrast>0.6;
t_low = base & es.contrast>0 & es.contrast<0.6;
t0 = es.contrast==0 & es.traj~=0;

figure;
% set(gcf, 'name', [animal '_' num2str(iseries)]);
subplot(121)
if type==1
    plotBehavSpks_refined(es,t,[es.traj],gca);
else
    t_all = (t | t_low | t_high);% & es.outcome==2;% t | | t0;
    plotBehavSpks_refinedPreReward(es,t_all,[es.traj],gca,[],0);
    drawnow;
end
title('BASELINE');
subplot(522)
if type==1
    plotBehavSpks_refined(es,t0,[es.traj],gca);
else
    plotBehavSpks_refinedPreReward(es,t0,[es.traj],gca,[],0);
end
title('0 CONTRAST');
subplot(5,2,[4 6])
% plotBehavSpks_refined(es,t_low,[es.traj],gca);
if type==1
    plotBehavSpks_refined(es,t_low,[es.traj],gca);
else
    plotBehavSpks_refinedPreReward(es,t_low,[es.traj],gca,[],0);
end
title('LOW CONTRAST');
subplot(5,2,[8 10])
% plotBehavSpks_refined(es,t_high,[es.traj],gca);
if type==1
    plotBehavSpks_refined(es,t_high,[es.traj],gca);
else
    plotBehavSpks_refinedPreReward(es,t_high,[es.traj],gca,[],0);
end
title('HIGH CONTRAST');

