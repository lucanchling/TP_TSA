function [Gth,Gbiais,fth]=sptheo(Q,method,fenetre);
% [Gth,Gbiais,f]=sptheo(Q,method,fenetre);
% calcule dans le cadre du TP Estimation spectrale
%  - Gth : la valeur en dB de la DSPM du bruit blanc filtr� entre 0 et 0,5
%  - Gbiais : la valeur en dB de Gth convolu� par la grandeur r�gissant le
%  biais attach� � la 'method'
%  - fth : un vecteur fr�quence r�duite de m�me taille que Gth et Gbiais 
% method peut prendre 3 valeurs :
%   'simple'
%   'moyenne'
%   'welch'3
%
% Si method='simple', Q repr�sente la longueur de l'�chantillon analys�
%
% Si method='moyenne' ou 'welch', Q repr�sente la longueur d'une tranche
%
% Si method='simple' ou 'moyenne' le param�tre fenetre est ignor�
%
% Si method='welch', il faut sp�cifier le nom de la fen�tre dans le 3�me
% param�tre
%
% Exemple : [Gth,Gbiais,f]=sptheo(1024,'welch','hamming');

% fonction d�velopp�e par N. Gache le 25/3/2010

%coefficients du filtre
load LPbutt
if or(strcmp(method,'simple'),strcmp(method,'moyenne'))
    % dans le cas 'simple' et 'moyenn�', tranches de longueur Q,  
    % la fen�tre de Bartlett en jeu va de -(Q-1) � Q-1
    LBart=2*Q-1;
    fenetre='bartlett';
    % recherche de la puissance de 2 sup�rieure � la taille de la fen�tre
    % pour d�finir le nbre de point sur lequel on calcule les TF
    np2=nextpow2(LBart);
    ntfr=pow2(np2);
    % spectre th�orique complet entre 0 et 0.5
    [H,fth]=freqz(b,a,ntfr/2,1);
    H2=abs(H).^2;
    Gth=10*log10(H2);
    % calcul de la version biais�e
    % Gth convolu� par la TF de la fen�tre
    % on calcule le produit en temps puis on revient en fr�quence
    %
    % �laboration du vecteur de la DSPM entre 0 et 1
    spth=[H2;0;flipud(H2(2:ntfr/2))]; 
    % calcul de son ant�c�dent en temps
    tspth=real(ifft(spth)); 
    % calcul de la fen�tre paire de Bartlett
    eval(['wQ=',fenetre,'(LBart);']);
    % positionnement correct entre t=0 et  
    wBQ=[wQ(Q:2*Q-1);zeros(ntfr-LBart,1);wQ(1:Q-1)];
    % multiplication des deux s�quences en temps
    z=tspth.*wBQ;
    % retour en fr�quence entre 0 et 1
    Gbiais=real(fft(z));
    % limitation entre 0 et 0,5 et mise en dB
    Gbiais=10*log10(Gbiais(1:length(Gbiais)/2));
end
if strcmp(method,'welch')
    Lf=Q;
    % recherche de la puissance de 2 sup�rieure � la taille de la fen�tre
    % pour d�finir le nbre de point sur lequel on calcule les TF
    np2=nextpow2(Lf);
    nfft=pow2(np2);
    [h,fth]=freqz(b,a,nfft,1);
    mag2=abs(h).^2;
    Gth=10*log10(mag2);
    % calcul du spectre th�orique biais�
    % spectre th�orique complet
    spth=[mag2;0;flipud(mag2(2:nfft))]; 
    tspth=real(ifft(spth)); % son ant�c�dent en temps
    %calcul de la fen�tre
    eval(['wf=',fenetre,'(Lf);']);
    % calcul de la TF de la fen�tre
    Hf=fft(wf,2*nfft);
    P=(abs(Hf).^2)/sum(wf.*wf);
    p=ifft(P);
    % multiplication des deux s�quences en temps
    z=tspth.*real(p);
    % retour en fr�quence
    spconv=real(fft(z));
    Gbiais=10*log10(spconv(1:length(spconv)/2));
end
    
    