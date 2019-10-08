% This script pulls onsets and durations from the subject output files for
% WTP to create FX multicond files
%
% D.Cos 10/2018

%% Load data and intialize variables
inputDir = '~/Dropbox (PfeiBer Lab)/Devaluation/Tasks/WTP/output';
runNames = {'run1', 'run2', 'run3', 'run4'};
waveNames = {'1', '2'};
writeDir = '~/Documents/code/sanlab/DEV_scripts/fMRI/fx/multiconds/WTP/betaseries';
studyName = 'DEV';
filePattern = 'DEV.';
rowNum = -1;

% list files in input directory
runFiles = dir(sprintf('%s/*/*%s*.mat', inputDir, filePattern));
filesCell = struct2cell(runFiles);

% extract subject IDs
subjectID = unique(extractBetween(filesCell(1,:), 5,7));

% exclude test responses
excluded = subjectID(cellfun(@isempty,regexp(subjectID, '[0-2]{1}[0-9]{2}')));
subjectID = subjectID(~cellfun(@isempty,regexp(subjectID, '[0-2]{1}[0-9]{2}')));
fprintf(1, 'Excluded: %s\n', excluded{:})

% initialize table
eventtable  = cell2table(cell(0,9), 'VariableNames', {'subjectID', 'wave', 'run', 'foodpic', 'health', 'liking', 'liking_rating', 'bid', 'rt'});

%% Loop through subjects and runs and save names, onsets, and durations as .mat files
for i = 1:numel(subjectID)
    sub = subjectID{i};
    
    for j = 1:numel(waveNames)
        wave = waveNames{j};
        files = dir(fullfile(inputDir, sprintf('/%s%s/%s.%s.%s.mat', studyName, sub, studyName, sub, wave)));
        subFileName = {files.name};

        % log missing trial info
        trials{i+j+rowNum,1} = sprintf('%s%s', studyName, sub);
        trials{i+j+rowNum,2} = sprintf('%s', wave);

        %% Load text file
        if ~isempty(subFileName)
            subFile = sprintf('%s/%s%s/%s', inputDir, studyName, sub, subFileName{end}); %select the last file
            if exist(subFile)
                load(subFile);

                for k = 1:numel(runNames)
                    run = runNames{k};

                    % Check if run exists
                    if isfield(Data, (char(run))) && isfield(Data.(char(run)), 'FoodOnset')
                        %% Pull onsets
                        onsets = Data.(char(run)).FoodOnset;

                        %% Initialize names
                        for b = 1:length(onsets)
                            names{b} = strcat('trial',num2str(b));
                        end

                        %% Create durations
                        Data.(char(run)).RT(strcmp([Data.(char(run)).RT], 'NaN')) = {2.5}; % recode missing RTs as 2.5s
                        durations = num2cell([Data.(char(run)).FoodDuration{:}] + [Data.(char(run)).RT{:}]);

                        %% Define output file name
                        outputName = sprintf('%s%s_%s_WTP%d.mat', studyName, sub, wave, k);

                        %% Save as .mat file and clear
                        if ~exist(writeDir); mkdir(writeDir); end

                        if ~(isempty(onsets{1}) && isempty(onsets{2}))
                            save(fullfile(writeDir,outputName),'names','onsets','durations');
                        else
                            warning('File is empty. Did not save %s.', outputName);
                        end

                        %% Log missing trial info
                        trials{i+j+rowNum,k+2} = length(onsets);

                        %% Add subject data to table
                        tmp.subjectID = cell(length(Data.(char(run)).Cond),1);
                        tmp.subjectID(:) = {sprintf('%s%s', studyName, sub)};
                        tmp.wave = cell(length(Data.(char(run)).Cond),1);
                        tmp.wave(:) = {wave};
                        tmp.run = cell(length(Data.(char(run)).Cond),1);
                        tmp.run(:) = {run};
                        tmp.foodpic = Data.(char(run)).FoodPic';
                        tmp.health = Data.(char(run)).HealthCond';
                        tmp.liking = Data.(char(run)).LikingCond';
                        tmp.liking_rating = Data.(char(run)).LikingRating';
                        tmp.bid = Data.(char(run)).Resp';
                        tmp.rt = Data.(char(run)).RT';
                        runtable = struct2table(tmp);
                        eventtable = vertcat(eventtable, runtable);
                        
                        clear names onsets durations;
                    else
                        warning('Subject %s%s wave %s is missing %s', studyName, sub, wave, run)
                    end
                end
            end
        else
            warning('Unable to load subject %s%s wave %s.', studyName, sub, wave)
        end
    end
    rowNum = rowNum+1;
end
  
% save missing trial info
table = cell2table(trials,'VariableNames',[{'subjectID'}, {'wave'}, runNames{:}]);
writetable(table,fullfile(writeDir, 'trials.csv'),'Delimiter',',')
fprintf('\nTrial info saved in %s\n', fullfile(writeDir, 'trials.csv'))

% save event info
writetable(eventtable,fullfile(writeDir, 'events.csv'),'Delimiter',',')
fprintf('\nEvent info saved in %s\n', fullfile(writeDir, 'events.csv'))