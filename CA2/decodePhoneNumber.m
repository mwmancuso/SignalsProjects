function phoneNumber = decodePhoneNumber(fileName, varargin)
% Source: Matthew Mancuso
%
% Use: This function will take a file given by fileName, decompress it if
% need be, loop through it and determine the phone number dialed
%
% Inputs fileName: The .wav or .mat (compressed) file with audio data
%        varargin: IF used:
%               First arg: windowLen: length of window to check for tone
%                   Default: 50ms
%               Second arg: frequencyTolerance: % off detected frequency
%                           can be from tone frequency to be recognized
%                   Default: 5%
%               Third arg: showGraph: whether or not to show graphs for
%                           phone number decoding
%                   Default: 0
% Outputs phoneNumber: String with phone number dialed
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Get the extension of the fileName, and set decompress flag to 1 if it
    % is a .mat file, since .mat files call for decompression
    [~, ~, extension] = fileparts(fileName);
    mustDecompress = strcmp(extension, '.mat');
    
    % If decompress flag is set, decompress it using the decompressAudio
    % function. Otherwise just import the .wav data
    if mustDecompress
        [audioData, fs] = decompressAudio(fileName);
    else
        [audioData, fs] = audioread(fileName);
    end

    % The length of a window to check for a tone.
    % This should be half the length of a button press for best results.
    % Theoretical minimum button press is 50ms, but these buttons are pressed
    % for longer.
    windowLen = 0.050;
    if (~isempty(varargin))
        windowLen = varargin{1};
    end

    % Each frequency returned by myFFT will not be perfect. This is the
    % threshold vs. the actual tone frequencies that will be accepted for a
    % digit. 5% seems to work well.
    frequencyTolerance = 0.05;
    if (length(varargin) >= 2)
        frequencyTolerance = varargin{2};
    end
    
    % Whether or not we should show a graph for the signal
    showGraph = 0;
    if (length(varargin) >= 3)
        showGraph = varargin{3};
    end

    % This normalizes audioData to go from -1 to 1
    audioData = 2*((audioData - min(audioData)) / (max(audioData) - min(audioData))) - 1;

    % Creates time vector from 0-total length @ fs to compare audioData to
    t = linspace(0, length(audioData) / fs, length(audioData));

    % Running string of phone number initialization
    phoneNumber = '';
    
    % Xx2 matrix consisting of start and stop times of each digit
    digitTimes = [];
    
    % Keeps track of top two frequencies at any given time (with respect to
    % window, not a perfect representation)
    highFreqs = zeros(length(audioData), 2);
    
    % We'll keep track of the FFTs of the first non-match, and the first
    % two distinct numbers, so that we can graph them later
    noMatchX = [];
    noMatchf = [];
    match1Digit = 0;
    match1X = [];
    match1f = [];
    match2Digit = 0;
    match2X = [];
    match2f = [];

    % We keep track of the last digit to see if a new one has been pressed.
    % This should always reset to 0 between digits since it is likely
    % impossible to hit one digit right after the next, given small enough
    % windowLen.
    lastDigit = 0;

    % Loop over all windows (of length defined by windowLen). i is the
    % beginning index of each window
    samplesPerWindow = round(windowLen*fs);
    numWindows = ceil(length(audioData) / samplesPerWindow);
    for i = (1:numWindows)
        % Array from i to 1 before next i
        idxs = ((i-1)*samplesPerWindow+1) : min(i*samplesPerWindow, length(audioData));

        % Get audio and time windows
        audWindow = audioData(idxs);
        tWindow = t(idxs);

        % Will find top two strongest frequencies in window
        [freqs, X, f] = findStrongFrequencies(audWindow, fs);
        
        % We'll need to put the freq vector in every index referred to by
        % this window.
        highFreqs(idxs, 1:2) = repmat(sort(freqs), length(idxs), 1);

        % Will find digit corresponding to top two frequencies, or 0 if no
        % digit is close enough
        digit = findDigit(freqs, frequencyTolerance);
        
        % This digit is the end of an old digit, record last digit's end
        if (digit ~= lastDigit && lastDigit ~= 0)
            digitTimes(length(phoneNumber), 2) = tWindow(1) - (1/fs);
        end

        % We'll append the digit to the phone number if it is new
        if (digit ~= 0 && digit ~= lastDigit)
            phoneNumber = strcat(phoneNumber, digit);
            
            % Since we have a new digit, record its start time
            digitTimes(length(phoneNumber), 1) = tWindow(1);
        end
        
        % Record FFT of first non-match, i.e. noise
        if (digit == 0 && isempty(noMatchX))
            noMatchX = X;
            noMatchf = f;
        end
        
        % Record FFT of first real digit
        if (digit ~= 0 && isempty(match1X))
            match1Digit = digit;
            match1X = X;
            match1f = f;
        end
        
        % Record FFT of second distinct digit
        if (digit ~= 0 && isempty(match2X) && digit ~= match1Digit)
            match2Digit = digit;
            match2X = X;
            match2f = f;
        end

        lastDigit = digit;
    end
    
    % Function to plot rectangles corresponding to place on graph where a
    % number was detected. Also labels the number detected
    function plotRectangle(index, number, x, y, width, height)
        % Alternating color vector
        colors = [.2 .5 .7; .2 .5 .7; .2 .5 .7];
        colorIdx = mod(index - 1, length(colors)) + 1;
        
        % Paint a transparent rectangle
        rectangle('Position', [x, y, width, height], ...
            'FaceColor', [colors(colorIdx, :) .3], 'EdgeColor', [0 0 0 0]);
        
        % Label the rectangle at the bottom
        text(x + (width/2), y, number, ...
            'HorizontalAlignment', 'center', 'FontSize', 11, 'Color', 'black', ...
            'VerticalAlignment', 'bottom', 'BackgroundColor', [1 1 1 0.5], 'Margin', 2);
    end
    
    % If we're showing graphs, run through the figure and subplots
    if showGraph
        % Label the figure with the filename
        figure('Name', fileName);
        clf;
        
        % Plot 1: Original Audio Signal
        % XXXXX
        % - - -
        % - - -
        % Using 3x3 subplot, but taking the entire first row for the
        % original audio signal
        subplot(3,3,[1 2 3]);
        
        plot(t, audioData);
        axis tight;
        title('Original Audio Signal');
        xlabel('time (s)');

        % Plot all rectangles for digits atop original audio signal
        for i = 1:length(phoneNumber)
            plotRectangle(i, phoneNumber(i), digitTimes(i, 1), min(audioData), ...
                digitTimes(i, 2) - digitTimes(i, 1), max(audioData) - min(audioData));
        end

        % Plot 2: Strongest Two Frequencies
        % - - -
        % XXXXX
        % - - -
        % Using 3x3 subplot, but taking the entire second row
        subplot(3,3,[4 5 6]);
        
        defColors = get(gca, 'colororder');
        hold off;
        plot(t, highFreqs(:, 1), 'Color', defColors(1, :), 'LineWidth', 1.5);
        hold on;
        plot(t, highFreqs(:, 2), 'Color', defColors(1, :), 'LineWidth', 1.5);
        axis([min(t) max(t) 0 2000]);
        title('Strongest Two Frequencies');
        xlabel('time (s)');
        ylabel('frequency (Hz)');

        % Plot all rectangles for digits
        for i = 1:length(phoneNumber)
            plotRectangle(i, phoneNumber(i), digitTimes(i, 1), 0, digitTimes(i, 2) - digitTimes(i, 1), 2000);
        end

        % Plot 3: No Match FFT
        % - - -
        % - - -
        % X - -
        subplot(3,3,7);
        
        plot(noMatchf, abs(noMatchX));
        axis([-2000 2000 min(abs(noMatchX)) max(abs(noMatchX))]);
        title('No Match FFT');
        xlabel('frequency (Hz)');
        ylabel('amplitude (|A|)');

        % Plot 4: Match 1 FFT
        % - - -
        % - - -
        % - X -
        subplot(3,3,8);
        
        plot(match1f, abs(match1X));
        axis([-2000 2000 min(abs(match1X)) max(abs(match1X))]);
        title(strcat('"', match1Digit, '" FFT'));
        xlabel('frequency (Hz)');
        ylabel('amplitude (|A|)');

        % Plot 5: Match 2 FFT
        % - - -
        % - - -
        % - - X
        subplot(3,3,9);
        
        plot(match2f, abs(match2X));
        axis([-2000 2000 min(abs(match2X)) max(abs(match2X))]);
        title(strcat('"', match2Digit, '" FFT'));
        xlabel('frequency (Hz)');
        ylabel('amplitude (|A|)');
    end
end