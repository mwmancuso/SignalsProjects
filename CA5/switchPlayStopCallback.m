function switchPlayStopCallback(~, ~, playing, controlObj)
    % Determine if the Filter On button is pressed
    filter = controlObj.filterOnButton.Value;
    
    % If this is the play button, simply resume whichever player was
    % playing
    if (playing)
        if (filter)
            resume(controlObj.filteredPlayer);
        else
            resume(controlObj.originalPlayer);
        end
    else
        % Otherwise, play it safe. Pause both in case of bugs
        pause(controlObj.filteredPlayer);
        pause(controlObj.originalPlayer);
    end
    
    