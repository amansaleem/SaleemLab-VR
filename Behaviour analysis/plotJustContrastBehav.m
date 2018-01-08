function plotJustContrastBehav(animal, iseries, exp_list, type, newOrder)

if nargin<4
    type = 1;
end
if nargin<5
    newOrder = [];
end

es = VRLoadMultipleExpts(animal, iseries, exp_list);

es = redefineOutcome(es);

base = es.traj~=0   & es.gain==1 & es.roomLength==1 & es.outcome~=0 & es.outcome~=5;
t = base & es.contrast==0.6; 
t_high = base & es.contrast>0 & es.contrast>0.6;
t_low = base & es.contrast>0 & es.contrast<0.6;
t0 = es.contrast==0 & es.traj~=0;

figure;
set(gcf, 'name', [animal '_' num2str(iseries)]);
subplot(121)
if type==1
    plotBehavSpks_refined(es,t,[es.traj],gca);
else
    t_all = t;% | t_low |t_high | t0;
    plotBehavSpks_refinedPreReward(es,t_all,[es.traj],gca,[],0, newOrder);
end
title('BASELINE');
subplot(522)
if type==1
    plotBehavSpks_refined(es,t0,[es.traj],gca);
else
    plotBehavSpks_refinedPreReward(es,t0,[es.traj],gca,[],0, newOrder);
end
title('0 CONTRAST');
subplot(5,2,[4 6])
% plotBehavSpks_refined(es,t_low,[es.traj],gca);
if type==1
    plotBehavSpks_refined(es,t_low,[es.traj],gca);
else
    plotBehavSpks_refinedPreReward(es,t_low,[es.traj],gca,[],0, newOrder);
end
title('LOW CONTRAST');
subplot(5,2,[8 10])
% plotBehavSpks_refined(es,t_high,[es.traj],gca);
if type==1
    plotBehavSpks_refined(es,t_high,[es.traj],gca);
else
    plotBehavSpks_refinedPreReward(es,t_high,[es.traj],gca,[],0, newOrder);
end
title('HIGH CONTRAST');

