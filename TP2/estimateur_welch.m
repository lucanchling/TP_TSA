function [gamma,freq] = estimateur_welch(x,N,Nom_fenetre,M,NOVERLAP,NFFT)
switch Nom_fenetre
    case 'rectwin'
        window = rectwin(M);
    case 'bartlett'
        window = bartlett(M);
    case 'hann'
        window = hann(M);
    case 'hamming'
        window = hamming(M);
    case 'blackman'
        window = blackman(M);
    case 'gausswin'
        window = gausswin(M);
end
x=x(1:N);
[gamma,freq] = pwelch(x,window,NOVERLAP,NFFT,1,'twosided');
end