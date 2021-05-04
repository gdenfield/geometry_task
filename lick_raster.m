window = 500;

%completed_trials = ismember(trials,[0,1,2,3,8,9]);

completed_trials = ismember(trials,[1,2,3]);
completed_trials_i = find(completed_trials);

licks = zeros(length(completed_trials_i),window);

%close all
figure
tiledlayout(2,1)
nexttile
hold on
for i = 1:length(completed_trials_i)% find(completed_trials)
    t = completed_trials_i(i);
    % Get start and stop times
    start = round(data(t).BehavioralCodes.CodeTimes(data(t).BehavioralCodes.CodeNumbers==66));
    stop = start + window - 1;
        
    % Get lick data
    if length(data(t).AnalogData.General.Gen1(start:end)) < window
        disp(['Short: ' num2str(t)])
        continue
    end
    lick = data(t).AnalogData.General.Gen1(start:stop);
    
    % Convert to times
    lick = lick > 2;
    licks(i,:) = lick;
    lick = find(lick);
    
    % Add to plot
    num_licks = numel(lick);
    for j = 1:num_licks
        plot([lick(j) lick(j)], [i-.4 i+.4], 'k')
    end
end

nexttile
bar(sum(licks,1))
