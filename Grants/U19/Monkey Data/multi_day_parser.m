% Extract all sessions, contexts, conditions, trials, and correction-loops
all.session = [];
all.context = [];
all.condition = [];
all.trials = [];
all.CLs = [];
all.SC_on = [];
all.CC_on = [];

for i = 1:length(data)
    all.session = [all.session repmat(i, 1, length(data{i}))];
    all.context = [all.context [data{i}.Block]];
    all.condition = [all.condition [data{i}.Condition]];
    all.trials = [all.trials [data{i}.TrialError]];
    all.CLs = [all.CLs TR{i}.User.CL_trials];
    all.SC_on = [all.SC_on TR{i}.User.SC_trials];
    all.CC_on = [all.CC_on TR{i}.User.CC_trials];
end

% Find completed trials
all.completed = (all.trials==0|all.trials==1|all.trials==2|all.trials==3|all.trials==4);

% Assemble official trial vectors (completed and non-CL)
official.session = all.session(all.completed & ~all.CLs);
official.context = all.context(all.completed & ~all.CLs);
official.condition = all.condition(all.completed & ~all.CLs);
official.fractal = official.condition;
official.fractal(official.fractal>4) = official.fractal(official.fractal>4)-4;
official.trials = all.trials(all.completed & ~all.CLs);
official.SC_on = all.SC_on(all.completed & ~all.CLs);
official.CC_on = all.CC_on(all.completed & ~all.CLs);

% Find boundary between sessions and context switches
official.eod = [];
for i = 1:length(data)
    official.eod = [official.eod sum(official.session==i)];
end
official.eod = cumsum(official.eod);

official.switches = [0 sort([strfind(official.context==1,[0 1]) strfind(official.context==1,[1 0])]) length(official.context)];

official.context_indices = {};
for i = 2:length(official.switches)
    official.context_indices{i-1} = official.switches(i-1)+1:official.switches(i);
end