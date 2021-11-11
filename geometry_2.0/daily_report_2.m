date = input("What is today's date? ",'s');
[data, MLConfig, TrialRecord, filename] = mlread();
trials = TrialRecord.TrialErrors;
disp(['Rewarded/ Completed: ', num2str(sum(trials == 0)), '/', num2str(sum(trials==0|trials==1|trials==2|trials==3|trials==4))]);

completed = (trials==0|trials==1|trials==2|trials==3|trials==4);

CL_trials = TrialRecord.User.CL_trials;
disp(['CL Trials Completed: ' num2str(sum(CL_trials&(trials==0|trials==1|trials==2|trials==3|trials==4)))])

s1 = [data.Condition] == 1;
s2 = [data.Condition] == 2;
s3 = [data.Condition] == 3;
s4 = [data.Condition] == 4;
s5 = [data.Condition] == 5;
s6 = [data.Condition] == 6;
s7 = [data.Condition] == 7;
s8 = [data.Condition] == 8;

disp('C1 HR (all)')
hit_rate_2(trials(s1|s2|s3|s4))
disp('C2 HR (all)')
hit_rate_2(trials(s5|s6|s7|s8))

disp('HR by fractal (all)')
hit_rate_2(trials(s1))
hit_rate_2(trials(s2))
hit_rate_2(trials(s3))
hit_rate_2(trials(s4))
disp('---')
hit_rate_2(trials(s5))
hit_rate_2(trials(s6))
hit_rate_2(trials(s7))
hit_rate_2(trials(s8))

disp('HR by fractal (non-CL)')
hit_rate_2(trials((s1|s2|s3|s4)&(~CL_trials)))
hit_rate_2(trials((s5|s6|s7|s8)&(~CL_trials)))
disp('---')
hit_rate_2(trials(s1&~CL_trials))
hit_rate_2(trials(s2&~CL_trials))
hit_rate_2(trials(s3&~CL_trials))
hit_rate_2(trials(s4&~CL_trials))
disp('---')
hit_rate_2(trials(s5&~CL_trials))
hit_rate_2(trials(s6&~CL_trials))
hit_rate_2(trials(s7&~CL_trials))
hit_rate_2(trials(s8&~CL_trials))


figure
hold on
sgtitle([date ' (completed only)']) 
subplot(2,4,1)
plot(cumsum(trials(s1&completed)==0))
unity = refline(1,0);
unity.Color = 'r';
title('s1')
xlabel('trial')
ylabel('cumulative correct')
subplot(2,4,2)
plot(cumsum(trials(s2&completed)==0))
unity = refline(1,0);
unity.Color = 'r';
title('s2')
xlabel('trial')
ylabel('cumulative correct')
subplot(2,4,3)
plot(cumsum(trials(s3&completed)==0))
unity = refline(1,0);
unity.Color = 'r';
title('s3')
xlabel('trial')
ylabel('cumulative correct')
subplot(2,4,4)
plot(cumsum(trials(s4&completed)==0))
unity = refline(1,0);
unity.Color = 'r';
title('s4')
xlabel('trial')
ylabel('cumulative correct')
subplot(2,4,5)
plot(cumsum(trials(s5&completed)==0))
unity = refline(1,0);
unity.Color = 'r';
title('s5')
xlabel('trial')
ylabel('cumulative correct')
subplot(2,4,6)
plot(cumsum(trials(s6&completed)==0))
unity = refline(1,0);
unity.Color = 'r';
title('s6')
xlabel('trial')
ylabel('cumulative correct')
subplot(2,4,7)
plot(cumsum(trials(s7&completed)==0))
unity = refline(1,0);
unity.Color = 'r';
title('s7')
xlabel('trial')
ylabel('cumulative correct')
subplot(2,4,8)
plot(cumsum(trials(s8&completed)==0))
unity = refline(1,0);
unity.Color = 'r';
title('s8')
xlabel('trial')
ylabel('cumulative correct')

