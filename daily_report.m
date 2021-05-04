load_data

% date = [MLConfig.FormattedName(3:4) '/' MLConfig.FormattedName(5:6) '/20' MLConfig.FormattedName(1:2)];
% disp(['Date: ' date])
% t1 = datetime(data(1).TrialDateTime);
% t2 = datetime(data(end).TrialDateTime);
% duration = t2-t1;
% disp('Start: ' + string(timeofday(t1)) + ', Stop: ' + string(timeofday(t2)))
% disp('Duration: ' + string(duration))
% disp(['Animal: ' MLConfig.SubjectName])
% fprintf('Weight: %.2f kg', TrialRecord.User.weight)
% fprintf('Total Rewarded Trials: %.f', TrialRecord.User.rewarded_count(end))
% fprintf('Average RR: %.2f rewarded trials/min', TrialRecord.User.rewarded_count(end)/minutes(duration))

% figure
% try
% timing_variables
% catch
% end

figure
window = 20; % number of trials in running HR
title([num2str(length(trials)) ' Trials'])
yyaxis left
    cla
    hold on
    scatter(trial_i(trials==0&CC_trials==0),trials(trials==0&CC_trials==0),'filled','g')
    scatter(trial_i(trials==0&CC_trials==1),trials(trials==0&CC_trials==1),'o','g')
    
    scatter(trial_i(trials==1&CC_trials==0),trials(trials==1&CC_trials==0),'filled','c')
    scatter(trial_i(trials==1&CC_trials==1),trials(trials==1&CC_trials==1),'o','c')
    
    scatter(trial_i(trials==2&CC_trials==0),trials(trials==2&CC_trials==0),'filled','y')
    scatter(trial_i(trials==2&CC_trials==1),trials(trials==2&CC_trials==1),'o','y')
    
    scatter(trial_i(trials==3&CC_trials==0),trials(trials==3&CC_trials==0),'filled','b')
    scatter(trial_i(trials==3&CC_trials==1),trials(trials==3&CC_trials==1),'o','b')
    
    scatter(trial_i(trials==4&CC_trials==0),trials(trials==4&CC_trials==0),'filled','r')
    scatter(trial_i(trials==4&CC_trials==1),trials(trials==4&CC_trials==1),'o','r')
    
    scatter(trial_i(trials==5&CC_trials==0),trials(trials==5&CC_trials==0),'filled','s','r')
    scatter(trial_i(trials==5&CC_trials==1),trials(trials==5&CC_trials==1),'s','r')

    scatter(trial_i(trials==6&CC_trials==0),trials(trials==6&CC_trials==0),'filled','d','r')
    scatter(trial_i(trials==6&CC_trials==1),trials(trials==6&CC_trials==1),'d','r')

    scatter(trial_i(trials==7&CC_trials==0),trials(trials==7&CC_trials==0),'filled','^','r')
    scatter(trial_i(trials==7&CC_trials==1),trials(trials==7&CC_trials==1),'^','r')

    scatter(trial_i(trials==8&CC_trials==0),trials(trials==8&CC_trials==0),'filled','s','m')
    scatter(trial_i(trials==8&CC_trials==1),trials(trials==8&CC_trials==1),'s','m')

    scatter(trial_i(trials==9&CC_trials==0),trials(trials==9&CC_trials==0),'filled','m')
    scatter(trial_i(trials==9&CC_trials==1),trials(trials==9&CC_trials==1),'o','m')

    
    yticks(0:9);
    yticklabels({'Correct', 'Alt', 'Across', 'Random', 'No Fix', 'Break Fix', 'Early Ans', 'No Ans', 'Bad CL', 'Good CL'});
    
    %Hit Rate
    yyaxis right
    cla
    hold on
    running_HR = zeros(length(trials),1);
    for j = 1:length(trials)
        try
            running_HR(j) = hit_rate(trials(j-window:end));
        catch
            running_HR(j) = hit_rate(trials(1:j));
        end
    end
    
    RC = TrialRecord.User.rewarded_count;
    running_RR = zeros(length(trials),1);
    for j = 1:length(trials)
        try
            running_RR(j) = (RC(j) - RC(j-window))/window;
        catch
            try
            running_RR(j) = (RC(j) - RC(1))/j;
            catch
            end
        end
    end
        
    plot(trial_i, running_HR,'-k')
    plot(trial_i, running_RR, '-b')
    ylim([0 1])
    ylabel([num2str(window) '-trial HR (black), RR (drops/trial, blue)'])
   
    
    xticks('auto')
    xlabel('Trial #')
    
    %Blocks
    for i = 1:length(trials)
        try
            if blocks(i) > blocks(i-1)
                xline(i, '--r') % start of context 2
            elseif blocks(i) < blocks(i-1)
                xline(i, '--k') % start of context 1
            end
        catch
        end
    end

figure
histogram(trials, 'Normalization','probability');
title('Trial Outcomes');
xticks(0:9)
xticklabels({'correct', 'wrong ctx', 'across', 'random', 'no fixation', 'break fixation', 'early answer', 'no choice', 'incorrect CL', 'correct CL'});
xtickangle(45)
ylabel('proportion')
figure
histogram(trials(CC_trials));
hold on
histogram(trials(~CC_trials));
title('Trial Outcomes');
xticks(0:9)
xticklabels({'correct', 'wrong ctx', 'across', 'random', 'no fixation', 'break fixation', 'early answer', 'no choice', 'incorrect CL', 'correct CL'});
xtickangle(45)
ylabel('count')
legend({'CC Trials','None Trials'})


