function [ddp,ci,xout,deltax] = histogramme(x,N)
    sigma = std(x);
    mu = mean(x);
    
    deltax = 3.49*sigma*(N^(-1/3));
    ci = min(x)+(deltax/2):deltax:max(x)-(deltax/2);
    
    figure()
    subplot 211
    stem(x)
    title('Signal x');
    [ddp,xout] = hist(x,ci);
    subplot 212
    bar(xout,ddp/(N*deltax));
    title('ddp de x')
    text(max(xout)/1.5,max(ddp/(N*deltax))/2,['\Deltax = ',num2str(deltax)])
    text(max(xout)/1.5,max(ddp/(N*deltax))/3,['\sigmax = ',num2str(sigma)])
end