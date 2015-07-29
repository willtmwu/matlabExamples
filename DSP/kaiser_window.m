% A HP filter window design criteria
% Fs = 10Khz, Fc = 2.5kHz, Ft = 0.5kHz, A = 60dB
% 2.5kHz (1dB down) and 60dB at 2kHz
% N = 73.49 (initial estimation)
% L = 18.25 (initial estimation)
fc = 2500;
fa = 2000;
fs = 10000;

N = 73;
L = 18;

odd = mod(N,2); % check if odd or even
even = not(odd);

V = ones(N,1);
V(1:L+even) = zeros(L+even,1);
V(N-L+1:N) =zeros(L,1);
x=fs*[0:N-1]/N;
clf;

subplot(4,2,1);
plot(x,V); title('Desired Response V');
v=fftshift(real(ifft(V)));

subplot(4,2,2);
plot(v); title('Unwindowed Filter Impulse response');
x=fs*[0:511]/512;

subplot(4,2,3);
plot(x,20*log10(abs(fft(v,512))));title('Unwindowed Freq response');
w=kaiser(N+even,5.65);

subplot(4,2,4);
plot(w); title('Kaiser Window beta=5.65');
f=v.*w(1:N);

subplot(4,2,5);
plot(f); title('Windowed Filter Impulse Response');

subplot(4,2,6);
plot(x,20*log10(abs(fft(f,512)))); title('Windowed Freq response');
grid;

s1 = (fa/(fs/2));
s2 = (fc/(fs/2));
Q=remez(N,[0 s1 s2 1],[0 0 1 1], 'h');

subplot(4,2,7);
plot(Q); title('Optimal Impulse Response');
x=[0:511]*fs/512;

subplot(4,2,8);
plot(x,20*log10(abs(fft(Q,512)))); title('Optimal HP Filter');