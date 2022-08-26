%% Function: Coefficients
% This function takes a wave spectrum and either a difference in 
% wavenumber or a difference in frequency. Either will work. 
% The function returns two vectors of coefficients that can be used  
% to determine the surface profile associated with the spectrum.

function [an,bn] = coefficients(spectrum,dk)

    spectrum = spectrum.*dk; % due to discrete bandwidth of spectrum                        

    an = normrnd(0,sqrt(spectrum));
    bn = normrnd(0,sqrt(spectrum));

end