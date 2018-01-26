clear; clc;

load 'hw5Data.mat';

% Beep is inverted with respect to the rest of the audio vectors. Let's
% standardize it. Remove this and the below will crash!
beep = beep';

% All the settings needed for the assignment
selectedAudio = audio1;  % Audio vector to use
filterType = 'IIR';      % FIR or IIR
delay = 0.1;             % How long echo should be delays
amplitude = 0.33;         % Magnitude of echo
stereo = true;           % Will put original on left, echo on right, unless...
stereoSwap = true;      % ...this is set, which will swap the channels
removeOriginal = true;  % Whether or not to remove original audio from echoed.
                         % Use this for a more convincing "angled" audio

% Do the echo and derive the time vector
audioEchoed = addEcho(selectedAudio, fs, 'filterType', filterType, 'delay', ...
    delay, 'amplitude', amplitude, 'stereo', stereo, 'stereoSwap', stereoSwap);
audioTime = linspace(0, length(selectedAudio) / fs, length(selectedAudio));

% X-axis window for all three graphs in one fell swoop
timeWindow = [min(audioTime) max(audioTime)];
% timeWindow = [0.2 0.7];

% Play the echoed audio; may be stereo
soundsc(audioEchoed, fs);

% We'll want to plot the echoed audio, so get just that if addEcho returned
% two channels
if (stereo)
    if (stereoSwap)
        echoOnly = audioEchoed(:, 1);
    else
        echoOnly = audioEchoed(:, 2);
    end
else
    echoOnly = audioEchoed;
end

% Plots
% -----

figure(); clf;

% If we're already removing the original audio in addEcho, don't re-do it
% here
subdivisions = 3 - removeOriginal;

% Plot original audio
subplot(subdivisions, 1, 1);
plot(audioTime, selectedAudio);
title 'Original Audio';
xlabel 'Time (s)';
axis([timeWindow -max(abs(selectedAudio)) max(abs(selectedAudio))]);

% Plot echoed audio
subplot(subdivisions, 1, 2);
plot(audioTime, echoOnly);
title 'Echoed Audio';
xlabel 'Time (s)';
axis([timeWindow -max(abs(echoOnly)) max(abs(echoOnly))]);

if (~removeOriginal)
    % Plot JUST echo, without original audio, to see where it is and how big it
    % is
    subplot(subdivisions, 1, 3);
    plot(audioTime, echoOnly - selectedAudio);
    title 'Echoed Audio Minus Original';
    xlabel 'Time (s)';
    axis([timeWindow -max(abs(echoOnly - selectedAudio)) max(abs(echoOnly - selectedAudio))]);
end