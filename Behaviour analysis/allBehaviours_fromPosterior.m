figure;
hold on;
axis equal; axis([0 28 0 28])
line(xlim, ylim);
for animalIdx = 1:length(Posterior_all);
    es = Posterior_all(animalIdx).data;
    trialEnds = [find(diff(es.trialID)>=1)-15];
    % Early
    temp = 1;
    numOutcome(animalIdx).early.lowGain = sum(es.outcome(trialEnds)==temp & es.gain(trialEnds)<1);
    numOutcome(animalIdx).early.highGain = sum(es.outcome(trialEnds)==temp & es.gain(trialEnds)>1);
    numOutcome(animalIdx).early.lowRL = sum(es.outcome(trialEnds)==temp & es.roomLength(trialEnds)<1);
    numOutcome(animalIdx).early.highRL = sum(es.outcome(trialEnds)==temp & es.roomLength(trialEnds)>1);
    % Correct
    temp = 2;
    numOutcome(animalIdx).correct.lowGain = sum(es.outcome(trialEnds)==temp & es.gain(trialEnds)<1);
    numOutcome(animalIdx).correct.highGain = sum(es.outcome(trialEnds)==temp & es.gain(trialEnds)>1);
    numOutcome(animalIdx).correct.lowRL = sum(es.outcome(trialEnds)==temp & es.roomLength(trialEnds)<1);
    numOutcome(animalIdx).correct.highRL = sum(es.outcome(trialEnds)==temp & es.roomLength(trialEnds)>1);
    % Late
    temp = 3;
    numOutcome(animalIdx).late.lowGain = sum(es.outcome(trialEnds)==temp & es.gain(trialEnds)<1);
    numOutcome(animalIdx).late.highGain = sum(es.outcome(trialEnds)==temp & es.gain(trialEnds)>1);
    numOutcome(animalIdx).late.lowRL = sum(es.outcome(trialEnds)==temp & es.roomLength(trialEnds)<1);
    numOutcome(animalIdx).late.highRL = sum(es.outcome(trialEnds)==temp & es.roomLength(trialEnds)>1);
    % Miss
    temp = 4;
    numOutcome(animalIdx).miss.lowGain = sum(es.outcome(trialEnds)==temp & es.gain(trialEnds)<1);
    numOutcome(animalIdx).miss.highGain = sum(es.outcome(trialEnds)==temp & es.gain(trialEnds)>1);
    numOutcome(animalIdx).miss.lowRL = sum(es.outcome(trialEnds)==temp & es.roomLength(trialEnds)<1);
    numOutcome(animalIdx).miss.highRL = sum(es.outcome(trialEnds)==temp & es.roomLength(trialEnds)>1);
    
%     meanSpeed(animalIdx).low = es.smthBallSpd(Posterior_all(animalIdx).t_low & es.traj<100 & es.traj>0);
%     meanSpeed(animalIdx).high = es.smthBallSpd(Posterior_all(animalIdx).t_high & es.traj<100 & es.traj>0);
    meanSpeed(animalIdx).low = es.smthBallSpd(es.contrast<0.6 & es.traj<100 & es.traj>0 ...
        & es.contrast>0 & es.outcome<4 & es.smthBallSpd>=0);
    meanSpeed(animalIdx).high = es.smthBallSpd(es.contrast>0.6 & es.traj<100 & es.traj>0 ...
        & es.contrast>0 & es.outcome<4 & es.smthBallSpd>=0);
         
%     errorbarxy(nanmean(meanSpeed(animalIdx).low), nanmean(meanSpeed(animalIdx).high),...
%         nansem(meanSpeed(animalIdx).low), nansem(meanSpeed(animalIdx).high),...
%         {'ko','k','k'});
    plot(nanmean(meanSpeed(animalIdx).low), nanmean(meanSpeed(animalIdx).high),'ko')
    hold on;
%     axis equal; axis([0 50 0 50])
%     pause

    display([num2str(Posterior_all(animalIdx).iseries) '  Early'])
    numOutcome(animalIdx).early
    display([num2str(Posterior_all(animalIdx).iseries) '  Correct'])
    numOutcome(animalIdx).correct
    display([num2str(Posterior_all(animalIdx).iseries) '  Late'])
    numOutcome(animalIdx).miss
    display([num2str(Posterior_all(animalIdx).iseries) '  Miss'])
    numOutcome(animalIdx).late
    pause
end
