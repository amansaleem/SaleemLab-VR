function percentTimeRun = getPercentTimeRun(animal, iseries, iexp, spdThres)
if nargin<4
    spdThres = 0.2;
end
es = VRLoadMultipleExpts_SL(animal, iseries, iexp);
es.smthBallSpd = smthInTime(es.ballspeed,150,60);
percentTimeRun = 100*sum(es.smthBallSpd(~isnan(es.smthBallSpd))>spdThres)./length(es.smthBallSpd(~isnan(es.smthBallSpd))>spdThres);