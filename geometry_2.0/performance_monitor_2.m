function performance_monitor_2(TrialRecord)
    n = 300; % Change to monitor n trials back
    window = 20; % number of trials in running HR
    
    if TrialRecord.CurrentTrialNumber > n
        trials = TrialRecord.TrialErrors(end-n:end);
        blocks = TrialRecord.BlocksPlayed(end-n:end);
        trial_number = TrialRecord.CurrentTrialNumber-n:TrialRecord.CurrentTrialNumber;
        CC_trials = TrialRecord.User.CC_trials(end-n:end);
        n_correct = TrialRecord.User.correct_count(end-n:end);
    else
        trials = TrialRecord.TrialErrors;
        blocks = TrialRecord.BlocksPlayed;
        trial_number = 1:TrialRecord.CurrentTrialNumber;
        CC_trials = TrialRecord.User.CC_trials;
        n_correct = TrialRecord.User.correct_count;
    end
        
    %Error Type
    yyaxis left
    cla
    hold on
    scatter(trial_number(trials==0&CC_trials==0),trials(trials==0&CC_trials==0),'filled','g')
    scatter(trial_number(trials==0&CC_trials==1),trials(trials==0&CC_trials==1),'o','g')
    
    scatter(trial_number(trials==1&CC_trials==0),trials(trials==1&CC_trials==0),'filled','c')
    scatter(trial_number(trials==1&CC_trials==1),trials(trials==1&CC_trials==1),'o','c')
    
    scatter(trial_number(trials==2&CC_trials==0),trials(trials==2&CC_trials==0),'filled','y')
    scatter(trial_number(trials==2&CC_trials==1),trials(trials==2&CC_trials==1),'o','y')
    
    scatter(trial_number(trials==3&CC_trials==0),trials(trials==3&CC_trials==0),'filled','b')
    scatter(trial_number(trials==3&CC_trials==1),trials(trials==3&CC_trials==1),'o','b')
    
    scatter(trial_number(trials==4&CC_trials==0),trials(trials==4&CC_trials==0),'filled','r')
    scatter(trial_number(trials==4&CC_trials==1),trials(trials==4&CC_trials==1),'o','r')
    
    scatter(trial_number(trials==5&CC_trials==0),trials(trials==5&CC_trials==0),'filled','s','k')
    scatter(trial_number(trials==5&CC_trials==1),trials(trials==5&CC_trials==1),'s','k')

    scatter(trial_number(trials==6&CC_trials==0),trials(trials==6&CC_trials==0),'filled','d','k')
    scatter(trial_number(trials==6&CC_trials==1),trials(trials==6&CC_trials==1),'d','k')

    scatter(trial_number(trials==7&CC_trials==0),trials(trials==7&CC_trials==0),'filled','^','k')
    scatter(trial_number(trials==7&CC_trials==1),trials(trials==7&CC_trials==1),'^','k')

    scatter(trial_number(trials==8&CC_trials==0),trials(trials==8&CC_trials==0),'filled','s','k')
    scatter(trial_number(trials==8&CC_trials==1),trials(trials==8&CC_trials==1),'s','k')

    scatter(trial_number(trials==9&CC_trials==0),trials(trials==9&CC_trials==0),'filled','k')
    scatter(trial_number(trials==9&CC_trials==1),trials(trials==9&CC_trials==1),'o','k')

    
    yticks(0:9);
    yticklabels({'Correct', 'Up', 'Right', 'Down', 'Left', 'No Fix', 'Break Fix', 'Early Ans', 'No Ans', 'Break Choice'});
    
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
    
    running_RR = zeros(length(trials),1);
    for j = 1:length(trials)
        try
            running_RR(j) = (n_correct(j) - n_correct(j-window))/window;
        catch
            running_RR(j) = n_correct(end)/j;
        end
    end
    %fprintf([num2str(window) '-Trial RR: %.3f\n'], running_RR(end));
    plot(trial_number, running_HR,'-k')
    plot(trial_number, running_RR,'-b')
    yline(hit_rate(TrialRecord.TrialErrors),'--k')
    ylim([0 1])
   
    xticks('auto')
    xlabel('Trial #')
    
    %Blocks
    for i = 1:length(trials)
        try
            if blocks(i)~= blocks(i-1)
                xline(trial_number(i), '--k')
            end
        catch
        end
    end
end