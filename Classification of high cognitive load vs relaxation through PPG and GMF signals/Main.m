%% Load the short version of the CLAWDAS dataset 
load('FEB_CLData_AUCL_AUDIO.mat');
for sbj=1:length(CLData)
    disp(sbj)
%%  Filter the analyzed signals in order to remove noise and
    % artifacts.   

     % apply a filter to the GSR data (CLData(sbj).GSRraw)
    CLData(sbj).GSRfilt = filterSegment_GSR(CLData(sbj).GSRraw);
  
    %  apply a filter to the PPG data (CLData(sbj).PPGraw)
    CLData(sbj).PPGfilt = filterSegment_PPG(CLData(sbj).PPGraw);


 %%  Apply Signal ampliude normalization to the analyzed signal

    CLData(sbj).GSRnorm=zscore(CLData(sbj).GSRfilt);
    CLData(sbj).PPGnorm=zscore(CLData(sbj).PPGfilt);

 %% Find the positions where the pulses occur
    MK=CLData(sbj).GSRPPGmarker;
    iAudioPeaks = find(MK == 17);
     
    % For each pulse, devide the two task according to what described
    % before
    for it = 1:length(iAudioPeaks)
        
        if it == 1 %For the first trial, the segment starts at the beginning of signal
            CognLoad(sbj).GSR.AUDIO{it} = CLData(sbj).GSRnorm(1:iAudioPeaks(it));
            CognLoad(sbj).PPG.AUDIO{it} = CLData(sbj).PPGnorm(1:iAudioPeaks(it));
        else
            CognLoad(sbj).GSR.AUDIO{it} = CLData(sbj).GSRnorm(iAudioPeaks(it)-4*30*128:iAudioPeaks(it));
            CognLoad(sbj).PPG.AUDIO{it} = CLData(sbj).PPGnorm(iAudioPeaks(it)-4*30*128:iAudioPeaks(it));
        end
               
        if it == 6 % For the last trial (6th), the end of the segment match with the end of the signal
            CognLoad(sbj).GSR.AUCL{it} = CLData(sbj).GSRnorm(iAudioPeaks(it)+1:end);
            CognLoad(sbj).PPG.AUCL{it} = CLData(sbj).PPGnorm(iAudioPeaks(it)+1:end);
        else
            CognLoad(sbj).GSR.AUCL{it} = CLData(sbj).GSRnorm(iAudioPeaks(it)+1:iAudioPeaks(it)+30*128);
            CognLoad(sbj).PPG.AUCL{it} = CLData(sbj).PPGnorm(iAudioPeaks(it)+1:iAudioPeaks(it)+30*128);
        end
        
    end
    
end 

%% Features extraction

% PPG features
auCl_feat_PPG = [];
audio_feat_PPG = [];
auCl_sbjFeatIndex_PPG = [];
audio_sbjFeatIndex_PPG = [];

Fs = 128;

for sbj= 1 : length(CognLoad)
    
    % Extract PPG features from the signals collected from the subject "sbj" 
    % during the High Cognitive Load task 
    aucl=CognLoad(sbj).PPG.AUCL;
    tabTmp = struct2table(computeFeaturesPPG(aucl, Fs));
    
    auCl_feat_PPG = vertcat(auCl_feat_PPG, tabTmp); 
    auCl_sbjFeatIndex_PPG = [auCl_sbjFeatIndex_PPG, ones(1, size(tabTmp, 1))*sbj];
    
    
    % Extract PPG features from the signals collected from the subject "sbj" 
    % during the Low Cognitive Load task
    relax = CognLoad(sbj).PPG.AUDIO; 
    tabTmp = struct2table(computeFeaturesPPG(relax, Fs)); 

    audio_feat_PPG = vertcat(audio_feat_PPG, tabTmp);
    audio_sbjFeatIndex_PPG = [audio_sbjFeatIndex_PPG, ones(1, size(tabTmp, 1))*sbj];
    
end
%% GSR features 
auCl_feat_GSR = [];
audio_feat_GSR = [];
auCl_sbjFeatIndex_GSR = [];
audio_sbjFeatIndex_GSR = [];
Fs = 128;

