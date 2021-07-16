% New version of task for geometry project MJP 07/15/21

function [C,timingfile,userdefined_trialholder] = geometry_userloop(MLConfig,TrialRecord)
% Training Variables
block_length = 15; % Number of trials before context switch
sequence_depth = 2; % Number of times each condition should be shown in a given trial sequence
n_fractals = 4; % 1-4, set to 4 for full set of fractals

% Initialization
C = [];
timingfile = 'geometry_2_timingfile.m';
userdefined_trialholder = '';
persistent trials_left_in_sequence % number of time each fractal has been completed successfully
persistent correct_counts % running tally correct of answers
persistent incorrect_counts % running tally of incorrect answers
persistent first_context
persistent context
persistent timing_filename_returned
if isempty(trials_left_in_sequence) || TrialRecord.BlockChange %Reset counters if start of session or block change happened
    trials_left_in_sequence = sequence_depth + zeros(1,2*n_fractals);
    correct_counts = zeros(1,2*n_fractals);
    incorrect_counts = zeros(1,2*n_fractals);
    TrialRecord.User.contrast = 1;
    TrialRecord.User.switch = 0;
    TrialRecord.User.block_length = block_length;
end
if isempty(timing_filename_returned)
    timing_filename_returned = true;
    return
end
TrialRecord.User.correct_counts = correct_counts;
TrialRecord.User.incorrect_counts = incorrect_counts;

% Experimental conditions
target_distance = 7; %degrees from center, for all target locations (up, right, down, left)
up = [0 target_distance];
right = [target_distance 0];
down = [0 -target_distance];
left = [-target_distance 0];

target_color = [255 255 255];
conditions =... %Context 1: rows 1-4, Context 2: rows 5-8
   [1 5;  % [stimulus ctx_cue]
    2 5;
    3 5;
    4 5;
    1 6;
    2 6;
    3 6;
    4 6];

% Randomly select block if first trial
if isempty(TrialRecord.TrialErrors)
    first_context = 1;%randi([1,2]);
    context = first_context;
    TrialRecord.User.SC = 0;
end

% Switch Procedure
if TrialRecord.CurrentTrialWithinBlock >= TrialRecord.User.block_length || TrialRecord.User.switch == 1
    %sc_color = [160 160 160];
    TrialRecord.User.SC = 1; % Don't give SC trial, but determine if switch will occur
    switch_test = randi([0,1]);
    if switch_test
        switch context
            case 1
                context = 2;
            case 2
                context = 1;
        end
        trials_left_in_sequence = sequence_depth + zeros(1,2*n_fractals);
        TrialRecord.User.switch = 0;
    end
else
    %sc_color = [255 255 255];
    TrialRecord.User.SC = 0;
end

% Increase sequence counter based on last trial
if ~isempty(TrialRecord.TrialErrors)
    if TrialRecord.TrialErrors(end)==0
        trials_left_in_sequence(TrialRecord.CurrentCondition) = trials_left_in_sequence(TrialRecord.CurrentCondition)-1;
        correct_counts(TrialRecord.CurrentCondition) = correct_counts(TrialRecord.CurrentCondition)+1;
    elseif ismember(TrialRecord.TrialErrors(end), [1 2 3 4])
        trials_left_in_sequence(TrialRecord.CurrentCondition) = trials_left_in_sequence(TrialRecord.CurrentCondition)+1;
        incorrect_counts(TrialRecord.CurrentCondition) = incorrect_counts(TrialRecord.CurrentCondition)+1;
    end
end
    
disp(['     trials left: ' num2str(trials_left_in_sequence(1:4)) ' || ' num2str(trials_left_in_sequence(5:8))])
disp(['  correct counts: ' num2str(correct_counts(1:4)) ' || ' num2str(correct_counts(5:8))])
disp(['incorrect counts: ' num2str(incorrect_counts(1:4)) ' || ' num2str(incorrect_counts(5:8))])

%Reset sequence count if each fractal has been encountered enough times
if sum(trials_left_in_sequence(1,(1:4)+( (context - 1) * 4))) == 0
    trials_left_in_sequence = sequence_depth + zeros(1,2*n_fractals);
end

%Pick fractal
while true
    condition = randi(n_fractals)+((context-1)*4);
    if trials_left_in_sequence(condition) ~= 0
        chosen_condition = conditions(condition,:);
        break
    end
end

% Stimuli
image_list = {'stim_21.png','stim_81.png','stim_82.png', 'stim_95.png', 'cc_1.png', 'cc_2.png'};
stimulus = image_list{chosen_condition(1)};
ctx_cue = image_list{chosen_condition(2)};

% TaskObjects:
%1: switch_cue
C(1).Type = 'crc';
C(1).Radius = 7;     % visual angle
C(1).Color = [255 0 0];  % [R G B]
C(1).FillFlag = 1;
C(1).Xpos = 0;
C(1).Ypos = 0;

%2: fixation_point
C(2).Type = 'crc';
C(2).Radius = 0.1;     % visual angle
C(2).Color = [255 255 255];  % [R G B]
C(2).FillFlag = 1;
C(2).Xpos = 0;
C(2).Ypos = 0;

%3: FP_background
C(3).Type = 'crc';
C(3).Radius = 0.5;     % visual angle
C(3).Color = [0 0 0];  % [R G B]
C(3).FillFlag = 1;
C(3).Xpos = 0;
C(3).Ypos = 0;

%4: stimulus
C(4).Type = 'pic';
C(4).Name = stimulus;
C(4).Xpos = 0;
C(4).Ypos = 0;
C(4).Colorkey = [0 0 0]; %sets black as transparent

%5: ctx_cue
C(5).Type = 'pic';
C(5).Name = ctx_cue;
C(5).Xpos = 0;
C(5).Ypos = 0;
C(5).Colorkey = [0 0 0]; %sets black as transparent

%6: up
C(6).Type = 'crc';
C(6).Radius = 0.1;     % visual angle
C(6).Color = target_color;  % [R G B]
C(6).FillFlag = 1;
C(6).Xpos = up(1);
C(6).Ypos = up(2);

%7: right
C(7).Type = 'crc';
C(7).Radius = 0.1;     % visual angle
C(7).Color = target_color;  % [R G B]
C(7).FillFlag = 1;
C(7).Xpos = right(1);
C(7).Ypos = right(2);

%8: down
C(8).Type = 'crc';
C(8).Radius = 0.1;     % visual angle
C(8).Color = target_color;  % [R G B]
C(8).FillFlag = 1;
C(8).Xpos = down(1);
C(8).Ypos = down(2);

%9: left
C(9).Type = 'crc';
C(9).Radius = 0.1;     % visual angle
C(9).Color = target_color;  % [R G B]
C(9).FillFlag = 1;
C(9).Xpos = left(1);
C(9).Ypos = left(2);

TrialRecord.NextBlock = context;
TrialRecord.NextCondition = condition;
end