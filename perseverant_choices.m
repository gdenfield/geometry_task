trials = TrialRecord.TrialErrors;
incorrect_trials_i = ismember(trials, [1,2,3,8]);
directions = TrialRecord.User.directions;
incorrect_directions = directions(incorrect_trials_i);
repeat_directions_i = directions(2:end) == directions(1:end-1);
repeat_incorrect_directions_i = incorrect_directions(2:end) == incorrect_directions(1:end-1);
repeat_incorrect_directions_i = [false repeat_incorrect_directions_i];

% Figures
figure
histogram(incorrect_directions(repeat_incorrect_directions_i), 'Normalization','probability')
n = sum(repeat_incorrect_directions_i);
xticklabels({'Up','Right','Down','Left'})
xticks(1:4)
ylabel('proportion')
title(['Perseverant Saccades (n = ' num2str(n) ' incorrect trials)'])

figure
histogram(incorrect_directions,'Normalization','probability')
n = length(incorrect_directions);
xticklabels({'Up','Right','Down','Left'})
xticks(1:4)
ylabel('proportion')
title(['Incorrect Trial Saccade Directions (n = ' num2str(n) ' trials)'])