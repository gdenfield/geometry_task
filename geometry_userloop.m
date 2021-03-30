function [C,timingfile,userdefined_trialholder] = geometry_userloop(MLConfig,TrialRecord)
%MJP 11/11/2020

% Training variables
sequence_depth = 2; % Number of times each condition should be shown in a given trial sequence
CL_threshold = -3; % Number of errors for a given condition before starting correction loop
CL_depth = 3; % Number of times condition will be repeated in CL
n_fractals = 4; % 1-4, set to 4 for full set of fractals
%training = 5; % 1-8, SINGLE-CONDITION TRAINING, SEE CAPS COMMENT BELOW TOO!!
instructed_threshold = 5; % Adjust contrast after threshold errors in a row, only in CL

% Initialize ML variables
C = [];
timingfile = 'geometry_timingfile.m';
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
persistent block_length
persistent timing_filename_returned
if isempty(condition_correct) || TrialRecord.BlockChange %Reset counters if start of session or block change happened
    condition_correct = zeros(1,2*n_fractals);
    condition_incorrect = zeros(1,2*n_fractals);
    correct_counts = zeros(1,2*n_fractals);
    incorrect_counts = zeros(1,2*n_fractals);
    CL_counter = [0 0]; 
    CL_errors = 0;
    CL_trials = [];
    TrialRecord.User.contrast = 1;
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

image_list = {'stim_6.png','stim_8.png','stim_13.png', 'stim_17.png', 'cc_1.png', 'cc_2.png'};
conditions =... %Context 1: rows 1-4, Context 2: rows 5-8
   [1 5 up right down left;  % [stimulus ctx_cue target off_target1 off_target2 off_target3]
    3 5 down left up right;  % off_target1 = correct in other context
    2 5 right down left up;  % off_target2 = across FP from target
    4 5 left up right down;  % off_target3 = random guess
    1 6 right up left down;
    3 6 left down right up;
    2 6 down right up left;
    4 6 up left down right];

% Randomly select block if first trial
if isempty(TrialRecord.TrialErrors)
    first_context = 1;%randi([1,2]);
    context = first_context;
    TrialRecord.User.SC = 0; % for first call
end

% Switch Procedure
block_length = 100000; % Number of trials before context switch
if TrialRecord.CurrentTrialWithinBlock >= block_length
    if TrialRecord.User.SC_trials(end)
        TrialRecord.User.SC = 0;
        switch_test = randi([0,1]);
        disp('Switch Test: ')
        if switch_test
            disp('Success!')
            switch context
                case 1
                    context = 2;
                case 2
                    context = 1;
            end
        end
    else
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
if sum(condition_correct(1,(1:4)+( (context - 1) * 4))) == (sequence_depth * n_fractals)
    condition_correct = zeros(1,2 * n_fractals);
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
    condition = randi(n_fractals)+((context-1)*4);
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
    contrast = TrialRecord.User.contrast - 0.15;
%       %To reset counter after correct CL trials
%     if TrialRecord.TrialErrors(end) == 9
%         CL_errors = 0;
%     end
end

%chosen_condition = conditions(training,:); % SINGLE-CONDITION TRAINING, IF USING, COMMENT OUT NEXT LINE


% Set the stimuli
target_color = [255 255 255];
off_target_color = [contrast*255 contrast*255 contrast*255];

stimulus = image_list{chosen_condition(1)};
ctx_cue = image_list{chosen_condition(2)};
target_x = chosen_condition(3);
target_y = chosen_condition(4);
off1_x = chosen_condition(5);
off1_y = chosen_condition(6);
off2_x = chosen_condition(7);
off2_y = chosen_condition(8);
off3_x = chosen_condition(9);
off3_y = chosen_condition(10);

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
C(2).Radius = 0.5;     % visual angle
C(2).Color = [0 0 0];  % [R G B]
C(2).FillFlag = 1;
C(2).Xpos = 0;
C(2).Ypos = 0;

%3: stimulus
C(3).Type = 'pic';
C(3).Name = stimulus;
C(3).Xpos = 0;
C(3).Ypos = 0;
C(3).Colorkey = [0 0 0]; %sets black as transparent

%4: ctx_cue
C(4).Type = 'pic';
C(4).Name = ctx_cue;
C(4).Xpos = 0;
C(4).Ypos = 0;
C(4).Colorkey = [0 0 0]; %sets black as transparent

%5: target
C(5).Type = 'crc';
C(5).Radius = 0.1;     % visual angle
C(5).Color = target_color;  % [R G B]
C(5).FillFlag = 1;
C(5).Xpos = target_x;
C(5).Ypos = target_y;

%6: off_target1
C(6).Type = 'crc';
C(6).Radius = 0.1;     % visual angle
C(6).Color = off_target_color;  % [R G B]
C(6).FillFlag = 1;
C(6).Xpos = off1_x;
C(6).Ypos = off1_y;

%7: off_target2
C(7).Type = 'crc';
C(7).Radius = 0.1;     % visual angle
C(7).Color = off_target_color;  % [R G B]
C(7).FillFlag = 1;
C(7).Xpos = off2_x;
C(7).Ypos = off2_y;

%8: off_target3
C(8).Type = 'crc';
C(8).Radius = 0.1;     % visual angle
C(8).Color = off_target_color;  % [R G B]
C(8).FillFlag = 1;
C(8).Xpos = off3_x;
C(8).Ypos = off3_y;

%8: off_target3
C(9).Type = 'crc';
C(9).Radius = 3;     % visual angle
C(9).Color = [255 255 0];  % [R G B]
C(9).FillFlag = 1;
C(9).Xpos = 0;
C(9).Ypos = 0;

% Set the block number and the condition number of the next trial. Since
% this userloop function provides the list of TaskObjects and timingfile
% names, ML does not need the block/condition number. They are just for
% your reference.
% However, if TrialRecord.NextBlock is -1, the task ends immediately
% without running the next trial.
TrialRecord.NextBlock = context;
TrialRecord.NextCondition = condition;