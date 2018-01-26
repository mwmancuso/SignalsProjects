# Computer Assignment 2: Phone Number Decoding
## Overview
The goal of this assignment was to decode dialed phone numbers (albeit recorded for use in MATLAB). Using preliminary knowledge about DTMF tones (i.e. each digit is the sum of two distinct consines), a Fourier Transform could be used to determine which two frequencies were being transmitted, and from that the digit could be extracted.

The entry-point to this project is `MatthewMancusoCA2.m`.

From there, the function calls `decodePhoneNumber.m` on two files—one a `.wav` file and the other a `.mat`. The `.mat` file is a compressed audio file, which can be decompressed with the code from CA1—conveniently packaged in `decompressAudio.m`.

## Algorithm
The process to extracting the phone number is as follows:
1. Take one 50ms window of data
2. Run a Fourier Transform on it using `myFFT()`
3. Use `findpeaks()` to get the two strongest frequencies, if any
4. Compare those frequencies to known DTMF frequencies
5. If the two frequencies correspond to a DTMF row and column, find the digit
6. If the number was different than the number from the last window (which could be null), record the digit
7. Repeat until no more data exists

## Results
The phone numbers recorded are augmented over their respective audio graphs in `Results/phone1.png` and `Results/phone2.png`. The highest two detected frequencies are also continuously plotted in the middle graphs—you can see that digits 1, 2 and 3 are part of the same row, as their lower frequencies are all on the same line.

Fourier Transform results are also plotted for a few of the digits to understand what the determinant audio contents are.

## Disclaimer
The `myFFT()` function used in this code was developed by my professor, Dr. Obeid—not myself. It is a convenience wrapper built around MATLAB's FFT function.
