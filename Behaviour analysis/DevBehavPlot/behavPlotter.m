classdef behavPlotter < handle
    
    properties
        expObject
        
        figHand
        es
        esLoaded = false;
        totalReward = [];
        trialStart = [];
        trialEnd = [];
    end
    
    methods
        function createUI(obj)
        end
        
        function load(obj)
            % load / reload the data
            [obj.es, obj.totalReward] = obj.expObject.loadBehav;
        end
        
        function run(obj, animal, iseries, iexp)
            % Takes in the details directly
            obj.expObject.animal = animal;
            obj.expObject.iseries = iseries;
            obj.expObject.exp_list = iexp;
            obj.run_rest;
        end
        
        function runFromExpSelector(obj, eo)
            % Takes in experiment object from the expSelector
            obj.expObject = eo;
            obj.run_rest;
        end
           
        function run_rest(obj)
            % This is the main plotting function
            obj.load;
            obj.createUI;
        end
    end