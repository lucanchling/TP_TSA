%% Etude du bruit seul
clear variables;
close all;
clc;

% Déclaration des constantes
Fs = 500;
B = 160;
nu0 = 100;
m = 6;
T=100;

% Outpout of CGN
Xp = struct('sigma',sqrt(5),'Fs',Fs,'B',B,'T',T) ;
figure()
[X,Xp] = CGN(Xp);
varX=std(X.data)^2;

% Outpout of Filter F1
Dnu=16;
Fp = struct('Fs',Fs,'F0',nu0,'Dnu',Dnu,'order',m,'class','BP filter') ;
figure()
[Yb,Fp] = BPF(X,Fp);
moyYb=mean(Yb.data);
varYb=std(Yb.data)^2;

Zb = SquareSig(Yb);

for Dnu_x_RC = [2,20,100]
    RC =  Dnu_x_RC/Dnu;
    RCFp = struct('Fs',Fs,'RC',RC);
    figure()
    [W,RCFp] = RCF(Zb,RCFp);
    moyW = mean(W.data);
    varW = std(W.data)^2;
    Wkurt = kurtosis(W.data);
    title(['Pour un \Delta\nu x RC = ',num2str(Dnu_x_RC),'\newlineMoyenne = ',num2str(moyW),'  Variance = ',num2str(varW),'  Kurtosis = ',num2str(Wkurt)])
    W.data = W.data(find(W.time>5*RC):length(W.data));
    W.time = W.time(find(W.time>5*RC):length(W.data));
    moyW = mean(W.data);
    varW = std(W.data)^2;
    Wkurt = kurtosis(W.data);
    text(0,-max(W.data)/3,['Avec une correction apportée : ','\newlineMoyenne = ',num2str(moyW),'  Variance = ',num2str(varW),'  Kurtosis = ',num2str(Wkurt)])
end    

%% Mélange Signal + Bruit
clear variables;
close all;
clc;

% Déclaration des constantes
Fs = 500;
B = 160;
nu0 = 100;
m = 6;
T=100;

% génération du signal
Sp = struct('Fs',Fs,'A',1,'Fc',nu0,'FM',1,'Phi',2*pi-2*pi*rand(1,1),'T',T,'W',[]);
[S,Sp,M] = OOK(Sp);

% Vérification altération S(t)

% Outpout of Filter F1
Dnu=16;
Fp = struct('Fs',Fs,'F0',nu0,'Dnu',Dnu,'order',m,'class','BP filter') ;
figure()
[Ys,Fp] = BPF(S,Fp);

% Outpout of CGN
Xp = struct('sigma',sqrt(5),'Fs',Fs,'B',B,'T',T) ;
figure()
[B,Xp] = CGN(Xp);

% Signal + Noise 
X = AddSig(B,S);

% Outpout of Filter F1 of Signal and Noise
figure()
[Y,Fp] = BPF(X,Fp);

% Outpout of squareSig
Z = SquareSig(Y);

for Dnu_x_RC = [2,20,100]
    RC =  Dnu_x_RC/Dnu;
    RCFp = struct('Fs',Fs,'RC',RC);
    figure()
    [W,RCFp] = RCF(Z,RCFp);
    moyW = mean(W.data);
    varW = std(W.data)^2;
    Wkurt = kurtosis(W.data);
    title(['Pour un \Delta\nu x RC = ',num2str(Dnu_x_RC)])
    W.data = W.data(find(W.time>5*RC):length(W.data));
    W.time = W.time(find(W.time>5*RC):length(W.data));
    moyW = mean(W.data);
    varW = std(W.data)^2;
    Wkurt = kurtosis(W.data);
    text(0,-max(W.data)/3,['Avec une correction apportée : ','\newlineMoyenne = ',num2str(moyW),'  Variance = ',num2str(varW),'  Kurtosis = ',num2str(Wkurt)])
end

%% Transmission d'un message binaire
close all;
clear variables;
clc;

% Déclaration des constantes
Fs = 500;
B = 160;
nu0 = 100;
m = 6;
Pb = 5;
nuE = -10;
FM = .05;
T = 100;

% génération du signal
Sp = struct('Fs',Fs,'A',1,'Fc',nu0,'FM',1,'Phi',2*pi-2*pi*rand(1,1),'T',T,'W',[]);
[S,Sp,M] = OOK(Sp);

% Outpout of CGN
Xp = struct('sigma',sqrt(5),'Fs',Fs,'B',B,'T',T) ;
figure()
[B,Xp] = CGN(Xp);

% Signal + Noise 
X = AddSig(B,S);

% For F1
Dnu=16;
Fp = struct('Fs',Fs,'F0',nu0,'Dnu',Dnu,'order',m,'class','BP filter') ;
[Y,Fp] = BPF(S,Fp);

% Outpout of squareSig
Z = SquareSig(Y);

% For H1
Dnu_x_RC = 20;
RC =  Dnu_x_RC/Dnu;
RCFp = struct('Fs',Fs,'RC',RC);
[W,RCFp] = RCF(Z,RCFp);
W.data = W.data(find(W.time>5*RC):length(W.data));
W.time = W.time(find(W.time>5*RC):length(W.time));

% Pour le seuil
seuil = max(W.data)/2;
W_seuil = (W.data>seuil);

figure()
subplot 411
plot(S.time,S.data)
title('Signal S(t)')
subplot 412
plot(X.time,X.data)
title('Signal X(t)')
subplot 413
plot(W.time,W.data)
title('signal W(t)')
subplot 414
plot(W.time,W_seuil)
title('W(t) seuil')