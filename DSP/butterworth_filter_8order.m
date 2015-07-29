clear;
order = 8; % Filter Order (Butterworth)
cutoff = 2000; % Cut-off frequency (2kHz)
sampling_rate = 10000; % Sampling Rate 10kHz
bit_rate = 16; % N-bit quantisation error, default 16-bit

% Butterworth filter, using normalised cutoff frequency with fs/2, where fs is sampling rate
[zeros, poles] = butter(order, cutoff/(sampling_rate/2));

figure(1);
subplot(2,2,1); % Pole-Zero Plot
zplane(zeros, poles); title('8th Order');

subplot(2,2,2); % Normalised frequency plot
[mag_freq, ang_freq] = freqz(zeros, poles);
plot([0:length(mag_freq)-1]/(length(mag_freq)-1), 20*log(abs(mag_freq)) );
title('8th Order Frequency');

subplot(2,2,3); % Introduce quantisation errors
max_zero = max(abs(zeros));
zeros_quant = zeros/max_zero; % Scale down to 0-1
zeros_quant = zeros_quant*(2^(bit_rate-1));
zeros_quant = floor(zeros_quant); % Truncate the fractional part by flooring
zeros_quant = zeros_quant/(2^(bit_rate-1)); %Renormalise
max_zero_quant = max(abs(zeros_quant));
zeros_quant = zeros_quant/max_zero_quant;

max_poles = max(abs(poles));
poles_quant = poles/max_poles;
poles_quant = poles_quant*(2^(bit_rate-1));
poles_quant = floor(poles_quant);
poles_quant = poles_quant/(2^(bit_rate-1));
max_poles_quant = max(abs(poles_quant));
poles_quant = poles_quant/max_poles_quant;

% Poles-zero plot of filter with quantisation error
zplane(zeros_quant, poles_quant); title('8th Order Quantised');

subplot(2,2,4); %
[mag_freq_quant, ang_freq_quant] = freqz(zeros_quant, poles_quant);
plot([0:length(mag_freq_quant)-1]/(length(mag_freq_quant)-1));
20*log(abs(mag_freq_quant));
title('8th Order Quantised Frequency');