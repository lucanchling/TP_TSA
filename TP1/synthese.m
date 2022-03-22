function [x1,x2,x3,a,b] = synthese(N,B,m3,sigma3,Fs)
    fc = B;
    x1 = randn(1,N);
    m = 8;
    [b,a] = butter(m,fc/(Fs/2));
    x2  = filter(b,a,x1);
    x3 = ((x2-mean(x2))/std(x2))*sigma3+m3;
end
