function switchFilterOnCallback(button, ~, controlObj)
    % If the button is pressed, the filter is enabled
    filter = button.Value;
    
    % Dirty way to determine if either audio player is playing
    playing = isplaying(controlObj.originalPlayer) || isplaying(controlObj.filteredPlayer);
    
    if (filter)
        % Make the filtered spectrogram visible
        uistack(controlObj.filteredPanel, 'top');
        
        % Get the current sample from the original player, so we can resume
        % from there on the filtered player
        start = get(controlObj.originalPlayer, 'CurrentSample');
        
        % Toggle players and ensure play-times line up
        if (playing)
            play(controlObj.filteredPlayer, start);
            pause(controlObj.originalPlayer);
        end
    else
        % Make the original spectrogram visible
        uistack(controlObj.originalPanel, 'top');
        
        % Get the current sample from the filtered player, so we can resume
        % from there on the original player
        start = get(controlObj.filteredPlayer, 'CurrentSample');
        
        % Toggle players and ensure play-times line up
        if (playing)
            play(controlObj.originalPlayer, start);
            pause(controlObj.filteredPlayer);
        end
    end
    
    