%% Function: wave_heights2
% This function takes as vectors the surface profile (state), 
% the x coordinates (x), and the index of the zero crossings of the 
% vector state (crossing_index). 
% It returns the wave heights, crest heights, trough depths, 
% and wave periods.

function [heights,crests,troughs,periods] = ...
                                   wave_heights2(state, x, crossing_index)

    terminal = length(crossing_index); % last value of crss

    heights = zeros(1,terminal); % vector for filling with wave
                                 % heights
    crests = heights;            % same but for crests
    periods = heights;           % same but for periods
    troughs = heights;           % troughs
    
    % if the first crossing location has an index of 1, the code will
    % crash. Remove the opertunity for failure.
    
    if crossing_index(1) == 1
        
        crossing_index(1) = [];
        state(1) = [];
        x(1) = [];
        
    end

    if state(crossing_index(1) - 1) > 0 % downward zero crossing 

        ii = 1; % the count
        
        while ii + 2 < terminal 

            jj = ii + 2;

            begg = crossing_index(ii); % beginning of interval
            endi = crossing_index(jj); % end of interval
            
            % fill the heights
            heights(ii) = max(state(begg:endi)) - ... 
                          min(state(begg:endi));
            
            % fill the crests
            crests(ii) = max(state(begg:endi));  
            
            % fill troughs
            troughs(ii) = min(state(begg:endi)); 
            
            % fill periods
            periods(ii) = x(endi) - x(begg); 
            
            % A wave is between two successive zero crossings so
            % to get to the next wave, skip a zero crossing by adding 
            % two to the count
            ii = ii + 2; 

        end    

    else

        ii = 2; % first is upward zero crossing

        while ii + 2 < terminal

            jj = ii + 2;

            begg = crossing_index(ii); % beginning of interval
            endi = crossing_index(jj); % end of interval
            
            heights(ii-1) = max(state(begg:endi)) - ... 
                          min(state(begg:endi));
            
            crests(ii) = max(state(begg:endi)); 
            
            troughs(ii) = min(state(begg:endi)); 

            periods(ii-1) = x(endi) - x(begg);     

            ii = ii + 2; 

        end

    end

    % get rid of the zero values

    nope_H = find(heights == 0);
    nope_T = find(periods == 0);
    nope_C = find(crests == 0);
    nope_TR = find(troughs == 0);

    heights(nope_H) = [];
    periods(nope_T) = [];
    crests(nope_C) = [];
    troughs(nope_TR) = [];
    
end

