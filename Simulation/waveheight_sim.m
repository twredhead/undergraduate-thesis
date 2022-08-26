%% Script: waveheight_sim
% This script calls various functions to simulate wave heights 
% from pre-made wave height spectrum files. This script loops over
% each file twice, to simulate waves from the initial spectrum and 
% final spectrum from each file.

% This is the simulation

% Name all file handles 
% These are the files containing the spectra used in the simulation.
handles_opn = {'ExpSpectra_nos_R9700_kp200_A100.mat'...
           'ExpSpectra_nos_R9700_kp200_A100.mat'...
           'ExpSpectra_nos_R9700_kp300_A200.mat'...
           'ExpSpectra_nos_R9700_kp300_A200.mat'...
           'ExpSpectra_nos_R9700_kp400_A300.mat'...
           'ExpSpectra_nos_R9700_kp400_A300.mat'...
           'ExpSpectra_nos_R9700_kp600_A100.mat'...
           'ExpSpectra_nos_R9700_kp600_A100.mat'};

% Save names for files

handles_sve = {'sim10e3_t1_kp2_A1.mat'...
           'sim10e3_t1500_kp2_A1.mat'...
           'sim10e3_t1_kp3_A2.mat'...
           'sim10e3_t1500_kp3_A2.mat'...
           'sim10e3_t1_kp4_A3.mat'...
           'sim10e3_t1500_kp4_A3.mat'...
           'sim10e3_t1_kp6_A1.mat'...
           'sim10e3_t1500_kp6_A1.mat'};

%%
% Run for each spectrum
times = [1,4];
for jj = 1:length(handles_opn)   

t1 = clock; % this code would take upwards of 20 hours to run a 
            % simulation so it was nice to have some idea when things
            % started and stopped.
time =  datestr(t1,'dd-mmm-yyyy HH:MM:SS');

% open the mat file containing the spectrum
file = open(handles_opn{jj});

% print file currently running
fprintf('Now running from %s\n', sprintf(handles_opn{jj}))
fprintf('Run started at %s.\n', sprintf(time))

Spec_surf = file.Spec_surf; % spectrum at four different times
waveNumber = file.wave_number;

dk = mean(diff(waveNumber)); % these wave numbers are not evenly 
                             % spaced. However, they are nearly evenly 
                             % spaced so I took the mean of the 
                             % differences as dk.


dk = dk/30; % this will set the number of coefficients.

kn = min(waveNumber):dk:max(waveNumber); % kn values for making coeffs.

% This if statement determines if the spectrum used should be
% the evolved spectrum or the initial spectrum
if rem(jj,2) == 0 

    tt = 4;
    spect = interp1(waveNumber,Spec_surf(tt,:),kn); % spectrum

else

    tt = 1;
    spect = interp1(waveNumber,Spec_surf(tt,:),kn);

end

x_start = 0;
x_end = 1000;

num_runs = 10e3; % number of runs

sig_heights = zeros(num_runs,1); % this is where significant wave 
                                 % heights are stored.

heights_container = cell(1,num_runs); % this is a cell that contains 
                                      % vectors with each wave height.

crests_container = cell(1,num_runs); % cell that contains vectors with 
                                     % each crest height

periods_container = cell(1,num_runs); % same but for periods

troughs_container = cell(1,num_runs); % troughs

% start the simulation

rng 'default' % At the beginning of each simulation set the seed to be
              % the same.

for ii = 1:num_runs

    [an,bn] = coefficients(spect,dk); % coefficients

    [x,state] = sea_state(an,bn,kn,x_start,x_end,1); % sea state and 
                                                     % distance 
                                                     % vector

    % dx for interpolation required for finding zero crossings
    dx = mean(diff(x))/100;

    % interpolated state and x with zero crossing locations crss
    [x_new,state_new,crss] = find_zero_crss(state,x,dx);

    Hs = 4*std(state_new); % significant wave height

    sig_heights(ii) = Hs;

    % heights and periods (periods are spatial)
    [heights,crests,troughs,periods] = wave_heights2...
                                       (state_new, x_new,crss);

    % stored heights from run
    heights_container{ii} = heights;

    % store crests from run
    crests_container{ii} = crests;

    % store troughs from run
    troughs_container{ii} = troughs;

    % stored periods from run
    periods_container{ii} = periods;

end

% These are the fields to be saved in the data file
H = heights_container;
C = crests_container;
TR = troughs_container;
Hs = sig_heights;
T = periods_container;


t2 = clock;
time =  datestr(t2,'dd-mmm-yyyy HH:MM:SS');
elapsed = etime(t2,t1)/3600;

% save the data
save(handles_sve{jj},'H','Hs','C','T','TR')
fprintf('Finished running %s\n', sprintf(handles_opn{jj}))
fprintf('File Saved as %s\n', sprintf(handles_sve{jj}))
fprintf('Run finished at %s.\n', sprintf(time))
fprintf('The run took %.2f hours.\n', elapsed)
fprintf('-----------------------------------------------------------\n')

end

fprintf('All files run \n')
