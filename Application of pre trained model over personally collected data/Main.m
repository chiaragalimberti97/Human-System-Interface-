CLData=struct_creation();

%%  work on each session one at the time
for sbj=1:length(CLData)
    

%% Filter the analyzed signals in order to remove noise and
    % artifacts.   

    %  apply a filter to the GSR 1 data
    CLData(sbj).GSR1filt = filterSegment_GSR1(CLData(sbj).GSR1);
    
    %  apply a filter to the GSR 2 data
    CLData(sbj).GSR2filt = filterSegment_GSR2(CLData(sbj).GSR2);

    %  apply a filter to the PPG data 
    CLData(sbj).PPGfilt = filterSegment_PPG(CLData(sbj).PPG);


 %%  Apply Signal ampliude normalization to the analyzed signal

    CLData(sbj).GSR1norm=zscore(CLData(sbj).GSR1filt);
    CLData(sbj).GSR2norm=zscore(CLData(sbj).GSR2filt);
    CLData(sbj).PPGnorm=zscore(CLData(sbj).PPGfilt);

 %% Plot
    figure();
    subplot(2, 3, 1); plot(CLData(sbj).GSR1(1:1000));
    subplot(2, 3, 4); plot(CLData(sbj).GSR1norm(1:1000));
    subplot(2, 3, 2); plot(CLData(sbj).GSR2(1:1000));
    subplot(2, 3, 5); plot(CLData(sbj).GSR2norm(1:1000));
    subplot(2, 3, 3); plot(CLData(sbj).PPG(1:200));
    subplot(2, 3, 6); plot(CLData(sbj).PPGnorm(1:200));

 %% divide the data in the three task
       
    %find all the indices for which the following marker has a different event
    %marker value
    event_indices = find(diff(CLData(sbj).EventMarker) ~= 0);
    marker=CLData(sbj).EventMarker(event_indices);
    A=0;
    B=0;
    M=0;
    
   
    for i = 1 : length(event_indices) +1
        
        if i==1 %first event must be thretated differently
            
            if CLData(sbj).EventMarker(event_indices(i))==1
                A=A+1;
                CognLoad(sbj).GSR1.AUDIO{A}=CLData(sbj).GSR1norm(1:event_indices(i));
                CognLoad(sbj).GSR2.AUDIO{A}=CLData(sbj).GSR2norm(1:event_indices(i));
                CognLoad(sbj).PPG.AUDIO{A}=CLData(sbj).PPGnorm(1:event_indices(i));
                
            
            elseif CLData(sbj).EventMarker(event_indices(i)) == 4
                B=B+1;    
                CognLoad(sbj).GSR1.BASELINE{B}=CLData(sbj).GSR1norm(1:event_indices(i));
                CognLoad(sbj).GSR2.BASELINE{B}=CLData(sbj).GSR2norm(1:event_indices(i));
                CognLoad(sbj).PPG.BASELINE{B}=CLData(sbj).PPGnorm(1:event_indices(i));
                
            
    
            elseif CLData(sbj).EventMarker(event_indices(i))==8
                M=M+1;
                CognLoad(sbj).GSR1.MATH{M}=CLData(sbj).GSR1norm(1:event_indices(i));
                CognLoad(sbj).GSR2.MATH{M}=CLData(sbj).GSR2norm(1:event_indices(i));
                CognLoad(sbj).PPG.MATH{M}=CLData(sbj).PPGnorm(1:event_indices(i));
            end
            

        elseif i < length(event_indices)+1 && i>1 % intermediate events
            if CLData(sbj).EventMarker(event_indices(i))==1
                A=A+1;
                CognLoad(sbj).GSR1.AUDIO{A}=CLData(sbj).GSR1norm(event_indices(i-1)+1:event_indices(i));
                CognLoad(sbj).GSR2.AUDIO{A}=CLData(sbj).GSR2norm(event_indices(i-1)+1:event_indices(i));
                CognLoad(sbj).PPG.AUDIO{A}=CLData(sbj).PPGnorm(event_indices(i-1)+1:event_indices(i));
                
            
            elseif CLData(sbj).EventMarker(event_indices(i))==4
                B=B+1;   
                CognLoad(sbj).GSR1.BASELINE{B}=CLData(sbj).GSR1norm(event_indices(i-1)+1:event_indices(i));
                CognLoad(sbj).GSR2.BASELINE{B}=CLData(sbj).GSR2norm(event_indices(i-1)+1:event_indices(i));
                CognLoad(sbj).PPG.BASELINE{B}=CLData(sbj).PPGnorm(event_indices(i-1)+1:event_indices(i));
                
            
    
            elseif CLData(sbj).EventMarker(event_indices(i))==8
                M=M+1;
                CognLoad(sbj).GSR1.MATH{M}=CLData(sbj).GSR1norm(event_indices(i-1)+1:event_indices(i));
                CognLoad(sbj).GSR2.MATH{M}=CLData(sbj).GSR2norm(event_indices(i-1)+1:event_indices(i));
                CognLoad(sbj).PPG.MATH{M}=CLData(sbj).PPGnorm(event_indices(i-1)+1:event_indices(i));
            end
            
        else %last event 
            if CLData(sbj).EventMarker(event_indices(i-1)+1)==1
                A=A+1;
                CognLoad(sbj).GSR1.AUDIO{A}=CLData(sbj).GSR1norm(event_indices(i-1)+1:length(CLData(sbj).EventMarker));
                CognLoad(sbj).GSR2.AUDIO{A}=CLData(sbj).GSR2norm(event_indices(i-1)+1:length(CLData(sbj).EventMarker));
                CognLoad(sbj).PPG.AUDIO{A}=CLData(sbj).PPGnorm(event_indices(i-1)+1:length(CLData(sbj).EventMarker));
                
            
            elseif CLData(sbj).EventMarker(event_indices(i-1)+1)==4
                B=B+1;   
                CognLoad(sbj).GSR1.BASELINE{B}=CLData(sbj).GSR1norm(event_indices(i-1)+1:length(CLData(sbj).EventMarker));
                CognLoad(sbj).GSR2.BASELINE{B}=CLData(sbj).GSR2norm(event_indices(i-1)+1:length(CLData(sbj).EventMarker));
                CognLoad(sbj).PPG.BASELINE{B}=CLData(sbj).PPGnorm(event_indices(i-1)+1:length(CLData(sbj).EventMarker));
                
            
    
            elseif CLData(sbj).EventMarker(event_indices(i-1)+1)==8
                M=M+1;
                CognLoad(sbj).GSR1.MATH{M}=CLData(sbj).GSR1norm(event_indices(i-1)+1:length(CLData(sbj).EventMarker));
                CognLoad(sbj).GSR2.MATH{M}=CLData(sbj).GSR2norm(event_indices(i-1)+1:length(CLData(sbj).EventMarker));
                CognLoad(sbj).PPG.MATH{M}=CLData(sbj).PPGnorm(event_indices(i-1)+1:length(CLData(sbj).EventMarker));
            end
            
        end
    end       
