clear all

width = 100;
slide = 50;
spacerBin = 10;

Fx_analysis_win  = [-500 999];
Go_analysis_win  = [-500 699];
FB_analysis_win  = [1 1300];

Fx_bn= ((Fx_analysis_win(2)-Fx_analysis_win(1)+1)-width)/slide+1;
Go_bn= ((Go_analysis_win(2)-Go_analysis_win(1)+1)-width)/slide+1;
FB_bn= ((FB_analysis_win(2)-FB_analysis_win(1)+1)-width)/slide+1;

FPon = (0 - (Fx_analysis_win(1) + width/2)) / slide + 1 %
GoSignal = (0 - (Go_analysis_win(1) + width/2)) / slide + 1 + 39;
FbOn =  73;
RewOn = (350 - 50)/slide + 1 + 72;


%% draw NonPerfect cycle trials

hold on;
figure(1);
alpha = 0.05;

hight = .1
load PEV_NonPerfect_trials_dv_PFC.mat
PEV_Targ_NonPerfectTrials = PEV.TargOmega;
PEV_otherTarg_NonPerfectTrials = PEV.OtherTargOmega;
clear PEV
[cell, bins] = size(PEV_Targ_NonPerfectTrials); 
spacer = ones(1, spacerBin)*NaN;


for i = 1:bins
    data = PEV_Targ_NonPerfectTrials(find(~isnan(PEV_Targ_NonPerfectTrials(:,i))),i);
    Curve_Target_NonPerfectTrials(i) = mean(data);    
    SE_Targ(i) = std(data)/sqrt(length(data));
    clear data
    data = PEV_otherTarg_NonPerfectTrials(find(~isnan(PEV_otherTarg_NonPerfectTrials(:,i))),i);
    Curve_OtherTarget_NonPerfectTrials(i) = mean(data);    
    SE_otherTarg(i) = std(data)/sqrt(length(data));
    clear data
end


CurveCycle12_Targ_concatenated = horzcat(Curve_Target_NonPerfectTrials(1:Fx_bn), spacer, ...
                                 Curve_Target_NonPerfectTrials(Fx_bn+1 : Fx_bn + Go_bn), spacer, ...
                                 Curve_Target_NonPerfectTrials(Fx_bn + Go_bn + 1 : end));
SE_Targ = horzcat(SE_Targ(1:Fx_bn), spacer, ...
                                 SE_Targ(Fx_bn+1 : Fx_bn + Go_bn), spacer, ...
                                 SE_Targ(Fx_bn + Go_bn + 1 : end));


CurveCycle12_otherTarg_concatenated =  horzcat(Curve_OtherTarget_NonPerfectTrials(1:Fx_bn), spacer, ...
                                 Curve_OtherTarget_NonPerfectTrials(Fx_bn+1 : Fx_bn + Go_bn), spacer, ...
                                 Curve_OtherTarget_NonPerfectTrials(Fx_bn + Go_bn + 1 : end));
SE_otherTarg = horzcat(SE_otherTarg(1:Fx_bn), spacer, ...
                                 SE_otherTarg(Fx_bn+1 : Fx_bn + Go_bn), spacer, ...
                                 SE_otherTarg(Fx_bn + Go_bn + 1 : end));                             
                


[cell, bins] = size(CurveCycle12_Targ_concatenated); 

subplot(2,2,1)
title('T1 trials in Non-perfect cycles in dv PFC')
hold on
plot(1+1:bins+1, CurveCycle12_Targ_concatenated-SE_Targ, 'color',[.8 .8 .8])
plot(1+1:bins+1, CurveCycle12_Targ_concatenated,'LineWidth',1, 'color',[.8 .8 .8])
plot(1+1:bins+1, CurveCycle12_Targ_concatenated+SE_Targ, 'color',[.8 .8 .8])

plot(1+1:bins+1, CurveCycle12_otherTarg_concatenated-SE_otherTarg*1, 'k-')
plot(1+1:bins+1, CurveCycle12_otherTarg_concatenated, 'k-')
plot(1+1:bins+1, CurveCycle12_otherTarg_concatenated+SE_otherTarg*1, 'k-')



plot([FPon+1, FPon+1 ],[-0.005, 0.05],'k')
plot([GoSignal+1, GoSignal+1],[-0.005, 0.05],'k')
plot([FbOn+1 , FbOn+1],[-0.005, 0.05],'k')
plot([RewOn+1, RewOn+1],[-0.005, 0.05],'k--')
plot([1 100],[0 0],'k--')
axis([0 105 -0.005 0.05]) 
axis square



