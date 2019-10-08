% This script pulls onsets and durations from the subjects structure created
% by the FP_MVPA_GetOnsetsDurations script and saves them as a .mat file to be
% used in MVPA FX models.
%
% K.DeStasio 2017-08-16

%% Load data and intialize variables
writeDir = '~/Documents/code/sanlab/CHIVES_scripts/fMRI/fx/multiconds/mvpa/money/multiconds/';
cd('~/Documents/code/sanlab/CHIVES_scripts/behavioral/money/');

exclude = [15 28 39 40 67 86 93 99 101 104]; % If you want to exclude any numbers, put them in this vector (e.g. exclude = [5 20];)
numSubs = 105;

studyName = 'CHIVES1';
%% Loop through subjects and runs and save names, onsets, and durations as .mat files
for s=1:numSubs
    if find(exclude==s)
    else
        %% Format subject numbers
        if s<10
            placeholder = '00';
        elseif s<100
            placeholder = '0';
        else placeholder = '';
        end
        %% Specify data file names
        filename=['Data.' placeholder num2str(s) '.2'];
        if exist([filename '.mat'])
            load([filename '.mat'])
            %% Pull onsets from the data files
            for a = 1:length(Data.FoodOnset)
                onsets{a} = cell2mat(Data.FoodOnset(a));
            end
            %% Create the names vector
            for b = 1:length(onsets)
                names{b} = strcat('trial',num2str(b));
            end
            %% Recode durations for all fixed conditions
            durations = onsets;
            for c = 1:length(onsets)
                durations{c} = 8;
            end
            %% Define output file name
            outputName = ['multicond_' studyName placeholder (num2str(s)),'.mat'];
            %% Save as .mat file and clear
            save([writeDir,outputName],'names','onsets','durations');
            clear names onsets durations a b c;
        end
    end
end

