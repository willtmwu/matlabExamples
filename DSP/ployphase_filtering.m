% A HP filter window design criteria
% Fs = 24kHz, Fc = 150Hz, Ft = 100Hz, A = 70dB
% 150Hz (1dB down) and 70dB at 250Hz
% N = 1037 (initial estimation)
% L = 6.5 ~ 6 (initial estimation)

clear;
fc = 150;
fa = 250;
fs = 24000;
fftWindow = 65536;

N = 1051;
L = 7;

odd = mod(N,2); % check if odd or even
even = not(odd);

figure(1);
V = zeros(N,1);
V(1:L+even)= ones(L+even,1);
V(N-L+1:N)=ones(L,1);
scaledXAxis=fs*[0:N-1]/N; %Scaled Axis

clf;
subplot(3,2,1);
plot(scaledXAxis,V); title('Desired Response V');

subplot(3,2,2);
v=fftshift(real(ifft(V)));
plot(v); title('Unwindowed Desired Filter Impulse response');

subplot(3,2,3);
scaledXfftAxis=fs*[0:(fftWindow - 1)]/fftWindow;
plot(scaledXfftAxis,20*log10(abs(fft(v,fftWindow))));title('Unwindowed Desired Freq response');

subplot(3,2,4);
KWindow=kaiser(N+even,6.75526);
plot(KWindow); title('Kaiser Window beta=6.75526');

subplot(3,2,5);
finalFilter=v.*KWindow(1:N);
plot(finalFilter); title('Windowed Filter Impulse Response');

subplot(3,2,6);
plot(scaledXfftAxis,20*log10(abs(fft(finalFilter,fftWindow)))); title('Windowed Freq response');

figure(2);
f1 = 50;
f2 = 100;
f3 = 1000;
f4 = 1100;
dwnFactor = 60;
n = [-10 : 1/fs : 10];
originalSig = sin(2*pi*f1*n) + sin(2*pi*f2*n) + sin(2*pi*f3*n) + sin(2*pi*f4*n);

subplot(2,2,1);
plot(scaledXfftAxis,20*log10(abs(fft(originalSig,fftWindow)))); title('Freq Original Signal');

subplot(2,2,2);
filteredSig = conv(originalSig,finalFilter);
plot(scaledXfftAxis,20*log10(abs(fft(filteredSig,fftWindow)))); title('Freq Filtered Signal');

subplot(2,2,3);
filteredSig = filteredSig(length(finalFilter):end - length(finalFilter)); %Removing original stuff start and end of vector
downedSig = downsample(filteredSig, dwnFactor);
axisXDwnSampled = 400*[0:(fftWindow-1)]/fftWindow;
plot(axisXDwnSampled, 20*log10(abs(fft(downedSig,fftWindow)))); title('Freq Filtered Downsampled');

subplot(2,2,4);
polyFilter = finalFilter;
polyFilter(end: end+ dwnFactor - mod(length(finalFilter), dwnFactor)) = 0;
polyFilterMatr = flipud(reshape(polyFilter, dwnFactor, length(polyFilter)/dwnFactor));

originalPolySig = originalSig;
originalPolySig(end: end+ dwnFactor - mod(length(originalSig), dwnFactor)) = 0;
originalPolySigMatr = reshape(originalPolySig, dwnFactor, length(originalPolySig)/dwnFactor);

finalDownedSig = conv( originalPolySigMatr(1,:), polyFilterMatr(1,:) );
for i=2:60,
finalDownedSig = finalDownedSig + conv( originalPolySigMatr(i,:), polyFilterMatr(i,:) );
end
plot(axisXDwnSampled, 20*log10(abs(fft(finalDownedSig,fftWindow)))); title('Freq Filtered Downsampled Poly');


figure(3);
%--Upsample to return to original
subplot(2,1,1);
finalUpedSig = upsample(conv(finalDownedSig, polyFilterMatr(1,:)), dwnFactor, dwnFactor-1);
for j=2:60,
	finalUpedSig = finalUpedSig + upsample(conv(finalDownedSig, polyFilterMatr(j,:)), dwnFactor, dwnFactor-j);
end
plot(scaledXfftAxis,20*log10(abs(fft(finalUpedSig,fftWindow)))); title('Reconstructed Filtered Signal');

subplot(2,1,2);
fShift = 4000;
finalUpedShift = upsample(conv(finalDownedSig, polyFilterMatr(1,:)), dwnFactor, dwnFactor-1);
for k=2:60;
	finalUpedShift = finalUpedShift + upsample(conv(finalDownedSig, polyFilterMatr(k,:)), dwnFactor, dwnFactor-k)*cos(2*pi*(k-1)*fShift/fs);
end
plot(scaledXfftAxis,20*log10(abs(fft(finalUpedShift,fftWindow)))); title('Reconstructed Filtered Signal');