function ddpbr2f(ecartype,N);%2008
clf
% function ddpbr2f(ecartype,N)
% estimation de la densit� de probabilit� d'un bruit gaussien de moyenne nulle
%	�lev� au carr� et filtr� passe-bas
%
% variables d'entr�e
%	ecartype �cart-type du bruit
%	N nombre de points (doit �tre sup�rieure � 2500)
% 
% le bruit de d�part a une bande de 2000 Hz et est �chantillonn� � 10 KHz
%
% on choisit en cours de programme la fr�quence de coupure du filtre passe-bas
%
% on affiche d'abord 
%	400 points du bruit
%	400 points du bruit �l�v� au carr�
% puis on choisit la fr�quence de coupure du filtre passe-bas
% on affiche
%	la densit� spectrale du bruit �lev� au carr�
%	et le gain complexe du filtre passe-bas choisi
% puis
%	le bruit �lev� au carr� filtr� passe-bas
%	et la ddp estim�e

if N<2500
	disp('Nombre de points trop faible : il faut plus de 2500 points');
end;
if (N>=2500)
	fe=1e4;			% fr�quence d'�chantillonnage
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% g�n�ration du bruit de d�part
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	Nplus=1000;		% Nbre de pts � rajouter pour �tre en r�gime permanent
	br0=randn(1,N+Nplus);	% apr�s filtrage
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% filtrage du bruit pour le consigner dans une bande donn�e
	% ici 2000 Hz pour un bruit �chantillonn� � 10 KHz
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	[b,a]=butter(12,2*0.20);
	br1=filter(b,a,br0);
	clear br0
	br=br1*ecartype/sqrt(2*0.20);
	clear br1
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% affichage de 400 points de bruit et de sa version �lev�e au carr�
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	figure(1)%%%%%%%%%%%%%%%%%%%%%%figure1
	t=(0:399)/fe;
	subplot(3,1,1),plot(t,br(Nplus+1:Nplus+400))
	title(['400 pts de bruit gaussien centr� de bande 2000 Hz d''�cart-type ',num2str(ecartype)])
	set(gca,'Xlim',[0 t(400)],'YLim',[min(br) max(br)])
	br2=br.*br;
	clear br
	subplot(3,1,2),plot(t,br2(Nplus+1:Nplus+400))
	title('le m�me bruit �lev� au carr�')
	set(gca,'Xlim',[0 t(400)],'YLim',[min(br2) max(br2)])
	pause
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
	% choix du filtre
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	chnup=1;
    
	while chnup~=5
		chnup=menu('Fr�quence de coupure du filtre int�grateur','1000 Hz','500 Hz',...
			'200 Hz','50 Hz','fin');
		
		if chnup==1
			fp=1000/fe;	% fr�quence de coupure
			fs=1700/fe;	% limite de la bande de transition
			orpb=9;		% ordre du filtre
		end;
		if chnup==2
			fp=500/fe;
			fs=900/fe;
			orpb=9;
		end;
		if chnup==3
			fp=200/fe;
			fs=360/fe;
			orpb=9;
		end;
		if chnup==4
			fp=50/fe;
			fs=100/fe;
			orpb=8;
		end;
		if (chnup>0)&(chnup<5)
			load dsp.mat 	% contient une dsp de br2 calcul�e sur 32818 pts 
			sp2=sp*(ecartype^4);
			figure(2)%%%%%%%%%%%%%%%%figure 2
			subplot(2,1,1),plot(nu,sp2)
			title(['densit� spectrale du bruit d''�cart-type ',num2str(ecartype),...
			' �lev� au carr�'])
			xlabel('Hz')
			set(gca,'Xlim',[0 nu(length(nu))],'YLim',[0 1.1*max(sp2)])
			% construction du filtre (passe-bas );
			[bb,ab]=butter(orpb,2*fp);
			[hpb,w]=freqz(bb,ab,256,fe);
			subplot(2,1,2),plot(w,abs(hpb))
			title(['|H(nu)| fr�quence de coupure ',sprintf('%4.0f',fp*fe),' Hz'])
			xlabel('Hz')
			set(gca,'Xlim',[0 w(length(w))],'YLim',[0 1.1*max(abs(hpb))])
			clear nu sp sp2 hpb w
			pause
			brf=filter(bb,ab,br2);
			y=brf(Nplus:N+Nplus);
			lg=length(y);
			figure(1)%%%%%%%%%%%%%%%
            subplot(3,1,3),plot(t,y(1:400))
			title(['bruit �lev� au carr� filtr� passe-bas � ',sprintf('%4.0f',fp*fe),' Hz'])
			xlabel('secondes')
			[ormin,ormax]=tracord(y);
			set(gca,'Xlim',[0 t(400)],'YLim',[ormin ormax])
			pause
			clear brf
			pas=(max(y)-min(y))/30;
			kmin=fix(min(y)/pas)-1;
			kmax=fix(max(y)/pas)+1;
			x=(kmin:kmax)*pas;
			[Nbre,x]=hist(y,x);
			figure(3),clf%%%%%%%%%%%%%%%figure44444444444444444
			ddpest=Nbre/N/pas;
			subplot(2,1,1),plot((0:lg-1)/fe,y(1:lg))
			title(['(bruit)2 filtr� passe-bas � ',sprintf('%4.0f',fp*fe),' Hz    �cart-type du bruit :',...
			num2str(ecartype)])
			set(gca,'Xlim',[0 lg/fe],'YLim',[ormin ormax])
			xlabel('secondes')
			subplot(2,1,2),stem(x,ddpest)
			title(['ddp estim�e avec ',sprintf('%6.0f',N),' points'])
			xlabel('amplitude');
			set(gca,'XLim',[x(1)-pas x(length(x))+pas],'YLim',[0 1.1*max(ddpest)])
			%pause
			%imprime;
		end; 		%if (chnup>0)&(chnup<5)
        end;        %while chnup~=5

	end; 
    close(gcf)
    close(gcf)
    close(gcf)
    

