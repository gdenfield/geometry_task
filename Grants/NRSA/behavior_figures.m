%% F31 BEHAVIOR FIGS
% MJP 12/01/2021
%% Load .mat file
load('112921.mat')

%% Parse behavioral data

all_trials = [data.TrialError];
CL_Idx = TrialRecord.User.CL_trials;
complete_Idx = ismember(all_trials,0:4);
official_Idx = ~CL_Idx & complete_Idx; % exclude CL trials and incomplete trials
trials = all_trials(official_Idx);

all_conditions = [data.Condition];
conditions_Idx = all_conditions(official_Idx);
s1 = conditions_Idx == 1;
s2 = conditions_Idx == 2;
s3 = conditions_Idx == 3;
s4 = conditions_Idx == 4;
s5 = conditions_Idx == 5;
s6 = conditions_Idx == 6;
s7 = conditions_Idx == 7;
s8 = conditions_Idx == 8;

A = s1|s5;
B = s2|s6;
C = s3|s7;
D = s4|s8;

fractals = [1 2 3 4 1 2 3 4];
fractal_Idx = fractals(conditions_Idx);

SC_Idx = TrialRecord.User.SC_trials;
SC_trials = SC_Idx(official_Idx); % trials with switch cues

CC_Idx = TrialRecord.User.CC_trials;
CC_trials = CC_Idx(official_Idx); % trials with contextual cues

all_block_Idx = [data.BlockCount];
block_Idx = all_block_Idx(official_Idx);
block_changes = [0 diff(block_Idx)];
all_block_changes = [0 diff(all_block_Idx)];

all_ctx_Idx = [data.Block];
ctx_Idx = all_ctx_Idx(official_Idx);
c1 = ctx_Idx==1;
c2 = ctx_Idx==2;

%% Plot floating hit rate for whole session
%close
figure
hold on
HR = smoothdata(trials==0,'gaussian',20);
plot(HR)
for c = find(block_changes)
    xline(c,'-')
end
%% Plot each block's floating hit rate
%close
figure
hold on
for b = 1:block_Idx(end)
    block_trials = trials(block_Idx==b);
    HR = smoothdata(block_trials==0,'gaussian',20);
    if length(HR)>50
        plot(HR(1:50))
    else
        plot(HR)
    end
end
%% Plot range of performances in block
%close
figure
hold on
HR = smoothdata(trials==0,'gaussian',15);
boxchart(block_Idx(c1), HR(c1));
boxchart(block_Idx(c2), HR(c2));
ylim([0 1])
hold on
xline(0.5:1:8.5)
yline(0.25, 'r--')
legend({'ctx 1','ctx 2'})
xlabel('block number')
ylabel('hit rate')
ax = gca;
ax.FontSize = 35;

%% Plot increase in HR over each block
close
figure
hold on
block_progress = zeros(block_Idx(end),2); %two column matrix for start and end of every block
n_trials = 10;
for b = 1:block_Idx(end)
    block_trials = trials(block_Idx==b);
    block_SCs = SC_trials(block_Idx==b);
    block_trials = block_trials(~block_SCs);
    block_progress(b,1) = mean(block_trials(1:n_trials)==0);
    block_progress(b,2) = mean(block_trials(end-n_trials+1:end)==0);
end
bar(block_progress(1:7,:))
ylim([0 1])
xlabel('block number')
ylabel('performance')
legend({['first ' num2str(n_trials) ' trials'], ['last ' num2str(n_trials) ' trials']})
ax = gca;
ax.FontSize = 35;
%% Plot blocks by fractal
close
figure
fractal_HR = zeros(block_Idx(end), 4);
block_HR = zeros(block_Idx(end),2);%mean, error estimate sqrt(p.est*(1-p.est)/n)
for b = 1:block_Idx(end)
    block_trials = trials(block_Idx==b);
    block_conditions = conditions_Idx(block_Idx==b);
    unique_conditions = unique(block_conditions);
    for i = 1:length(unique_conditions)
        fractal_HR(b,i) = mean(block_trials(block_conditions==unique_conditions(i))==0);
    end
    block_HR(b,1) = mean(block_trials==0);
    block_HR(b,2) = 1.96*sqrt(mean(block_trials==0)*(1-mean(block_trials==0))/length(block_trials));
end
bar(fractal_HR,'FaceAlpha',1)
newcolors = [0 0.7 1
             0 0.6 1
             0 0.5 1
             0 0.4 1];
         