figure
hold on
histogram(trials(official&c1), 'Normalization','probability');
histogram(trials(official&c2), 'Normalization','probability');
title([num2str(sum(official)) ' Offical Trials, ' sprintf('Hit Rate: %.2f', hit_rate(trials))]);
xticks(0:3)
xticklabels({'correct', 'wrong ctx', 'across', 'random'});
xtickangle(45)
ylabel('proportion')
legend({'C1','C2'})

figure
HR = hit_rate(trials);
ctx1_HR = hit_rate(trials(c1));
ctx2_HR = hit_rate(trials(c2));
s1_HR = hit_rate(trials(s1));
s2_HR = hit_rate(trials(s2));
s3_HR = hit_rate(trials(s3));
s4_HR = hit_rate(trials(s4));
s5_HR = hit_rate(trials(s5));
s6_HR = hit_rate(trials(s6));
s7_HR = hit_rate(trials(s7));
s8_HR = hit_rate(trials(s8));

b = bar([ctx1_HR s1_HR s2_HR s3_HR s4_HR; ctx2_HR s5_HR s6_HR s7_HR s8_HR]);
title(sprintf('Hit Rate By Context and Condition (all trials = %.2f)', HR));
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints-b(1).YEndPoints;
labels1 = 'total';
text(xtips1,ytips1,labels1,'HorizontalAlignment','center','VerticalAlignment','bottom')
xtips2 = b(2).XEndPoints;
ytips2 = b(2).YEndPoints-b(2).YEndPoints;
labels2 = 'f1';
text(xtips2,ytips2,labels2,'HorizontalAlignment','center','VerticalAlignment','bottom')
xtips3 = b(3).XEndPoints;
ytips3 = b(3).YEndPoints-b(3).YEndPoints;
labels3 = 'f2';
text(xtips3,ytips3,labels3,'HorizontalAlignment','center','VerticalAlignment','bottom')
xtips4 = b(4).XEndPoints;
ytips4 = b(4).YEndPoints-b(4).YEndPoints;
labels4 = 'f3';
text(xtips4,ytips4,labels4,'HorizontalAlignment','center','VerticalAlignment','bottom')
xtips5 = b(5).XEndPoints;
ytips5 = b(5).YEndPoints-b(5).YEndPoints;
labels5 = 'f4';
text(xtips5,ytips5,labels5,'HorizontalAlignment','center','VerticalAlignment','bottom')
xticklabels({'context 1', 'context 2'});
%xtickangle(45)



figure
t = tiledlayout(2,2);
title(t,'Choice Behavior')
polarbins = [-pi/4 pi/4 3*pi/4 5*pi/4 7*pi/4];
nexttile
polarhistogram(radians(all_completed),polarbins)
title([num2str(sum(all_completed)) ' Completed Trials'])

nexttile
polarhistogram(radians(incorrect),polarbins)
title([num2str(sum(CL_completed)) ' Incorrect Trials'])

nexttile
polarhistogram(radians(official),polarbins)
title([num2str(sum(official)) ' Official Trials'])

nexttile
polarhistogram(radians(c1 & official),polarbins)
hold on
polarhistogram(radians(c2 & official),polarbins)
title('C1 vs C2')
legend({'C1','C2'})

figure
t = tiledlayout(2,4);
title(t, 'Incorrect Trials By Condition')
nexttile
polarhistogram(radians(s1&incorrect),polarbins)
title('S1')

nexttile
polarhistogram(radians(s2&incorrect),polarbins)
title('S2')

nexttile
polarhistogram(radians(s3&incorrect),polarbins)
title('S3')

nexttile
polarhistogram(radians(s4&incorrect),polarbins)
title('S4')

nexttile
polarhistogram(radians(s5&incorrect),polarbins)
title('S5')

nexttile
polarhistogram(radians(s6&incorrect),polarbins)
title('S6')

nexttile
polarhistogram(radians(s7&incorrect),polarbins)
title('S7')

nexttile
polarhistogram(radians(s8&incorrect),polarbins)
title('S8')

figure
t = tiledlayout(2,4);
title(t,'Official Trials by Condition')
nexttile
polarhistogram(radians(s1&official),polarbins,'FaceColor','red')
title('S1')

nexttile
polarhistogram(radians(s2&official),polarbins,'FaceColor','red')
title('S2')

nexttile
polarhistogram(radians(s3&official),polarbins,'FaceColor','red')
title('S3')

nexttile
polarhistogram(radians(s4&official),polarbins,'FaceColor','red')
title('S4')

nexttile
polarhistogram(radians(s5&official),polarbins,'FaceColor','red')
title('S5')

nexttile
polarhistogram(radians(s6&official),polarbins,'FaceColor','red')
title('S6')

nexttile
polarhistogram(radians(s7&official),polarbins,'FaceColor','red')
title('S7')

nexttile
polarhistogram(radians(s8&official),polarbins,'FaceColor','red')
title('S8')

sum(TrialRecord.TrialErrors==0) + sum(TrialRecord.TrialErrors==9)
sum(TrialRecord.TrialErrors==0) + sum(TrialRecord.TrialErrors==1) + sum(TrialRecord.TrialErrors==2) +sum(TrialRecord.TrialErrors==3) +sum(TrialRecord.TrialErrors==8) + sum(TrialRecord.TrialErrors==9)


