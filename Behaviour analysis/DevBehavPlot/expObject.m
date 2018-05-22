classdef expObject < handle
    
    properties
        animal
        iseries
        iexp
        totalReward = 0;
    end
    
    methods
        function [es, totalReward, VR] = loadBehav(obj)
            [VR, ~, es] = VRWheelLoad_SL(obj.animal, obj.iseries, obj.iexp(1));

            totalReward = VR.REWARD.TotalValveOpenTime;
            if length(obj.iexp>1)
                for iexp = 2:length(obj.iexp)
                    [~, ~, esX] = VRWheelLoad_SL(obj.animal, obj.iseries, obj.exp_list(iexp));
                    VR = combineTwoVRexpts(es, esX);
                    totalReward = totalReward + VR.REWARD.TotalValveOpenTime;
                end
            end
            obj.totalReward = totalReward;
        end
        function obj = expObject_init(a, s, e)
            obj.animal = a;
            obj.iseries = s;
            obj.iexp = e;
        end
    end
end