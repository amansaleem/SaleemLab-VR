classdef expObject < handle
    
    properties
        animal
        iseries
        exp_list
        totalReward = 0;
    end
    
    methods
        function obj = expObject(a, s, e)
            obj.animal = a;
            obj.iseries = s;
            obj.exp_list = e;
        end
        function [es, totalReward] = loadBehav(obj)
            [VR, ~, es] = VRWheelLoad_SL(obj.animal, obj.iseries, obj.expt_list(1));
            totalReward = VR.REWARD.TotalValveOpenTime;
            if length(obj.expt_list>1)
                for iexp = 2:length(obj.expt_list)
                    [~, ~, esX] = VRWheelLoad_SL(obj.animal, obj.iseries, obj.expt_list(iexp));
                    VR = combineTwoVRexpts(es, esX);
                    totalReward = totalReward + VR.REWARD.TotalValveOpenTime;
                end
            end
            obj.totalReward = totalReward;
        end
    end
end