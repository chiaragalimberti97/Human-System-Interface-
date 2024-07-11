function [output] = struct_creation()
%From the cogniLoad data construct the data structure in the same form as
%FEB_CLData_AUCL_AUDIO.mat 


num_sessions = 6;

data_struct = struct('PPG', [], 'GSR1', [], 'GSR2', [], 'EventMarker', []);

% Iteration trough the sessions
for i = 1:num_sessions
    if i < 5
        file_name = sprintf('Session%d_Shimmer_5E8A.mat', i);
    else 
        file_name = sprintf('Session%d_Shimmer_8965.mat', i);
    end

    % load session i data
    data = load(file_name);
    
    %Insert the data in the struct
    if i==3 % since subject 3 have problems in the end of the registration I decided to vcut off the problematic data
        k=1500;
        h=1;
    elseif i==5 % subject 5 instead had problem at the beginning 
        k=0;
        h=300; 
    else
        k=0;
        h=1;
    end
    
    if i < 5
        data_struct(i).PPG = data.Shimmer_5E8A_PPG_A13_CAL(h:end-k);
        data_struct(i).GSR1 = data.Shimmer_5E8A_GSR_Skin_Resistance_CAL(h:end-k);
        data_struct(i).GSR2 = data.Shimmer_5E8A_GSR_Skin_Conductance_CAL(h:end-k);
        data_struct(i).EventMarker = data.Shimmer_5E8A_Event_Marker_CAL(h:end-k);

    else 
        data_struct(i).PPG = data.Shimmer_8965_PPG_A13_CAL(h:end-k);
        data_struct(i).GSR1 = data.Shimmer_8965_GSR_Skin_Resistance_CAL(h:end-k);
        data_struct(i).GSR2 = data.Shimmer_8965_GSR_Skin_Conductance_CAL(h:end-k);
        data_struct(i).EventMarker = data.Shimmer_8965_Event_Marker_CAL(h:end-k);
    end
   
    % Correct the markers so that they are always the same for each session
    if i < 3 
        data_struct(i).EventMarker(data_struct(i).EventMarker == 1) = 8;
        data_struct(i).EventMarker(data_struct(i).EventMarker == 4) = 1;
        data_struct(i).EventMarker(data_struct(i).EventMarker == 2) = 4;
        
    elseif ( i == 3 || i == 4  ) 
        data_struct(i).EventMarker(data_struct(i).EventMarker == 16) = 1;
    end
 
    
    
end

% Visualize thr structure
disp(data_struct)
output=data_struct;
end