% phist_odr.m
%
for i_run =1:2
    save i_run i_run
    clear all
    load i_run
    
    i_run
    IPS = 0;
    
    % % reference to data folder
    switch i_run
        case 1
            load Results_CurrVsOtherTarg_PEV_nonPerfectTrls_dv_pfc
        case 2
            load Results_CurrVsOtherTarg_PEV_PerfectTrls_dv_pfc
        
    end
    
    
    
    numCells= size(binned_data,2)    % <- SPATIAL‚ð‹L˜^‚µ‚½ƒjƒ…[ƒƒ“‚ÌŒÂ”
    PEV = [];
    Pval= [];
    
    fn = sprintf('a');
    
    %%-------------------------------------------------------------------------
    for i=1:numCells
        i;
        SpRates_all = [];
        Anova_matrix = [];
        
        spikes1_2 = [];
        spikes1_3 = [];
        spikes1_4 = [];
        spikes1_5 = [];
        spikes2_1 = [];
        spikes2_3 = [];
        spikes2_4 = [];
        spikes2_5 = [];
        spikes3_1 = [];
        spikes3_2 = [];
        spikes3_4 = [];
        spikes3_5 = [];
        spikes4_1 = [];
        spikes4_2 = [];
        spikes4_3 = [];
        spikes4_5 = [];
        spikes5_1 = [];
        spikes5_2 = [];
        spikes5_3 = [];
        spikes5_4 = [];
        
        
        idx1_2 = find(binned_labels.currentTarget_ID{i} == 1 & binned_labels.otherTarget_ID{i} == 2);
        idx1_3 = find(binned_labels.currentTarget_ID{i} == 1 & binned_labels.otherTarget_ID{i} == 3);
        idx1_4 = find(binned_labels.currentTarget_ID{i} == 1 & binned_labels.otherTarget_ID{i} == 4);
        idx1_5 = find(binned_labels.currentTarget_ID{i} == 1 & binned_labels.otherTarget_ID{i} == 5);
        
        idx2_1 = find(binned_labels.currentTarget_ID{i} == 2 & binned_labels.otherTarget_ID{i} == 1);
        idx2_3 = find(binned_labels.currentTarget_ID{i} == 2 & binned_labels.otherTarget_ID{i} == 3);
        idx2_4 = find(binned_labels.currentTarget_ID{i} == 2 & binned_labels.otherTarget_ID{i} == 4);
        idx2_5 = find(binned_labels.currentTarget_ID{i} == 2 & binned_labels.otherTarget_ID{i} == 5);
        
        idx3_1 = find(binned_labels.currentTarget_ID{i} == 3 & binned_labels.otherTarget_ID{i} == 1);
        idx3_2 = find(binned_labels.currentTarget_ID{i} == 3 & binned_labels.otherTarget_ID{i} == 2);
        idx3_4 = find(binned_labels.currentTarget_ID{i} == 3 & binned_labels.otherTarget_ID{i} == 4);
        idx3_5 = find(binned_labels.currentTarget_ID{i} == 3 & binned_labels.otherTarget_ID{i} == 5);
        
        idx4_1 = find(binned_labels.currentTarget_ID{i} == 4 & binned_labels.otherTarget_ID{i} == 1);
        idx4_2 = find(binned_labels.currentTarget_ID{i} == 4 & binned_labels.otherTarget_ID{i} == 2);
        idx4_3 = find(binned_labels.currentTarget_ID{i} == 4 & binned_labels.otherTarget_ID{i} == 3);
        idx4_5 = find(binned_labels.currentTarget_ID{i} == 4 & binned_labels.otherTarget_ID{i} == 5);
        
        idx5_1 = find(binned_labels.currentTarget_ID{i} == 5 & binned_labels.otherTarget_ID{i} == 1);
        idx5_2 = find(binned_labels.currentTarget_ID{i} == 5 & binned_labels.otherTarget_ID{i} == 2);
        idx5_3 = find(binned_labels.currentTarget_ID{i} == 5 & binned_labels.otherTarget_ID{i} == 3);
        idx5_4 = find(binned_labels.currentTarget_ID{i} == 5 & binned_labels.otherTarget_ID{i} == 4);
        
        
        
        
        eval(['spikes1_2 = binned_data{1,i}(idx1_2,:);']);
        eval(['spikes1_3 = binned_data{1,i}(idx1_3,:);']);
        eval(['spikes1_4 = binned_data{1,i}(idx1_4,:);']);
        eval(['spikes1_5 = binned_data{1,i}(idx1_5,:);']);
        
        eval(['spikes2_1 = binned_data{1,i}(idx2_1,:);']);
        eval(['spikes2_3 = binned_data{1,i}(idx2_3,:);']);
        eval(['spikes2_4 = binned_data{1,i}(idx2_4,:);']);
        eval(['spikes2_5 = binned_data{1,i}(idx2_5,:);']);
        
        eval(['spikes3_1 = binned_data{1,i}(idx3_1,:);']);
        eval(['spikes3_2 = binned_data{1,i}(idx3_2,:);']);
        eval(['spikes3_4 = binned_data{1,i}(idx3_4,:);']);
        eval(['spikes3_5 = binned_data{1,i}(idx3_5,:);']);
        
        eval(['spikes4_1 = binned_data{1,i}(idx4_1,:);']);
        eval(['spikes4_2 = binned_data{1,i}(idx4_2,:);']);
        eval(['spikes4_3 = binned_data{1,i}(idx4_3,:);']);
        eval(['spikes4_5 = binned_data{1,i}(idx4_5,:);']);
        
        eval(['spikes5_1 = binned_data{1,i}(idx5_1,:);']);
        eval(['spikes5_2 = binned_data{1,i}(idx5_2,:);']);
        eval(['spikes5_3 = binned_data{1,i}(idx5_3,:);']);
        eval(['spikes5_4 = binned_data{1,i}(idx5_4,:);']);
        
        SpRates_all =vertcat(spikes1_2,spikes1_3 , spikes1_4,spikes1_5,spikes2_1, ...
            spikes2_3,spikes2_4, spikes2_5,...
            spikes3_1,spikes3_2,spikes3_4,spikes3_5,...
            spikes4_1,spikes4_2,spikes4_3,spikes4_5,...
            spikes5_1,spikes5_2,spikes5_3,spikes5_4);
        
        trs = [];
        Anova_temp = [];
        
        trs = size(spikes1_2,1);
        Anova_temp(1:trs,1) = 1;
        Anova_temp(1:trs,2) = 2;
        Anova_matrix = vertcat(Anova_matrix, Anova_temp);
        
        trs = [];
        Anova_temp = [];
        trs = size(spikes1_3,1);
        Anova_temp(1:trs,1) = 1;
        Anova_temp(1:trs,2) = 3;
        Anova_matrix = vertcat(Anova_matrix, Anova_temp);
        
        trs = [];
        Anova_temp = [];
        trs = size(spikes1_4,1);
        Anova_temp(1:trs,1) = 1;
        Anova_temp(1:trs,2) = 4;
        Anova_matrix = vertcat(Anova_matrix, Anova_temp);
        
        trs = [];
        Anova_temp = [];
        trs = size(spikes1_5,1);
        Anova_temp(1:trs,1) = 1;
        Anova_temp(1:trs,2) = 5;
        Anova_matrix = vertcat(Anova_matrix, Anova_temp);
        
        trs = [];
        Anova_temp = [];
        trs = size(spikes2_1,1);
        Anova_temp(1:trs,1) = 2;
        Anova_temp(1:trs,2) = 1;
        Anova_matrix = vertcat(Anova_matrix, Anova_temp);
        
        trs = [];
        Anova_temp = [];
        trs = size(spikes2_3,1);
        Anova_temp(1:trs,1) = 2;
        Anova_temp(1:trs,2) = 3;
        Anova_matrix = vertcat(Anova_matrix, Anova_temp);
        
        trs = [];
        Anova_temp = [];
        trs = size(spikes2_4,1);
        Anova_temp(1:trs,1) = 2;
        Anova_temp(1:trs,2) = 4;
        Anova_matrix = vertcat(Anova_matrix, Anova_temp);
        
        trs = [];
        Anova_temp = [];
        trs = size(spikes2_5,1);
        Anova_temp(1:trs,1) = 2;
        Anova_temp(1:trs,2) = 5;
        Anova_matrix = vertcat(Anova_matrix, Anova_temp);
        
        trs = [];
        Anova_temp = [];
        trs = size(spikes3_1,1);
        Anova_temp(1:trs,1) = 3;
        Anova_temp(1:trs,2) = 1;
        Anova_matrix = vertcat(Anova_matrix, Anova_temp);
        
        trs = [];
        Anova_temp = [];
        trs = size(spikes3_2,1);
        Anova_temp(1:trs,1) = 3;
        Anova_temp(1:trs,2) = 2;
        Anova_matrix = vertcat(Anova_matrix, Anova_temp);
        
        trs = [];
        Anova_temp = [];
        trs = size(spikes3_4,1);
        Anova_temp(1:trs,1) = 3;
        Anova_temp(1:trs,2) = 4;
        Anova_matrix = vertcat(Anova_matrix, Anova_temp);
        
        trs = [];
        Anova_temp = [];
        trs = size(spikes3_5,1);
        Anova_temp(1:trs,1) = 3;
        Anova_temp(1:trs,2) = 5;
        Anova_matrix = vertcat(Anova_matrix, Anova_temp);
        
        trs = [];
        Anova_temp = [];
        trs = size(spikes4_1,1);
        Anova_temp(1:trs,1) = 4;
        Anova_temp(1:trs,2) = 1;
        Anova_matrix = vertcat(Anova_matrix, Anova_temp);
        
        trs = [];
        Anova_temp = [];
        trs = size(spikes4_2,1);
        Anova_temp(1:trs,1) = 4;
        Anova_temp(1:trs,2) = 2;
        Anova_matrix = vertcat(Anova_matrix, Anova_temp);
        
        trs = [];
        Anova_temp = [];
        trs = size(spikes4_3,1);
        Anova_temp(1:trs,1) = 4;
        Anova_temp(1:trs,2) = 3;
        Anova_matrix = vertcat(Anova_matrix, Anova_temp);
        
        trs = [];
        Anova_temp = [];
        trs = size(spikes4_5,1);
        Anova_temp(1:trs,1) = 4;
        Anova_temp(1:trs,2) = 5;
        Anova_matrix = vertcat(Anova_matrix, Anova_temp);
        
        trs = [];
        Anova_temp = [];
        trs = size(spikes5_1,1);
        Anova_temp(1:trs,1) = 5;
        Anova_temp(1:trs,2) = 1;
        Anova_matrix = vertcat(Anova_matrix, Anova_temp);
        
        trs = [];
        Anova_temp = [];
        trs = size(spikes5_2,1);
        Anova_temp(1:trs,1) = 5;
        Anova_temp(1:trs,2) = 2;
        Anova_matrix = vertcat(Anova_matrix, Anova_temp);
        
        trs = [];
        Anova_temp = [];
        trs = size(spikes5_3,1);
        Anova_temp(1:trs,1) = 5;
        Anova_temp(1:trs,2) = 3;
        Anova_matrix = vertcat(Anova_matrix, Anova_temp);
        
        trs = [];
        Anova_temp = [];
        trs = size(spikes5_4,1);
        Anova_temp(1:trs,1) = 5;
        Anova_temp(1:trs,2) = 4;
        Anova_matrix = vertcat(Anova_matrix, Anova_temp);
        
        
        bins = size(SpRates_all, 2);
        
        for j = 1:bins
            PEV.TargOmega(i,j) = NaN;
            PEV.OtherTargOmega(i,j) = NaN;
            PEV.InterOmega(i,j) = NaN;
            Pval.Targ(i,j) = NaN;
            Pval.OtherTarg(i,j) = NaN;
            Pval.Inter(i,j) = NaN;
            
            [p, tbl] = anovan(SpRates_all(:,j),{Anova_matrix(:,1), Anova_matrix(:,2)},'display','off','model','linear','varnames',{'ChosenT','OtherT'});
            Pval.Targ(i,j) = p(1);
            Pval.OtherTarg(i,j) = p(2);
            
            % Omega squared or partial omega squared is calculated 
            % by subtracting one from the F-statistic and 
            % multiplying it by degrees of freedom of the model
            
            % df_effect * (F_effect -1) / ( df_effect * (F_effect - 1) + N  )
            PEV.TargOmega(i,j) = tbl{12}*(tbl{27}-1)/(tbl{12}*(tbl{27}-1)+ tbl{15}+1);
            PEV.OtherTargOmega(i,j) = tbl{13}*(tbl{28}-1)/(tbl{13}*(tbl{28}-1)+ tbl{15}+1);

            clear tbl p idx*
            
            
        end
        
        
    end
    switch i_run
        case 1
            save PEV_NonPerfect_trials_dv_PFC PEV
            save Pval_NonPerfect_trials_dv_PFC Pval
        case 2
            save PEV_Perfect_trials_dv_PFC PEV
            save Pval_Perfect_trials_dv_PFC Pval
       
       
    end
    
end


clear pd* spike*



load handel
sound(y(1:6000),Fs)



