%% %Slide 14
%Exercise  1 
load('PPG_CLAWDAS_ELD_read_subset_noise.mat')
signal=CLAWDAS_OLD_read_subset_noise(1).TEXT;
%Exercise 2
%a) moving average filter with window size 6
windowSize=6;
kernel=1/windowSize*ones(windowSize,1);
y_MA=conv(signal,kernel,'valid');

%%b) Apply a 6th-order lowpass Butterworth filter with a cutoff frequency of 
% 4 Hz, for data sampled at Fs = 128 Hz 

Fc=4;
Fs=128;
[b_butter_low,a_butter_low]=butter(6,Fc/(Fs/2),'low');
y_butter_low=filtfilt(b_butter_low,a_butter_low,signal);


%c)Apply a 4th-order Bandpass Butterworth filter with passband frequencies of
% 0.4 Hz and 4 Hz for data sampled at Fs = 128 Hz 

[b_butter_bandpass,a_butter_bandpass]=butter(2,[0.4 4]/(Fs/2),'bandpass');
y_butter_bandpass=filtfilt(b_butter_bandpass,a_butter_bandpass,signal);

%d) Apply a 6th-order low-pass digital 
% Chebyshev I filter or Chebyshev II filter 
% with normalized passband edge frequency 6 and
% 18 decibels of peak-to-peak passband rippl
[b_cheb1,a_cheb1]=cheby1(6,18,6/(128/2),'low');
[b_cheb2,a_cheb2]=cheby2(6,18,6/(128/2),'low');
y_cheb1=filtfilt(b_cheb1,a_cheb1,signal);
y_cheb2=filtfilt(b_cheb2,a_cheb2,signal);
%e) Apply a 6th-order lowpass elliptic filter with 0.5 dB
% of passband ripple, 20 dB of stopband 
%attenuation, and a passband edge frequency of 6 Hz
% for data sampled at 128 Hz

Fc_ell=6;
Fs_ell=128;
[b_ell,a_ell]=ellip(6,0.5,20,Fc_ell/(Fs_ell/2),'low');
y_ell=filtfilt(b_ell,a_ell,signal);
%Exercise 3 :For each of the previous filter
% [items b), c), d) e), and f)] visualize:

%%I. In the same figure, the first 30 seconds of the 
% original signal, the first 30 seconds of the filtered 
%signal, and the Pole-Zero Plot. 
%%II. In a different figure, the magnitude response 
% and the phase response of the filter 


%% %b)
t=0:1/128:30;
figure;
subplot(2,2,1);
plot(t,signal(1:128*30+1));
title("Original signal");
xlabel('Time')
ylabel('Amplitude')
subplot(2,2,2);
plot(t,y_butter_low(1:128*30+1));
title("Butterwoth lowpass filter");
xlabel('Time')
ylabel('Amplitude')
subplot(2,2,3);
zplane(b_butter_low,a_butter_low);
title("Pole-Zero plot");
fvtool(b_butter_low,a_butter_low);

%% %c)
figure;
subplot(2,2,1);
plot(t,signal(1:128*30+1));
title("Original signal");
xlabel('Time')
ylabel('Amplitude')
subplot(2,2,2);
plot(t,y_butter_bandpass(1:128*30+1));
title("Butterwoth bandpass filter");
xlabel('Time')
ylabel('Amplitude')
subplot(2,2,3);
zplane(b_butter_bandpass,a_butter_bandpass);
title("Pole-Zero plot");
fvtool(b_butter_bandpass,a_butter_bandpass);

%% %d)
figure;
subplot(2,2,1);
plot(t,signal(1:128*30+1));
title("Original signal");
xlabel('Time')
ylabel('Amplitude')
subplot(2,2,2);
plot(t,y_cheb1(1:128*30+1));
title("Chebychev filter");
xlabel('Time')
ylabel('Amplitude')
subplot(2,2,3);
zplane(b_cheb1,a_cheb1);
title("Pole-Zero plot");
fvtool(b_cheb1,a_cheb1);

%% e)
figure;
subplot(2,2,1);
plot(t,signal(1:128*30+1));
title("Original signal");
xlabel('Time')
ylabel('Amplitude')
subplot(2,2,2);
plot(t,y_ell(1:128*30+1));
title("Elliptical filter");
xlabel('Time')
ylabel('Amplitude')
subplot(2,2,3);
zplane(b_ell,a_ell);
title("Pole-Zero plot");
fvtool(b_ell,a_ell);








