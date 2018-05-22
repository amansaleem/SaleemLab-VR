

AnimalObject = expSelector;
r = expObject;
r.animal = AnimalObject.expObject.animal;
r.iseries = AnimalObject.expObject.iseries;
r.exp_list = AnimalObject.expObject.iexp;
% load experiment
[VR, es, totalReward] = loadBehav(r);

PlotObject = behavPlotter;
PlotObject.AnimalObject = AnimalObject;
PlotObject.expObject = r;
PlotObject.es = es;
PlotObject.VR = VR;

createUI(PlotObject)

AnimalSessionInfo = GetSessionInfo(PlotObject);