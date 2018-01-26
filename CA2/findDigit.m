function digit = findDigit(highestFreqs, varargin)
% Source: Matthew Mancuso
%
% Use: This function finds the digit of a window of signal given the
% highest frequencies in that window. Can use more than two highest
% frequencies, but should use top two
%
% Inputs highestFreqs: Vector of top two or more frequencies
%        varargin: IF used is the tolerance for frequency matching
%               Else uses freq within 5% of digit frequency
% Outputs digit: Single character highestFreqs corresponds to, or 0 if none
%                match
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Defaults tolerance to 5%, uses varargin otherwise. This value will be
    % used to determine how far off highestFreqs values can be from
    % toneCols or toneRows to be considered for the digit
    tolerance = 0.05;
    if ~isempty(varargin)
        tolerance = varargin{1};
    end

    % In the criminal justice system, the digits are represented by two
    % separate yet equally important frequencies, the columns, who
    % investigate horizontally, and the rows, who prosecute vertically. 
    % These are their stories.
    toneCols = [1209, 1336, 1447, 1633];
    toneRows = [697, 770, 852, 941];
    digits = ...
        ['1', '2', '3' ;
         '4', '5', '6' ;
         '7', '8', '9' ;
         '*', '0', '#' ];
    
    % Here we keep track of any column or row frequencies that matched
    digitCol = 0;
    digitRow = 0;
    
    % We'll loop through all of the highest frequencies provided to match
    % against either toneCols or toneRows
    for freqIdx = 1:length(highestFreqs)
        freq = highestFreqs(freqIdx);
        
        % Look for freq within toneCols, within tolerance
        for col = 1:length(toneCols)
            colFreq = toneCols(col);
            if (freq >= colFreq*(1-tolerance) && freq <= colFreq*(1+tolerance))
               digitCol = col;
               break;
            end
        end
        
        % Look for freq within toneRows, within tolerance
        for row = 1:length(toneRows)
            rowFreq = toneRows(row);
            if (freq >= rowFreq*(1-tolerance) && freq <= rowFreq*(1+tolerance))
               digitRow = row;
               break;
            end
        end
    end
    
    % If we couldn't match both a column and row, we don't have a digit.
    % Otherwise, use the column and row to assign the correct digit
    if (digitCol == 0 || digitRow == 0)
        digit = 0;
    else
        digit = digits(digitRow, digitCol);
    end
end