classdef expObject < handle
    
    properties
        animal
        iseries
        exp_list
        totalReward = 0;
    end
    
    methods
        function [VR, es, totalReward] = loadBehav(obj)
            [VR, ~, es] = VRWheelLoad_SL(obj.animal, obj.iseries, obj.exp_list(1));
            totalReward = VR.REWARD.TotalValveOpenTime;
            if length(obj.exp_list>1)
                for iexp = 2:length(obj.exp_list)
                    [~, ~, esX] = VRWheelLoad_SL(obj.animal, obj.iseries, obj.exp_list(iexp));
                    VR = combineTwoVRexpts(es, esX);
                    totalReward = totalReward + VR.REWARD.TotalValveOpenTime;
                end
            end
            obj.totalReward = totalReward;
        end
    end
end