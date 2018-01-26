# Computer Assignment 5: Discrete Time Filters
## Overview
This assignment was based around discrete time (FIR and IIR) filters. The first part of this assignment deals mostly with adding echoes to various audio clips. The second part involves removing vocals from an audio clip of Mariah Carey's Emotion.

## Echoes
All code for echos produced can be found in `MatthewMancusoCA5Echos.m` and the dependent function. Multiple types of echoes can be produced by messing with the parameters, such as stereo echos, IIR echoes and FIR echos.

## Vocal Reduction
All code for vocal reduction can be found in `MatthewMancusoCA5ExtraCredit.m`. Running the script produces a window which can be used to play/pause the audio and view the seekbar superimposed on the spectrogram. Additionally, the vocal reduction filter can be toggled on and off in real time with the center button.

## Results
The results related to echoes are as follows:
* `Results/FIRandIIRecho.png` - compares FIR to IIR echoes of the `beep` audio data
* `Results/FIREcho.png` - shows FIR echoed `beep` along with original data subtracted from filtered data to see the actual diffrence
* `Results/IIRaGT1.png` - shows what happens when the amplitude of the echo is greater than 1 for an IIR echo (exponential growth)
* `Results/step6.wav` - reverb effect produced by using IIR filter with delay of 0.1 seconds and amplitude of 0.33
* `Results/step7.wav` - stereo angle effect produced by using FIR filter with delay of 0.008 seconds and amplitude of 1

## Disclaimer
The `myFFT()` function used in this code was developed by my professor, Dr. Obeid—not myself. It is a convenience wrapper built around MATLAB's FFT function.
