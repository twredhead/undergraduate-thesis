%% Function: sea_state
% Takes a wavenumber vector, and two vectors of coefficients. 
% Requires spatial or time series start and end values.  
% Returns distance vector and state vector. 
% If using time xort = 0, if using space xort = 1.
function [x,state] = sea_state(an,bn,kn,x0,x_end,xort)

% make sure that an, bn, and kn are all column vectors
    [col_a,row_a] = size(an);
    [col_b,row_b] = size(bn);
    [col_k,row_k] = size(kn);

    if col_a == 1
       
        an = an';
   
    end

    if col_b == 1
   
        bn = bn';
    
    end

    if col_k == 1
   
        kn = kn';
    
    end
    
    k_max = max(kn); % find max k to determine dx
    
    if xort == 0
        
        dx = 1/(2*k_max); % calculates dt from frequency
    
    else
    
        dx = pi/k_max; % calculates dx from Nyquist wavenumber
    
    end
    
    x = x0:dx:x_end;
    
    waves = an.*cos(kn.*x) + bn.*sin(kn.*x);
    
    state = sum(waves);

end