c1_trials = [official.condition==1; official.condition==2; official.condition==3; official.condition==4];
c2_trials = [official.condition==5; official.condition==6; official.condition==7; official.condition==8];

c1_condition_correct = {};
c2_condition_correct = {};

figure
subplot(1,2,1)
title('Context 1')
hold on
for i = 1:4
    c1_condition_correct{i} = official.trials(c1_trials(i,:))==0;
    plot(cumsum(c1_condition_correct{i}));
end
xlabel('trial')
ylabel('cumulative correct')
legend('F1','F2','F3','F4','Location','northwest')

subplot(1,2,2)
title('Context 2')
hold on
for i = 1:4
    c2_condition_correct{i} = official.trials(c2_trials(i,:))==0;
    plot(cumsum(c2_condition_correct{i}));
end
xlabel('trial')
ylabel('cumulative correct')
legend('F1','F2','F3','F4','Location','northwest')

sgtitle(['Learning Curves by Condition'])