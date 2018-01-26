function AMSignals = decodeAMSignals(fileName, outputFs, bandwidth, varargin)
% Source: Matthew Mancuso
%
% Use: This function will take a file given by fileName, detect the AM
% carrier frequencies, calculate the bandwidth, and return a cell array of
% each of the demodulated signals.
%
% Inputs fileName: The .mat file with AM data (xmod) and sample rate (fs)
%        outputFs: output sampling rate; will downsample original data to
%           this sampling rate
%        varargin: IF used: offset percentage (in %) of carrier frequency.
%                      Used to test the required accuracy of carrier freq.
%                  ELSE: no offset -- uses detected frequency
% Outputs AMSignals: Cell array with all demodulated audio signals
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % This file should contain xmod (modulated AM data) and sampling
    % frequency (fs) to be used below
    load(fileName);
    
    % Preliminary calculations to deduce time vector
    numSamples = length(xmod);
    totalSeconds = numSamples / fs;
    t = linspace(0, totalSeconds, numSamples);

    % This is the percent off of the carrier frequency; used for
    % determining how accurate the frequency must be to create audible
    % demodulated sound. If fourth argument is given to function, it is 
    % used as for this value. Note that this is in units of %, and will be
    % divided by 100
    offsetPct = 0;
    if (~isempty(varargin))
        offsetPct = varargin{1};
    end
    
    % First we'll take the Fourier transform, then pass the results to
    % getDetectedFrequency to determine which (and how many) carrier
    % frequencies exist in the modulated signal. signalFrequencies will
    % then be a vector with all carrier frequencies
    [X, f] = myFFT(xmod, fs);
    signalFrequencies = sort(getDetectedFrequencies(f, X, bandwidth));
    signalFrequencies = signalFrequencies * (1 + (offsetPct/100));
    
    % Since the modulated data may be noisy and bleed into adjacent
    % carriers, we will take 85% of the bandwidth for the cutoff frequency
    % in Hertz. This allows the filter to cut off noisy directly on the
    % carrier boundaries to a significant extent
    cutoffFreq = bandwidth*0.85;
    
    % Determine the minimum order to achieve -40 dB at the carrier
    % boundary (bandwidth) with only a 1 dB ripple in the passband. Will be
    % used to design filter below
    filterOrd = cheb1ord(2*pi*cutoffFreq, 2*pi*bandwidth, 1, 40, 's');
    
    % We'll use a Chebyshev filter to provide a fast decay and significant
    % attenuation at the adjacent carrier signal boundary, as well as
    % allowing only a 1 decibel ripple in the passband. Then create a
    % transfer function from the filter coefficients
    [num, denom] = cheby1(filterOrd, 1, 2*pi*cutoffFreq, 's');
    transferFunc = tf(num, denom);
    
    % Initialize a cell array equal in length to the number of carrier
    % frequencies to store the frequencies.
    AMSignals = cell(1, length(signalFrequencies));
    
    % Loop over all carrier frequencies.
    for i = 1:length(signalFrequencies)
        % Create a cosine of each carrier frequency to shift the signal
        % with. Then, multiply the carrier by the signal to shift the audio
        % into the audio frequency domain
        carrier = cos(2*pi*signalFrequencies(i)*t);
        shiftedSignal = carrier .* xmod;
        
        % Simulate the filtered signal with the filter defined earlier.
        filteredSignal = lsim(transferFunc, shiftedSignal, t)';
        
        % Downsample the signal to the output sample frequency defined.
        resampledSignal = resample(filteredSignal, outputFs, fs);
        
        % Scale data into -1 to 1 range.
        scaledData = (resampledSignal - min(-abs(resampledSignal))) ./ (2*max(abs(resampledSignal)));
        scaledData = 2*scaledData - 1;
        
        % Add audio signal to AMSignals cell array.
        AMSignals{i} = scaledData;
    end
end