%% Script: bootstrap_all
% This script calculates the exceedance probabilities from each set of wave
% heights. It also performs the bootstrapping calculation to determine 
% uncertainty ranges.


% files that need to be opened

file_handles = {'sim10e3_t1_kp2_A1.mat'...
               'sim10e3_t1_kp2_A7.mat'...
               'sim10e3_t1_kp3_A2.mat'...
               'sim10e3_t1_kp4_A3.mat'...
               'sim10e3_t1_kp6_A1.mat'...
               'sim10e3_t1500_kp2_A1.mat'...
               'sim10e3_t1500_kp2_A7.mat'...
               'sim10e3_t1500_kp3_A2.mat'...
               'sim10e3_t1500_kp4_A3.mat'...
               'sim10e3_t1500_kp6_A1.mat'};
           
% file names that are going to be made    
           
file_sve =  {'sim10e3_t1_kp2_A1_H_boot.mat'...
             'sim10e3_t1_kp2_A7_H_boot.mat'...
             'sim10e3_t1_kp3_A2_H_boot.mat'...
             'sim10e3_t1_kp4_A3_H_boot.mat'...
             'sim10e3_t1_kp6_A1_H_boot.mat'...
             'sim10e3_t1500_kp2_A1_H_boot.mat'...
             'sim10e3_t1500_kp2_A7_H_boot.mat'...
             'sim10e3_t1500_kp3_A2_H_boot.mat'...
             'sim10e3_t1500_kp4_A3_H_boot.mat'...
             'sim10e3_t1500_kp6_A1_H_boot.mat'};

 
% alpha = linspace(0.5,2.4,50)./1.76; %% use this alpha if using
                                     %%% crest heights 
alpha = linspace(0.5,2.4,50);

for file = 1:length(file_handles)
    
    % This can take a long time. It's nice to know when a file started
    t1 = clock;
    time =  datestr(t1,'dd-mmm-yyyy HH:MM:SS');
    
    fprintf('Running from %s.\n', sprintf(file_handles{file}))
    fprintf('Run started at %s.\n', sprintf(time))
    
    % open the data
    data = open(file_handles{file});
    
   
    HH = data.H; % wave heights
    Hs = data.Hs; % significant wave height
    
    % calculate the exceedance probabilities
    exceeds = exceedance(HH,Hs,alpha);
    
    % bootstrap the data
    [err_neg,err_pos,probs] = bootstrapper(HH,Hs,alpha);
    
    % these are the fields to be saved in the new file
    neg = err_neg;
    pos = err_pos;
    probMat = probs;
    prob = exceeds;
    
    % save the file
    save(file_sve{file},'neg','pos','probMat','prob')
    
    t2 = clock;
    time =  datestr(t2,'dd-mmm-yyyy HH:MM:SS');
    elapsed = etime(t2,t1)/3600;
    
    fprintf('Finished running %s.\n', sprintf(file_handles{file}))
    fprintf('File Saved as %s.\n', sprintf(file_sve{file}))
    fprintf('Run finished at %s.\n', sprintf(time))
    fprintf('The run took %.2f hours.\n', elapsed)
    fprintf('-----------------------------------------------------------\n')
   
   
end

fprintf('All files run.\n')
fprintf('-----------------------------------------------------------\n')
fprintf('-----------------------------------------------------------\n')