%% draw Perfect cycle trials
clear S* t* C* i m 

hight = .1
load PEV_Perfect_trials_dv_PFC.mat
PEV_Targ_PerfectTrials = PEV.TargOmega;
PEV_OtherTarg_PerfectTrials = PEV.OtherTargOmega;
clear PEV
[cell, bins] = size(PEV_Targ_PerfectTrials); 
spacer = ones(1, spacerBin)*NaN;


for i = 1:bins
    data = PEV_Targ_PerfectTrials(find(~isnan(PEV_Targ_PerfectTrials(:,i))),i);
    Curve_Target_PerfectTrials(i) = mean(data);    
    SE_Targ(i) = std(data)/sqrt(length(data));
    clear data
    data = PEV_OtherTarg_PerfectTrials(find(~isnan(PEV_OtherTarg_PerfectTrials(:,i))),i);
    Curve_OtherTarget_PerfectTrials(i) = mean(data);    
    SE_otherTarg(i) = std(data)/sqrt(length(data));
    clear data
end


CurveCycle34_Targ_concatenated = horzcat(Curve_Target_PerfectTrials(1:Fx_bn), spacer, ...
                                 Curve_Target_PerfectTrials(Fx_bn+1 : Fx_bn + Go_bn), spacer, ...
                                 Curve_Target_PerfectTrials(Fx_bn + Go_bn + 1 : end));
SE_Targ = horzcat(SE_Targ(1:Fx_bn), spacer, ...
                                 SE_Targ(Fx_bn+1 : Fx_bn + Go_bn), spacer, ...
                                 SE_Targ(Fx_bn + Go_bn + 1 : end));


CurveCycle34_otherTarg_concatenated =  horzcat(Curve_OtherTarget_PerfectTrials(1:Fx_bn), spacer, ...
                                 Curve_OtherTarget_PerfectTrials(Fx_bn+1 : Fx_bn + Go_bn), spacer, ...
                                 Curve_OtherTarget_PerfectTrials(Fx_bn + Go_bn + 1 : end));
SE_otherTarg = horzcat(SE_otherTarg(1:Fx_bn), spacer, ...
                                 SE_otherTarg(Fx_bn+1 : Fx_bn + Go_bn), spacer, ...
                                 SE_otherTarg(Fx_bn + Go_bn + 1 : end));                             
                


[cell, bins] = size(CurveCycle34_Targ_concatenated); 

subplot(2,2,3)
title('T1 trials in Perfect cycles in dv PFC')

hold on
plot(1+1:bins+1, CurveCycle34_Targ_concatenated-SE_Targ, 'color',[.8 .8 .8])
plot(1+1:bins+1, CurveCycle34_Targ_concatenated,'LineWidth',1, 'color',[.8 .8 .8])
plot(1+1:bins+1, CurveCycle34_Targ_concatenated+SE_Targ, 'color',[.8 .8 .8])

plot(1+1:bins+1, CurveCycle34_otherTarg_concatenated-SE_otherTarg*1, 'k-')
plot(1+1:bins+1, CurveCycle34_otherTarg_concatenated, 'k-')
plot(1+1:bins+1, CurveCycle34_otherTarg_concatenated+SE_otherTarg*1, 'k-')



plot([FPon+1, FPon+1 ],[-0.005, 0.05],'k')
plot([GoSignal+1, GoSignal+1],[-0.005, 0.05],'k')
plot([FbOn+1 , FbOn+1],[-0.005, 0.05],'k')
plot([RewOn+1, RewOn+1],[-0.005, 0.05],'k--')
plot([1 100],[0 0],'k--')
axis([0 105 -0.005 0.05]) 
axis square



clear Pval cell bins data 
clear S* t* C* i m 




%% Significance plot
sig1 = 0.045
sig2 = 0.04
base = 0.049
% cycle 1
[cell, bins]  = size(PEV_Targ_NonPerfectTrials);
signif = ones(1,bins)*base;
for i = 1:bins
    if isnan(nanmedian(PEV_Targ_NonPerfectTrials(:,i)))    
        p(i) = 999;
    else
        data = [];
        data = find(~isnan(PEV_Targ_NonPerfectTrials(:,i)));
        p(i) = mult_comp_perm_t1(PEV_Targ_NonPerfectTrials(data,i),10000);
        
    end
end

