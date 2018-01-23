percentCorrect = [73 90 81;
    75 92 96;
    58 60 70;
    69 82 92;
    100 77 100;
    50 89 67;
    67 100 100;
    60 83 78];    

bar([1 2 3],mean(percentCorrect,1),'k')
hold on;
errorbar([1 2 3],mean(percentCorrect,1), sem(percentCorrect), 'k','linestyle','none')
set(gca, 'box','off','TickDir','out','fontsize',14,'color','none');
set(gca, 'YLim', [50 100], 'XTick', [1 2 3], 'XTickLabel',[{'Low'},{'Medium'},{'High'}]);
