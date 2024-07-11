function [outputArg1] = filterSegment_GSR1(inputArg1)
    %Apply a filter to the GSR signal in order to remove the noise
    Fs = 128;
    Fc = 4; 

    [b_butter_low, a_butter_low] = butter(4, Fc / (Fs / 2), 'low');

    y = filtfilt(b_butter_low, a_butter_low, inputArg1);
    outputArg1 = y;
end
