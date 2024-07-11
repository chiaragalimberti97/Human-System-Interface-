function [out] = computeFeaturesPPG(struct, Fc)
%UNTITLED Summary of this function goes here
    measures_max_ppg = [];
    measures_min_ppg = [];
    measures_mean_ppg = [];
    measures_var_ppg = [];
    
    measures_rate_pks_ppg = [];
    
    measures_IBI_mean = [];
    measures_SDNN = [];
    
    % For each signal in the input structure "stuct" 
    for j = 1 : length(struct)
         % Estrazione segmento da analizzare
         temp_ppg = struct{1,j};
       
        
        
        %% [TO DO]: Evaluate the four statistical features Maximum, Minimum,
            % Mean and Variance from the signal "temp_ppg" and add them to
            % their respective structures (measures_max_ppg, measures_min_ppg,
            % etc...)
        measures_max_ppg = [measures_max_ppg;max(temp_ppg)];
        measures_min_ppg = [measures_min_ppg;min(temp_ppg)];
        measures_mean_ppg = [measures_mean_ppg;mean(temp_ppg)];
        measures_var_ppg = [measures_var_ppg;var(temp_ppg)];
    
    
    
        %% [TO DO] Use the findPeak function and the min distances between two peaks to
            % compute the PeakRate feature for each of the PPG signal
            % (temp_ppg). Then, add it to the structure "measures_rate_pks_ppg"
        [pks,locs] = findpeaks(temp_ppg,Fc,'MinPeakDistance',0.3);
        Time=length(temp_ppg)/Fc;
        PeakRate=length(pks)/Time;
        measures_rate_pks_ppg = [measures_rate_pks_ppg;PeakRate];
    
        %% [TO DO] Starting from the peaks detected, evaluate the Inter Beat Intervals (IBIs)
            % as the distances between consecutive peaks. Then, using IBI,
            % compute the two time domain features IBI_mean and SDNN.
            IBI=diff(locs);
            IBI_mean = mean(IBI);
            measures_IBI_mean = [measures_IBI_mean; IBI_mean];
            
            SDNN = std(IBI);
            measures_SDNN = [measures_SDNN; SDNN];
               
            
    end
                
%% Costruzione dell'output
    out.max_ppg = measures_max_ppg;
    out.min_ppg = measures_min_ppg;
    out.mean_ppg = measures_mean_ppg;
    out.var_ppg = measures_var_ppg;
    
    out.rate_peaks_ppg = measures_rate_pks_ppg;
    
    out.IBI_mean = measures_IBI_mean;
    out.SDNN = measures_SDNN;

end
