function [currTrialVar varIdx] = getNewTrialParameter(varArray, varArray_rand, runInfo, expInfo)

varIdx = 1;
if length(varArray)>1
    if varArray_rand
        varIdx = randi(length(varArray));
    else
        varIdx = runInfo.currTrial;
        if varIdx>length(varArray)
            varIdx = rem(runInfo.currTrial, length(varArray));
            if varIdx==0
                varIdx = length(varArray);
            end
        end
    end
    varToSet = varArray(varIdx);
else
    varToSet = 1;
end
currTrialVar = varToSet;

end