end 


%% Features extraction

% PPG features
math_feat_PPG = [];
audio_feat_PPG = [];
base_feat_PPG = [];
math_sbjFeatIndex_PPG = [];
audio_sbjFeatIndex_PPG = [];
base_sbjFeatIndex_PPG = [];

Fs = 128;

for sbj= 1 : length(CognLoad)
    
    % Extract PPG features from the signals collected from the subject "sbj" 
    % during the High Cognitive Load task 
    math=CognLoad(sbj).PPG.MATH;
    tabTmp = struct2table(computeFeaturesPPG(math, Fs));
    
    math_feat_PPG = vertcat(math_feat_PPG, tabTmp); 
    math_sbjFeatIndex_PPG = [math_sbjFeatIndex_PPG, ones(1, size(tabTmp, 1))*sbj];
    
    
    % Extract PPG features from the signals collected from the subject "sbj" 
    % during the Low Cognitive Load task
    relax = CognLoad(sbj).PPG.AUDIO; 
    tabTmp = struct2table(computeFeaturesPPG(relax, Fs)); 

    audio_feat_PPG = vertcat(audio_feat_PPG, tabTmp);
    audio_sbjFeatIndex_PPG = [audio_sbjFeatIndex_PPG, ones(1, size(tabTmp, 1))*sbj];


    % Extract PPG features from the signals collected from the subject "sbj" 
    % during the Baseline
    base = CognLoad(sbj).PPG.BASELINE; 
    tabTmp = struct2table(computeFeaturesPPG(base, Fs)); 

    base_feat_PPG = vertcat(base_feat_PPG, tabTmp);
    base_sbjFeatIndex_PPG = [base_sbjFeatIndex_PPG, ones(1, size(tabTmp, 1))*sbj];
    
