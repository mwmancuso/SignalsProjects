function moveBarCallback(hObject, ~, seekBars)
    for i = (1:length(seekBars))
        seekBar = seekBars{i};
        currentSample = get(hObject, 'CurrentSample');
        currentTime = currentSample/get(hObject, 'SampleRate');
        set(seekBar, 'X', currentTime*[1 1]);
    end
end