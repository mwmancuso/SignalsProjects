# Signals Computer Assignments
MATLAB projects developed in Dr. Obeid's Signals class at Temple University. Computer Assignment 5 (CA5) is my favorite code.

## Computer Assignment 1 (CA1)
The goal of this assignment was to decompress pre-compressed data using the concept of the sum of cosines. The data was compressed by an algorithm invented by Dr. Obeid, my instructor.

## Computer Assignment 2 (CA2)
The goal of this assignment was to decode dialed phone numbers (albeit recorded for use in MATLAB). Using preliminary knowledge about DTMF tones (i.e. each digit is the sum of two distinct consines), a Fourier Transform could be used to determine which two frequencies were being transmitted, and from that the digit could be extracted.

The entry-point to this project is `MatthewMancusoCA2.m`.

From there, the function calls `decodePhoneNumber.m` on two files—one a `.wav` file and the other a `.mat`. The `.mat` file is a compressed audio file, which can be decompressed with the code from CA1—conveniently packaged in `decompressAudio.m`.

## Computer Assignment 3 (CA3)
The assignment here was to decode AM and FM data. AM and FM signals both operate by varying the signal of a carrier signal. AM (Amplitude Modulation) varies the amplitude of the carrier signal, while FM (Frequency Modulation) varies the frequency of the carrier.

This assignment was mainly an exercise in convolution, though some other techniques were used to automate the demodulation.

The entry-point to this project is `MatthewMancusoCA3.m`. From there, it will carry out AM demodulation on three signals transmitted at the same time (found in `ca3_AM_Data.m`) and FM demodulation on one signal found in `ca3_FM_Data.m`.

## Computer Assignment 4 (CA4)
This computer assignment deals with image processing, filtering and 2D frequency analysis.

The results in this assignment are more useful than the code itself.

All of the code for the assignment can be found in `MatthewMancusoCA4.m`, which produces all of the resultant images.


## Computer Assignment 5 (CA5)
This assignment was based around discrete time (FIR and IIR) filters. The first part of this assignment deals mostly with adding echoes to various audio clips. The second part involves removing vocals from an audio clip of Mariah Carey's Emotion.