% Confusion matrix (proportion)
s1_prob = [sum(trials(s1&completed)==0) sum(trials(s1&completed)==2) sum(trials(s1&completed)==3) sum(trials(s1&completed)==4)] /length(trials(s1&completed));
s2_prob = [sum(trials(s2&completed)==1) sum(trials(s2&completed)==0) sum(trials(s2&completed)==3) sum(trials(s2&completed)==4)] /length(trials(s2&completed));
s3_prob = [sum(trials(s3&completed)==1) sum(trials(s3&completed)==2) sum(trials(s3&completed)==0) sum(trials(s3&completed)==4)] /length(trials(s3&completed));
s4_prob = [sum(trials(s4&completed)==1) sum(trials(s4&completed)==2) sum(trials(s4&completed)==3) sum(trials(s4&completed)==0)] /length(trials(s4&completed));
s5_prob = [sum(trials(s5&completed)==1) sum(trials(s5&completed)==0) sum(trials(s5&completed)==3) sum(trials(s5&completed)==4)] /length(trials(s5&completed));
s6_prob = [sum(trials(s6&completed)==1) sum(trials(s6&completed)==2) sum(trials(s6&completed)==0) sum(trials(s6&completed)==4)] /length(trials(s6&completed));
s7_prob = [sum(trials(s7&completed)==1) sum(trials(s7&completed)==2) sum(trials(s7&completed)==3) sum(trials(s7&completed)==0)] /length(trials(s7&completed));
s8_prob = [sum(trials(s8&completed)==0) sum(trials(s8&completed)==2) sum(trials(s8&completed)==3) sum(trials(s8&completed)==4)] /length(trials(s8&completed));

c1_prob = [s1_prob;s2_prob;s3_prob;s4_prob];
c2_prob = [s5_prob;s6_prob;s7_prob;s8_prob];

figure
subplot(1,2,1)
sgtitle(['Confusion Matrices (proprtion) ' date])
imagesc(c1_prob,[0 1]);
colormap(hot)
c = colorbar;
c.Label.String = 'proportion of choices';
title('Ctx 1')
xticklabels({'Up', 'Right', 'Down', 'Left'})
xticks(1:4)
yticklabels({'F1', 'F2', 'F3', 'F4'})
yticks(1:4)

subplot(1,2,2)
imagesc(c2_prob,[0 1]);
colormap(hot)
c = colorbar;
c.Label.String = 'proportion of choices';
title('Ctx 2')
xticklabels({'Up', 'Right', 'Down', 'Left'})
xticks(1:4)
yticklabels({'F1', 'F2', 'F3', 'F4'})
yticks(1:4)



% Confusion matrix (trial count)
s1_count = [sum(trials(s1&completed)==0) sum(trials(s1&completed)==2) sum(trials(s1&completed)==3) sum(trials(s1&completed)==4)];
s2_count = [sum(trials(s2&completed)==1) sum(trials(s2&completed)==0) sum(trials(s2&completed)==3) sum(trials(s2&completed)==4)];
s3_count = [sum(trials(s3&completed)==1) sum(trials(s3&completed)==2) sum(trials(s3&completed)==0) sum(trials(s3&completed)==4)];
s4_count = [sum(trials(s4&completed)==1) sum(trials(s4&completed)==2) sum(trials(s4&completed)==3) sum(trials(s4&completed)==0)];
s5_count = [sum(trials(s5&completed)==1) sum(trials(s5&completed)==0) sum(trials(s5&completed)==3) sum(trials(s5&completed)==4)];
s6_count = [sum(trials(s6&completed)==1) sum(trials(s6&completed)==2) sum(trials(s6&completed)==0) sum(trials(s6&completed)==4)];
s7_count = [sum(trials(s7&completed)==1) sum(trials(s7&completed)==2) sum(trials(s7&completed)==3) sum(trials(s7&completed)==0)];
s8_count = [sum(trials(s8&completed)==0) sum(trials(s8&completed)==2) sum(trials(s8&completed)==3) sum(trials(s8&completed)==4)];

c1_count = [s1_count;s2_count;s3_count;s4_count];
c2_count = [s5_count;s6_count;s7_count;s8_count];

figure
subplot(1,2,1)
sgtitle(['Confusion Matrices (choice) ' date])
imagesc(c1_count);
colormap(hot)
c = colorbar;
c.Label.String = 'times chosen';
title('Ctx 1')
xticklabels({'Up', 'Right', 'Down', 'Left'})
xticks(1:4)
yticklabels({'F1', 'F2', 'F3', 'F4'})
yticks(1:4)

subplot(1,2,2)
imagesc(c2_count);
colormap(hot)
c = colorbar;
c.Label.String = 'times chosen';
title('Ctx 2')
xticklabels({'Up', 'Right', 'Down', 'Left'})
xticks(1:4)
yticklabels({'F1', 'F2', 'F3', 'F4'})
yticks(1:4)