load Behav_all_sessions

variable = 'CONTRAST'; %'GAIN';'ROOMLENGTH' % %'ROOMLENGTH' % 'ROOMLENGTH' % 'ROOMLENGTH', 'GAIN'
for n = 1:9

    switch n
        case 1
            k = plotLickBeh(es_530,variable,[],0);
        case 2
            k = plotLickBeh(es_531,variable,[],0);
        case 3
            k = plotLickBeh(es_601,variable,[],0);
        case 4
            k = plotLickBeh(es_602,variable,[],0);
        case 5
            k = plotLickBeh(es_603,variable,[],0);
        case 6
            k = plotLickBeh(es_604,variable,[],0);
        case 7
            k = plotLickBeh(es_605,variable,[],0);
        case 8
            k = plotLickBeh(es_918,variable,[],0);
        case 9
            k = plotLickBeh(es_920,variable,[],0);
    end
    
    correct(n,1) = k.outcome.correct.low./(k.outcome.correct.low+k.outcome.wrong.low+k.outcome.miss.low);
    correct(n,2) = k.outcome.correct.norm./(k.outcome.correct.norm+k.outcome.wrong.norm+k.outcome.miss.norm);
    correct(n,3) = k.outcome.correct.high./(k.outcome.correct.high+k.outcome.wrong.high+k.outcome.miss.high);
    
    wrong(n,1) = k.outcome.wrong.low./(k.outcome.correct.low+k.outcome.wrong.low+k.outcome.miss.low);
    wrong(n,2) = k.outcome.wrong.norm./(k.outcome.correct.norm+k.outcome.wrong.norm+k.outcome.miss.norm);
    wrong(n,3) = k.outcome.wrong.high./(k.outcome.correct.high+k.outcome.wrong.high+k.outcome.miss.high);
    
    miss(n,1) = k.outcome.miss.low./(k.outcome.correct.low+k.outcome.wrong.low+k.outcome.miss.low);
    miss(n,2) = k.outcome.miss.norm./(k.outcome.correct.norm+k.outcome.wrong.norm+k.outcome.miss.norm);
    miss(n,3) = k.outcome.miss.high./(k.outcome.correct.high+k.outcome.wrong.high+k.outcome.miss.high);
    
    timeOut(n,1) = k.outcome.TO.low;
    timeOut(n,2) = k.outcome.TO.norm;
    timeOut(n,3) = k.outcome.TO.high;
end

correct(n+1,:) = mean(correct);
wrong(n+1,:) = mean(wrong);
miss(n+1,:) = mean(miss);
%%
figure('Position',[ 366         176        1285         922]);
n = 1;
subplot(2,3,1)
h = bar([correct(:,n) wrong(:,n) miss(:,n)],0.9,'stacked');
set(h(1),'facecolor',[.5 .5 1]);set(h(2),'facecolor',[.5 .5 .5]);set(h(3),'facecolor',[1 1 1]);
set(gca, 'box','off','TickDir','out','fontsize',14,'color','none');
axis tight;
xlabel('Session')
ylabel('Proportion of complete trials')
title(['Low ' variable])
n = 2;
subplot(2,3,2);
h= bar([correct(:,n) wrong(:,n) miss(:,n)],0.9,'stacked');
set(h(1),'facecolor',[.5 .5 1]);set(h(2),'facecolor',[.5 .5 .5]);set(h(3),'facecolor',[1 1 1]);
set(gca, 'box','off','TickDir','out','fontsize',14,'color','none');
axis tight;
xlabel('Session')
% ylabel('Proportion of complete trials')
title(['Baseline ' variable])
subplot(2,3,3)
n = 3;
h=bar([correct(:,n)  wrong(:,n) miss(:,n)],0.9,'stacked');
set(h(1),'facecolor',[.5 .5 1]);set(h(2),'facecolor',[.5 .5 .5]);set(h(3),'facecolor',[1 1 1]);
set(gca, 'box','off','TickDir','out','fontsize',14,'color','none','YLim',[0 1]);
axis tight;
xlabel('Session')
% ylabel('Proportion of complete trials')
title(['High ' variable])


