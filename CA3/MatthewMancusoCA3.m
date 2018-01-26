% Computer Assignment 3: Part 1
% By: Matthew Mancuso

clear; clc;

% This is the listening frequency. 44.1 KHz allows it to be clearly
% listened to through the sound/soundsc commands
downsampledFs = 44.1e3;

% The expected bandwidth of each carrier in Hz. This allows the
% decodeAMSignals function to accurately detect carrier frequencies and
% extract the audio from them, without getting noise from adjacent
% carriers.
AMBandwidth = 10000;

% This is the artificaial offset of the AM carriers. We use this to test
% how shifting the carrier frequency affects the quality of the audio
% signal. Note that this is in units of % ; set to 5.0 for 5%.
offsetPct = 0;

% Let's decode the signals from AM data now. Note that we are not defining
% how many signals to look for, or where the carriers are. The signals will
% be returned to the cell array, AMSignals
AMSignals = decodeAMSignals('ca3_AM_Data.mat', downsampledFs, AMBandwidth, offsetPct);

% We'll store all the clips in a continuous vector, allClips. This can be
% played back to hear all clips -- both AM and FM
allClips = [];

% Loop through the AMSignals cell array and add each audio clip, followed
% by a 1 second delay, to the allClips vector.
for i = 1:length(AMSignals)
    % We add downsampleFs zeros to the end for a 1 second delay.
    allClips = [allClips, AMSignals{i}, zeros(1, 1*downsampledFs)];
end

% Let's now demodulate the FM signal, and output it to FMSignal at the
% downsampledFs
FMSignal = decodeFMSignal('ca3_FM_Data.mat', downsampledFs);

% Add the demodulated FM to the allClips vector, followed by another 1
% second delay
allClips = [allClips, FMSignal, zeros(1, 1*downsampledFs)];

% Play all the clips in a row at the downsampledFs
soundsc(allClips, downsampledFs);

% Plot the clips for visual observation
t = linspace(0, length(allClips)/downsampledFs, length(allClips));
plot(t, allClips);