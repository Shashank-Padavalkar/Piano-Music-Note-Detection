# Piano Music Note Detection using Digital Signal Processing

This project implements a digital signal processing (DSP) system to automatically detect and classify **piano notes** from musical audio. It extracts musical parameters such as **note name**, **octave**, **frequency**, and **timing**, and generates a time-aligned **music chart**. The project aims to support music learners, educators, and analysis tools through accurate and efficient audio-to-note conversion.

---

## 1. Problem Statement

Manual identification of piano notes from audio is difficult and time-consuming, especially for beginners. This project proposes an automated DSP-based system that:
- Analyzes audio input
- Detects and classifies notes
- Filters out noise
- Maps frequencies to musical notation

The system enhances music learning, analysis, and transcription by enabling fast and accurate note recognition from raw audio.

---

## 2. Dataset and Signal Parameters

- **Audio Duration**: ~60 seconds per sample
- **Sampling Rate**: 48,000 Hz
- **Amplitude Range**: +0.26312 to -0.24771
- **Frequency Range**: 15 Hz to 8000 Hz
- **Source**: Custom recordings + publicly available datasets (e.g., MAESTRO, YouTube)
- **Dataset Link**: [Google Drive](https://drive.google.com/drive/folders/1NktWTptHznOxpNwXWqVoufSPfa8u4luF?usp=drive_link)

---

## 3. Signal Processing Techniques

### 3.1 Discrete Fourier Transform (DFT)
- Converts time-domain audio to the frequency domain
- Computation time: ~839 seconds (67,200 samples)

### 3.2 Fast Fourier Transform (FFT)
- Efficient implementation of DFT
- Computation time: ~0.038 seconds (2.9M samples)
- Suitable for real-time analysis

### 3.3 Short-Time Fourier Transform (STFT)
- Time-localized frequency detection
- Spectrogram visualization
- Computation time: ~0.048 seconds (2.9M samples)

---

## 4. Filter Design and Noise Reduction

The system includes a digital bandpass filter to isolate piano note frequencies and reduce noise.

### Filter Parameters
- **Passband**: 27 Hz (A0) to 4186 Hz (C8)
- **Passband Ripple**: 1 dB
- **Stopband Attenuation**: 60 dB
- **Sampling Rate**: 48,000 Hz

### Filter Types Explored
- IIR Butterworth (N=39)
- FIR (Hamming, Hanning, Rectangular)
- IIR Chebyshev

Filtering enhances clarity by suppressing irrelevant frequencies and focusing on the musical range of a piano.

---

## 5. Methodology

### Stage 1: Data Acquisition
- Audio files recorded or collected from datasets
- Converted to mono and normalized

### Stage 2: Processing
- Apply filters to suppress noise
- Use FFT and STFT for spectral analysis

### Stage 3: Note Detection
- Extract dominant frequencies
- Map to standard piano note frequencies
- Generate music chart with note name, octave, frequency, and timestamp

---

## 6. Results and Analysis

- **FFT Output**: Accurately isolates dominant frequencies
- **STFT Output**: Captures frequency variations over time
- **Filtering Impact**: Clear separation between musical content and noise

### Example Output
- Note Detected: C4  
- Frequency: 261.63 Hz  
- Time: 12.3 s  
- Octave: 4

Visual plots and spectrograms illustrate the accuracy and clarity of the extracted notes.