end
%% GSR1 features 
math_feat_GSR1 = [];
audio_feat_GSR1 = [];
base_feat_GSR1 = [];
math_sbjFeatIndex_GSR1 = [];
audio_sbjFeatIndex_GSR1 = [];
base_sbjFeatIndex_GSR1 = [];
  
    
Fs = 128;

for sbj= 1 : length(CognLoad)
    
    % Extract GSR1 features from the signals collected from the subject "sbj" 
    % during the High Cognitive Load task 
    math = CognLoad(sbj).GSR1.MATH;
    tabTmp = struct2table(computeFeaturesGSR1(math, Fs));
    
    
    math_feat_GSR1 = vertcat(math_feat_GSR1, tabTmp);
    math_sbjFeatIndex_GSR1 = [math_sbjFeatIndex_GSR1, ones(1, size(tabTmp, 1))*sbj];
    
    
    % Extract GSR1 features from the signals collected from the subject "sbj" 
    % during the Low Cognitive Load task
    relax = CognLoad(sbj).GSR1.AUDIO; 
    tabTmp = struct2table(computeFeaturesGSR1(relax, Fs));
    
    
    audio_feat_GSR1 = vertcat(audio_feat_GSR1, tabTmp);
    audio_sbjFeatIndex_GSR1 = [audio_sbjFeatIndex_GSR1, ones(1, size(tabTmp, 1))*sbj];


    % Extract GSR1 features from the signals collected from the subject "sbj" 
    % during the baseline
    base = CognLoad(sbj).GSR1.BASELINE; 
    tabTmp = struct2table(computeFeaturesGSR1(base, Fs));
    
    
    base_feat_GSR1 = vertcat(base_feat_GSR1, tabTmp);
    base_sbjFeatIndex_GSR1 = [base_sbjFeatIndex_GSR1, ones(1, size(tabTmp, 1))*sbj];
end


%% GSR2 features 
math_feat_GSR2 = [];
audio_feat_GSR2 = [];
base_feat_GSR2 = [];
math_sbjFeatIndex_GSR2 = [];
audio_sbjFeatIndex_GSR2 = [];
base_sbjFeatIndex_GSR2 = [];
  
    
Fs = 128;

for sbj= 1 : length(CognLoad)
    
    % Extract GSR2 features from the signals collected from the subject "sbj" 
    % during the High Cognitive Load task 
    math = CognLoad(sbj).GSR2.MATH;
    tabTmp = struct2table(computeFeaturesGSR2(math, Fs));
    
    
    math_feat_GSR2 = vertcat(math_feat_GSR2, tabTmp);
    math_sbjFeatIndex_GSR2 = [math_sbjFeatIndex_GSR2, ones(1, size(tabTmp, 1))*sbj];
    
    
    % Extract GSR2 features from the signals collected from the subject "sbj" 
    % during the Low Cognitive Load task
    relax = CognLoad(sbj).GSR2.AUDIO; 
    tabTmp = struct2table(computeFeaturesGSR2(relax, Fs));
    
    
    audio_feat_GSR2 = vertcat(audio_feat_GSR2, tabTmp);
    audio_sbjFeatIndex_GSR2 = [audio_sbjFeatIndex_GSR2, ones(1, size(tabTmp, 1))*sbj];


    % Extract GSR2 features from the signals collected from the subject "sbj" 
    % during the baseline
    base = CognLoad(sbj).GSR2.BASELINE; 
    tabTmp = struct2table(computeFeaturesGSR2(base, Fs));
    
    
    base_feat_GSR2 = vertcat(base_feat_GSR2, tabTmp);
    base_sbjFeatIndex_GSR2 = [base_sbjFeatIndex_GSR2, ones(1, size(tabTmp, 1))*sbj];
