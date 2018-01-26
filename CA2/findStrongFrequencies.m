function [freqs, varargout] = findStrongFrequencies(signal, fs, varargin)
% Source: Matthew Mancuso
%
% Use: This function will find the strongest harmonic frequencies of a
% given sinusoidal signal using Fourier transform. Defaults to top 2.
%
% Inputs signal: Is the raw audio data to run FFT on
%        fs: Is the frequency points/time
%        varargin: IF used is the number of frequencies returned
%               Else returns top two frequencies
% Outputs freqs: Is a vector with highest frequencies, sorted high-to-low
%         varargout:
%             X: magnitude and phase values of myFFT function
%             f: frequencies that correspond to X
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Defaults number of frequencies to 2, sets to varargin if given
    numLocs = 2;
    if ~isempty(varargin)
        numLocs = varargin{1};
    end
    
    % How much percent difference is required to pick a new frequency
    tolerance = 0.05;

    % Run given FFT function, returns the X (amplitude and phase) values
    % along with the frequencies at which they occur.
    [X,f] = myFFT(signal, fs, 2^17);
    
    % Take only the magnitudes and frequencies at positive frequencies,
    % since negative frequencies should mirror
    mags = abs(X);
    mags = mags(f >= 0);
    posFreqs = f(f >= 0);
    
    % Find peaks of amplitudes, sorted high-to-low, and gets frequencies at
    % which they occur
    [~, locs] = findpeaks(mags, posFreqs, 'SortStr', 'descend');
    
    % We're going to avoid picking frequencies which fall within the
    % specified tolerance of each other. Since FFT may have two adjacent
    % peaks, we'll want to filter them out and take only distinct peaks. To
    % do this, we loop over all locations for each peak until the
    % difference is >= tolerance, or we run out of peaks
    freqs = zeros(1, numLocs);
    locIdx = 1;
    for i = 1:numLocs
        if i > 1
            % We take the percent difference and compare it to tolerance
            while (abs(locs(locIdx) - freqs(i - 1)) ...
                    / mean([locs(locIdx) freqs(i - 1)])) < tolerance ...
                    && locIdx < length(locs)
                % If we're still within the tolerance vs. the previous
                % frequency, move on to the next one
                locIdx = locIdx + 1;
            end
        end
        
        freqs(i) = locs(locIdx);
        
        locIdx = locIdx + 1;
    end
    
    if (nargout >= 2)
        varargout{1} = X;
    end
    
    if (nargout >= 3)
        varargout{2} = f;
    end
end