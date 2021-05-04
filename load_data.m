[data, MLConfig, TrialRecord, filename] = mlread();

% Task Variables
ITI = MLConfig.InterTrialInterval;
wait_for_fix = TrialRecord.Editable.wait_for_fix;
fix_time = TrialRecord.Editable.fix_time;
stim_time = TrialRecord.Editable.stim_time;
stim_trace_time = TrialRecord.Editable.stim_trace_time;
ctx_cue_time = TrialRecord.Editable.ctx_cue_time;
ctx_cue_trace_time = TrialRecord.Editable.ctx_cue_trace_time; % time maintain fixation after ctx_cue
max_decision_time = TrialRecord.Editable.max_decision_time;
decision_fix_time = TrialRecord.Editable.decision_fix_time; % time to register choice
decision_trace_time = TrialRecord.Editable.decision_trace_time; % period before reward delivery
solenoid_time = TrialRecord.Editable.solenoid_time; %ms
big_drops = TrialRecord.Editable.big_drops; %number of pulses
drop_gaps = TrialRecord.Editable.drop_gaps; %ms

% Partition Indices
trials = TrialRecord.TrialErrors;
trial_i = 1:TrialRecord.CurrentTrialNumber;
conditions = TrialRecord.ConditionsPlayed;
CC_trials = logical(TrialRecord.User.CC_trials);
CL_trials = logical(TrialRecord.User.CL_trials);
blocks = TrialRecord.BlocksPlayed;
directions = TrialRecord.User.directions;
if length(directions) ~= length(trials)
    directions = [directions 0];
end
rts = TrialRecord.ReactionTimes;

% Contexts
c1 = blocks == 1;
c2 = blocks == 2;

% Answers
correct = trials == 0;
alternative = trials == 1;
across = trials == 2;
random = trials == 3;

no_fix = trials == 4;
break_fix = trials == 5;
early_ans = trials == 6;
no_choice = trials == 7;

incorrect_CL = trials == 8;
correct_CL = trials == 9;

incorrect = logical(alternative + across + random);
official = logical(correct + incorrect);
CL_completed = logical(correct_CL + incorrect_CL);
all_completed = logical(official + CL_completed);

% Conditions
s1 = conditions == 1;
s2 = conditions == 2;
s3 = conditions == 3;
s4 = conditions == 4;
s5 = conditions == 5;
s6 = conditions == 6;
s7 = conditions == 7;
s8 = conditions == 8;

% Directions - By Code
up = directions == 1;
right = directions == 2;
down = directions == 3;
left = directions == 4;

% Directions - Radians
radians = directions;
radians(up) = pi/2;
radians(down) = 3*pi/2;
radians(left) = pi;
radians(right) = 0;

% Licks

