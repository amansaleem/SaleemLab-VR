classdef expObject < handle
    
    properties
        animal
        iseries
        exp_list
        totalReward = 0;
    end
    
    methods
<<<<<<< HEAD
        function [VR, es, totalReward] = loadBehav(obj)
            [VR, ~, es] = VRWheelLoad_SL(obj.animal, obj.iseries, obj.exp_list(1));
=======
        function obj = expObject(a, s, e)
            obj.animal = a;
            obj.iseries = s;
            obj.exp_list = e;
        end
        function [es, totalReward] = loadBehav(obj)
            [VR, ~, es] = VRWheelLoad_SL(obj.animal, obj.iseries, obj.expt_list(1));
>>>>>>> bda0974edaa731457a4cc825e67beb839fdbad76
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