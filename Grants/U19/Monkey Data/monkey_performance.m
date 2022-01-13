% % Make a vector of first n trials following context switch
multi_day_importer
multi_day_parser

% % confusion matrices
% multi_day_confusion_matrix(official,above)
% 
% % post-switch performance
% n = 20; % number of trials to track following switch
% switch_trials = zeros(length(official.context_indices),n);
% for s = 1:length(official.context_indices)
%     trial_numbers = official.context_indices{s}(1:n);
%     switch_trials(s,:) = official.trials(trial_numbers);
% end
% 
% correct = switch_trials==0;
% figure
% bar(sum(correct)/size(switch_trials,1))
% yline(.25,'r')
% ylabel('Proportion Correct')
% xlabel('Trial from Switch')
% title('Post-Switch Performance')
% 
% % cumulative correct following SC
% figure
% SC_trials = official.trials(logical(official.SC_on));
% plot(cumsum(SC_trials==0))
% title('Cumulative Correct SC Trials')
% xlabel('SC Trials')
% ylabel('Cumulative Correct')
% 
% % context progress distribution for SESSION
% for n = 10:5:25
% start_trials = [];
% end_trials = [];
% for i = 1:length(official.eod)
%     start_i = [1 official.eod+1];
%     stop_i = official.eod;
%     start_trials = [start_trials hit_rate_2(official.trials(start_i(i):start_i(i)+n))];
%     end_trials = [end_trials hit_rate_2(official.trials(stop_i(i)-n:stop_i(i)))];
% end
% 
% figure
% histogram(start_trials,"BinEdges",0:.05:1)
% hold on
% histogram(end_trials,"BinEdges",0:.05:1)
% ylabel('count')
% xlabel('hit rate')
% legend('start of session','end of session')
% title(['First and Last ' num2str(n) '-trials of Session'])
% end
% 
% % context progress distribution for SWITCH
% for n = 10:5:25
% start_trials = [];
% end_trials = [];
% for i = 1:length(official.switches)-1
%     start_i = official.switches+1;
%     stop_i = official.switches(2:end);
%     start_trials = [start_trials hit_rate_2(official.trials(start_i(i):start_i(i)+n))];
%     end_trials = [end_trials hit_rate_2(official.trials(stop_i(i)-n:stop_i(i)))];
% end
% 
% figure
% histogram(start_trials,"BinEdges",0:.05:1)
% hold on
% histogram(end_trials,"BinEdges",0:.05:1)
% ylabel('count')
% xlabel('hit Rate')
% legend('start of session','end of session')
% title(['First and Last ' num2str(n) '-trials within Context'])
% end
% 
% % Confustion Matrices: Learning within Contexts
% n = 10;
% start_trials = [];
% end_trials = [];
% for i = 1:length(official.switches)-1
%     start_i = official.switches+1;
%     stop_i = official.switches(2:end);
%     start_trials = [start_trials start_i(i):start_i(i)+n];
%     end_trials = [end_trials stop_i(i)-n:stop_i(i)];
% end
% multi_day_confusion_matrix(official,start_trials)
% sgtitle(['First ' num2str(n) '-trials in Context (' num2str(length(official.eod)) '-session average)'])
% multi_day_confusion_matrix(official,end_trials)
% sgtitle(['Last ' num2str(n) '-trials in Context (' num2str(length(official.eod)) '-session average)'])

% Distribution of trials to reach significance
% % Isolate each switch
% switch_i = official.switches+1;
% switches = cell(length(switch_i)-1,1);
% for i = 1:length(switch_i)-1
%     switches{i,1} = official.trials(switch_i(i):switch_i(i+1)-1); 
% end
% % For each switch, find number of trials needed
% trials_to_criterion = zeros(length(switches),1);
% criterion_thresh = 0.5; % HR
% criterion_window = 20; % -trial average
% criterion_duration = 1; % trials
% for s = 1:length(switches)
%     A = switches{s}==0;
%     B = smoothdata(A,'gaussian',criterion_window);
%     C = B > criterion_thresh;
%     C_diff = diff([0 C 0]);
%     starts = find(C_diff == 1); % start of streaks
%     ends = find(C_diff == -1); % end of streaks
%     if sum((ends-starts)>criterion_duration)==0
%         trials_to_criterion(s,1) = NaN;
%     else
%         trials_to_criterion(s,1) = starts(find((ends-starts)>criterion_duration,1));
%     end
% end
% figure
% histogram(trials_to_criterion,'NumBins',50)
% xlabel('trials to criterion')
% ylabel('count')
% title({[num2str(criterion_duration) ' trials over ' num2str(criterion_thresh*100) '% (' num2str(criterion_window) '-trial moving average)'], ['(n = ' num2str(length(switches)) ' switches)']})


% % Learning Scatter:
% scatter(1:28,trials_to_criterion(2:end),'filled')
% xlabel('switch number')
% ylabel('trials to criterion')
% %title({['Criterion: HR > ' num2str(criterion_thresh*100) '% (' num2str(criterion_window) '-trial average)']})
% ax = gca;
% ax.LabelFontSizeMultiplier = 2;
% ax.FontSize = 15;
% 
% 
% % Look at performance on days with multiple switches
% days = [1 official.eod];
% switches_per_day = zeros(length(days)-1,1);
% for d = 1:length(days)-1
%     switches_per_day(d,1) = sum(official.switches>days(d) & official.switches<days(d+1));
% end
% 
% multiple_switch_trials = false(1,length(official.trials));
% for i = find(switches_per_day>1)'
%     multiple_switch_trials = multiple_switch_trials | official.session==i;
% end
% 
% multi_day_confusion_matrix(official,multiple_switch_trials)
