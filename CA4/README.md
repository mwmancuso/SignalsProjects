# Computer Assignment 4: Image Filtering
## Overview
This computer assignment deals with image processing, filtering and 2D frequency analysis.

The results in this assignment are more useful than the code itself.

All of the code for the assignment can be found in `MatthewMancusoCA4.m`, which produces all of the resultant images.

## Results
* `Results/p1a.png` - Shows difference between smooth image and sharp image Fourier Transforms; smooth image produces an impulse, while sharp image produces a sinc wave
* `Results/p1b.png` - Shows low- and high-frequency images and their associated FTs; explains frequency graphically
* `Results/p1c.png` - Introduces 2D Fourier Transforms by alternating both X and Y values; sharp edges produce 1D and 2D sinc waves
* `Results/p2.png` - Shows frequency content of US and UK flags; patterns can be observed in different directions dependent on the directions of the flags' lines
* `Results/p3.png` - Shows results of different power averaging filters on a picture of the moon
* `Results/p4a.png` - Shows result of turning high-pass 1D Butter filter into 2D filter and using it to edge-detect picture of moon
* `Results/p4b.png` - Shows two different filters smoothing noisy image; low-pass elliptical filter converted to 2D filter is poor compared to self-adjusting Wiener filter

## Disclaimer
The myFFT2() function used in this code was developed by my professor, Dr. Obeid—not myself. It is a convenience wrapper built around MATLAB's FFT function.
