window = 500;

for reward = 1:2


switch reward
    case 1
        lick_trials = r1 & all_completed;
        title = 'Licking: Small Reward Trials';
    case 2
        lick_trials = r2 & all_completed;
        title = 'Licking: Large Reward Trials';
end


lick_trials_i = find(lick_trials);

licks = zeros(length(lick_trials_i),window);

% close all
% figure
% tiledlayout(2,1)
% nexttile
% hold on
for i = 1:length(lick_trials_i)% find(completed_trials)
    t = lick_trials_i(i);
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
%    num_licks = numel(lick);
%     for j = 1:num_licks
%         plot([lick(j) lick(j)], [i-.4 i+.4], 'k')
%     end
end

figure
tiledlayout(2,1)
nexttile
imagesc(-licks+1)
ylabel('trial')
xlabel('time (ms) before reward delivery')
xticks(0:50:500)
xticklabels(-500:50:0)
colormap([0 0 0; 1 1 1])
nexttile
bar(sum(licks,1)/size(licks,1))
yticks(0:.25:1)
ylim([0,1])
ylabel('proportion')
grid('on')
xticks(0:50:500)
xticklabels(-500:50:0)
sgtitle(title)
end
