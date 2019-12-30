clc
clear all
close all

plotATM('100m');
load('100m','val');

Fs=1000;
ecg=val(1,:);

l1=length(ecg);

%%%%
t=0:0.001:(length(ecg)*0.001)-0.001;
power_int=10*cos(2*pi*50*t);
%%%%

ecg_noise= ecg+power_int;

fc=150;
wn=(2/Fs)*fc;

%b=fir1(100,0.08,'low',kaiser(101,3));
b=fir1(100,[0.07 0.13], 'stop',kaiser(101,5));
     
Hd= designfilt('bandstopfir','FilterOrder',100, ...
         'CutoffFrequency1',40,'CutoffFrequency2',60,'DesignMethod','window','Window', ...
         {@kaiser,5},'SampleRate',1000);

fvtool(b,1,'Fs', Fs);
%fvtool(Hd,'Fs',Fs);

y1=filter(Hd,ecg_noise);
plot(t,[ecg_noise; y1]);
