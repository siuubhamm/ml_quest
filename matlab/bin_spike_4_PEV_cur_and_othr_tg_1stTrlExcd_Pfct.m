function [binspikes curr_targ_idx other_targ_idx] = bin_spike_4_PEV_cur_and_othr_tg_1stTrlExcd_Pfct(...   %location last touched 
    t_spike,... %spike time stamps
    t_trig,...  %event time stamps
    TrialID,... %behavioral event codes (eg correct/incorrect)
    width,...   % bin width
    slide,...
    Fx_ana_win,...
    Go_ana_win,...
    Fb_ana_win,...
    numBx,...  % number of choices in the task
    Cycle,...   % cycle to analyze
    targnum,... % number of targets in the task
    touchOrder)



binspikes = [];
curr_targ_idx = [];
other_targ_idx = [];

w = 30; % Gaussian SD not used
Gauss_width = max([11 6*w+1]); % 
kernel      = normpdf(-floor(Gauss_width/2):floor(Gauss_width/2),0,w);

COI = Cycle;



%%-------------------------------------------------------------------------
% Extract trial event data with Reveal event from raw data (trials appropriate for analyses)
RevealTime = t_trig(2:end,5);
for iii = 1:length(RevealTime)
    if ~isempty(RevealTime{iii}) && length(RevealTime{iii}) == 1
    ActiveTrial(iii) = ~isnan(RevealTime{iii});
    else
        ActiveTrial(iii) = 0;
    end
end
% ?s‚²‚Æ‚ÌTaskí—Ş
cellTask = TrialID(2:end,1);
trialcounts = length(cellTask);
cellTargnum = TrialID(2:end,3);
cellChoicenum = TrialID(2:end,4);
cellCyclenum = TrialID(2:end,5);
cellTouchID = TrialID(2:end,8);

celltcode = TrialID(2:end,6);
for iii = 1:length(celltcode)
    if isempty(celltcode{iii})
        ActiveTrial(iii) = 0;
        celltcode{iii} = NaN;
    end
end


TouchCountInCycle = [];
if cellTouchID{1} == 1
    cellCorCount(1) = 1;
    cellCorrectCount = 1;
    TouchCountInCycle(1) = 1;
else
    cellCorCount(1) = NaN;
    cellCorrectCount = 0;
    TouchCountInCycle(1) = 1;
end

lastCycle = 1;

for i = 2:trialcounts
    comp = 0; % comparison ?
    if isnan(cellCyclenum{i-1})
        comp = lastCycle; % = 1
    else
        comp = cellCyclenum{i-1};
        if ~isnan(cellCyclenum{i})
            lastCycle = cellCyclenum{i};
        end
    end
    if cellCyclenum{i} == comp | isnan(cellCyclenum{i})% cycle continued
        if ~isnan(celltcode{i})
        TouchCountInCycle(i) = TouchCountInCycle(i-1) + 1;
        else     
        TouchCountInCycle(i) = TouchCountInCycle(i-1); 
        end
         
        if cellTouchID{i} == 1
            cellCorrectCount = cellCorrectCount + 1; % 1st or 2nd correct touch ?
            cellCorCount(i) = cellCorrectCount;
        else
            cellCorCount(i) = cellCorrectCount; %NaN;
        end
    else % new cycle
        if ~isnan(celltcode{i})
            TouchCountInCycle(i) = 1;
        else
            TouchCountInCycle(i) = 0;
        end
       
        cellCorrectCount = 0;
        if cellTouchID{i} == 1
            cellCorrectCount = cellCorrectCount + 1;
            cellCorCount(i) = cellCorrectCount;
        else
            cellCorCount(i) = cellCorrectCount; %NaN
        end
    end
end





celllevlatency = TrialID(2:end,10);
for iii = 1:length(celllevlatency)
    if isempty(celllevlatency{iii})
        ActiveTrial(iii) = 0;
        celllevlatency{iii} = NaN;
    end
end

celltouchlatency = TrialID(2:end,11);
for iii = 1:length(celltouchlatency)
    if isempty(celltouchlatency{iii})
        ActiveTrial(iii) = 0;
        celltouchlatency{iii} = NaN;
    end
end

cellTargLoc = TrialID(2:end,2);

cellOtherTarg = {};

nTrl2OtherTargTch = [];

for i_trl = 1:length(cellTargLoc) % for all trials
    if ~isempty(cellTouchID{i_trl}) && cellTouchID{i_trl} == 1 &&  cellTargnum{i_trl} == 2 % correct touch in the 2-target condition
        currentTargs = [];
        currentTargs = cellTargLoc{i_trl}; % indices of current 2 targets
       
        cellOtherTarg{i_trl} = currentTargs(find(currentTargs ~= celltcode{i_trl}));
        
        % find if this is a perfect cycle
        ntrl_to_check = [];
%         nTrl2OtherTargTch = 99;
        if cellCorCount(i_trl) == 1 % first touch
            ntrl_to_check = length(celltcode(i_trl:end)) -1;
            for i_check = 1:ntrl_to_check
                if ( celltcode{i_trl + i_check} == cellOtherTarg{i_trl})
                    nTrl2OtherTargTch(i_trl) = i_check;
                    break;
                end
            end
        elseif cellCorCount(i_trl) == 2
            ntrl_to_check = length(celltcode(1:i_trl)) -1;
            for i_check = 1:ntrl_to_check
                if celltcode{i_trl - i_check} == cellOtherTarg{i_trl}              
                    nTrl2OtherTargTch(i_trl) = i_check;
                    break;
                end
            end
            
        end
        
    else
        cellOtherTarg{i_trl} = NaN;  % all other touches (ignored in the 'other target' analysis)
    end
       
end

