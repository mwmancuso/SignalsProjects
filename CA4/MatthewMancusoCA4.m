clc;

load 'hw4Data.mat';

% Part 1
% -------------------------------------------------------------------------

% im1 vs. im2
% -----------
figure(1);
colormap bone;

subplot(2,2,1);

imagesc(im1);
axis equal;
title 'im1';

subplot(2,2,2);
myFFT2(im1);
title 'im1 FFT';

subplot(2,2,3);

imagesc(im2);
axis equal;
title 'im2';

subplot(2,2,4);
myFFT2(im2);
title 'im2 FFT';

% im1 vs. im4
% -----------
figure(2);
colormap bone;

subplot(2,2,1);

imagesc(im1);
axis equal;
title 'im1';

subplot(2,2,2);
myFFT2(im1);
title 'im1 FFT';

subplot(2,2,3);

imagesc(im4);
axis equal;
title 'im4';

subplot(2,2,4);
myFFT2(im4);
title 'im4 FFT';

% im2 vs. im5 & im6
% -----------------
figure(3);
colormap bone;

subplot(3,2,1);

imagesc(im2);
axis equal;
title 'im2';

subplot(3,2,2);
myFFT2(im2);
title 'im2 FFT';

subplot(3,2,3);

imagesc(im5);
axis equal;
title 'im5';

subplot(3,2,4);
myFFT2(im5);
title 'im5 FFT';

subplot(3,2,5);

imagesc(im6);
axis equal;
title 'im6';

subplot(3,2,6);
myFFT2(im6);
title 'im6 FFT';

% Part 2
% -------------------------------------------------------------------------

% UK Flag
% -------
figure(4);
colormap bone;

subplot(2,3,1);

imagesc(uk);
axis equal;
title 'UK';

subplot(2,3,2);
myFFT2(uk, 'db');
title 'UK FFT 1';

subplot(2,3,3);
myFFT2(uk, 'db');
title 'UK FFT 2';

% US Flag
% -------
subplot(2,3,4);

imagesc(us);
axis equal;
title 'US';

subplot(2,3,5);
myFFT2(us, 'db');
title 'US FFT 1';

subplot(2,3,6);
myFFT2(us, 'db');
title 'US FFT 2';

% Part 3
% -------------------------------------------------------------------------

figure(5);

% 3x3 Low Pass Filter
% -------------------
h = fspecial('average', 3);
h_6 = fspecial('average', 6);
h_10 = fspecial('average', 10);

subplot(2,1,1);
myFFT2(h);
title '3x3 Low Pass FFT';

subplot(2,1,2);
myFFT2(h_6);
title '6x6 Low Pass FFT';

% Low Pass Filter Applied
% -----------------------
moon = imread('moon.tif');
filtered_moon = imfilter(moon, h);
filtered_6_moon = imfilter(moon, h_6);
filtered_10_moon = imfilter(moon, h_10);

figure(6);
colormap bone;

subplot(3,2,1);
myFFT2(moon);
title 'Moon FFT';

subplot(3,2,2);
myFFT2(filtered_moon);
title '3x3 LPF Moon FFT';

subplot(3,2,3);
imagesc(moon(400:470, 150:240));
axis equal;
title 'Moon Unfiltered';

subplot(3,2,4);
imagesc(filtered_moon(400:470, 150:240));
axis equal;
title 'Moon 3x3 Filtered';

subplot(3,2,5);
imagesc(filtered_6_moon(400:470, 150:240));
axis equal;
title 'Moon 6x6 Filtered';

subplot(3,2,6);
imagesc(filtered_10_moon(400:470, 150:240));
axis equal;
title 'Moon 10x10 Filtered';

% Honors
% -------------------------------------------------------------------------

% High Pass Filter
% ----------------
figure(7);
colormap bone;

moon = imread('moon.tif');

[b,a] = butter(2, 0.05, 'high');
h_1d = tf(b, a);
h = ftrans2(b);
highpass_moon = imfilter(moon, h);

subplot(2,2,1);
bode(h_1d);
title 'Butter HPF 1D Response';

subplot(2,2,2);
myFFT2(h, 'db');
title 'Butter HPF 2D Response';

subplot(2,2,3);
imagesc(moon);
axis equal;
title 'Moon Unfiltered';

subplot(2,2,4);
imagesc(highpass_moon);
axis equal;
title 'Moon Edge Detected';

% Noise Reduction
% ---------------

figure(8);
colormap bone;

subplot(2,2,1);
imagesc(pears);
axis equal;
title 'Original';

subplot(2,2,2);
imagesc(pears_noisy);
axis equal;
title 'Noisy';

b = ellip(2, 3, 40, 0.1, 'low');
h = ftrans2(b);
denoise_ellip = imfilter(pears_noisy, h);

subplot(2,2,3);
imagesc(denoise_ellip);
axis equal;
title 'Ellip Filter';

denoise_wiener = wiener2(pears_noisy, [6 6]);

subplot(2,2,4);
imagesc(denoise_wiener);
axis equal;
title 'Wiener Filter';