end




%% Leave one out classifcation for 
disp('%%% CLASSIFICATION with leave one out strategy ')


   
    
%% -- Classificazione PPG-- 

nsbj = size(CognLoad, 2);
 
feat_total_CL_PPG = math_feat_PPG;
CL_sbjFeatindex_PPG = math_sbjFeatIndex_PPG';
    
feat_total_relax_PPG = audio_feat_PPG;
relax_sbjFeatindex_PPG = audio_sbjFeatIndex_PPG';
 
feat_total_base_PPG = base_feat_PPG;
base_sbjFeatindex_PPG = base_sbjFeatIndex_PPG';

% Define a single table with all the features (both high and low CL)
feat_total_session_PPG =[feat_total_CL_PPG; feat_total_relax_PPG; feat_total_base_PPG];

index_Sbj_features_PPG = [CL_sbjFeatindex_PPG;relax_sbjFeatindex_PPG;base_sbjFeatindex_PPG];

% Definizione delle label
labels_PPG = repmat({'math'}, size(feat_total_CL_PPG, 1), 1);
labels_PPG = vertcat(labels_PPG, repmat({'relax'}, size(feat_total_relax_PPG, 1),1));
labels_PPG = vertcat(labels_PPG, repmat({'base'}, size(feat_total_base_PPG, 1),1));

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
    Y_Train=labels_PPG(~temp,:);
    X_Test=feat_total_session_PPG(temp,:);
    Y_Test=labels_PPG(temp,:);
    % Modello di classificazione
 
    
 % Define Cubic Polynomial SVM 
    template = templateSVM(...
        'CacheSize', 512, ...
        'KernelFunction', 'gaussian', ...
        'KernelScale', 'auto', ...
        'Standardize', true);
    mdl = fitcecoc(...
        X_Train, ...
        Y_Train, ...
        'Learners', template, ...
        'Coding', 'onevsone', ...
        'ClassNames', unique(labels_PPG));
    
    YPred_test = predict(mdl, X_Test);
    Y_Pred_total_PPG = [Y_Pred_total_PPG; categorical(YPred_test)];
    Y_Real_total_PPG = [Y_Real_total_PPG; categorical(Y_Test)];

    end


% [TO DO] Evaluate performances on the final confusion matrix



[C_t_total, order_t] = confusionmat( Y_Real_total_PPG, Y_Pred_total_PPG, 'order', unique(labels_PPG));

accuracy_SVM_poly_PPG = sum(diag(C_t_total))/sum(sum(C_t_total));

precision_tmp_poly_PPG = diag(C_t_total)'./(sum(C_t_total,1));
recall_tmp_poly_PPG = (diag(C_t_total)./(sum(C_t_total,2)))';

f1_measure_tmp_poly_PPG = 2 *(precision_tmp_poly_PPG.*recall_tmp_poly_PPG)./(precision_tmp_poly_PPG+recall_tmp_poly_PPG);

 disp('PPG')
disp(['accuracy_SVM_poly: ', num2str(accuracy_SVM_poly_PPG)]);
disp(['precision_tmp_poly: ', num2str(precision_tmp_poly_PPG)]);
disp(['recall_tmp_poly: ', num2str(recall_tmp_poly_PPG)]);
disp(['f1_measure_tmp_poly: ', num2str(f1_measure_tmp_poly_PPG)]);



%% -- Classificazione GSR1-- 

nsbj = size(CognLoad, 2);
 
feat_total_CL_GSR1 = math_feat_GSR1;
CL_sbjFeatindex_GSR1 = math_sbjFeatIndex_GSR1';
    
