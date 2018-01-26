clear; clc;

load 'hw5Data.mat';

% Uses noVoiceFilter filter function to remove most of the singing
% frequencies, i.e. between 500Hz and 4300Hz
noVoiceAudio = filter(noVoiceFilter, audio3);

% Spectrogram Analyzer With Play/Pause/Filter Buttons
% ---------------------------------------------------
% To use: simply press Play, then toggle Filter On on and off to see/hear
%         the difference.

% Let's set up a spectrogram analyzer window so we can switch between
% graphs
spectrogramFigure = figure(); clf;

% Set up original spectrogram with 'hot' colormap and Frequency on the
% y-axis. Put it in its own panel so we can swap it with the filtered
% spectrogram as needed. Seekbar is also initialized here
controlObj.originalPanel = uipanel(spectrogramFigure, 'Position', [0 .34 1 .66], 'BorderType', 'none');
axes('Parent',controlObj.originalPanel,'Position',[.1 .15 .8 .75]);
spectrogram(audio3, 256, 200, [], fs, 'yaxis'); colormap hot;
originalSeekBar = line([0 0], [-2 30], 'LineWidth', 3, 'Color', 'white');

% Set up original audio player, and set up a callback to move the seekbar
controlObj.originalPlayer = audioplayer(audio3, fs);
set(controlObj.originalPlayer, 'TimerFcn', {@moveBarCallback, {originalSeekBar}}, 'TimerPeriod', 0.05);

% Set up filtered spectrogram, exactly the same as the original
% spectrogram, in its own panel. Give it its own seekbar
controlObj.filteredPanel = uipanel(spectrogramFigure, 'Position', [0 .34 1 .66], 'BorderType', 'none');
axes('Parent',controlObj.filteredPanel,'Position',[.1 .15 .8 .75]);
spectrogram(noVoiceAudio, 256, 200, [], fs, 'yaxis'); colormap hot;
filteredSeekBar = line([0 0], [-2 30], 'LineWidth', 3, 'Color', 'white');

% Set up filtered audio player, and another callback to move its seekbar
controlObj.filteredPlayer = audioplayer(noVoiceAudio, fs);
set(controlObj.filteredPlayer, 'TimerFcn', {@moveBarCallback, {filteredSeekBar}}, 'TimerPeriod', 0.05);

% Ensure original spectrogram is showing, since Filter On is originally off
uistack(controlObj.originalPanel, 'top');

% Add button panel and control buttons. All buttons have callback functions
% which use the controlObj to determine which?if any?file is playing and
% switch the filtered audio and spectrogram in real time
buttonPanel = uipanel(spectrogramFigure, 'Title', 'Mariah Carey Controls', 'Position', [0 0 1 .32], ...
    'TitlePosition', 'centertop', 'FontSize', 16);
controlObj.filterOnButton = uicontrol('String', 'Filter On', 'Parent', buttonPanel, 'Style', ... 
    'togglebutton', 'Units', 'normalized', 'Position', [.34 .25 .32 .5], 'FontUnits', ...
    'normalized', 'FontSize', .4, 'Callback', {@switchFilterOnCallback, controlObj});
playButton = uicontrol('String', 'Play', 'Parent', buttonPanel, 'Style', 'pushbutton', 'Units', ...
    'normalized', 'Position', [.01 .25 .32 .5], 'FontUnits', 'normalized', 'FontSize', .4, ...
    'Callback', {@switchPlayStopCallback, true, controlObj});
stopButton = uicontrol('String', 'Pause', 'Parent', buttonPanel, 'Style', 'pushbutton', 'Units', ...
    'normalized', 'Position', [.67 .25 .32 .5], 'FontUnits', 'normalized', 'FontSize', .4, ...
    'Callback', {@switchPlayStopCallback, false, controlObj});