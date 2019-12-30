clc
clear all
close all

Fs = 500;
x = repmat(ecg(Fs), 1, 8);
mains_coeff = 0.2;   % Amplitude of mains line to change. Depends on your ECG signal.
time_step = 1/Fs;
max_time = 8;    % Duration of your signal in seconds.
t = time_step:time_step:max_time;    % This is our time vector.
mains_signal = cos(2*pi*50*t);       % 60Hz mains frequency. Depends.
x = x + mains_coeff*mains_signal;


% plot noisy signal
figure
plot(x), set(gca, 'YLim', [-1 1], 'xtick',[])
title('noisy')

% % sgolay filter is a FIR / smoothing
% frame = 9;
% degree = 0;
% y = sgolayfilt(x, degree, frame);
% figure
% plot(y), set(gca, 'YLim', [-1 1], 'xtick',[])
% title('sgolayfilt')
% 
% 
% % smooth
% window = 30;
% %y = smooth(x, window, 'moving');
% %y = smooth(x, window/length(x), 'sgolay', 2);
% y = smooth(x, window/length(x), 'rloess');
% figure
% plot(y), set(gca, 'YLim', [-1 1], 'xtick',[])
% title('smooth')
% 
% % moving average filter
% window = 15;
% h = ones(window,1)/window;
% figure
% y = filter(h, 1, x);
% plot(y), set(gca, 'YLim', [-1 1], 'xtick',[])
% title('moving average')
% 
% % moving weighted window
% window = 7;
% h = gausswin(2*window+1)./window;
% y = zeros(size(x));
% for i=1:length(x)
%     for j=-window:window;
%         if j>-i && j<(length(x)-i+1) 
%             %y(i) = y(i) + x(i+j) * (1-(j/window)^2)/window;
%             y(i) = y(i) + x(i+j) * h(j+window+1);
%         end
%     end
% end
% figure
% plot( y ), set(gca, 'YLim', [-1 1], 'xtick',[])
% title('weighted window')
% 
% % gaussian
% window = 15;
% h = normpdf( -window:window, 0, fix((2*window+1)/6) );
% y = filter(h, 1, x);
% figure
% plot( y ), set(gca, 'YLim', [-1 1], 'xtick',[])
% title('gaussian')
% 
% % median filter
% window = 15;
% y = medfilt1(x, window);
% figure
% plot(y), set(gca, 'YLim', [-1 1], 'xtick',[])
% title('median')
% 
% % filter
% order = 15;
% h = fir1(order, 0.1, rectwin(order+1));
% y = filter(h, 1, x);
% figure
% plot( y ), set(gca, 'YLim', [-1 1], 'xtick',[])
% title('fir1')
% 
% % lowpass Butterworth iir filter
% fNorm = 25 / (Fs/2);               % normalized cutoff frequency
% [b,a] = butter(10, fNorm, 'low');  % 10th order filter
% y = filtfilt(b, a, x);
% figure
% plot(y), set(gca, 'YLim', [-1 1])
% title('butterworth')
% 
% % filter 2
% order = 100;
% h = fir1(order, [0.15 0.25], 'stop');
% y = filter(h, 1, x);
% figure
% plot( y ), set(gca, 'YLim', [-1 1], 'xtick',[])
% title('fir2')
% 
% %notch filter
% fs = 500;             % sampling rate
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
% plot( y ), set(gca, 'YLim', [-1 1], 'xtick',[])
% title('Notch');

K = wiener2(x,[9 9]);
figure;
plot(K);

