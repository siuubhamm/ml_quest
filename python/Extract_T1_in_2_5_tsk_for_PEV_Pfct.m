clear all

% reference to data folder
addpath 'C:\Users\渡邉　慶\Documents\MATLAB\Oxford\Pop&Puddle_all'
addpath 'C:\Users\渡邉　慶\Documents\MATLAB\Oxford\CellList\NeuralList'

d = dir('C:\Users\渡邉　慶\Documents\MATLAB\Oxford\Pop&Puddle_all');% directory where raw neural data are stored

width = 100;
slide = 50;

FB_analysis_win  = [1 1300];
Fx_analysis_win  = [-500 999];
Go_analysis_win  = [-500 699];
control_win = [-999 -500];


T_ordr = 1; % use data until (T_order =) 1 st correct touch

%%
numBox = 5 %
lever = 1;%


if numBox == 5
    targetnumber = [1,2];
elseif numBox == 6
    targetnumber = [1,3];
end

files = [];

for Monkey = 1:2
    if Monkey == 1
        if numBox == 5
            files = vertcat(files, ...
                            fns_Puddle_lPFC_5ch_dorsal, ...
                            fns_Puddle_rPFC_5ch_dorsal, ...
                            fns_Puddle_lPFC_5ch_LR_dorsal, ...
                            fns_Puddle_lPFC_5ch_ventral, ...
                            fns_Puddle_rPFC_5ch_ventral, ...
                            fns_Puddle_lPFC_5ch_LR_ventral);
        elseif numBox == 6
        end
    elseif Monkey == 2
        if numBox == 5
            files = vertcat(files, fns_Pop_rPFC_5ch_dorsal, fns_Pop_rPFC_5ch_ventral);
        end
    end
end




%%% LR条件のデータも解析に入れるために、ここより以下を移植
fns = [];
fnsL = [];
fnsR = [];
for i_files = 1:length(files)
    for i_dir = 1:length(d)
        if ~isempty(findstr(files{i_files},d(i_dir).name))  %&& ~isempty(findstr('L',d(ii).name))
            fns = strvcat(fns,d(i_dir).name); % fns =?@SPATIALを記録したニュ?[?ン番??ﾌリスト
        end
        if ~isempty(findstr(files{i_files},d(i_dir).name)) && ~isempty(findstr('L',d(i_dir).name))
            fnsL = strvcat(fnsL,d(i_dir).name); % fns =?@SPATIALを記録したニュ?[?ン番??ﾌリスト
        end
        if ~isempty(findstr(files{i_files},d(i_dir).name)) && ~isempty(findstr('R',d(i_dir).name))
            fnsR = strvcat(fnsR,d(i_dir).name); % fns =?@SPATIALを記録したニュ?[?ン番??ﾌリスト
        end
    end
end
%%%　移植終わり

[numCells,s] = size(fns);    % <- SPATIALを記録したニュ?[?ンの個??
fns
nstart = 1;
session_list = [];
prev_session_name = [];
session_count = 0;
%%% LR条件のデータも解析に入れるために、ここより以下を移植
counter = 0;
%%%　移植終わり

%%------------------------------------------------------------------------
for i_cell = nstart:numCells
    
    fn = fns(i_cell,:)
    %%% LR条件のデータも解析に入れるために、ここより以下を移植
    load_this = 0;
    if isempty(findstr(fn,'L')) && isempty(findstr(fn,'R'))
        load(fn(1:23)); % load normal session data (non LR condition)
        counter = counter + 1;
        load_this = 1;
    elseif ~isempty(findstr(fn,'R')) % collapse Larm and Rarm conditions
        counter = counter + 1;
        load_this = 1;
        t_spike_all = [];
        t_trig_all = [];
        TrialID_all = [];
        fnR = [];
        fnL = [];
        
        fnR = fn;
        load(fnR);
        t_spike_all = t_spike;
        t_trig_all = t_trig;
        TrialID_all = TrialID;
        clear t_spike t_trig TrialID
        
        fnR(findstr(fnR,'R')) = 'L';
        for ii = 1: size(fnsL,1)
            if ~isempty(findstr(fnR,fnsL(ii,:)))
                load(fnsL(ii,:))
                t_spike_all = horzcat(t_spike_all, t_spike);
                t_trig_all = vertcat(t_trig_all, t_trig(2:end,:));
                TrialID_all = vertcat(TrialID_all, TrialID(2:end,:));
                clear t_spike t_trig TrialID
                break;
            end
        end
        t_spike = t_spike_all;
        t_trig = t_trig_all;
        TrialID = TrialID_all;
        fn = fnR;
    end
    %%%　移植終わり
    
    if load_this
        binned_data{1,counter} = [];
        binned_labels.currentTarget_ID{counter} = [];
        binned_labels.otherTarget_ID{counter} = [];
        
        session_name = fname(1,1:12)
        if isempty(prev_session_name) || ~strcmp(prev_session_name,session_name) % new session
            session_count = session_count + 1
        else
            session_count = session_count;
        end
        
        if fn(2) == 'u' % puddle
            excld = 4
        else
            excld = 3
        end
        
        %     1
        % 5       2
        %   4   3
        
        for input_cycle = 1:4
            
            [result_binspikes, current_idx, other_idx]  = bin_spike_4_PEV_cur_and_othr_tg_1stTrlExcd_Pfct(...
                t_spike,...
                t_trig,...
                TrialID,...
                width,...
                slide,...
                Fx_analysis_win,...
                Go_analysis_win,...
                FB_analysis_win,...
                numBox,...
                input_cycle,...
                targetnumber(2),...
                T_ordr);
            
            
            binned_data{1,counter} = vertcat(binned_data{1,counter}, result_binspikes);
            binned_labels.currentTarget_ID{counter} = horzcat(binned_labels.currentTarget_ID{counter}, current_idx);
            binned_labels.otherTarget_ID{counter} = horzcat(binned_labels.otherTarget_ID{counter}, other_idx);
            
            if input_cycle == 4
                binned_site_info.sessionID{counter} =  session_count;
            end
            
            clear  result_binspikes current_idx other_idx
            
        end
        clear t_spike t_trig TrialID fname
        
        if isempty(prev_session_name) || ~strcmp(prev_session_name,session_name) % new session
            if input_cycle == 4
                trial_Data(session_count).val = binned_labels.currentTarget_ID{counter};
                trial_Data(session_count).val2 = binned_labels.otherTarget_ID{counter}
            end
        end
        prev_session_name = session_name;
        
        clear spike* Corr_then* cc* ce* session_name fn
    end
end


save Results_CurrVsOtherTarg_PEV_PerfectTrls_dv_pfc binned_data binned_labels binned_site_info trial_Data

clear all


