%% Function: find_zero_crss
% find_zero_crss finds the zero crossings in data.
% It interpolates to a higher resolution set by input dx and returns 
% the zero crossing locations in the new interpolated time series. 
% It also returns the new time series and the new x range for 
% plotting purposes. 

function [x_interp,state_interp,crss] = find_zero_crss(state, x, dx)

% first interpolate to higher resolution
x_interp = x(1):dx:x(end);

state_interp = pchip(x,state,x_interp);


% Find the zero crossings in the new series
sgn = sign(state_interp);
sgn_shift = [4, sgn(1:end-1)];

dff = sgn + sgn_shift;

% zero crossing point is crss
[~, crss] = find(dff == 0);

end