%% Function: exceedance
% This function takes, as parameters, a cell containing vectors of 
% waveheights, Hs is a vector containing the significant waveheight from 
% each run, and alpha is a vector containing exceedence ratios of H/Hs.


function exceeded = exceedance(heights,Hs,alpha)
    
    num_waves = length([heights{:}]); % total number of waves
    
    runs = length(Hs); % number of runs as indicated by length of
                       % Hs vector
    
    ratios = cell(1,runs); % make an empty cell to  be filled 
                           % with ratios
    
    for run = 1:runs
        % calculate ratios of H/Hs
        ratios{1,run} = heights{1,run}./Hs(run); 
                                                    
    end
    
    ratios = [ratios{:}];
   
    exceeded = zeros(length(alpha),1);

    for ii = 1:length(alpha)
    
    exceed_index = find(ratios > alpha(ii));
    
    % exceedence probability
    exceeded(ii) = length(exceed_index)/num_waves;
    
   
    end
    
    
end