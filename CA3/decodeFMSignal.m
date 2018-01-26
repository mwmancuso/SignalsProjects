function FMSignal = decodeFMSignal(fileName, outputFs)
% Source: Matthew Mancuso
%
% Use: This function will take an input file and demodulate the FM data
% stored, returning an audio signal at the output sampling frequency
% specified
%
% Inputs fileName: The .mat file with FM data (xmod) and sample rate (fs)
%        outputFs: output sampling rate; will downsample original data to
%           this sampling rate
% Outputs FMSignal: audio data sampled at outputFs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % This file should contain xmod (modulated FM data) and sampling
    % frequency (fs) to be used below
    load(fileName);
    
    % Preliminary calculations to deduce time vector
    numSamples = length(xmod);
    totalSeconds = numSamples/fs;
    t = linspace(0,totalSeconds,numSamples);

    % First, we take the estimated derivative of xmod by taking the
    % difference of each point and dividing it by the interval of time
    % between the points.
    xmodDeriv = diff(xmod) ./ diff(t);
    
    % Then, we take the upper half of the envelope of the derivative to
    % obtain a sound wave -- albeit vertically shifted
    [upperEnv, ~] = envelope(xmodDeriv);
    
    % Next, we shift the sound wave to the 0 line by subtracting the
    % average value. We're assuming the mean here is the middle of the data
    % over a significant number of samples
    normEnv = upperEnv - mean(upperEnv);
    
    % Downsample the signal to the output sample frequency defined.
    resampledSignal = resample(normEnv, outputFs, fs);
    
    % Scale data into -1 to 1 range.
    scaledData = (resampledSignal - min(-abs(resampledSignal))) ./ (2*max(abs(resampledSignal)));
    scaledData = 2*scaledData - 1;
    
    % Output our data and exit the function.
    FMSignal = scaledData;
end