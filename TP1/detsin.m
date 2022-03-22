function detsin(M,ssb)
% function detsin(M,ssb)
%
% detection d'un signal periodique dans un bruit 
%	le signal est un signal sinusoedal de frequence 227 Hz a phase equipartie
%	le bruit un bruit blanc gaussien centre filtre dans la bande 150-300 Hz
% on dispose d'un signal de reference periodique de meme periode que le signal
% 
% le tout est echantillonne a 1 KHz
%
% variables d'entree
% 	M : nombre de points (> 100)
%	ssb : rapport signal sur bruit en dB (< 20 dB)
%
% on affiche le melange signal + bruit
%	     le signal de reference
% 	puis l'autocorrelation estimee du melange signal+ bruit
%	     et l'intercorrelation estimee entre signal + bruit et reference 

nue=1000; %Hz
if (ssb<=20)&(ssb>=-20)&(M>100)
	% synthese du filtre
	[b,a]=butter(8,2*[0.15 0.3]);
	L=nextpow2(2*M-1);
	% generation du signal a phase equipartie
	phi=rand(1,1);
	sig=sin(2*pi*0.227*(0:M-1)+pi*phi);
	% generation de la reference
	ref=sin(2*pi*0.227*(0:M-1));
	% generation du bruit blanc de variance unite
	br=randn(1,M+150);
	% filtrage du bruit blanc
	brf=filter(b,a,br);
	clear br
	% suppression de 150 points dus au transitoire du filtre
	br=brf(151:M+150);
	sb=std(br);
	ss=std(sig);
	ssth=sb*(10^(ssb/20));
	gain=ssth/ss;
   %bs=gain*sig+br;
   bseul=br/gain;
   mbs=sig+br/gain;
	[minsig,maxsig]=tracord(mbs);
	clear brf
    abstrace=0:M-1; %donnera un trace en ms
    labelx='millisecondes';
    limx=[0 M-1];
    if M>10000 
        abstrace=abstrace/nue;
        labelx='secondes';
        limx=[0 M-1]/nue;
    end
    figure(1),subplot(2,1,1),plot(abstrace,bseul)
	set(gca,'XLim',limx,'YLim',[minsig maxsig])
	title(['signal recu - SIGNAL ABSENT'])
	xlabel(labelx)
    subplot(2,1,2),plot(abstrace,mbs)
	set(gca,'XLim',limx,'YLim',[minsig maxsig])
	title(['signal recu - SIGNAL PRESENT avec (S/B) = ',num2str(ssb),' dB'])
	xlabel(labelx)
% 	subplot(3,1,3),plot(abstrace,ref)
% 	set(gca,'XLim',limx,'YLim',[-1.1 1.1])
% 	title('signal de reference')
% 	xlabel('millisecondes')
	%pause
	tau=-100:100;
	cseul=xcorr(bseul,'biased');
	icseul=xcorr(bseul,ref,'biased');
    c=xcorr(mbs,'biased');
    %cm=[min(c) max(c)];
    [minc maxc]=tracord(c);
	ic=xcorr(mbs,ref,'biased');
    [minicseul maxicseul]=tracord(icseul);
    [minic maxic]=tracord(ic);
    a=maxic-maxicseul;
    b=minicseul-minic;
    if a>0
        a=maxic;
    else
        a=maxicseul;
    end;
    if b>0
        b=minic;
    else
        b=minicseul;
    end;
        
	figure(2),subplot(2,2,1),plot(tau,cseul(M-100:M+100))
	set(gca,'XLim',[tau(1) tau(length(tau))],'YLim',[minc maxc])
	title(['Autocorrelation estimee du signal recu - SIGNAL ABSENT '])
	xlabel('retards en millisecondes')
    subplot(2,2,2),plot(tau,c(M-100:M+100))
	set(gca,'XLim',[tau(1) tau(length(tau))],'YLim',[minc maxc])
	title(['Autocorrelation - SIGNAL PRESENT - (S/B) = ',num2str(ssb),...
		' dB - Duree du signal ',num2str(M-1),' ms'])
	xlabel('retards en millisecondes')
	subplot(2,2,3),plot(tau,icseul(M-100:M+100))
	set(gca,'XLim',[tau(1) tau(length(tau))],'YLim',[b a])
	title('Intercorrelation estimee entre signal recu et reference - SIGNAL ABSENT')
	xlabel('retards en millisecondes')
    subplot(2,2,4),plot(tau,ic(M-100:M+100))
	set(gca,'XLim',[tau(1) tau(length(tau))],'YLim',[b a])
	title('Intercorrelation estimee - SIGNAL PRESENT')
	xlabel('retards en millisecondes')
elseif ssb>20
	disp('rapport signal a bruit trop eleve')
elseif ssb<-20
    disp('rapport signal a bruit trop faible')
elseif M<=100
	disp('duree trop courte : doit etre superieure a 100 echantillons')
end;	
