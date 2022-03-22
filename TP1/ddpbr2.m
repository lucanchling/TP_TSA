function ddpbr2(ecartype,N);
% function ddpbr2(ecartype,N);
% estimation de la densit� de probabilit� d'un bruit gaussien 
% de moyenne nulle et �lev� au carr�
%
% variables d'entr�e
%	ecartype �cart-type du bruit
%	N nombre de points (doit �tre sup�rieure � 500)
% 
% le bruit de d�part a une bande de 2000 Hz et est �chantillonn� � 10 KHz
% on affiche 
%	400 points de bruit �lev� au carr�
%	la ddp estim�e
%	la ddp th�orique en fonction de l'�cart-type choisi

if N<500
	disp('Nombre de points trop faible');
end;
if N>=500
	% g�n�ration du bruit gaussien
	br0=randn(1,N);
	% filtrage du bruit pour le consigner dans une bande donn�e
	ord=buttord(2*0.2,2*0.25,1,40);
	[b,a]=butter(ord,2*0.2);
	br1=filter(b,a,br0);
	br=br1*ecartype/sqrt(2*0.2);
	br2=br.*br;
	% calcul de l'histogramme
	pas=((3*ecartype)^2)/50;
	x=0:pas:51*pas;
	[Nbre,y]=hist(br2,x);
	clf
	t=(0:399)/10;
	subplot(2,1,1),plot(t,br2(101:500))
	title(['400 points de bruit gaussien eleve au carre de moyenne 0',...
		' et d''ecart-type ',num2str(ecartype)])
	set(gca,'XLim',[0 399]/10,'YLim',[0 1.1*max(br2(101:500))])
	xlabel('millisecondes')
	ddpest=Nbre/N/pas;
	z=pas/2:pas/2:51*pas;
	ecarg=ecartype;
	g=exp(-z/2/ecarg/ecarg)./sqrt(2*pi*z)/ecarg;
	lon=length(x)-1;
	subplot(2,1,2),stem(x(1:lon),ddpest(1:lon))
	title(['ddp estimee avec ',sprintf('%6.0f',N),' points et ddp theorique'])
	xlabel('amplitude');
	set(gca,'XLim',[x(1)-pas x(length(x))],'YLim',[0 1.1*max(ddpest)])
	hold on
	subplot(2,1,2),plot(z,g,'c')
	hold off

	%imprime;
end;
