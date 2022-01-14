% Data Parser

session_i = []; % session number (integer)
session_length = []; % trials per session (integer)
trials = []; % trial outcomes (0-9)
condition = []; % coding both fractal and context (C1: 1-4, C2:5-8)
context = []; % context ID (1 or 2)
ncl = []; % non-correction-loop trials (logical)
completed = []; % correct and incorrect trials
correct = []; % correct trials

for i = 1:length(data)
    session_i = [session_i repmat(i, 1, length(data{i}))];
    session_length = [session_length length(data{i})];
    trials = [trials [data{i}.TrialError]];
    condition = [condition [data{i}.Condition]];
    context = [context [data{i}.Block]];
    ncl = [ncl ~TR{i}.User.CL_trials];
    completed = [completed ismember([data{i}.TrialError],0:4)];
    correct = [correct [data{i}.TrialError]==0];
end
