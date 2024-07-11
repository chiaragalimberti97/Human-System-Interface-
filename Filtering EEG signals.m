%% %Exercise slide 19
load('EEG_TCDM.mat')
load('single_ch.mat');
Fs_single=128;
F_EEG=500;
Y=fft(EEGDATA,[],2);
N=length(EEGDATA);
Y1=abs(Y).^2;
Y_scaled=Y1*(2/(F_EEG*N));
Y_scaled(:,1)=Y_scaled(:,1)/2;
signal=Y_scaled(:,1:N/2+1);
PSD_fft=signal;
N_fft=length(PSD_fft);
f_fft=(0:N_fft-1)*F_EEG/N;
Fs=F_EEG;
for (i=1:5)
figure();
subplot(3,1,1);
[PSD_per,f_per]=periodogram(EEGDATA(i,:), [],[],Fs);
plot(f_per,10*log10(PSD_per));
title('Periodogram of EGGDATA')
xlabel('frequency Hz')
ylabel('PSD dB/Hz')

subplot(3,1,2);
plot(f_fft,10*log10(PSD_fft(i,:)));
title('PSD through fft of EGGDATA')
xlabel('frequency Hz')
ylabel('PSD dB/Hz')
subplot(3,1,3);
plot(f_per,10*log10(PSD_per)); 
hold on;
plot(f_fft,10*log10(PSD_fft(i,:)));
title('Superposition of the two PSD for EGGDATA')
xlabel('frequency Hz')
ylabel('PSD dB/Hz')
hold off;
end
figure();
[PSD_sing,f_sing]=periodogram(single_ch, [],[],Fs_single);
plot(f_sing,10*log10(PSD_sing));
title('Periodogram of Single channel')
xlabel('frequency Hz')
ylabel('PSD dB/Hz')