feat_total_relax_GSR1 = audio_feat_GSR1;
relax_sbjFeatindex_GSR1 = audio_sbjFeatIndex_GSR1';

feat_total_base_GSR1 = base_feat_GSR1;
base_sbjFeatindex_GSR1 = base_sbjFeatIndex_GSR1';
    
% Define a single table with all the features (both high and low CL)
feat_total_session_GSR1 =[feat_total_CL_GSR1; feat_total_relax_GSR1;feat_total_base_GSR1];

index_Sbj_features_GSR1 = [CL_sbjFeatindex_GSR1;relax_sbjFeatindex_GSR1;base_sbjFeatindex_GSR1];

% Definizione delle label
labels_GSR1 = repmat({'math'}, size(feat_total_CL_GSR1, 1), 1);
labels_GSR1 = vertcat(labels_GSR1, repmat({'relax'}, size(feat_total_relax_GSR1, 1),1));
labels_GSR1 = vertcat(labels_GSR1, repmat({'base'}, size(feat_total_base_GSR1, 1),1));

% Inizializzazione array
Y_Pred_total_GSR1 = [];
Y_Real_total_GSR1 = [];
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
    temp=(index_Sbj_features_GSR1 == numIt);
    X_Train=feat_total_session_GSR1(~temp,:);
    Y_Train=labels_GSR1(~temp,:);
    X_Test=feat_total_session_GSR1(temp,:);
    Y_Test=labels_GSR1(temp,:);
 
     % Define Cubic Polynomial SVM 
    template = templateSVM(...
        'CacheSize', 512, ...
        'KernelFunction', 'polynomial', ...       
        'PolynomialOrder', 3,...
        'KernelScale', 'auto', ...
        'Standardize', true);

    mdl = fitcecoc(...
        X_Train, ...
        Y_Train, ...
        'Learners', template, ...
        'Coding', 'onevsone', ...
        'ClassNames', unique(labels_GSR1));
    
    YPred_test = predict(mdl, X_Test);
    Y_Pred_total_GSR1 = [Y_Pred_total_GSR1; categorical(YPred_test)];
    Y_Real_total_GSR1 = [Y_Real_total_GSR1; categorical(Y_Test)];

    end


% Evaluate performances on the final confusion matrix


[C_t_total, order_t] = confusionmat( Y_Real_total_GSR1, Y_Pred_total_GSR1, 'order', unique(labels_GSR1));

accuracy_SVM_poly_GSR1 = sum(diag(C_t_total))/sum(sum(C_t_total));

precision_tmp_poly_GSR1 = diag(C_t_total)'./(sum(C_t_total,1));
recall_tmp_poly_GSR1 = (diag(C_t_total)./(sum(C_t_total,2)))';

f1_measure_tmp_poly_GSR1 = 2 *(precision_tmp_poly_GSR1.*recall_tmp_poly_GSR1)./(precision_tmp_poly_GSR1+recall_tmp_poly_GSR1);
disp('GSR1')
disp(['accuracy_SVM_poly: ', num2str(accuracy_SVM_poly_GSR1)]);
disp(['precision_tmp_poly: ', num2str(precision_tmp_poly_GSR1)]);
disp(['recall_tmp_poly: ', num2str(recall_tmp_poly_GSR1)]);
disp(['f1_measure_tmp_poly: ', num2str(f1_measure_tmp_poly_GSR1)]);

%% -- Classificazione GSR2-- 

nsbj = size(CognLoad, 2);
 
feat_total_CL_GSR2 = math_feat_GSR2;
CL_sbjFeatindex_GSR2 = math_sbjFeatIndex_GSR2';
    
feat_total_relax_GSR2 = audio_feat_GSR2;
relax_sbjFeatindex_GSR2 = audio_sbjFeatIndex_GSR2';

feat_total_base_GSR2 = base_feat_GSR2;
base_sbjFeatindex_GSR2 = base_sbjFeatIndex_GSR2';
    
