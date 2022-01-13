function [C,timingfile,userdefined_trialholder] = geometry_userloop(MLConfig,TrialRecord)
%MJP 11/11/2020

% Training variables
block_length = 3000; % Number of trials before context switch
sequence_depth = 2; % Number of times each condition should be shown in a given trial sequence
CL_threshold = -3; % Number of errors for a given condition before starting correction loop
CL_depth = 1; % Number of times condition will be repeated in CL
n_stimuli = 4; % 1-4, set to 4 for full set of stimuli
%training = 5; % 1-8, SINGLE-CONDITION TRAINING, SEE CAPS COMMENT BELOW TOO!!
instructed_threshold = 5; % Adjust contrast after threshold errors in a row, only in CL

% Initialize ML variables
C = [];
timingfile = 'colors_timingfile.m';
userdefined_trialholder = '';

persistent condition_correct % number of time each fractal has been completed successfully
persistent condition_incorrect % number of errors for condition
persistent correct_counts % running tally correct of answers
persistent incorrect_counts % running tally of incorrect answers
persistent CL_counter % [number of repeats left in CL, condition number]
persistent CL_errors % counts mistakes within correction loop
persistent CL_trials
persistent first_context
persistent context
persistent timing_filename_returned
if isempty(condition_correct) || TrialRecord.BlockChange %Reset counters if start of session or block change happened
    condition_correct = zeros(1,2*n_stimuli);
    condition_incorrect = zeros(1,2*n_stimuli);
    correct_counts = zeros(1,2*n_stimuli);
    incorrect_counts = zeros(1,2*n_stimuli);
    CL_counter = [0 0]; 
    CL_errors = 0;
    CL_trials = [];
    TrialRecord.User.contrast = 1;
    TrialRecord.User.switch = 0;
    TrialRecord.User.block_length = block_length;
end
if isempty(timing_filename_returned)
    timing_filename_returned = true;
    return
end

contrast = TrialRecord.User.contrast; % 0-1 for off-target FPs
TrialRecord.User.correct_counts = correct_counts;
TrialRecord.User.incorrect_counts = incorrect_counts;

% Trial Conditions
target_distance = 7; %degrees from center, for all target locations (up, right, down, left)
up = [0 target_distance];
right = [target_distance 0];
down = [0 -target_distance];
left = [-target_distance 0];

color_list = {[255 0 0],[255 128 0],[255 255 0],[128 255 0], [0 255 255], [255 0 255]}; %1-4 for stimuli, 5-6 for CCs
conditions =... %Context 1: rows 1-4, Context 2: rows 5-8
   [1 2 3 4 5 up right down left;  % [stimulus ot1 ot2 ot3 ctx_cue target_pos ot1_pos ot2_pos ot3_pos]
    2 3 4 1 5 right down left up;  % off_target1 = correct in other context
    3 4 1 2 5 down left up right;  % off_target2 = across FP from target
    4 1 2 3 5 left up right down;  % off_target3 = random guess
    1 2 3 4 6 right up left down;
    2 3 4 1 6 down right up left;
    3 4 1 2 6 left down right up;
    4 1 2 3 6 up left down right];

% Randomly select block if first trial
if isempty(TrialRecord.TrialErrors)
    first_context = 1;%randi([1,2]);
    context = first_context;
    TrialRecord.User.SC = 0; % for first call
end

% Switch Procedure
disp(['Trials Left in Block: ' num2str(TrialRecord.User.block_length - TrialRecord.CurrentTrialWithinBlock)])
if TrialRecord.CurrentTrialWithinBlock >= TrialRecord.User.block_length || TrialRecord.User.switch == 1
    if TrialRecord.User.SC_trials(end) && ismember(TrialRecord.TrialErrors(end), [0 1 2 3 8 9]) % If just completed SC trial
        TrialRecord.User.SC = 0; % Don't give SC trial, but determine if switch will occur
        switch_test = randi([0,1]);
        if switch_test
            switch context
                case 1
                    context = 2;
                    condition_incorrect(1:4) = 0;
                case 2
                    context = 1;
                    condition_incorrect(5:8) = 0;
            end
            TrialRecord.User.switch = 0;
        end
    else % Give SC trial
        TrialRecord.User.SC = 1;
    end
end

%Increase sequence counter based on last trial
try
    if TrialRecord.TrialErrors(end)==0 && CL_counter(1)==0 %don't count CL trials as correct
        condition_correct(TrialRecord.CurrentCondition) = condition_correct(TrialRecord.CurrentCondition)+1;
        correct_counts(TrialRecord.CurrentCondition) = correct_counts(TrialRecord.CurrentCondition)+1;
        condition_incorrect(TrialRecord.CurrentCondition) = 0; % Reset incorrect count if correct trial is performed, remove this line to have cumulative CL criteria
        disp(['condition correct: ' num2str(condition_correct)])
    elseif ismember(TrialRecord.TrialErrors(end), [1 2 3]) && CL_counter(1)==0
        condition_incorrect(TrialRecord.CurrentCondition) = condition_incorrect(TrialRecord.CurrentCondition)-1;
        incorrect_counts(TrialRecord.CurrentCondition) = incorrect_counts(TrialRecord.CurrentCondition)-1;
        disp(['condition incorrect: ' num2str(condition_incorrect)])
        disp(['incorrect counts: ' num2str(incorrect_counts)])
    end
    
    %Initiate CL, if needed
    if condition_incorrect(TrialRecord.CurrentCondition) == CL_threshold
        condition_incorrect(TrialRecord.CurrentCondition) = 0; % Reset error count
        CL_counter = [CL_depth TrialRecord.CurrentCondition];
        CL_errors = 0;
    end
