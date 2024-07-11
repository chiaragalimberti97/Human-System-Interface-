function [outputArg1] = filterSegment_GSR(inputArg1)
%Apply a filter to the GSR signal in order to remove the noise
Fs=128;
Fc=6;
[b_butter_low,a_butter_low]=butter(6,Fc/(Fs/2),'low');
y=filtfilt(b_butter_low,a_butter_low,inputArg1);
outputArg1=y;

end