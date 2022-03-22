clear variables;
close all;
clc;

filename = 'experience1.mat';

load(filename);
Fs = 1000;
N = 1000;
B = 100;
m3 = 5;
sigma3 = 10; 

% Mettre en commentaire pour réutiliser l'expérience précedemment faite !

% [x1,x2,x3,a,b] = synthese(N,B,m3,sigma3,Fs);

% [ddp1,ci1] = histogramme(x1,N);
% [ddp2,ci2] = histogramme(x2,N);
% [ddp3,ci3] = histogramme(x3,N);

% Expérimentation - Cas Général

figure()
subplot 241
plot(x1)
title('x1(kTs)')
subplot 242
plot(x2)
title('x2(kTs)')
subplot 243
plot(x3)
title('x3(kTs)')
subplot 244
[h,w] = freqz(b,a,200);
plot(20*log(abs(h).^2),w);
title('Module du gain complexe du filtre')
subplot 245

subplot 246

subplot 247


