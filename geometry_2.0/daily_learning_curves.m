% Daily learning curves
figure
title('Session Engagement and Performance')
hold on

% Cumulative trials completed vs. trial #
cum_trials_completed = cumsum(completed);
plot(cum_trials_completed)

% Cumulative trials correct vs. trial #
cum_trials_correct = cumsum(trials == 0);
plot(cum_trials_correct);

unity = refline(1,0);
unity.Color = 'r';

legend('trials completed', 'trials correct','Location','northwest')
xlabel('trial number')
ylabel('cumulative count')

% Cumulative trials correct vs. trial # (by stimulus)
% figure
% title('C1 Learning Curves')
% hold on
% plot(cumsum(trials(s1)==0));
% plot(cumsum(trials(s2)==0));
% plot(cumsum(trials(s3)==0));
% plot(cumsum(trials(s4)==0));
% legend('s1', 's2', 's3', 's4','Location','northwest')
% xlabel('trial number')
% ylabel('cumulative correct')

figure
title('C2 Learning Curves')
hold on
cs5 = cumsum(trials(s5)==0);
cs6 = cumsum(trials(s6)==0);
cs7 = cumsum(trials(s7)==0);
cs8 = cumsum(trials(s8)==0);
legend('s5', 's6', 's7', 's8','Location','northwest')
xlabel('trial number')
ylabel('cumulative correct')
