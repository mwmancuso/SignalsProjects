function [audioData, fs] = decompressAudio(fileName, varargin)
% Source: Matthew Mancuso
%
% Use: This function is from Part 1 of Computer Assignment 1, and
% decompresses audio given a .mat file of harmonics and frequencies.
%
% Inputs fileName: The .mat file with vectors A and freqs, and scalar fs
%        varargin: IF used is the window length of the algorithm
%               Else uses 75ms
% Outputs audioData: Decompressed audio data, can be fed into soundsc or
%                    plotted
%         fs: Sampling rate provided in file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    A = [];
    freqs = [];
    fs = [];

    % data1.mat, data2.mat, or data3.mat
    load(fileName);

    % max number of harmonics of A to use. lower number = lower quality
    max_harmonics = 15;

    win_len = 75e-3; % in seconds
    if (~isempty(varargin))
        win_len = varargin{1};
    end
    
    samples_per_win = round(fs*win_len);

    [num_windows, num_harmonics] = size(freqs);

    total_samples = samples_per_win*num_windows;
    total_len = win_len*num_windows;

    t = linspace(0, total_len, total_samples);
    data = zeros(1, total_samples);

    % loop over all windows in A
    for window = 1:num_windows
        % samples at which windows begin and end. window_loc should be
        % samples_per_win long
        window_begin = (window - 1)*samples_per_win + 1;
        window_end = window_begin + samples_per_win - 1;
        window_loc = window_begin:window_end;

        % matches time vector with data vector
        win_t = t(window_loc);

        % running sum of all harmonics
        win = zeros(1, samples_per_win);

        % loops over all harmonics in A, up to max_harmonics
        for harmonic = 1:min(max_harmonics, num_harmonics)
            % get A and frequency value at window and harmonic
            cur_A = A(window, harmonic);
            cur_freq = 2*pi*freqs(window, harmonic);

            % gets magnitude and phase shift of A value
            cos_mag = abs(cur_A);
            cos_shift = angle(cur_A);

            % sums cosine for harmonic into window
            win = win + cos_mag * cos(cur_freq*win_t + cos_shift);
        end

        % adds window to data vector
        data(window_loc) = win;
    end
    
    audioData = data;
    
end