% Define a single table with all the features (both high and low CL)
feat_total_session_GSR2 =[feat_total_CL_GSR2; feat_total_relax_GSR2;feat_total_base_GSR2];

index_Sbj_features_GSR2 = [CL_sbjFeatindex_GSR2;relax_sbjFeatindex_GSR2;base_sbjFeatindex_GSR2];

% Definizione delle label
labels_GSR2= repmat({'math'}, size(feat_total_CL_GSR2, 1), 1);
labels_GSR2 = vertcat(labels_GSR2, repmat({'relax'}, size(feat_total_relax_GSR2, 1),1));
labels_GSR2 = vertcat(labels_GSR2, repmat({'base'}, size(feat_total_base_GSR2, 1),1));

% Inizializzazione array
Y_Pred_total_GSR2 = [];
Y_Real_total_GSR2 = [];
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
    temp=(index_Sbj_features_GSR2 == numIt);
    X_Train=feat_total_session_GSR2(~temp,:);
    Y_Train=labels_GSR2(~temp,:);
    X_Test=feat_total_session_GSR2(temp,:);
    Y_Test=labels_GSR2(temp,:);
 
     % Define Cubic Polynomial SVM 
    template = templateSVM(...
        'CacheSize', 512, ...
        'KernelFunction', 'polynomial', ...
        'PolynomialOrder', 3, ...
        'KernelScale', 'auto', ...
        'Standardize', true);

    mdl = fitcecoc(...
        X_Train, ...
        Y_Train, ...
        'Learners', template, ...
        'Coding', 'onevsone', ...
        'ClassNames', unique(labels_GSR2));
    
    YPred_test = predict(mdl, X_Test);
    Y_Pred_total_GSR2 = [Y_Pred_total_GSR2; categorical(YPred_test)];
    Y_Real_total_GSR2 = [Y_Real_total_GSR2; categorical(Y_Test)];

    end


% Evaluate performances on the final confusion matrix


[C_t_total, order_t] = confusionmat( Y_Real_total_GSR2, Y_Pred_total_GSR2, 'order', unique(labels_GSR2));

accuracy_SVM_poly_GSR2 = sum(diag(C_t_total))/sum(sum(C_t_total));

precision_tmp_poly_GSR2 = diag(C_t_total)'./(sum(C_t_total,1));
recall_tmp_poly_GSR2 = (diag(C_t_total)./(sum(C_t_total,2)))';

f1_measure_tmp_poly_GSR2 = 2 *(precision_tmp_poly_GSR2.*recall_tmp_poly_GSR2)./(precision_tmp_poly_GSR2+recall_tmp_poly_GSR2);
disp('GSR2')
disp(['accuracy_SVM_poly: ', num2str(accuracy_SVM_poly_GSR2)]);
disp(['precision_tmp_poly: ', num2str(precision_tmp_poly_GSR2)]);
disp(['recall_tmp_poly: ', num2str(recall_tmp_poly_GSR2)]);
disp(['f1_measure_tmp_poly: ', num2str(f1_measure_tmp_poly_GSR2)]);



%% Classification learner trained over new data
% Using feat_total_session_PPG or feat_total_session_GSR  as predictor and
% labels_PPG or Lalbels_GSR as response, respectively, the results obtained
% are:
%
%PPG: the best result is obtained for hold out of 25% which obtained an
%accuracy of 63.6% for cubic KNN and tree coarse model
%
%GSR1: the best result is obtained for a hold out of 25% which obtained an
%accuracy of 81.8% for cosine and cubic KNN and efficient linear SVM
%
%GSR2 : the best result is obtained for a hold out of 25% which obtained an
%accuracy of 90.9% for fine and medium tree, fine KNN and weighted KNN
%




%% CLASSIFICATION LEARNER FROM PREVIOUS TRAINING (ASSIGNMENT 2)
%the two trained model come from the previous assignment and were exported
%and saved under the name trainedModel_GSR and traineModel_PPG




feat_total_CL_GSR2 = math_feat_GSR2;
    
feat_total_relax_GSR2 = audio_feat_GSR2;

