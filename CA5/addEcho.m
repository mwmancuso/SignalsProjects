function delayedAudio = addEcho(audio, fs, varargin)

    % Let's take care of all the variables
    % ------------------------------------------------------------------- %
    argumentList = {'delay', 'amplitude', 'filterType', 'stereo', 'stereoSwap', 'removeOriginal'};

    filterType = 'FIR';     % FIR or IIR
    delay = 0.1;            % How long echo should be delays
    amplitude = 0.5;        % Magnitude of echo
    stereo = false;         % Will put original on left, echo on right, unless...
    stereoSwap = false;     % ...this is set, which will swap the channels
    removeOriginal = false;
    
    if (~isempty(varargin)) 
        if (mod(length(varargin), 2) ~= 0)
            error('Odd number of variable arguments. Use key-value pairs, such as addDelay(audio, fs, "filterType", "IIR")');
        end
        
        for i = (1:2:length(varargin))
            if (~ismember(varargin{i}, argumentList))
                error(strcat('"', varargin{i}, '" is an unrecognized argument. Please use one of the following: ', strjoin(argumentList)));
            end
            
            switch (varargin{i})
                case 'delay'
                    delay = varargin{i + 1};
                case 'amplitude'
                    amplitude = varargin{i + 1};
                case 'filterType'
                    filterType = varargin{i + 1};
                case 'stereo'
                    stereo = varargin{i + 1};
                case 'stereoSwap'
                    stereoSwap = varargin{i + 1};
                case 'removeOriginal'
                    removeOriginal = varargin{i + 1};
            end
                    
        end
    end
    % ------------------------------------------------------------------- %
    
    % Since some audio vectors are inverted, make sure they're all X by 1
    if (size(audio, 1) == 1)
        audio = audio';
    end
    
    % Build the delay discrete time vector
    tfDelay = [1 zeros(1, round(delay*fs)) amplitude];
    
    % Put discrete time vector in numerator if FIR, denominator if IIR
    if (strcmp(filterType, 'FIR'))
        b = tfDelay;
        a = 1;
    else
        b = 1;
        a = tfDelay;
    end
    
    % Filter the audio with numerator/denominator from above
    filteredAudio = filter(b, a, audio);
    
    if (removeOriginal)
        filteredAudio = filteredAudio - audio;
    end
    
    % If we're doing stereo, put the echoed audio on the left, unless
    % stereoSwap is true, in which case we'll put the echoed auio on the
    % right.
    if (stereo)
        if (stereoSwap)
            delayedAudio = [filteredAudio, audio];
        else
            delayedAudio = [audio, filteredAudio];
        end
    else
        % If not stereo, just return the original filtered vector
        delayedAudio = filteredAudio;
    end
