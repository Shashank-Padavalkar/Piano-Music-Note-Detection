%HANNING
% Given Parameters
Fs = 48000;       % Sampling Frequency (Hz)
f_cutoff = 4186;  % Cutoff Frequency (Hz) - Highest note (C8)
A_pass = 1;       % Passband Gain (dB) (not used for FIR)
A_stop = 60;      % Stopband Gain (dB) (not used for FIR)

% Normalize cutoff frequency to Nyquist frequency
Wn_cutoff = f_cutoff / (Fs / 2);

% Define transition width and estimate filter order
trans_width = Wn_cutoff; % Since low-pass, we only have one edge
M = ceil(6.6 / trans_width); % Estimate filter order using empirical formula
if mod(M, 2) == 0
    M = M + 1; % Ensure filter order is odd for symmetry
end

% Design the low-pass FIR filter using Hanning window
b_hanning = fir1(M-1, Wn_cutoff, 'low', hanning(M));
a = 1; % FIR filter denominator coefficients

% Display the filter order
disp(['Calculated filter order M: ', num2str(M)]);

% Load the audio file (example file path)
[audioData, ~] = audioread("C:\Users\shash\Desktop\College Files\Sem 5\DSP\Audio files\Happy_birthday.wav");

% Convert stereo to mono if necessary
if size(audioData, 2) > 1
    audioData = mean(audioData, 2);
end

% Apply the FIR low-pass filter to the signal using Hanning window
filteredSignal_hanning = filter(b_hanning, a, audioData);

% Signal duration for plotting
signalDuration = (0:length(audioData)-1) / Fs;

% Plot the time-domain signal before and after filtering
figure;
subplot(3, 1, 1);
plot(signalDuration, audioData);
xlim([0, length(audioData) / Fs]);
xlabel('Time (s)');
ylabel('Amplitude');
title('Input Signal ');
grid on;

subplot(3, 1, 2);
plot(signalDuration, filteredSignal_hanning);
xlim([0, length(audioData) / Fs]);
xlabel('Time (s)');
ylabel('Amplitude');
title('Hanning Window');
grid on;

% Plot the output signal in time domain after filtering with Hanning window
subplot(3, 1, 3);
plot(signalDuration, filteredSignal_hanning);
xlim([0, length(filteredSignal_hanning) / Fs]);
xlabel('Time (s)');
ylabel('Amplitude');
title('Output Signal');
grid on;

% Plot the frequency response of the filter (Hanning Window)
[H_hanning, Freq] = freqz(b_hanning, a, 1024, Fs);
figure;
plot(Freq, 20*log10(abs(H_hanning)));
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
title('Frequency Response of the FIR Low-Pass Filter (Hanning Window)');
grid on;
xlim([0, Fs/2]); % Nyquist rate

% Compute and plot FFT of the signal before and after filtering
fftOriginal = fftshift(fft(audioData));
fftFiltered_hanning = fftshift(fft(filteredSignal_hanning));
freqAxis = (-length(audioData)/2:length(audioData)/2-1)*(Fs/length(audioData));

% Plot the frequency spectrum of the input and output signals
figure;
subplot(2, 1, 1);
plot(freqAxis, abs(fftOriginal));
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('FFT of Original Signal');
grid on;

subplot(2, 1, 2);
plot(freqAxis, abs(fftFiltered_hanning));
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('FFT of Filtered Signal (Hanning Window)');
grid on;
