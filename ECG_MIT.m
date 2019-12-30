clc
clear all
close all

plotATM('100m');
load('100m','val');
e = val(1,:);

Fs = 1000;
x = repmat(e(1:Fs), [1, 10]);
mains_coeff = 10;   % Amplitude of mains line to change. Depends on your ECG signal.
time_step = 1/Fs;
max_time = 10;    % Duration of your signal in seconds.
t = time_step:time_step:max_time;    % This is our time vector.
mains_signal = cos(2*pi*50*t);       % 60Hz mains frequency. Depends.
noisy = mains_coeff*mains_signal;
x = x + noisy;

% original signal
figure
plot(e)
title('Original')

% plot noisy signal
figure
plot(x(1:3600))
title('noisy')

% sgolay filter is a FIR / smoothing
frame = 19;
degree = 0;
y = sgolayfilt(x, degree, frame);
figure
plot(y(1:3600))
title('sgolayfilt')

snr1 = (10*log10((sum(y))^2/(sum(y-x))^2))/20;


% gaussian
window = 18;
h = normpdf( -window:window, 0, fix((2*window+1)/6) );
y = filter(h, 1, x);
figure
plot( y(30:3629) )
title('gaussian')
snr2 = 10*log10( (sum(y(30:3629))^2) / (sum(y(30:3629)-x(1:3600))^2) )/ 20;        


% % lowpass Butterworth iir filter
% fNorm = 25 / (Fs/2);               % normalized cutoff frequency
% [b,a] = butter(12, fNorm, 'low');  % 10th order filter
% y = filtfilt(b, a, x);
% figure
% plot(y(1:3600))
% title('butterworth')
% 
% %notch filter
% fs = 1000;             % sampling rate
% f0 = 50;                % notch frequency
% fn = fs/2;              % Nyquist frequency
% freqRatio = f0/fn;      % ratio of notch freq. to Nyquist freq.
% 
% notchWidth = 0.1;       % width of the notch
% 
% % Compute zeros
% notchZeros = [exp( sqrt(-1)*pi*freqRatio ), exp( -sqrt(-1)*pi*freqRatio )];
% 
% % Compute poles
% notchPoles = (1-notchWidth) * notchZeros;
% 
% %figure;
% %zplane(notchZeros.', notchPoles.');
% 
% b = poly( notchZeros ); %  Get moving average filter coefficients
% a = poly( notchPoles ); %  Get autoregressive filter coefficients
% 
% %figure;
% %freqz(b,a,32000,fs)
% 
% % filter signal x
% y = filter(b,a,x);
% figure;
% plot( y(1:3600) )
% title('Notch');
