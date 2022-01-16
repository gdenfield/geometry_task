labels = cell(1,length(official.context_indices));

figure
hold on
for i = 1:length(official.context_indices)
    if official.context(official.context_indices{i}(1)) == 1
        plot(cumsum(official.trials(official.context_indices{i})==0), '-');
        labels{i} = 'Context 1';
    else
        plot(cumsum(official.trials(official.context_indices{i})==0), '-.');
        labels{i} = 'Context 2';
    end
end
title('Learning Curves by Context')
legend(labels, 'Location','northwest')