% Define a single table with all the features (both high and low CL)
feat_total_session_GSR2 =[feat_total_CL_GSR2; feat_total_relax_GSR2];

% label definition
labels_GSR2 = repmat({'CognLoad'}, size(feat_total_CL_GSR2, 1), 1);
labels_GSR2 = vertcat(labels_GSR2, repmat({'relax'}, size(feat_total_relax_GSR2, 1),1));

data=load("trainedModel_GSR.mat");
trainedModel_GSR=data.trainedModel_GSR;
[yfit1,scores1]=trainedModel_GSR.predictFcn(feat_total_session_GSR2);


[C_t_total, order_t] = confusionmat( categorical(labels_GSR2), categorical(yfit1), 'order', unique(labels_GSR2));

accuracy_SVM_poly_GSR2 = sum(diag(C_t_total))/sum(sum(C_t_total));

precision_tmp_poly_GSR2 = diag(C_t_total)'./(sum(C_t_total,1));
recall_tmp_poly_GSR2 = (diag(C_t_total)./(sum(C_t_total,2)))';

f1_measure_tmp_poly_GSR2 = 2 *(precision_tmp_poly_GSR2.*recall_tmp_poly_GSR2)./(precision_tmp_poly_GSR2+recall_tmp_poly_GSR2);
disp('GSR2')
disp(['accuracy_SVM_poly: ', num2str(accuracy_SVM_poly_GSR2)]);
disp(['precision_tmp_poly: ', num2str(precision_tmp_poly_GSR2)]);
disp(['recall_tmp_poly: ', num2str(recall_tmp_poly_GSR2)]);
disp(['f1_measure_tmp_poly: ', num2str(f1_measure_tmp_poly_GSR2)]);


%% PPG
feat_total_CL_PPG = math_feat_PPG;
    
feat_total_relax_PPG = audio_feat_PPG;

% Define a single table with all the features (both high and low CL)
feat_total_session_PPG =[feat_total_CL_PPG; feat_total_relax_PPG];

% label definition
labels_PPG = repmat({'CognLoad'}, size(feat_total_CL_PPG, 1), 1);
labels_PPG = vertcat(labels_PPG, repmat({'relax'}, size(feat_total_relax_PPG, 1),1));

data=load("trainedModel_PPG.mat");
trainedModel_PPG=data.trainedModel_PPG;
[yfit2,scores2]=trainedModel_PPG.predictFcn(feat_total_session_PPG);

[C_t_total, order_t] = confusionmat( categorical(labels_PPG), categorical(yfit2), 'order', unique(labels_PPG));

accuracy_SVM_poly_PPG = sum(diag(C_t_total))/sum(sum(C_t_total));

precision_tmp_poly_PPG = diag(C_t_total)'./(sum(C_t_total,1));
recall_tmp_poly_PPG = (diag(C_t_total)./(sum(C_t_total,2)))';

f1_measure_tmp_poly_PPG = 2 *(precision_tmp_poly_PPG.*recall_tmp_poly_PPG)./(precision_tmp_poly_PPG+recall_tmp_poly_PPG);
disp('PPG')
disp(['accuracy_SVM_poly: ', num2str(accuracy_SVM_poly_PPG)]);
disp(['precision_tmp_poly: ', num2str(precision_tmp_poly_PPG)]);
disp(['recall_tmp_poly: ', num2str(recall_tmp_poly_PPG)]);
disp(['f1_measure_tmp_poly: ', num2str(f1_measure_tmp_poly_PPG)]);


%% comparison table for training on the new data

data=[36 , 63, 61; 80 , 81.8 , 19 ; 82 ,90.9, 88];
rowNames={'Accuracy PPG','Accuracy GSR1','Accuracy GSR2'};
colNames={'LOSO','C.L. trained on new data','C.L. trained on old data'};
figure();
title('Comparison matrix')
uitable('Data',data,'ColumnName',colNames,'RowName',rowNames,'Units', 'Normalized','Position',[0,0,1,1]);
% the 19% for the classification of GSR1 is given by the fact that the
% precedent classififer was trained on GSR2 