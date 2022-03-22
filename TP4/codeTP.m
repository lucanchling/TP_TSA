%% Signal & Contexte
clear variables;
close all;
clc;

[s,Fs] = audioread('ProtestMonoBruit.wav');
t = linspace(0, 1, size(s,1))'/Fs;

plot(t,s);
title('signal en fonction du temps')
xlabel('temps (en s)')
ylabel('s(t)')

%% Estimation de la fonction d'autocorrélation
clear variables;
close all;
clc;

[s,Fs] = audioread('ProtestMonoBruit.wav');
t = linspace(0, 1, size(s,1))'/Fs;
% Déclaration des constantes :
K = 200;

% Modification du signal (entre 60s et 70s)
debut = 60*Fs;   % 60s
fin = 70*Fs;     % 70s

s1=s(debut:fin);
t1=t(debut:fin);

[R,lags] = xcorr(s1,K,'biased');

plot(lags,R);
title('\gamma_s(\tau) entre t=60s et t=70s')
xlabel('retard \tau (indiciel)')
ylabel('\gamma_s(\tau)')

%% Identification du modèle AR(M)
clear variables;
close all;
clc;

[s,Fs] = audioread('ProtestMonoBruit.wav');
t = linspace(0, 1, size(s,1))'/Fs;

% Déclaration des variables
M = 20;
K = 200;

% Modification du signal (entre 60s et 70s)
debut = 60*Fs;   % 60s
fin = 70*Fs;     % 70s

s1=s(debut:fin);
t1=t(debut:fin);

[R,lags] = xcorr(s1,K,'biased');

gammas = []

G = toeplitz(gammas);