% New version of task for geometry project MJP 07/15/21

function [C,timingfile,userdefined_trialholder] = geometry_userloop(MLConfig,TrialRecord)
% Training Variables
block_length = 50; % Number of trials before context switch
sequence_depth = 2; % Number of times each condition should be shown in a given trial sequence
n_fractals = 4; % 1-4, set to 4 for full set of fractals

% Initialization
C = [];
timingfile = 'geometry_3_timingfile.m';
userdefined_trialholder = '';
persistent trials_left_in_sequence % number of time each fractal has been completed successfully
persistent CL_trials % index of CL trials
persistent correct_counts % running tally correct of answers
persistent incorrect_counts % running tally of incorrect answers
persistent first_context
persistent context
persistent timing_filename_returned
if isempty(trials_left_in_sequence) || TrialRecord.BlockChange %Reset counters if start of session or block change happened
    trials_left_in_sequence = sequence_depth + zeros(1,2*n_fractals);
    correct_counts = zeros(1,2*n_fractals);
    incorrect_counts = zeros(1,2*n_fractals);
    CL_trials = 0;
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
    first_context = randi([1,2]);
    context = first_context;
    TrialRecord.User.SC = 0;
    TrialRecord.User.CL_trials = [];
end


% Switch Procedure
threshold = 0.75; % Hit rate
window = 8; % trials
ncl = ~TrialRecord.User.CL_trials; %non-correction-loop trials
completed = ismember(TrialRecord.TrialErrors, 0:4);
A = TrialRecord.TrialErrors(ncl&completed) == 0;
B = smoothdata(A,'gaussian',window);
above = B>threshold;
if length(above) > window
    criterion = isequal(above(end-window+1:end), ones(1,window));
    disp(['Criterion Performance: ' num2str(sum(above(end-window+1:end))) ' of ' num2str(window)])
else
    criterion = 0;
end

if ((TrialRecord.CurrentTrialWithinBlock >= TrialRecord.User.block_length && criterion) || TrialRecord.User.switch == 1 ) && TrialRecord.TrialErrors(end)==0
    TrialRecord.User.SC = 1; % SC on
    TrialRecord.User.switch = 1; % once triggered, stay triggered!
    switch_test = randi([0,1]); % Determine if actual switch will occur
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
    TrialRecord.User.SC = 0;
end

% Increase sequence counter based on last trial
if ~isempty(TrialRecord.TrialErrors)
    if TrialRecord.TrialErrors(end)==0
        trials_left_in_sequence(TrialRecord.CurrentCondition) = trials_left_in_sequence(TrialRecord.CurrentCondition)-1;
        correct_counts(TrialRecord.CurrentCondition) = correct_counts(TrialRecord.CurrentCondition)+1;
        CL_trials = [CL_trials 0];
        disp('Correct!')
    elseif ismember(TrialRecord.TrialErrors(end), [1 2 3 4])
        %trials_left_in_sequence(TrialRecord.CurrentCondition) = trials_left_in_sequence(TrialRecord.CurrentCondition)+1;
        incorrect_counts(TrialRecord.CurrentCondition) = incorrect_counts(TrialRecord.CurrentCondition)+1;
        CL_trials = [CL_trials 1];
        disp('CL Trial!')
    elseif CL_trials(end) == 1 % add to CL_trial vector for incomplete trials
        CL_trials = [CL_trials 1];
        disp('Still CL Trial!')
    else
        CL_trials = [CL_trials 0];
        disp('Not CL Trial')
    end
end
    
disp(['     trials left: ' num2str(trials_left_in_sequence(1:4)) ' || ' num2str(trials_left_in_sequence(5:8))])
disp(['  correct counts: ' num2str(correct_counts(1:4)) ' || ' num2str(correct_counts(5:8))])
disp(['incorrect counts: ' num2str(incorrect_counts(1:4)) ' || ' num2str(incorrect_counts(5:8))])

%Reset sequence count if each fractal has been encountered enough times -


if sum(trials_left_in_sequence(1,(1:4)+( (context - 1) * 4))) == 0
    trials_left_in_sequence = sequence_depth + zeros(1,2*n_fractals);
end

%Pick fractal
if CL_trials(end) == 1 % if CL trial, repeat condition
    condition = TrialRecord.ConditionsPlayed(end);
    chosen_condition = conditions(condition,:);
else % if not CL
    while true
    condition = randi(n_fractals)+((context-1)*4);
    if trials_left_in_sequence(condition) ~= 0
        chosen_condition = conditions(condition,:);
        break
    end
    end
end

% Repeat SC trial if not completed
if ~isempty(TrialRecord.TrialErrors)
    if (TrialRecord.User.SC_trials(end) == 1) && (~ismember(TrialRecord.TrialErrors(end), 0:4))
        TrialRecord.User.SC = 1;
        condition = TrialRecord.ConditionsPlayed(end);
        chosen_condition = conditions(condition,:);
    end
end

% Stimuli
image_list = {'stim_21.bmp','stim_81.bmp','stim_82.bmp', 'stim_95.bmp', 'cc_1.png', 'cc_2.png'};
stimulus = image_list{chosen_condition(1)};
ctx_cue = image_list{chosen_condition(2)};

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

%5: up
C(5).Type = 'crc';
C(5).Radius = 0.1;     % visual angle
C(5).Color = target_color;  % [R G B]
C(5).FillFlag = 1;
C(5).Xpos = up(1);
C(5).Ypos = up(2);

%6: right
C(6).Type = 'crc';
C(6).Radius = 0.1;     % visual angle
C(6).Color = target_color;  % [R G B]
C(6).FillFlag = 1;
C(6).Xpos = right(1);
C(6).Ypos = right(2);

%7: down
C(7).Type = 'crc';
C(7).Radius = 0.1;     % visual angle
C(7).Color = target_color;  % [R G B]
C(7).FillFlag = 1;
C(7).Xpos = down(1);
C(7).Ypos = down(2);

%8: left
C(8).Type = 'crc';
C(8).Radius = 0.1;     % visual angle
C(8).Color = target_color;  % [R G B]
C(8).FillFlag = 1;
C(8).Xpos = left(1);
C(8).Ypos = left(2);

%9: SC
C(9).Type = 'pic';
C(9).Name = 'sc.png';
C(9).Xpos = 0;
C(9).Ypos = 0;
C(9).Colorkey = [0 0 0]; %sets black as transparent


TrialRecord.User.CL_trials = CL_trials;
TrialRecord.NextBlock = context;
TrialRecord.NextCondition = condition;
end