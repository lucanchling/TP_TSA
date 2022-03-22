function [gamma,freq] = estimateur_moyenne(x,N,M,NFFT)
window = rectwin(M);     % taille des tranches
x=x(1:N);
[gamma,freq] = pwelch(x,window,0,NFFT,1,'twosided');
end