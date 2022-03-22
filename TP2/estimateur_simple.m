function [gamma,freq,N] = estimateur_simple(x,nd,nf,NFFT)
N = nf-nd+1;
x=x(nd:nf);
X = fft(x,NFFT);
gamma = (abs(X).^2)/N;
freq = (0:1/NFFT:1-(1/NFFT))';
end