% n = 1;
% subplot(2,3,3+n)
% h = bar(1, mean(wrong(:,1)),'r') 
% set(h,'facecolor',[.5 .5 .5])%1 1 1])
% hold on;
% h = bar(2, mean(wrong(:,2)),'k')
% set(h,'facecolor',[.5 .5 .5])%[1 1 1])
% h = bar(3, mean(wrong(:,3)));
% set(h,'facecolor',[.5 .5 .5])%[1 1 1])
% % set(h,'facecolor',[1 1 1])
% errorbar([1 2 3], [mean(wrong(:,1)) mean(wrong(:,2)) mean(wrong(:,3))], [sem(wrong(:,1)) sem(wrong(:,2)) sem(wrong(:,3))],'k','linewidth',1.5);
% % axis tight;
% set(gca, 'box','off','TickDir','out','fontsize',14,'color','none','XTick',[1 2 3], 'XTickLabel',[{'Low'},{'Baseline'},{'High'}]);
% % xlabel('Session')
% ylabel('Proportion of complete trials')
% title('Early')
% 
% n = 2;
% subplot(2,3,3+n)
% bar(1, mean(correct(:,1)),'b') 
% hold on;
% bar(2, mean(correct(:,2)),'b')
% h = bar(3, mean(correct(:,3)),'b');
% % set(h,'facecolor',[1 1 1])
% errorbar([1 2 3], [mean(correct(:,1)) mean(correct(:,2)) mean(correct(:,3))], [sem(correct(:,1)) sem(correct(:,2)) sem(correct(:,3))],'k','linewidth',1.5);
% % axis tight;
% set(gca, 'box','off','TickDir','out','fontsize',14,'color','none','XTick',[1 2 3], 'XTickLabel',[{'Low'},{'Baseline'},{'High'}]);
% % xlabel('Session')
% ylabel('Proportion of complete trials')
% title('Correct')
% 
% n = 3;
% subplot(2,3,3+n)
% h = bar(1, mean(miss(:,1)),'r') 
% set(h,'facecolor',[1 1 1])
% hold on;
% h = bar(2, mean(miss(:,2)),'k')
% set(h,'facecolor',[1 1 1])
% h = bar(3, mean(miss(:,3)));
% set(h,'facecolor',[1 1 1])
% errorbar([1 2 3], [mean(miss(:,1)) mean(miss(:,2)) mean(miss(:,3))], [sem(miss(:,1)) sem(miss(:,2)) sem(miss(:,3))],'k','linewidth',1.5);
% % axis tight;
% set(gca, 'box','off','TickDir','out','fontsize',14,'color','none','XTick',[1 2 3], 'XTickLabel',[{'Low'},{'Baseline'},{'High'}]);
% % xlabel('Session')
% ylabel('Proportion of complete trials')
% title('Miss')

n = 1;
subplot(2,3,3+n)
h = bar(1, mean(wrong(:,1)),'r') 
set(h,'facecolor',[.5 .5 .5])%1 1 1])
hold on;
h = bar(2, mean(wrong(:,3)));
set(h,'facecolor',[.5 .5 .5])%[1 1 1])
% set(h,'facecolor',[1 1 1])
errorbar([1 2 ], [mean(wrong(:,1))  mean(wrong(:,3))], [sem(wrong(:,1))  sem(wrong(:,3))],'k','linewidth',1.5);
% axis tight;
set(gca, 'box','off','TickDir','out','fontsize',14,'color','none','YLim',[0 1],'XTick',[1 2], 'XTickLabel',[{'Low'},{'High'}]);
% xlabel('Session')
ylabel('Proportion of complete trials')
title('Early (***)')

n = 2;
subplot(2,3,3+n)
h = bar(1, mean(correct(:,1)),'b') 
set(h,'facecolor',[.5 .5 1])
hold on;
h = bar(2, mean(correct(:,3)),'b');
set(h,'facecolor',[.5 .5 1])
errorbar([1 2 ], [mean(correct(:,1))  mean(correct(:,3))], [sem(correct(:,1)) sem(correct(:,3))],'k','linewidth',1.5);
% axis tight;
set(gca, 'box','off','TickDir','out','fontsize',14,'color','none','YLim',[0 1],'XTick',[1 2 ], 'XTickLabel',[{'Low'},{'High'}]);
% xlabel('Session')
ylabel('Proportion of complete trials')
title('Correct (n.s.)')

n = 3;
subplot(2,3,3+n)
h = bar(1, mean(miss(:,1)),'r') 
set(h,'facecolor',[1 1 1])
hold on;
h = bar(2, mean(miss(:,3)));
set(h,'facecolor',[1 1 1])
errorbar([1 2 ], [mean(miss(:,1)) mean(miss(:,3))], [sem(miss(:,1)) sem(miss(:,3))],'k','linewidth',1.5);
% axis tight;
set(gca, 'box','off','TickDir','out','fontsize',14,'color','none','YLim',[0 1],'XTick',[1 2 ], 'XTickLabel',[{'Low'},{'High'}]);
% xlabel('Session')
ylabel('Proportion of complete trials')
title('Miss (***)')
