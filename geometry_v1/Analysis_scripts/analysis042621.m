% Load Data
files = dir('*.bhv2');
partitions = cell(1,length(files));
behaviors = cell(1,length(files));
for f = 1:length(files)
    tic
    disp(['File ' num2str(f) ' of ' num2str(length(files))])
    filename = files(f).name;
    [partitions{f}, behaviors{f}, ] = load_data(filename);
    toc
end


% SC Trials
figure
sgtitle('Switch-Cue Trials (n)')

SC_perf = cell(1,length(partitions));
edges = -.5:1:9.5;
for f = 1:length(partitions)
    SC_perf{f} = partitions{f}.trials(partitions{f}.SC_trials);
    
    subplot(length(partitions)+1,1,f);
    histogram(SC_perf{f}, edges, 'FaceColor', [0 (f*(1/(length(partitions)+1))) 1])
    title([files(f).name(3:4) '/' files(f).name(5:6) ' (n = ' num2str(length(SC_perf{f})) ')'])
    xticklabels({'','Correct', 'Alt', 'Across', 'Random', 'No Fix', 'Break Fix', 'Early Ans', 'No Ans', 'Bad CL', 'Good CL'});

end

subplot(length(partitions)+1, 1, f+1);
histogram([SC_perf{1} SC_perf{2} SC_perf{3} SC_perf{4} SC_perf{5}], edges, 'Normalization', 'probability', 'FaceColor', [0 1 1])
title('Combined')
xticklabels({'','Correct', 'Alt', 'Across', 'Random', 'No Fix', 'Break Fix', 'Early Ans', 'No Ans', 'Bad CL', 'Good CL'});

% N+1 Trials
figure
sgtitle('Post Switch-Cue Trials (n+1)')

n1_perf = cell(1,length(partitions));
for f = 1:length(partitions)
    n1_trials = [false partitions{f}.SC_trials(1:end-1)] & ~partitions{f}.SC_trials;
    n1_perf{f} = partitions{f}.trials(n1_trials);
    
    subplot(length(partitions)+1,1,f);
    histogram(n1_perf{f}, edges, 'FaceColor', [0 1 (f*(1/(length(partitions)+1)))])
    title([files(f).name(3:4) '/' files(f).name(5:6) ' (n = ' num2str(length(n1_perf{f})) ')'])
    xticklabels({'','Correct', 'Alt', 'Across', 'Random', 'No Fix', 'Break Fix', 'Early Ans', 'No Ans', 'Bad CL', 'Good CL'});

end

subplot(length(partitions)+1, 1, f+1);
histogram([n1_perf{1} n1_perf{2} n1_perf{3} n1_perf{4} n1_perf{5}], edges, 'Normalization', 'probability', 'FaceColor', [0 1 1])
title('Combined')
xticklabels({'','Correct', 'Alt', 'Across', 'Random', 'No Fix', 'Break Fix', 'Early Ans', 'No Ans', 'Bad CL', 'Good CL'});



% Break times
figure

break_sessions = cell(1,length(partitions));
for f = 1:length(partitions) % for each session
    inds = find(partitions{f}.break_fix | partitions{f}.early_ans);
    break_times = [];
    for t = inds % for each SC trial
        SC_on_time = find(behaviors{f}.codes{t}==40 | behaviors{f}.codes{t}==42 | behaviors{f}.codes{t}==45);
        end_of_trial = find(behaviors{f}.codes{t}==46 | behaviors{f}.codes{t}==55);
        break_times = [break_times behaviors{f}.times{t}(end_of_trial) - behaviors{f}.times{t}(SC_on_time)];
    end
    
    break_sessions{f} = break_times;
end

all_breaks = [break_sessions{1} break_sessions{2} break_sessions{3} break_sessions{4} break_sessions{5}];
histogram(all_breaks,'BinWidth',20)

hold on

break_sessions = cell(1,length(partitions));
for f = 1:length(partitions) % for each session
    sc_inds = find(partitions{f}.SC_trials);
    break_times = [];
    for t = sc_inds % for each SC trial
        SC_on_time = find(behaviors{f}.codes{t}==42);
        end_of_trial = find(behaviors{f}.codes{t}==46 | behaviors{f}.codes{t}==55);
        break_times = [break_times behaviors{f}.times{t}(end_of_trial) - behaviors{f}.times{t}(SC_on_time)];
    end
    
    break_sessions{f} = break_times;
end

all_breaks = [break_sessions{1} break_sessions{2} break_sessions{3} break_sessions{4} break_sessions{5}];
histogram(all_breaks,'BinWidth',20)
legend('all trials','SC trials')
xlabel('time from CC/SC/None presentation (ms)')
title('Break-times')