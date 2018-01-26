function frequencies = getDetectedFrequencies(f, X, bandwidth)
% Source: Matthew Mancuso
%
% Use: This function will take the FFT result from modulated AM data and
% return the carrier frequencies
%
% Inputs f: frequencies from myFFT command
%        X: amplitudes/phases from myFFT command
%        bandwidth: expected bandwidth of carriers, used to determine
%           adjacent peaks
% Outputs frequencies: array of all carrier frequencies
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Smoothing distance for moving average, works best at 5/9ths of the
    % number of points in the frequency domain in the bandwidth
    smoothingDistance = (5/9)*round((1/(f(2) - f(1))))*bandwidth;
    
    % How high peaks should be to count as carrier frequencies.
    cutoffPercentage = 0.05;
    
    % Take only values at positive frequencies.
    posMags = abs(X(f >= 0));
    posFreqs = f(f >= 0);
    
    % Take moving average of data to smooth peaks and turn sidebands into
    % one single peak.
    smoothMags = movmean(posMags, smoothingDistance);
    
    % Sets absolute cutoff value from max value and cutoff percentage
    cutoffVal = max(smoothMags)*cutoffPercentage;
    
    % Finds peaks and returns their positions to determine carrier
    % frequencies.
    [~, frequencies] = findpeaks(smoothMags, posFreqs, 'SortStr', 'descend', 'MinPeakProminence', cutoffVal);
end