pvalues_cellnum = (find(p ~= 999));
spacer_cellnum = (find(p == 999));
pvalues = (p(pvalues_cellnum));
[h, crit_p, adj_ci_cvrg, adj_p]=fdr_bh(pvalues,0.01,'pdep','yes');
a(pvalues_cellnum) = adj_p;
a(spacer_cellnum) = 999;
signif(find(a < alpha)) = sig1;

signif_final = horzcat(signif(1:Fx_bn), spacer, ...
                                 signif(Fx_bn+1 : Fx_bn + Go_bn), spacer, ...
                                 signif(Fx_bn + Go_bn + 1 : end));
                            


subplot(2,2,1) 
stairs(1+1 : size(signif_final,2)+1, signif_final)

clear a pvalues_cellnum spacer_cellnum h crit_p adj_ci_cvrg adj_p p pvalues signif_final

signif = ones(1,bins)*base;
for i = 1:bins
    if isnan(nanmedian(PEV_otherTarg_NonPerfectTrials(:,i))) 
        p(i) = 999;
    else
        data = [];
        data = find(~isnan(PEV_otherTarg_NonPerfectTrials(:,i)));
        p(i) = mult_comp_perm_t1(PEV_otherTarg_NonPerfectTrials(data,i),10000);
    end
end

pvalues_cellnum = (find(p ~= 999));
spacer_cellnum = (find(p == 999));
pvalues = (p(pvalues_cellnum));
[h, crit_p, adj_ci_cvrg, adj_p]=fdr_bh(pvalues,0.01,'pdep','yes');
a(pvalues_cellnum) = adj_p;
a(spacer_cellnum) = 999;

signif(find(a < alpha)) = sig2;

signif_final = horzcat(signif(1:Fx_bn), spacer, ...
                                 signif(Fx_bn+1 : Fx_bn + Go_bn), spacer, ...
                                 signif(Fx_bn + Go_bn + 1 : end));
subplot(2,2,1) 

stairs(1+1 : size(signif_final,2)+1, signif_final)

clear a pvalues_cellnum spacer_cellnum h crit_p adj_ci_cvrg adj_p p  signif_final

%% cycle 34
signif = ones(1,bins)*base;
for i = 1:bins
    if isnan(nanmedian(PEV_Targ_PerfectTrials(:,i)))    
        p(i) = 999;
    else
         data = [];
        data = find(~isnan(PEV_Targ_PerfectTrials(:,i)));
         p(i) = mult_comp_perm_t1(PEV_Targ_PerfectTrials(data,i),10000);
    end
end

pvalues_cellnum = (find(p ~= 999));
spacer_cellnum = (find(p == 999));
pvalues = (p(pvalues_cellnum));
[h, crit_p, adj_ci_cvrg, adj_p]=fdr_bh(pvalues,0.01,'pdep','yes');
a(pvalues_cellnum) = adj_p;
a(spacer_cellnum) = 999;
signif(find(a < alpha)) = sig1;

signif_final = horzcat(signif(1:Fx_bn), spacer, ...
                                 signif(Fx_bn+1 : Fx_bn + Go_bn), spacer, ...
                                 signif(Fx_bn + Go_bn + 1 : end));


                             
subplot(2,2,3) 
stairs(1+1 : size(signif_final,2)+1, signif_final)
clear a pvalues_cellnum spacer_cellnum h crit_p adj_ci_cvrg adj_p p signif_final

signif = ones(1,bins)*base;
for i = 1:bins
    if isnan(nanmedian(PEV_OtherTarg_PerfectTrials(:,i)))    
        p(i) = 999;
    else
          data = [];
        data = find(~isnan(PEV_OtherTarg_PerfectTrials(:,i)));
         p(i) = mult_comp_perm_t1(PEV_OtherTarg_PerfectTrials(data,i),10000);
    end
end

pvalues_cellnum = (find(p ~= 999));
spacer_cellnum = (find(p == 999));
pvalues = (p(pvalues_cellnum));
[h, crit_p, adj_ci_cvrg, adj_p]=fdr_bh(pvalues,0.01,'pdep','yes');
a(pvalues_cellnum) = adj_p;
a(spacer_cellnum) = 999;
signif(find(a < alpha)) = sig2;
 
signif_final = horzcat(signif(1:Fx_bn), spacer, ...
                                 signif(Fx_bn+1 : Fx_bn + Go_bn), spacer, ...
                                 signif(Fx_bn + Go_bn + 1 : end));



subplot(2,2,3) 
stairs(1+1 : size(signif_final,2)+1, signif_final)
clear a pvalues_cellnum spacer_cellnum h crit_p adj_ci_cvrg adj_p p signif_final 


