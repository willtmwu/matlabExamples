X = [-5:1/40:5];
Y1 = sin(2*pi*8*X);
Y1 = upsample(Y1,5);
subplot(2,1,1);
stem(Y1);
S = [-5:1/5:5];
Y2 = sinc(S);
subplot(2,1,2);
stem(conv(Y1,Y2));