colororder(newcolors);
ylim([0 1])
xlabel('block number')
ylabel('performance')
hold on
plot(block_HR(:,1), 'k-','LineWidth',3,'MarkerFaceColor','k')
plot(1:2:length(block_HR),block_HR(1:2:end,1),'o','MarkerSize',20,'MarkerFaceColor','r', 'MarkerEdgeColor','r')
plot(2:2:length(block_HR),block_HR(2:2:end,1),'o','MarkerSize',20,'MarkerFaceColor','g', 'MarkerEdgeColor','g')
yline(.25,'r--','LineWidth',3)
ax = gca;
ax.FontSize = 35;
legend({'A','B','C','D','','ctx 1 average','ctx 2 average','chance = 0.25'},'FontSize',20)
%% Plot min and max HR
%close
figure
hold on
block_progress = zeros(block_Idx(end),2);
n_trials = 20;
for b = 1:block_Idx(end)
    block_trials = trials(block_Idx==b);
    block_progress(b,1) = min(smoothdata(block_trials==0,'gaussian',n_trials));
    block_progress(b,2) = max(smoothdata(block_trials==0,'gaussian',n_trials));
end
plot(block_progress(1:7,:)','ko-','MarkerFaceColor', 'k')
xlim([.75 2.25])
ylim([0 1])
axis square
xticks([1 2])
xticklabels({['worst ' num2str(n_trials) '-trials'], ['best ' num2str(n_trials) '-trials']});

%% Confusion matrix
s1_prob = [sum(trials(s1)==0) sum(trials(s1)==2) sum(trials(s1)==3) sum(trials(s1)==4)] /length(trials(s1));
s2_prob = [sum(trials(s2)==1) sum(trials(s2)==0) sum(trials(s2)==3) sum(trials(s2)==4)] /length(trials(s2));
s3_prob = [sum(trials(s3)==1) sum(trials(s3)==2) sum(trials(s3)==0) sum(trials(s3)==4)] /length(trials(s3));
s4_prob = [sum(trials(s4)==1) sum(trials(s4)==2) sum(trials(s4)==3) sum(trials(s4)==0)] /length(trials(s4));
s5_prob = [sum(trials(s5)==1) sum(trials(s5)==0) sum(trials(s5)==3) sum(trials(s5)==4)] /length(trials(s5));
s6_prob = [sum(trials(s6)==1) sum(trials(s6)==2) sum(trials(s6)==0) sum(trials(s6)==4)] /length(trials(s6));
s7_prob = [sum(trials(s7)==1) sum(trials(s7)==2) sum(trials(s7)==3) sum(trials(s7)==0)] /length(trials(s7));
s8_prob = [sum(trials(s8)==0) sum(trials(s8)==2) sum(trials(s8)==3) sum(trials(s8)==4)] /length(trials(s8));

c1_prob = [s1_prob;s2_prob;s3_prob;s4_prob];
c2_prob = [s5_prob;s6_prob;s7_prob;s8_prob];

%close
figure
tiledlayout(1,2, 'TileSpacing', 'compact')
nexttile
%sgtitle(['Confusion Matrices (' num2str(length(official.eod)) '-session average)'])
imagesc(c1_prob,[0 1]);
axis square
hold on
plot([0.5,0.5,1.5,1.5,0.5],[1.5,0.5,0.5,1.5,1.5],'c','linewidth',10)
plot([1.5,1.5,2.5,2.5,1.5],[2.5,1.5,1.5,2.5,2.5],'c','linewidth',10)
plot([2.5,2.5,3.5,3.5,2.5],[3.5,2.5,2.5,3.5,3.5],'c','linewidth',10)
plot([3.5,3.5,4.5,4.5,3.5],[4.5,3.5,3.5,4.5,4.5],'c','linewidth',10)
hold off
colormap(hot)
xlabel('Ctx 1','FontSize',30,'FontWeight','bold')
xticklabels({'Up', 'Right', 'Down', 'Left'})
xticks(1:4)
yticks(1:4)
yticklabels( {'A', 'B', 'C', 'D'} )
textStrings = num2str(c1_prob(:), '%0.2f');       % Create strings from the matrix values
textStrings = strtrim(cellstr(textStrings));  % Remove any space padding
[x, y] = meshgrid(1:4);  % Create x and y coordinates for the strings
hStrings = text(x(:), y(:), textStrings(:), ...  % Plot the strings
    'HorizontalAlignment', 'center');
set(hStrings,'FontSize', 35);
ax = gca;
ax.FontSize = 35;

nexttile
imagesc(c2_prob,[0 1]);
axis square
hold on
plot([1.5,1.5,2.5,2.5,1.5],[1.5,0.5,0.5,1.5,1.5],'c','linewidth',10)
plot([2.5,2.5,3.5,3.5,2.5],[2.5,1.5,1.5,2.5,2.5],'c','linewidth',10)
plot([3.5,3.5,4.5,4.5,3.5],[3.5,2.5,2.5,3.5,3.5],'c','linewidth',10)
plot([0.5,0.5,1.5,1.5,0.5],[4.5,3.5,3.5,4.5,4.5],'c','linewidth',10)
hold off
colormap(hot)
xlabel('Ctx 2','FontSize',30,'FontWeight','bold')
xticklabels({'Up', 'Right', 'Down', 'Left'})
xticks(1:4)
yticklabels({})
yticks(1:4)
textStrings = num2str(c2_prob(:), '%0.2f');       % Create strings from the matrix values
textStrings = strtrim(cellstr(textStrings));  % Remove any space padding
[x, y] = meshgrid(1:4);  % Create x and y coordinates for the strings
hStrings = text(x(:), y(:), textStrings(:), ...  % Plot the strings
    'HorizontalAlignment', 'center');
set(hStrings,'FontSize', 35);
ax = gca;
ax.FontSize = 35;

% c = colorbar('FontSize',22);
% c.Label.String = 'proportion of choices';

%% Performance at start of blocks
close
figure
n_trials=10;
first_correct = zeros(block_Idx(end),1);
post_inference = zeros(block_Idx(end),n_trials);
for b = 1:block_Idx(end)
    block_trials = trials(block_Idx==b);
    first_correct(b) = find(block_trials==0,1);
    post_inference(b,:) = block_trials(first_correct(b):first_correct(b)+n_trials-1)==0;
end

%% Trials to criterion
close
figure
hold on
trials_to_criterion = zeros(block_Idx(end),1);
for b = 1:block_Idx(end)
    criterion_thresh = 0.65; % HR
    criterion_window = 10; % -trial average
    criterion_duration = 1; % trials
    block_trials = trials(block_Idx==b)==0;
    B = smoothdata(block_trials,'gaussian',criterion_window);
    C = B > criterion_thresh;
    C_diff = diff([0 C 0]);
    starts = find(C_diff == 1); % start of streaks
    ends = find(C_diff == -1); % end of streaks
    if sum((ends-starts)>criterion_duration)==0
        trials_to_criterion(b,1) = NaN;
    else
        trials_to_criterion(b,1) = starts(find((ends-starts)>criterion_duration,1));
    end
end
trials_to_criterion = trials_to_criterion+10;
s = scatter(1:7,trials_to_criterion(1:7),'filled');
s.SizeData = 400;
xlabel('block number')

ylim([0 max(trials_to_criterion)])
ylabel('trials to criterion')
yline(mean(trials_to_criterion),'k--','LineWidth',3);
fit = polyfit(1:length(trials_to_criterion)-1,trials_to_criterion(1:7),1);
y_est = polyval(fit,1:length(trials_to_criterion));
plot(1:length(trials_to_criterion),y_est,'r--','LineWidth',3)
 legend({'',sprintf('mean = %.2f',mean(trials_to_criterion)),['linear fit (r^2 = 0.42)']},'FontSize',25)
ax = gca;
ax.FontSize = 35;
xticks(0:7)

%% Floating context predictor
n_trials = 10;
%% Complete trials
window_error = all_trials(complete_Idx);
window_cond = all_conditions(complete_Idx);
bc = find(all_block_changes(complete_Idx));
sc = find(SC_Idx(complete_Idx));

%% Official trials
window_error = trials;
window_cond = conditions_Idx;
bc = find(block_changes);
sc = find(SC_trials);
%%
%window_ctx = all_ctx_Idx(1:n_trials);
window_correct = window_error == 0;
map = [2 3 4 1 1 2 3 4];
window_correct_inv = window_error==map(window_cond);

p_c = smoothdata(window_correct,'gaussian',n_trials);
p_inv = smoothdata(window_correct_inv,'gaussian',n_trials);
p_inc = smoothdata(~window_correct & ~window_correct_inv,'gaussian',n_trials);
p_diff = p_c - p_inv;
p_tot = p_c + p_inv;
differential = p_diff./p_tot;

close all
figure
hold on
plot(p_c,'g')
plot(p_inv,'b')
plot(p_inc,'r')
%plot(p_diff,'k','LineWidth',2)
%plot(differential)
for i = sc
    xline(i,'r--')
end
for i = bc
    xline(i,'g--')
end
% for inc = find(p_inc>.6)
%     xline(inc,'k--')
% end
% for inv = find(p_inv>.6)
%     xline(inv,'k--')
% end
% for i = bc
%     xline(i,'g--')
% end
for i = sc
    xline(i,'r--')
end
yline(0,'r')

figure
histogram(p_c,'Normalization','probability','BinEdges',0:.05:1)
hold on
histogram(p_inv,'Normalization','probability','BinEdges',0:.05:1)
%histogram(p_c+p_inv,'BinEdges',0:.05:1)

percent_diff = sum(p_diff<0)/length(p_diff)
percent_inv = sum(p_inv>.6)/length(p_inv)
percent_inc = sum(p_inc>.6)/length(p_inc)

%% Cumulative counts
figure
hold on
plot(cumsum(window_correct))
plot(cumsum(window_correct_inv))
for i = bc
    xline(i,'g--')
end
for i = sc
    xline(i,'r--')
end