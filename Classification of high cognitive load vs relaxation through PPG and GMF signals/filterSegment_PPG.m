function [outputArg1] = filterSegment_PPG(inputArg1)
%Filter for the PPg signal
Fs=128;
[b_butter_bandpass,a_butter_bandpass]=butter(2,[0.4 4]/(Fs/2),'bandpass');
y_butter_bandpass=filtfilt(b_butter_bandpass,a_butter_bandpass,inputArg1);
outputArg1=y_butter_bandpass;

end