for sbj= 1 : length(CognLoad)
    
    % Extract GSR features from the signals collected from the subject "sbj" 
    % during the High Cognitive Load task 
    aucl = CognLoad(sbj).GSR.AUCL;
    tabTmp = struct2table(computeFeaturesGSR(aucl, Fs));
    
    
    auCl_feat_GSR = vertcat(auCl_feat_GSR, tabTmp);
    auCl_sbjFeatIndex_GSR = [auCl_sbjFeatIndex_GSR, ones(1, size(tabTmp, 1))*sbj];
    
    
    % Extract GSR features from the signals collected from the subject "sbj" 
    % during the Low Cognitive Load task
    relax = CognLoad(sbj).GSR.AUDIO; 
    tabTmp = struct2table(computeFeaturesGSR(relax, Fs));
    
    
    audio_feat_GSR = vertcat(audio_feat_GSR, tabTmp);
    audio_sbjFeatIndex_GSR = [audio_sbjFeatIndex_GSR, ones(1, size(tabTmp, 1))*sbj];
end




%% Leave one out classifcation for 
disp('%%% CLASSIFICATION with leave one out strategy ')


   
    
%% -- Classificazione PPG-- 

nsbj = size(CognLoad, 2);
 
feat_total_CL_PPG = auCl_feat_PPG;
CL_sbjFeatindex_PPG = auCl_sbjFeatIndex_PPG';
    
feat_total_relax_PPG = audio_feat_PPG;
relax_sbjFeatindex_PPG = audio_sbjFeatIndex_PPG';
    
% Define a single table with all the features (both high and low CL)
feat_total_session_PPG =[feat_total_CL_PPG; feat_total_relax_PPG];

index_Sbj_features_PPG = [CL_sbjFeatindex_PPG;relax_sbjFeatindex_PPG];

% Definizione delle label
labels = repmat({'CognLoad'}, size(feat_total_CL_PPG, 1), 1);
labels = vertcat(labels, repmat({'relax'}, size(feat_total_relax_PPG, 1),1));

% Inizializzazione array
Y_Pred_total_PPG = [];
Y_Real_total_PPG = [];
X_Train=[];
Y_Train=[];
X_Test=[];
Y_Test=[];

% TO DO: Implement the LOSO (Leave One Subject Out) cross validation to
% evaluate the performance of a classifier (you can select the one you prefer) that
% discriminate between low and high cognitive load. 

% Compute the evaluation metrics (precision, recall, accuracy, etc...) on the single confusion matrix 
% generated joining the confusion matrices resulting from each iteration.

% Use the following guidelines as a basis for your code.

for numIt = 1 : nsbj
    temp=(index_Sbj_features_PPG == numIt);
    X_Train=feat_total_session_PPG(~temp,:);
    Y_Train=labels(~temp,:);
    X_Test=feat_total_session_PPG(temp,:);
    Y_Test=labels(temp,:);
 
 % Define Cubic Polynomial SVM 
    template = templateSVM(...
        'CacheSize', 2048, ...
        'KernelFunction', 'polynomial', ...
        'PolynomialOrder', 2, ...
        'KernelScale', 'auto', ...
        'Standardize', true);
    mdl = fitcecoc(...
        X_Train, ...
        Y_Train, ...
        'Learners', template1, ...
        'Coding', 'onevsone', ...
        'ClassNames', unique(labels));
    
    YPred_test = predict(mdl, X_Test);
    Y_Pred_total_PPG = [Y_Pred_total_PPG; categorical(YPred_test)];
    Y_Real_total_PPG = [Y_Real_total_PPG; categorical(Y_Test)];

    end


% [TO DO] Evaluate performances on the final confusion matrix



[C_t_total, order_t] = confusionmat( Y_Real_total_PPG, Y_Pred_total_PPG, 'order', unique(labels));

accuracy_SVM_poly_PPG = sum(diag(C_t_total))/sum(sum(C_t_total));

precision_tmp_poly_PPG = diag(C_t_total)'./(sum(C_t_total,1));
recall_tmp_poly_PPG = (diag(C_t_total)./(sum(C_t_total,2)))';

f1_measure_tmp_poly_PPG = 2 *(precision_tmp_poly_PPG.*recall_tmp_poly_PPG)./(precision_tmp_poly_PPG+recall_tmp_poly_PPG);

 disp('PPG')
disp(['accuracy_SVM_poly: ', num2str(accuracy_SVM_poly_PPG)]);
disp(['precision_tmp_poly: ', num2str(precision_tmp_poly_PPG)]);
disp(['recall_tmp_poly: ', num2str(recall_tmp_poly_PPG)]);
disp(['f1_measure_tmp_poly: ', num2str(f1_measure_tmp_poly_PPG)]);

% the best result is obtained for a polynomial model of order 2 and batch
% size = 2048 
%accuracy_SVM_poly: 0.73333
%precision_tmp_poly: 0.79167     0.69444
%recall_tmp_poly: 0.63333     0.83333
%f1_measure_tmp_poly: 0.7037     0.75758


%% -- Classificazione GSR-- 

nsbj = size(CognLoad, 2);
 
