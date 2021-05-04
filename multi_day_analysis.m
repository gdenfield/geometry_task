[files,path] = uigetfile('*.bhv2','MultiSelect','on');

dates = cell(1,length(files));
performance.completed = zeros(1,length(files));
performance.HR = zeros(1,length(files));
performance.s1 = zeros(1,length(files));
performance.s2 = zeros(1,length(files));
performance.s3 = zeros(1,length(files));
performance.s4 = zeros(1,length(files));
performance.s5 = zeros(1,length(files));
performance.s6 = zeros(1,length(files));
performance.s7 = zeros(1,length(files));
performance.s8 = zeros(1,length(files));
performance.early = zeros(1,length(files));

for i = 1:length(files)
    tic
    disp(['Processing file ' num2str(i) ' of ' num2str(length(files))])
    dates{i} = [files{i}(3:4) '/' files{i}(5:6)];
    partitions = parse_data([path files{i}]);
    
    performance.completed(i) = sum(partitions.all_completed);
    performance.HR(i) = hit_rate(partitions.trials);
    performance.s1(i) = hit_rate(partitions.s1);
    performance.s2(i) = hit_rate(partitions.s2);
    performance.s3(i) = hit_rate(partitions.s3);
    performance.s4(i) = hit_rate(partitions.s4);
    performance.s5(i) = hit_rate(partitions.s5);
    performance.s6(i) = hit_rate(partitions.s6);
    performance.s7(i) = hit_rate(partitions.s7);
    performance.s8(i) = hit_rate(partitions.s8);
    performance.early(i) = sum(partitions.early_ans)/length(partitions.early_ans);
    toc
end

figure
bar(performance.completed)
xticklabels(dates)
title('Trials Completed')

figure
bar(performance.HR)
xticklabels(dates)
title('Hit Rate (all conditions)')

% C1
figure
subplot(2,2,1)
bar(performance.s1)
xticklabels(dates)
title('S1')

subplot(2,2,2)
bar(performance.s2)
xticklabels(dates)
title('S2')

subplot(2,2,3)
bar(performance.s3)
xticklabels(dates)
title('S3')

subplot(2,2,4)
bar(performance.s4)
xticklabels(dates)
title('S4')
sgtitle('Hit Rate by Condition (Context 1)')

% C2
figure
subplot(2,2,1)
bar(performance.s5)
xticklabels(dates)
title('S5')

subplot(2,2,2)
bar(performance.s6)
xticklabels(dates)
title('S6')

subplot(2,2,3)
bar(performance.s7)
xticklabels(dates)
title('S7')

subplot(2,2,4)
bar(performance.s8)
xticklabels(dates)
title('S8')
sgtitle('Hit Rate by Condition (Context 2)')

figure
bar(performance.early)
xticklabels(dates)
title('Early Answers (% of all trials)')