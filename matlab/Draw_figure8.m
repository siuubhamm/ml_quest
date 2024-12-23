% Use this script file to draw results presented in Figure 8 (DLPFC)


% run script 1
Extract_T1_in_2_5_tsk_for_PEV_Pfct
% run script 2
Extract_T1_in_2_5_tsk_for_PEV_nonPfct

% Calculate partial-omega squared for both perfrect and non-perfect trial
% Omega squared or partial omega squared is calculated
% by subtracting one from the F-statistic and
% multiplying it by degrees of freedom of the model

% df_effect * (F_effect -1) / ( df_effect * (F_effect - 1) + N  )

CalcPEV_for_CurTarg_x_otherTarg

% plot results 
Plot_PEV_2way_T1_trls_2_5_task_PFC_permute_FDR

