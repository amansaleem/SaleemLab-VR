function [out] = getVRBehavLearning(animal, type)

infoAll = getDataInfo(animal);
if ismac
    temp_start = 2;
else
    temp_start = 1;
end
index = 1;
for idate = temp_start:length(infoAll)
    out.date{index} = str2num(infoAll(idate).date);
    out.sessions{index} = infoAll(idate).sessions;
    display(['Processing date: ' num2str(out.date{index})]);
    es = VRLoadMultipleExpts...
        (animal,out.date{index},out.sessions{index});
    
    output = plotLickBeh(es,type,1);
    
    for itype = 1:length(output.lickPos)
        out.meanLR(index,itype) = mean(output.lickPos{itype});
        out.stdLR(index,itype) = std(output.lickPos{itype});
        out.numTrials(index,itype) = size(output.licks{itype},2);
        out.medianLR(index,itype) = median(output.lickPos{itype});
        out.madLR(index,itype) = mad(output.lickPos{itype});
    end
    index = index + 1;
end