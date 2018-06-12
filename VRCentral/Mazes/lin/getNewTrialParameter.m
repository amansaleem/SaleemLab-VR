function currTrialVar = getNewTrialParameter(varArray, varArray_rand, runInfo, expInfo)

if length(varArray)>1
    if varArray_rand
        varToSet = varArray(randi(length(varArray)));
    else
        varIdx = runInfo.currTrial;
        if varIdx>length(varArray)
            varIdx = rem(runInfo.currTrial, length(varArray));
            if varIdx==0
                varIdx = length(varArray);
            end
        end
        varToSet = varArray(varIdx);
    end
else
    varToSet = 1;
end
currTrialVar = varToSet;

end