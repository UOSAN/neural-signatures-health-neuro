% This script pulls onsets and durations from the subject output files for
% ROC to create FX multicond files
%
% D.Cos 10/2018

%% Load data and intialize variables
sub = '036';
inputDir = '~/Documents/code/sanlab/CHIVES_scripts/behavioral/picture';
runNames = {'R1', 'R2'}; % add runs names here
writeDir = '~/Documents/code/sanlab/CHIVES_scripts/fMRI/fx/multiconds/picture/betaseries';
studyName = 'CHIVES1';
filePattern = 'PIC_Picture';
nTrials = 40;

% list files in input directory
runFiles = dir(sprintf('%s/*PIC*.mat',inputDir));
filesCell = struct2cell(runFiles);

% initialize table
eventtable  = cell2table(cell(0,7), 'VariableNames', {'file', 'subjectID', 'wave', 'run', 'rating', 'rt', 'condition'});
wave = '1';

%% Load sub runs and save names, onsets, and durations as .mat files
files = dir(fullfile(inputDir, sprintf('%s_%s*.mat', sub, filePattern)));

% warn if there are not 2 files
if numel(files) ~= length(runNames)
    warning('Incorrect number of files. Subject %s has %d files.', sub, numel(files))
end

% log missing trial info
trials{1,1} = sprintf('%s%s', studyName, sub);

for j = 1:numel(runNames)
    %% Load text file
    run = runNames{j};
    if j == 2; run = 'R1'; end %second file is also R1
    runFile = dir(fullfile(inputDir, sprintf('%s_%s%s*.mat', sub, filePattern, run)));
    subFileName = {runFile.name};
    
    if ~isempty(subFileName)
        subFile = sprintf('%s/%s', inputDir, subFileName{j}); %select the last file

        if exist(subFile)
            load(subFile);

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
            trials{1,j+1} = length(onsets)-2;
            
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
        end
    else
        warning('Unable to load subject %s run %s.', sub, run);
    end
end

% save missing trial info
%missing(cellfun('isempty', missing)) = {NaN};
table = cell2table(trials,'VariableNames',[{'subjectID'}, runNames{:}]);
writetable(table,fullfile(writeDir, sprintf('trials_%s%s.csv', studyName, sub)),'Delimiter',',');
fprintf('\nTrial info saved in %s\n', fullfile(writeDir, sprintf('trials_%s%s.csv', studyName, sub)))

% save event info
writetable(eventtable,fullfile(writeDir, sprintf('events_%s%s.csv', studyName, sub)),'Delimiter',',')
fprintf('\nEvent info saved in %s\n', fullfile(writeDir, sprintf('events_%s%s.csv', studyName, sub)))