feat_total_CL_GSR = auCl_feat_GSR;
CL_sbjFeatindex_GSR = auCl_sbjFeatIndex_GSR';
    
feat_total_relax_GSR = audio_feat_GSR;
relax_sbjFeatindex_GSR = audio_sbjFeatIndex_GSR';
    
% Define a single table with all the features (both high and low CL)
feat_total_session_GSR =[feat_total_CL_GSR; feat_total_relax_GSR];

index_Sbj_features_GSR = [CL_sbjFeatindex_GSR;relax_sbjFeatindex_GSR];

% Definizione delle label
labels = repmat({'CognLoad'}, size(feat_total_CL_GSR, 1), 1);
labels = vertcat(labels, repmat({'relax'}, size(feat_total_relax_GSR, 1),1));

% Inizializzazione array
Y_Pred_total_GSR = [];
Y_Real_total_GSR = [];
X_Train=[];
Y_Train=[];
X_Test=[];
Y_Test=[];

% TO DO: Implement the LOSO (Leave One Subject Out) cross validation to
% evaluate the performance of a classifier (you can select the one you prefer) that
% discriminate between low and high cognitive load. 

% Compute the evaluation metrics (precision, recall, accuracy, etc...) on the single confusion matrix 
% generated joining the confusion matrices resulting from each iteration.

% Use the following guidelines as a basis for your code.

for numIt = 1 : nsbj
    temp=(index_Sbj_features_GSR == numIt);
    X_Train=feat_total_session_GSR(~temp,:);
    Y_Train=labels(~temp,:);
    X_Test=feat_total_session_GSR(temp,:);
    Y_Test=labels(temp,:);
 
     % Define Cubic Polynomial SVM 
    template = templateSVM(...
        'CacheSize', 2048, ...
        'KernelFunction', 'polynomial', ...
        'PolynomialOrder', 2, ...
        'KernelScale', 'auto', ...
        'Standardize', true);

    mdl = fitcecoc(...
        X_Train, ...
        Y_Train, ...
        'Learners', template, ...
        'Coding', 'onevsone', ...
        'ClassNames', unique(labels));
    
    YPred_test = predict(mdl, X_Test);
    Y_Pred_total_GSR = [Y_Pred_total_GSR; categorical(YPred_test)];
    Y_Real_total_GSR = [Y_Real_total_GSR; categorical(Y_Test)];

    end


% Evaluate performances on the final confusion matrix


[C_t_total, order_t] = confusionmat( Y_Real_total_GSR, Y_Pred_total_GSR, 'order', unique(labels));

accuracy_SVM_poly_GSR = sum(diag(C_t_total))/sum(sum(C_t_total));

precision_tmp_poly_GSR = diag(C_t_total)'./(sum(C_t_total,1));
recall_tmp_poly_GSR = (diag(C_t_total)./(sum(C_t_total,2)))';

f1_measure_tmp_poly_GSR = 2 *(precision_tmp_poly_GSR.*recall_tmp_poly_GSR)./(precision_tmp_poly_GSR+recall_tmp_poly_GSR);
disp('GSR')
disp(['accuracy_SVM_poly: ', num2str(accuracy_SVM_poly_GSR)]);
disp(['precision_tmp_poly: ', num2str(precision_tmp_poly_GSR)]);
disp(['recall_tmp_poly: ', num2str(recall_tmp_poly_GSR)]);
disp(['f1_measure_tmp_poly: ', num2str(f1_measure_tmp_poly_GSR)]);

% the best result is obtained for a polynomial model of order 2 with
% batch_size = 2048 
%accuracy_SVM_poly: 0.94583
%precision_tmp_poly: 0.99083      0.9084
%recall_tmp_poly: 0.9     0.99167
%f1_measure_tmp_poly: 0.94323     0.94821

%% Classification learner
% Using feat_total_session_PPG or feat_total_session_GSR  as predictor and
% labels_PPG or Lalbels_GSR as response, respectively, the results obtained
% are:
%
%PPG: the best result is obtained for hold out of 25% which obtained an
%accuracy of 75% for cubic KNN and tree coarse model
%
%GSR: the best result is obtained for a hold out of 25% which obtained an
%accuracy of 100% for fine tree, medium tree and coarse tree model

%% comparison table

data=[0.73, 0.75 ; 0.94,1.0];
rowNames={'Accuracy PPG','Accuracy GSR'};
colNames={'LOSO','C.L. hould out 25%'};
figure();
title('Comparison matrix')
uitable('Data',data,'ColumnName',colNames,'RowName',rowNames,'Units', 'Normalized','Position',[0,0,1,1]);
