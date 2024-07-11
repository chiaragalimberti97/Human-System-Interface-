%% %Exercise slide 26
clear
clc
%% loading of the signal and definition of important vales
load('EEG_TCDM.mat');
load('single_ch.mat');

N_1=length(EEGDATA);
N_2=length(single_ch);
Fs_EEG =500;
Fs_single=128;

%% Power line removal for EEG
w0=50/(Fs_EEG/2);
b0=w0/35;
[b_IIR,a_IIR]=iirnotch(w0,b0);
Y_IIR=filtfilt(b_IIR,a_IIR,EEGDATA');
t=(0:length(EEGDATA)-1)/Fs_EEG;

for i=1:5
figure(); %figure da 1 a 5
plot(t,EEGDATA(i,:));
title('Original EEG')
xlabel('Time s')
ylabel('Magnitude')
hold on;
plot(t,Y_IIR(:,i));
title('Filtered EEG')
xlabel('Time s')
ylabel('Magnitude')
hold off;
end

%% calculation of Welch PSD for EEGdata
[pxx_EEG,f_EEG]=pwelch(EEGDATA',500,300,[],Fs_EEG);
[pxx_IIR,f_IIR]=pwelch(Y_IIR,500,300,[],Fs_EEG);
% plot of the PSD 
%figure da 6 a 10
for i=1:5
figure();
subplot(2,1,1)
plot(f_EEG,10*log10(pxx_EEG(:,i)));
title('Power spectral density of EEG using Welch');
xlabel('frequency (Hz)');
ylabel('PSD (dB/Hz)');
subplot(2,1,2)
plot(f_IIR,10*log10(pxx_IIR(:,i)));
title('Power spectral density off filtered EEG using Welch');
xlabel('frequency (Hz)');
ylabel('PSD (dB/Hz)');
end


%% Power line removal for single channel
w1=60/(Fs_single/2);
b1=w1/35;
[b_IIR1,a_IIR1]=iirnotch(w1,b1);
Y_IIR1=filtfilt(b_IIR1,a_IIR1,single_ch);
t=(0:length(single_ch)-1)/Fs_single;
figure(); %figure 11
plot(t,single_ch);
title('Original single_ch')
xlabel('Time s')
ylabel('Magnitude')
hold on;
plot(t,Y_IIR1);
title('Filtered single_ch')
xlabel('Time s')
ylabel('Magnitude')
hold off,



%% calculation of Welch PSD for both signal

[pxx_single,f_single]=pwelch(single_ch,300,100,[],Fs_single);
[pxx_IIR1,f_IIR1]=pwelch(Y_IIR1,300,100,[],Fs_single);
figure(); %figure 12
subplot(2,1,1);
plot(f_single,10*log10(pxx_single));
title('Power spectral density of single channel using Welch');
xlabel('frequency (Hz)');
ylabel('PSD (dB/Hz)');
subplot(2,1,2);
plot(f_IIR1,10*log10(pxx_IIR1));
title('Power spectral density off filtered single_ch using Welch');
xlabel('frequency (Hz)');
ylabel('PSD (dB/Hz)');