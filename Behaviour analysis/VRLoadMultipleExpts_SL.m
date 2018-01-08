function es = VRLoadMultipleExpts_SL(animal, iseries, expt_list, type, channels, shank_list, tag)

if nargin<4
    type = 'BEHAV_ONLY';
end
if nargin<5
    channels = [20 40];
end
if nargin<7 
    tag = [];
end
if nargin<6
    shank_list = false;
end

switch type
    case 'BEHAV_ONLY';
        [~, ~, es] = VRWheelLoad_SL(animal, iseries, expt_list(1));
        if length(expt_list>1)
            for iexp = 2:length(expt_list)
                [~, ~, esX] = VRWheelLoad_SL(animal, iseries, expt_list(iexp));
                es = combineTwoVRexpts(es, esX);
            end
        end
    case 'BEHAV_LFP'
        es = VR_LFP_power_safe_new(animal,iseries,expt_list(1),1,channels(1), channels(2));
        if length(expt_list>1)
            for iexp = 2:length(expt_list)
                esX = VR_LFP_power_safe_new(animal,iseries,expt_list(iexp),1,channels(1), channels(2));
                es = combineTwoVRexpts(es, esX);
            end
        end
    case 'SPIKES'
        if ~shank_list
            inp = inputdlg({'Enter the group to be loaded:','Enter the suffix of this group:'}...
                           ,'Enter Group number');
            igroup = str2num(inp{1});            
            iaddinfo = inp{2};
        else
            igroup = shank_list;
            iaddinfo = tag;
        end
        es = getVRspikes(animal,iseries,expt_list(1),1,100,1,0,igroup,iaddinfo); % animal,iseries,iexp, discreet_steps, flag_load, flag_spont, flag_spkrate
        if length(expt_list>1)
            for iexp = 2:length(expt_list)
                esX = getVRspikes(animal,iseries,expt_list(iexp),1,100,1,0,igroup,iaddinfo);
                es = combineTwoVRexpts(es, esX);
            end
        end
    case 'SPIKES_TIMES'
        if ~shank_list
            inp = inputdlg({'Enter the group to be loaded:','Enter the suffix of this group:'}...
                           ,'Enter Group number');
            igroup = str2num(inp{1});            
            iaddinfo = inp{2};
        else
            igroup = shank_list;
            iaddinfo = tag;
        end
        es = getVRspikes(animal,iseries,expt_list(1),1,100,1,0,igroup,iaddinfo); % animal,iseries,iexp, discreet_steps, flag_load, flag_spont, flag_spkrate
        if length(expt_list>1)
            for iexp = 2:length(expt_list)
                esX = getVRspikes(animal,iseries,expt_list(iexp),1,100,1,0,igroup,iaddinfo);
                es = combineTwoVRexpts(es, esX);
            end
        end    
    case 'SPIKES_THETA'
        if ~shank_list
            inp = inputdlg({'Enter the group to be loaded:','Enter the suffix of this group:'}...
                           ,'Enter Group number');
            igroup = str2num(inp{1});            
            iaddinfo = inp{2};
        else
            igroup = shank_list;
            iaddinfo = tag;
        end
        es = VR_LFP_for_theta(animal,iseries,expt_list(1),1,channels(1), channels(2),1, shank_list);
  
        if length(expt_list>1)
            for iexp = 2:length(expt_list)
                esX = VR_LFP_for_theta(animal,iseries,expt_list(iexp),1,channels(1), channels(2),1, shank_list);
                es = combineTwoVRexpts(es, esX);
            end
        end
end
% if tag
%     save([animal '_' num2str(iseries) '_' tag],'-v7.3');
% end
%     
