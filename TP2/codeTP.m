%% Estimateur simple

clear variables;
close all;
clc;

% déclaration des variables
nf=10000;
nd=5;
NFFT=2^nextpow2(nf-nd);

x = genbrfil();

[gamma,freq,N] = estimateur_simple(x,nd,nf,NFFT);

[Gth,Gbiais,f] = sptheo(nf-nd+1,'simple');

figure()
hold on;
plot(f,Gth)
plot(freq,10*log10(gamma)) % Mise en échelle Log
plot(f,Gbiais)
legend('G_t_h','G_e_m_p','G_b_i_a_i_s_é_e')
title(['Estimateur simple avec NFFT = ',num2str(NFFT),' et N_e_c_h_a_n_t_i_l_l_o_n_s = ',num2str(nf-nd)])
xlim([0 .5])
ylim([-50 10])

%% Estimateur moyenné

clear variables;
close all;
clc;

% déclaration des variables
N = 10000;
M = 100;
NFFT = 2^(nextpow2(N)-2);

x = genbrfil();

[gamma,freq] = estimateur_moyenne(x,N,M,NFFT);

[Gth,Gbiais,f] = sptheo(M,'moyenne');

figure()
hold on;
plot(f,Gth)
plot(freq,10*log10(gamma)) % Mise en échelle Log
plot(f,Gbiais)
legend('G_t_h','G_e_m_p','G_b_i_a_i_s_é_e')
title(['Estimateur moyenne avec NFFT = ',num2str(NFFT),' et N_e_c_h_a_n_t_i_l_l_o_n_s = ',num2str(N),'\newline avec M = ',num2str(M),' et \sigma_x = ',num2str(std(gamma))])
xlim([0 .5])
ylim([-30 10])

%% Estimateur de Welch -- Préambule

clear variables;
close all;
clc;

fenetre()

%% Estimateur de Welch
clear variables;
close all;
clc;

% Déclaration des Ctes
N = 10000;
M = 40;
noverlap = 0;


x = genbrfil();

[gamma,freq] = estimateur_welch(x,N,'rectwin',M,noverlap,NFFT);

[Gth,Gbiais,f] = sptheo(M,'moyenne');


figure()
hold on;
plot(f,Gth)
plot(freq,10*log10(gamma)) % Mise en échelle Log
plot(f,Gbiais)
legend('G_t_h','G_e_m_p','G_b_i_a_i_s_é_e')
title(['Estimateur Welch avec NFFT = ',num2str(NFFT),' et N_e_c_h_a_n_t_i_l_l_o_n_s = ',num2str(N),'\newline avec M = ',num2str(M),' et \sigma_x = ',num2str(std(gamma))])
xlim([0 .5])
ylim([-30 10])