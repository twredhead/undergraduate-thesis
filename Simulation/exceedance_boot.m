%% Function: exceedance_boot
% This function is identical to exceedance, but it takes H as a vector
% instead of a cell and Hs as a single value.

function exceeded = exceedance_boot(heights,Hs,alpha)
    
    num_waves = length(heights); % total number of waves
     
    ratios = heights./Hs;
   
    exceeded = zeros(1,length(alpha));

    for ii = 1:length(alpha)
    
    exceed_index = find(ratios > alpha(ii));
    
    %exceedence probability
    exceeded(ii) = length(exceed_index)/num_waves;
    
    end
    
    
end