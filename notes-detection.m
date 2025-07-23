% Define musical note frequencies and names
noteFrequencies = [ ...
    130.81, 138.59, 146.83, 155.56, 164.81, 174.61, 185.00, 196.00, 207.65, 220.00, 233.08, 246.94, ... % 3rd octave
    261.63, 277.18, 293.66, 311.13, 329.63, 349.23, 369.99, 392.00, 415.30, 440.00, 466.16, 493.88, ... % 4th octave
    523.25, 554.37, 587.33, 622.25, 659.25, 698.46, 739.99, 783.99, 830.61, 880.00, 932.33, 987.77, ... % 5th octave
    1046.50, 1108.73, 1174.66, 1244.51, 1318.51, 1396.91, 1480.00, 1567.98, 1661.22, 1760.00, 1864.66, 1975.53]; % 6th octave

noteNames = { ...
    'C3', 'C#3', 'D3', 'D#3', 'E3', 'F3', 'F#3', 'G3', 'G#3', 'A3', 'A#3', 'B3', ...
    'C4', 'C#4', 'D4', 'D#4', 'E4', 'F4', 'F#4', 'G4', 'G#4', 'A4', 'A#4', 'B4', ...
    'C5', 'C#5', 'D5', 'D#5', 'E5', 'F5', 'F#5', 'G5', 'G#5', 'A5', 'A#5', 'B5', ...
    'C6', 'C#6', 'D6', 'D#6', 'E6', 'F6', 'F#6', 'G6', 'G#6', 'A6', 'A#6', 'B6'};

% Load the audio file
[audioData, fs] = audioread("C:\Users\shash\Desktop\College Files\Sem 5\DSP\Audio files\Happy_birthday.wav");

% Convert stereo to mono if necessary
if size(audioData, 2) > 1
    audioData = mean(audioData, 2);
end

% Apply Bandpass Filter to the signal (80 Hz - 1200 Hz)
lowCutoff = 80;   % Hz (lower bound of human vocal range)
highCutoff = 1200; % Hz (upper bound for typical musical notes)
[b, a] = butter(2, [lowCutoff, highCutoff] / (fs / 2), 'bandpass'); % 2nd-order Butterworth filter
filteredSignal = filter(b, a, audioData);

% Detect major peaks in the filtered time-domain signal
[peaks, locs] = findpeaks(filteredSignal, 'MinPeakProminence', 0.05);  % You can adjust this threshold value

% Parameters for segment processing
detectedNotes = {};
peakTimes = locs / fs; % Times corresponding to the detected peaks

% Process each detected peak
for i = 1:length(locs)
    % Define a small segment around the peak for analysis
    peakIdx = locs(i);
    startIdx = max(1, peakIdx - round(0.025 * fs)); % 25ms window before peak
    endIdx = min(length(filteredSignal), peakIdx + round(0.025 * fs)); % 25ms window after peak
    segment = filteredSignal(startIdx:endIdx);

    % Compute FFT for the segment
    fftResult = fft(segment);
    fftMagnitude = abs(fftResult(1:floor(length(segment) / 2))); % Positive frequencies only
    freqAxis = (0:floor(length(segment) / 2) - 1) * (fs / length(segment));

    % Limit frequency range to fundamental range (50 Hz - 1500 Hz)
    validFreqRange = freqAxis >= 50 & freqAxis <= 1500;
    fftMagnitude = fftMagnitude(validFreqRange);
    freqAxis = freqAxis(validFreqRange);

    % Find the peak frequency (fundamental)
    [~, peakFreqIdx] = max(fftMagnitude);
    peakFreq = freqAxis(peakFreqIdx);

    % Map the frequency to the closest note
    [~, noteIdx] = min(abs(noteFrequencies - peakFreq));
    detectedNotes{i} = noteNames{noteIdx};
end

% Eliminate redundant notes
uniqueNotes = {};
uniqueTimes = [];
timeThreshold = 0.75; % Increased to 0.1 seconds for longer intervals

for i = 1:length(detectedNotes)
    if isempty(uniqueNotes) || ...
            (~strcmp(detectedNotes{i}, uniqueNotes{end}) || (peakTimes(i) - uniqueTimes(end) > timeThreshold))
        % Add the note if it's different from the last or outside the time threshold
        uniqueNotes{end+1} = detectedNotes{i};
        uniqueTimes(end+1) = peakTimes(i);
    end
end

% Plot the detected notes over time (only one unique note per time instant)
figure;
stem(uniqueTimes, cellfun(@(x) find(strcmp(noteNames, x)), uniqueNotes), 'filled');
xlabel('Time (s)');
ylabel('Notes');
yticks(1:length(noteNames));
yticklabels(noteNames);
title('Unique Detected Notes Over Time');
grid on;

% Display detected notes
disp('Detected Unique Notes:');
disp(uniqueNotes);
