% Computer Assignment 1: Part 2
% By: Matthew Mancuso

clear; clc;

% data4.mat, data5.mat, or data6.mat
load data4.mat;

% max number of harmonics of A to use. lower number = lower quality
max_harmonics = 15;

win_len = 50e-3; % in seconds
samples_per_win = fs*win_len;

% number of samples each window is shifted
% incidentally, setting this equal to samples_per_win will allow it to run
% Part 1 files perfectly
sample_shift = ceil(samples_per_win / 2);

[num_windows, num_harmonics] = size(freqs);

total_samples = samples_per_win + sample_shift * (num_windows - 1);
total_len = (total_samples / samples_per_win) * win_len;

t = linspace(0, total_len, total_samples);
data = zeros(1, total_samples);

% loop over all windows in A
for window = 1:num_windows
    % samples at which windows begin and end. window_loc should be
    % samples_per_win long, each window begins sample_shift over
    window_begin = (window - 1)*sample_shift + 1;
    window_end = window_begin + samples_per_win - 1;
    window_loc = window_begin:window_end;
    
    % matches time vector with data vector
    win_t = t(window_loc);
    
    % running sum of all harmonics
    win = data(window_loc);
    
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

% plot and axes
fig = figure();
plot(t, data);
grid on;

% ensures negative and positive vertical axes are equal
data_max = max(abs(min(data)), abs(max(data)));
axis([0 total_len -data_max data_max]);
xlabel('time (s)');
figure(fig);

% soundsc instead of sound to prevent clipping
soundsc(data, fs);