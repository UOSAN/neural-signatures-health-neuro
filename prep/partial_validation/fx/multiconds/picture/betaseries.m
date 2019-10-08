% This script pulls onsets and durations from the subject output files for
% ROC to create FX multicond files
%
% D.Cos 10/2018

%% Load data and intialize variables
inputDir = '~/Documents/code/sanlab/CHIVES_scripts/behavioral/picture';
runNames = {'R1', 'R2'}; % add runs names here
writeDir = '~/Documents/code/sanlab/CHIVES_scripts/fMRI/fx/multiconds/picture/betaseries';
studyName = 'CHIVES1';
filePattern = 'PIC_Picture';
nTrials = 40;

% list files in input directory
runFiles = dir(sprintf('%s/*PIC*.mat',inputDir));
filesCell = struct2cell(runFiles);

% extract subject IDs
subjectID = unique(extractBetween(filesCell(1,:), 1,3));

% exclude test responses
subjectID = subjectID(~cellfun(@isempty,regexp(subjectID, '[0-2]{1}[0-9]{2}')));

% initialize table
eventtable  = cell2table(cell(0,7), 'VariableNames', {'file', 'subjectID', 'wave', 'run', 'rating', 'rt', 'condition'});
wave = '1';

%% Loop through subjects and runs and save names, onsets, and durations as .mat files
for i = 1:numel(subjectID)
    sub = subjectID{i};
    files = dir(fullfile(inputDir, sprintf('%s_%s*.mat', sub, filePattern)));
    
    % warn if there are not 2 files
    if numel(files) ~= length(runNames)
        warning('Incorrect number of files. Subject %s has %d files.', sub, numel(files))
    end
    
    % log missing trial info
    trials{i,1} = sprintf('%s%s', studyName, sub);
    
    for j = 1:numel(runNames)
        %% Load text file
        run = runNames{j};
        runFile = dir(fullfile(inputDir, sprintf('%s_%s%s*.mat', sub, filePattern, run)));
        subFileName = {runFile.name};
        
        if ~isempty(subFileName)
            subFile = sprintf('%s/%s', inputDir, subFileName{end}); %select the last file

            if exist(subFile)
                load(subFile);
                
                % Error if the behavioral version was run instead of the
                % scan version
                if ~contains(run_info.stimulus_input_file, 'beh')

                    %% Pull onsets and durations
                    % Trials
                    idxs_all = find(~cellfun(@isempty,run_info.tag(:,1)));
                    idxs_image = idxs_all(2:3:length(idxs_all));
                    durations = repelem({5}, length(idxs_image));
                    durations([durations{:}] == 0) = []; % remove incomplete trials
                    onsets = num2cell(run_info.onsets(idxs_image));
                    %onsets([onsets{:}] == 0) = []; % remove incomplete trials
                    onsets = onsets(1:length(durations)); % remove incomplete trials to match durations

                    % Instructions
                    idxs_instructions = idxs_all(1:3:length(idxs_all));
                    durations{length(durations)+1} = repelem(2, length(idxs_instructions))';
                    durations{length(durations)}(durations{length(durations)}(:) == 0) = []; % remove incomplete trials

                    onsets{length(onsets)+1} = run_info.onsets(idxs_instructions)';
                    %onsets{length(onsets)}(onsets{length(onsets)}(:) == 0) = []; % remove incomplete trials
                    onsets{length(onsets)} = onsets{length(onsets)}(1:length(durations{length(durations)})); % remove incomplete trials to match durations

                    % Ratings
                    idxs_ratings = idxs_all(3:3:length(idxs_all));
                    ratings = run_info.responses(idxs_ratings)';
                    onsets{length(onsets)+1} = run_info.onsets(idxs_ratings)';
                    onsets{length(onsets)}(onsets{length(onsets)}(:) == 0) = []; % remove incomplete trials
                    durations{length(durations)+1} = run_info.rt(idxs_ratings)';
                    if length(durations{length(durations)}) > length(onsets{length(onsets)})
                        durations{length(durations)} = durations{length(durations)}(1:length(onsets{length(onsets)})); % remove incomplete trials
                    end

                    %% Initialize names
                    % Trials
                    for b = 1:length(onsets)-2
                        names{b} = strcat('trial',num2str(b));
                    end

                    % Instructions
                    names{length(names)+1} = 'instructions';

                    % Ratings
                    names{length(names)+1} = 'ratings';

                    %% Define output file name
                    outputName = sprintf('%s%s_ROC%d.mat', studyName, sub, j);

                    %% Save as .mat file and clear
                    if ~exist(writeDir); mkdir(writeDir); end

                    if ~(isempty(onsets{1}) && isempty(onsets{2}))
                        save(fullfile(writeDir,outputName),'names','onsets','durations');
                    else
                        warning('File is empty. Did not save %s.', outputName);
                    end

                    %% Log missing trial info
                    trials{i,j+1} = length(onsets)-2;

                    %% Add subject data to table
                    % pull data
                    tmp.file = cell(length(run_info.responses(idxs_ratings)),1);
                    tmp.file(:) = {subFileName(end)};
                    tmp.subjectID = cell(length(run_info.responses(idxs_ratings)),1);
                    tmp.subjectID(:) = {sprintf('%s%s', studyName, sub)};
                    tmp.wave = cell(length(run_info.responses(idxs_ratings)),1);
                    tmp.wave(:) = {wave};
                    tmp.run = cell(length(run_info.responses(idxs_ratings)),1);
                    tmp.run(:) = {run};
                    tmp.rt = run_info.rt(idxs_ratings)';
                    tmp.condition = run_info.tag(idxs_ratings);

                    % replace missing values if response during
                    % fixation
                    ratings = run_info.responses(idxs_ratings);
                    fixationRatings = run_info.responses(idxs_ratings+1);
                    missingRatings = find(cellfun(@isempty,ratings));
                    ratings(missingRatings) = fixationRatings(missingRatings);
                    tmp.rating = ratings';

                    % convert to table
                    runtable = struct2table(tmp);
                    eventtable = vertcat(eventtable, runtable);

                    clear names onsets durations;
                else
                    warning('Behavioral version of task was run for subject %s wave %s %s.', sub, wave, run)
                end
            end
        else
            warning('Unable to load subject %s run %s.', sub, run);
        end
    end
end
  
% save missing trial info
%trials(cellfun('isempty', trials)) = {NaN};
table = cell2table(trials,'VariableNames',[{'subjectID'}, runNames{:}]);
writetable(table,fullfile(writeDir, 'trials.csv'),'Delimiter',',')
fprintf('\nTrial info saved in %s\n', fullfile(writeDir, 'trials.csv'))

% save event info
writetable(eventtable,fullfile(writeDir, 'events.csv'),'Delimiter',',')
fprintf('\nEvent info saved in %s\n', fullfile(writeDir, 'events.csv'))