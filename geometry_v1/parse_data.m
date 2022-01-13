function [partitions, filename] = load_data(varargin)
    switch nargin
        case 1
            filename = varargin{1};
            [~, ~, TrialRecord, ~] = mlread(filename);
        otherwise
            [~, ~, TrialRecord, ~] = mlread();
    end

% Partition Indices
partitions.trials = TrialRecord.TrialErrors;
partitions.trial_i = 1:TrialRecord.CurrentTrialNumber;
partitions.conditions = TrialRecord.ConditionsPlayed;
partitions.CC_trials = logical(TrialRecord.User.CC_trials);
partitions.CL_trials = logical(TrialRecord.User.CL_trials);
partitions.blocks = TrialRecord.BlocksPlayed;
partitions.directions = TrialRecord.User.directions;
if length(partitions.directions) ~= length(partitions.trials)
    partitions.directions = [partitions.directions 0];
end

% Contexts
partitions.c1 = partitions.blocks == 1;
partitions.c2 = partitions.blocks == 2;

% Answers
partitions.correct = partitions.trials == 0;
partitions.alternative = partitions.trials == 1;
partitions.across = partitions.trials == 2;
partitions.random = partitions.trials == 3;

partitions.no_fix = partitions.trials == 4;
partitions.break_fix = partitions.trials == 5;
partitions.early_ans = partitions.trials == 6;
partitions.no_choice = partitions.trials == 7;

partitions.incorrect_CL = partitions.trials == 8;
partitions.correct_CL = partitions.trials == 9;

partitions.incorrect = logical(partitions.alternative + partitions.across + partitions.random);
partitions.official = logical(partitions.correct + partitions.incorrect);
partitions.CL_completed = logical(partitions.correct_CL + partitions.incorrect_CL);
partitions.all_completed = logical(partitions.official + partitions.CL_completed);

% Conditions
partitions.s1 = partitions.conditions == 1;
partitions.s2 = partitions.conditions == 2;
partitions.s3 = partitions.conditions == 3;
partitions.s4 = partitions.conditions == 4;
partitions.s5 = partitions.conditions == 5;
partitions.s6 = partitions.conditions == 6;
partitions.s7 = partitions.conditions == 7;
partitions.s8 = partitions.conditions == 8;

% Directions - By Code
partitions.up = partitions.directions == 1;
partitions.right = partitions.directions == 2;
partitions.down = partitions.directions == 3;
partitions.left = partitions.directions == 4;

% Directions - Radians
partitions.radians = partitions.directions;
partitions.radians(partitions.up) = pi/2;
partitions.radians(partitions.down) = 3*pi/2;
partitions.radians(partitions.left) = pi;
partitions.radians(partitions.right) = 0;
end