catch    
end

%Reset sequence count if each fractal has been encountered enough times
if sum(condition_correct(1,(1:4)+( (context - 1) * 4))) == (sequence_depth * n_stimuli)
    condition_correct = zeros(1,2 * n_stimuli);
end

%Update CL_counter
try
    if TrialRecord.TrialErrors(end)==9
        CL_counter(1) = CL_counter(1)-1;
        if CL_counter(1) == 0
            CL_errors = 0;
            disp('CL Over')
        else
            disp(['CL trials left: ' num2str(CL_counter(1))])
        end
    elseif TrialRecord.TrialErrors(end)==8
        CL_counter(1) = CL_depth; % Require n correct in a row to exit CL
        CL_errors = CL_errors + 1;
        disp(['CL errors: ' num2str(CL_errors)])
    end
catch
end

try % Reset CL_counter and CL_errors if switch occurred during CL
    if switch_test
        CL_counter = [0 0];
        CL_errors = 0;
    end
catch
end

%Enter CL if criteria are met
if CL_counter(1) ~= 0
    condition = CL_counter(2);
    chosen_condition = conditions(condition,:);
    TrialRecord.User.CL = 1;
    CL_trials = [CL_trials 1];
    pick_condition = 0;
else
    pick_condition = 1;
end

%Pick fractal
while pick_condition
    condition = randi(n_stimuli)+((context-1)*4);
    if condition_correct(condition) < sequence_depth
        chosen_condition = conditions(condition,:);
        pick_condition = 0;
        TrialRecord.User.CL = 0;
        CL_trials = [CL_trials 0];
    end
end

TrialRecord.User.CL_trials = CL_trials;

%Adjust contrast on instructed trials within CL
if CL_errors >= instructed_threshold
    contrast = TrialRecord.User.contrast - 0.2;
%       %To reset counter after correct CL trials
%     if TrialRecord.TrialErrors(end) == 9
%         CL_errors = 0;
%     end
end

%chosen_condition = conditions(training,:); % SINGLE-CONDITION TRAINING, IF USING, COMMENT OUT NEXT LINE


% Set the stimuli
stimulus = color_list{chosen_condition(1)};
ot1 = color_list{chosen_condition(2)};
ot2 = color_list{chosen_condition(3)};
ot3 = color_list{chosen_condition(4)};
ctx_cue = color_list{chosen_condition(5)};
target_x = chosen_condition(6);
target_y = chosen_condition(7);
off1_x = chosen_condition(8);
off1_y = chosen_condition(9);
off2_x = chosen_condition(10);
off2_y = chosen_condition(11);
off3_x = chosen_condition(12);
off3_y = chosen_condition(13);

% TaskObjects:
%1: fixation_point
C(1).Type = 'crc';
C(1).Radius = 0.1;     % visual angle
C(1).Color = [255 255 255];  % [R G B]
C(1).FillFlag = 1;
C(1).Xpos = 0;
C(1).Ypos = 0;

%2: FP_background
C(2).Type = 'crc';
C(2).Radius = 0.3;     % visual angle
C(2).Color = [0 0 0];  % [R G B]
C(2).FillFlag = 1;
C(2).Xpos = 0;
C(2).Ypos = 0;

%3: stimulus
C(3).Type = 'crc';
C(3).Radius = 2.5;
C(3).Color = stimulus;
C(3).Xpos = 0;
C(3).Ypos = 0;
C(3).Colorkey = [0 0 0]; %sets black as transparent

%4: ctx_cue
C(4).Type = 'crc';
C(4).Radius = 12;
C(4).Color = ctx_cue;
C(4).FillFlag = 0;
C(4).Xpos = 0;
C(4).Ypos = 0;

%5: target
C(5).Type = 'crc';
C(5).Radius = 0.2;     % visual angle
C(5).Color = stimulus;  % [R G B]
C(5).FillFlag = 1;
C(5).Xpos = target_x;
C(5).Ypos = target_y;

%6: off_target1
C(6).Type = 'crc';
C(6).Radius = 0.2;     % visual angle
C(6).Color = contrast*ot1;  % [R G B]
C(6).FillFlag = 1;
C(6).Xpos = off1_x;
C(6).Ypos = off1_y;

%7: off_target2
C(7).Type = 'crc';
C(7).Radius = 0.2;     % visual angle
C(7).Color = contrast*ot2;  % [R G B]
C(7).FillFlag = 1;
C(7).Xpos = off2_x;
C(7).Ypos = off2_y;

%8: off_target3
C(8).Type = 'crc';
C(8).Radius = 0.2;     % visual angle
C(8).Color = contrast*ot3;  % [R G B]
C(8).FillFlag = 1;
C(8).Xpos = off3_x;
C(8).Ypos = off3_y;

% Set the block number and the condition number of the next trial. Since
% this userloop function provides the list of TaskObjects and timingfile
% names, ML does not need the block/condition number. They are just for
% your reference.
% However, if TrialRecord.NextBlock is -1, the task ends immediately
% without running the next trial.
TrialRecord.NextBlock = context;
TrialRecord.NextCondition = condition;