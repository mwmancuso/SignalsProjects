# Computer Assignment 1: Audio Decompression
## Overview
The goal of this assignment was to decompress pre-compressed data using the concept of the sum of cosines. The data was compressed by an algorithm invented by Dr. Obeid, my instructor.

[Download a ZIP with all files here.](https://drive.google.com/open?id=1rod5ozMS-zAMp572Jbrv89eGQq38trlZ)

## Part 1
The compression algorithm for Part 1 (files `data1.mat`, `data2.mat`, `data3.mat`) is as follows:

1. Divide the signal into 50ms windows (which corresponds to 2,205 samples)
2. In each window, determine the frequencies that contain the most energy. Store the frequency in Hertz and the A (complex amplitude/phase of) value for each of the strongest 15 harmonics in each window.

The audio could thus be reconstructed by—for each window—building a cosine for each of the 15 harmonics, summing them together, and, finally, stringing the windows together. The code in `Part1.m` does just this. It can be run as-is, for `data1.m`, `data2.m`, or `data3.m`.

## Part 2
The compression algorithm for Part 2 (files `data4.mat`, `data5.mat`, `data6.mat`) is as follows:

1. Divide the signal into 50ms windows (which corresponds to 2,205 samples), spaced only 25ms apart, to create overlapping windows
2. In each window, determine the frequencies that contain the most energy. Store the frequency in Hertz and the A (complex amplitude/phase of) value for each of the strongest 15 harmonics in each window.

The audio in Part 2 could thus be reconstructed just as in Part 1, but stringing the windows together required extra effort to place them at even offsets. The main difference between `part2.m` and `part1.m` are the initial calculations, which must be perfect down to the individual samples for accurate reconstruction.

## Results
Comparing `Results/Part1Data1Zoom.png` and `Results/Part2Data4Zoom.png` (the same original clips), we can see that the overlapping method produces much smoother audio, especially along window edges and sharp changes in audio content.
