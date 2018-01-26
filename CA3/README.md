# Computer Assignment 3: Demodulating AM and FM Data
## Important
The following file must be downloaded in addition to the files listed here to run the code:
[ca3_FM_Data.m](https://drive.google.com/file/d/1XIZ1wWOjZ5APeAmpKdg4Udy5pN8l8i4j/view?usp=sharing).

This file is too large to be uploaded to GitHub.

## Overview
The assignment here was to decode AM and FM data. AM and FM signals both operate by varying the signal of a carrier signal. AM (Amplitude Modulation) varies the amplitude of the carrier signal, while FM (Frequency Modulation) varies the frequency of the carrier.

This assignment was mainly an exercise in convolution, though some other techniques were used to automate the demodulation.

The entry-point to this project is `MatthewMancusoCA3.m`. From there, it will carry out AM demodulation on three signals transmitted at the same time (found in `ca3_AM_Data.m`) and FM demodulation on one signal found in `ca3_FM_Data.m`.

## AM Demodulation
The specifics for the AM demodulation can be found in `decodeAMSignals.m`. The code first extracts the carrier frequencies from the data (`getDetectedFrequencies.m`). It does this by using `findpeaks()`, applying thresholds, and averaging the sidebands. These carriers and their sidebands can be seen in `Results/OriginalAMFT.png`.

Once carrier frequencies have been determined, the main function can take over and extract each individual signal by multiplying the entire signal by the a cosine at each of the (three) frequencies—effectively shifting each of the carrier signals into the audible range. A filter was then applied to each of the shifted signals to cut out the other carriers.

The filter design for this part was crucial to create (relatively) decent audio. Because the original audio was poorly filtered (likely by design of the instructor) before being shifted into the carrier signal, the signal at 55kHz contained some unwanted noise from the signal at 80kHz (once again, see `Results/OriginalAMFT.png`).

Note: the second audio clip produced in the AM demodulation (at 55kHz) is incorrect. The `getDetectedFrequencies.m` code extracted the wrong frequency for this carrier, and thus produced a low-pitched version of *Ave Maria*.

## FM Demodulation
The `ca3_FM_Data.m` file (available for download above) contains audio data which has been frequency modulated. It only contains one FM signal, however, making demodulation fairly trivial.

Since only one signal is available, the original audio could be extracted by simply taking the derivative of the signal and applying an envelope detector to the upper half of it, and shifting that envelope down to the x-axis. Once scaled and resampled, the signal becomes audible. Exact details can be found in `decodeFMSignals.m`.

## Results
FFT examples for the AM demodulation can be found at:
* `Results/OriginalAMFT.png` – the original AM data Fourier Transform
* `Results/SmoothAMFT.png` – the smoothed AM data Fourier Transform for peak detection
* `Results/FTOrigAndShifted.png` – an example of shifted AM data compared to the original

The resultant audio may be heard by downloading the files and running the script.

## Disclaimer
The myFFT() function used in this code was developed by my professor, Dr. Obeid—not myself. It is a convenience wrapper built around MATLAB's FFT function.
