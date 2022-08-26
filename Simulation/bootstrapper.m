%% Function: bootstrapper
% This function takes data as a cell (H), and as a vector (Hs), and a
% vector of exceedance values (alpha). The data, H, is bootstrapped.
% The function returns the 75th and 25th percentiles of the data based on
% the values of the surrogate data.

function [err_neg, err_pos, probs] = bootstrapper(H,Hs,alpha)

    run_num = length(Hs); % number of different runs

    H = [H{:}]; % vector of all wave heights
    Hs = mean(Hs); % mean of Hs

    samp_size = length(H); % determines how many samples to take

    alpha_size = length(alpha); % determines the number of columns of the 
                                % probability matrix

    samp_frac = round(0.75*samp_size); % number of samples to be taken 
                                       % from data

    probs = zeros(run_num,alpha_size); % initialize probability matrix
    
    % fill the probability matrix
    for jj = 1:run_num

        H_jj = datasample(H,samp_frac); % datasample

        exceeded = exceedance_boot(H_jj,Hs,alpha); % exeedance probs

        probs(jj,:) = exceeded; % each row of probs is filled with the 
                                % exceedance probabilities calculated in
                                % the line above.

    end
    
    % These are returned. They are the top and bottom of the 
    % error bars.
    % The true value should be somewhere between the 25th and 75th
    % percentile.
    err_pos = prctile(probs,75,1); 
    err_neg = prctile(probs,25,1);