%% ------------------------------------------------------------------------
trialnum = size(TrialID, 1);
trialnum = trialnum - 1;
    
sps.Fx_bin = [];
sps.Go_bin = [];
sps.Fb_bin = [];
sps.All_bin = [];
%% ------------------------------------------------------------------------

trial_count = 0;
excld = 99;

                
for i = 2:trialnum
    if   ActiveTrial(i)  == 1 && ...                 % Trial n had  Reveal event
         ((cellCyclenum{i} == 1 && TouchCountInCycle(i) > 1) || (cellCyclenum{i} > 1)) && ...
         ~isempty(find(cellCyclenum{i} == COI)) && ...  % Trial n belongs to cycle of interest
         cellCorCount(i) == touchOrder && ...     % ordinal number is this correct touch in a given cycle?
         cellTouchID{i}  == 1 && ...              % Is this touch target-touch (1) or non-target touch (2)?
         cellTask{i}     == 1 && ....             % task (1->spatial; 2->object)
         cellChoicenum{i} == numBx && ...         % Trial n has numBx number of choice (ie 5 or 6 choice)
         cellTargnum{i}  == targnum && ...        % target condition (1 target / 2 target)
         celltcode{i} ~= excld && ...
         ~isnan(t_trig{i+1, 6}) && ...
         t_trig{i+1, 1} +  Fx_ana_win(1) > 0&& ...
         length(nTrl2OtherTargTch) >= i && ...
         (cellCyclenum{i} >= 2 && nTrl2OtherTargTch(i) == 1 && TouchCountInCycle(i) == 1)
  
        trial_count = trial_count + 1;
        

       %% Extracting fixation period activity in 'trial n'
        % set time of data (t_data0 -> t_data1)
        t_range = Fx_ana_win(2)-Fx_ana_win(1)+1;  
        bn = (t_range-width)/slide+1;     % number of sliding bins
        
        t_trig_data = t_trig{i+1,1}; % trigger is 1 (fixation onset)
        t_data0 = t_trig_data + Fx_ana_win(1);
        t_data1 = t_trig_data + Fx_ana_win(2);
        u_data = zeros(1,t_data1-t_data0+1);
        u_data =  t_spike{i}(t_data0:t_data1);
        % Gaussian Kernel Convolution
        % dummy       = conv(u_data,kernel); % pre allocation for speed-up
        % u_data      = dummy(floor(Gauss_width/2)+1:end-floor(Gauss_width/2)); % mode of Gaussian centered on spike -> noncausal      
        for j=1:bn
            bs = slide*(j-1)+1;
            be = bs+width-1;            
            u_bin = zeros(1,width);
            u_bin = u_data(1,bs:be);
            sps.Fx_bin(trial_count,j) = length(find(u_bin==1)) / (width/1000);  
        end
        
       %% Extracting Go period activity in 'trial n'
        % set time of data (t_data0 -> t_data1)
        t_range = Go_ana_win(2)-Go_ana_win(1)+1;  
        bn = (t_range-width)/slide+1;     % number of sliding bins      
        
        t_trig_data = t_trig{i+1,3}; % trigger is 3 (lever-release onset)       
        t_data0 = t_trig_data + Go_ana_win(1);
        t_data1 = t_trig_data + Go_ana_win(2);
        u_data = zeros(1,t_data1-t_data0+1);
        u_data =  t_spike{i}(t_data0:t_data1);
        % Gaussian Kernel Convolution
        % dummy       = conv(u_data,kernel); % pre allocation for speed-up
        % u_data      = dummy(floor(Gauss_width/2)+1:end-floor(Gauss_width/2)); % mode of Gaussian centered on spike -> noncausal      
        for j=1:bn
            bs = slide*(j-1)+1;
            be = bs+width-1;            
            u_bin = zeros(1,width);
            u_bin = u_data(1,bs:be);
            sps.Go_bin (trial_count,j) = length(find(u_bin==1)) / (width/1000);  %sum(u_bin); % length(find(u_bin==1));
        end
       
       %% Extracting Fb period activity in 'trial n'
        % set time of data (t_data0 -> t_data1)
        t_range = Fb_ana_win(2)-Fb_ana_win(1)+1;  
        bn = (t_range-width)/slide+1;     % number of sliding bins      
        
        t_trig_data = t_trig{i+1,5}; % trigger is 5 (feedback onset)  
        t_data0 = t_trig_data + Fb_ana_win(1);
        t_data1 = t_trig_data + Fb_ana_win(2);
        u_data = zeros(1,t_data1-t_data0+1);
        u_data =  t_spike{i}(t_data0:t_data1);
        % Gaussian Kernel Convolution
        % dummy       = conv(u_data,kernel); % pre allocation for speed-up
        % u_data      = dummy(floor(Gauss_width/2)+1:end-floor(Gauss_width/2)); % mode of Gaussian centered on spike -> noncausal      
        for j=1:bn
            bs = slide*(j-1)+1;
            be = bs+width-1;            
            u_bin = zeros(1,width);
            u_bin = u_data(1,bs:be);
            sps.Fb_bin(trial_count,j) = length(find(u_bin==1)) / (width/1000);  %sum(u_bin); % length(find(u_bin==1));
        end
        
       
        
      
        % identifing location of target (target idx)
        curr_targ_idx(trial_count) = celltcode{i};
        other_targ_idx(trial_count) = cellOtherTarg{i};
        
    else
        trial_count = trial_count;
    end
end


%% ------------------------------------------------------------------------
% Creating unified spike data
sps.All_bin = horzcat(sps.Fx_bin, sps.Go_bin, sps.Fb_bin);
if trial_count > 0
    binspikes = sps.All_bin;
else
    binspikes = [];
end





