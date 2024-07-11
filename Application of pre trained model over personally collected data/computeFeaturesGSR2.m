function [out] = computeFeaturesGSR2(struct, Fc)
%Compute features of GSR signal

%% Final structures inizialization
    measures_max_gsr = [];
    measures_min_gsr = [];
    measures_mean_gsr = [];
    measures_var_gsr = [];
    
    measures_max_gsr_phas = [];
    measures_min_gsr_phas = [];
    measures_mean_gsr_phas = [];
    measures_var_gsr_phas = [];
    
    measures_n_pks_gsr = [];
    measures_rate_pks_gsr = [];   
    
    measures_reg_coef_gsr = [];
    
    
    %% For each signal in the input structure "stuct" 
    for j = 1 : length(struct)
        
        temp_gsr = struct{1,j};
        
    %% Modo 1: usato in "Detecting Moments of Stress from Measurements of Wearable Physiological Sensors
        f = 0.05; %Hz
        [ba, aa] = butter(1, f/Fc, 'high');
        phasic_temp = filtfilt(ba, aa, temp_gsr);
               
        phas_min = min(phasic_temp);
        phasic_temp = phasic_temp - phas_min;
              
        [ba, aa] = butter(1, f/Fc, 'low');   
        tonic_temp =  filtfilt(ba, aa, temp_gsr);
        
        
    %% Modo 2: usando cxvEDA (cvxEDA: A Convex Optimization Approach to
        % Electrodermal Activity Processing]
        %[phasic_temp, ~, tonic_temp, ~, ~, ~, ~] = ...
        %    cvxEDA(temp_gsr, 1/Fc);
        %phasic_temp = phasic_temp';
        %tonic_temp = tonic_temp';
        % Note: Comment this part when you have to extract features from all the signals.
        
        % figure('units','normalized','outerposition',[0 0 0.9 0.9]); sgtitle([testo ' - Trial ' num2str(j)]) 
        % subplot(2,2,1); plot(phasic_temp); title('Phasic Component');
        % hold on; plot(temp_gsr); legend('phasic', 'original');
        % subplot(2,2,2); plot(tonic_temp); title('Tonic Component');
        % hold on; plot(temp_gsr); legend('tonic', 'original');


     %% [TO DO]: Evaluate the four statistical features Maximum, Minimum,
        % Mean and Variance from the signal "temp_gsr" and add them to
        % their respective structures (measures_max_gsr, measures_min_gsr,
        % etc...)
    measures_max_gsr = [measures_max_gsr ; max(temp_gsr)];
    measures_min_gsr = [measures_min_gsr ; min(temp_gsr)];
    measures_mean_gsr = [measures_mean_gsr ; mean(temp_gsr)];
    measures_var_gsr = [measures_var_gsr ; var(temp_gsr)];


    %% [TO DO]: Evaluate the four statistical features Maximum, Minimum,
        % Mean and Variance from the phasic component of "temp_ppg" signal and add them to
        % their respective structures (measures_max_gsr_phas, measures_min_gsr_phas,
        % etc...)
    measures_max_gsr_phas = [measures_max_gsr_phas ; max(phasic_temp)];
    measures_min_gsr_phas = [measures_min_gsr_phas ; min(phasic_temp)];
    measures_mean_gsr_phas = [measures_mean_gsr_phas ; mean(phasic_temp)];
    measures_var_gsr_phas = [measures_var_gsr_phas ; var(phasic_temp)];

    %% [TO DO] Use the findPeak function, the min distances between two peaks and the min peak prominance to
        % compute the PeakRate feature for each of the GSR signal
        % (phasic_temp). Then, add it to the structure "measures_rate_pks_gsr"
    pks=findpeaks(phasic_temp,"MinPeakDistance",128,"MinPeakProminence",0.02);
    PeakRate=length(pks)/(length(phasic_temp)/Fc);  
    measures_n_pks_gsr = [measures_n_pks_gsr ; length(pks)];
    measures_rate_pks_gsr = [measures_rate_pks_gsr ; PeakRate]; 

    %% Evaluate Regression Coefficient
        y = tonic_temp;
        x = (1:length(y))';
        p = polyfit(x,y,1);
        
        measures_reg_coef_gsr = [measures_reg_coef_gsr ; p(1)];
    end        

    %% Output construction
    out.max_gsr = measures_max_gsr;
    out.min_gsr = measures_min_gsr;
    out.mean_gsr = measures_mean_gsr;
    out.var_gsr = measures_var_gsr;
    
    out.max_gsr_phas = measures_max_gsr_phas;
    out.min_gsr_phas = measures_min_gsr_phas;
    out.mean_gsr_phas = measures_mean_gsr_phas;
    out.var_gsr_phas = measures_var_gsr_phas;
   
    out.rate_peaks_gsr = measures_rate_pks_gsr;        
    
    out.reg_coef_gsr = measures_reg_coef_gsr;
end
               
function [outputArg1,outputArg2] = untitled3(inputArg1,inputArg2)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
outputArg1 = inputArg1;
outputArg2 = inputArg2;
end