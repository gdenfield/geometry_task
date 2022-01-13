% % SD Task Import
% cd ./'SD Task'/
% sd_data = parse_amazon_turk_SD(pwd);
%
% % GGGP Task Import
% cd ../'CCGP Task'/
% ccgp_data = parse_amazon_turk_CCGP(pwd);

% % Summary Statistics
% sd_HR = sum([sd_data.correct])/length(sd_data(1).correct);
% figure
% histogram(sd_HR,'BinEdges',0:.1:1)
% xlabel('hit rate')
% title(['SD Task Performance (n = ' num2str(length(sd_HR)) ')'])
%
% ccgp_HR = sum([ccgp_data.correct])/length(ccgp_data(1).correct);
% figure
% histogram(ccgp_HR,'BinEdges',0:.1:1)
% xlabel('hit rate')
% title(['CCGP Task Performance (n = ' num2str(length(ccgp_HR)) ')'])
%
%
% % Context 1 vs. Context 2
% c1 = [sd_data.context]==1;
% c2 = [sd_data.context]==2;
% sd_c1_HR = [];
% sd_c2_HR = [];
% for i = 1:length(sd_data)
%     sd_c1_HR = [sd_c1_HR sum(sd_data(i).correct(c1(:,i)))/length(sd_data(i).correct(c1(:,i)))];
%     sd_c2_HR = [sd_c2_HR sum(sd_data(i).correct(c2(:,i)))/length(sd_data(i).correct(c2(:,i)))];
% end
% figure
% scatter(sd_c1_HR, sd_c2_HR)
% axis square
% xlabel('Ctx 1 HR')
% ylabel('Ctx 2 HR')
% title(['SD Task - Ctx 1 vs. Ctx 2 Performance (n = ' num2str(length(sd_c1_HR)) ')'])
%
% c1 = logical(mod([ccgp_data.context],2));
% c2 = ~c1;
% ccgp_c1_HR = [];
% ccgp_c2_HR = [];
% for i = 1:length(ccgp_data)
%     ccgp_c1_HR = [ccgp_c1_HR sum(ccgp_data(i).correct(c1(:,i)))/length(ccgp_data(i).correct(c1(:,i)))];
%     ccgp_c2_HR = [ccgp_c2_HR sum(ccgp_data(i).correct(c2(:,i)))/length(ccgp_data(i).correct(c2(:,i)))];
% end
% figure
% scatter(ccgp_c1_HR, ccgp_c2_HR)
% axis square
% xlabel('Ctx 1 HR')
% ylabel('Ctx 2 HR')
% title(['CCGP Task - Ctx 1 vs. Ctx 2 Performance (n = ' num2str(length(ccgp_c1_HR)) ')'])
%
% % SC Trial Statistics
% sd_sc_HR = [];
% for i = 1:length(sd_data)
%     sd_sc_HR = [sd_sc_HR sum(sd_data(i).correct(sd_data(i).sc_on))/length(sd_data(i).correct(sd_data(i).sc_on))];
% end
% figure
% histogram(sd_sc_HR,'BinEdges',0:.1:1)
% xlabel('hit rate')
% title(['SD Task - SC Trial Performance (n = ' num2str(length(sd_sc_HR)) ')'])
%
% ccgp_sc_HR = [];
% for i = 1:length(sd_data)
%     ccgp_sc_HR = [ccgp_sc_HR sum(ccgp_data(i).correct(ccgp_data(i).sc_on))/length(ccgp_data(i).correct(ccgp_data(i).sc_on))];
% disp(sum(ccgp_data(i).sc_on))
% end
% figure
% histogram(ccgp_sc_HR,'BinEdges',0:.1:1)
% xlabel('hit rate')
% title(['CCGP Task - SC Trial Performance (n = ' num2str(length(ccgp_sc_HR)) ')'])
%
% % cc-wise performance
% cc_HR = zeros(max(ccgp_data(1).context), length(ccgp_data));
% figure
% hold on
% for i = 1:length(ccgp_data)
%     for b = 1:max(ccgp_data(i).context)
%         block_i = find((ccgp_data(i).context-b)==0);
%         cc_HR(b,i) = sum(ccgp_data(i).correct(block_i))/length(ccgp_data(i).correct(block_i));
%     end
%     scatter(rand(1,max(ccgp_data(i).context)), cc_HR(:,i),'filled')
% end

% CC on vs off

% High/ low reward

% Confusion Matrices

% % Special trial performance
% data = parse_amazon_turk(pwd,'ccgp');
% probe_blocks = [9,10,15,16,21,22,27,28,33,34];
% probe_performance = zeros(length(data),1);
% new_CC_HR = zeros(length(data),1);
% for i = 1:length(data)
%     probe_trials = [];
%     for b = probe_blocks
%         block = data(i).correct(cell2mat(data(i).task(:,7))==b);
%         probe_trials = [probe_trials block(1)];
%     end
%     probe_performance(i) = sum(probe_trials)/length(probe_trials);
%     new_CC_trials = data(i).correct(33:end);
%     new_CC_HR(i) = sum(new_CC_trials)/length(new_CC_trials);
% end
% good_subjects = find(new_CC_HR>.5);
% figure
% scatter(new_CC_HR(good_subjects), probe_performance(good_subjects),'filled')
% %title('Held-Out Trial Performance vs. New CC Block Performance (n = 11 subjects)')
% ax = gca;
% ax.FontSize = 15;
% xlabel('overall performance','FontSize',25)
% ylabel('generalization performance','FontSize',25)


% figure
% histogram(probe_performance,'BinEdges',0:.1:1)
% ylabel('count')
% title('Held-Out Trial Performance (n = 15 subjects)')
% xlabel({'average performance', [' (' num2str(length(probe_blocks)) ' trials)']})

% Learning as fxn of trial number
% figure
% hold on
% blocks = cell(1,29);
% for b = 1:29
%     for i = 1:length(good_subjects)
%         blocks{b} = [cumsums{good_subjects,b+4}]';
%         plot(blocks{b}')
%     end
% end
% master_block = vertcat(blocks{:});
% plot(mean(master_block),'k','LineWidth',2)


% figure
% hold on
% cumsums = zeros(length(data),length(data(1).correct));
% for i = good_subjects'
%     cumsums(i,:) = cumsum(data(i).correct);
%     plot(cumsums(i,:)./(1:length(cumsums(i,:))))
% end

% figure
% hold on
% smooths = zeros(length(data),length(data(1).correct));
% for i = good_subjects'
%     smooths(i,:) = smoothdata(data(i).correct,'gaussian',10);
%     plot(smooths(i,:))
% end
% plot(mean(smooths),'k',"LineWidth",2)
%
% % block_switch = find(diff(cell2mat(data(i).task(:,7))))+1;
% % for b = block_switch'
% %     xline(b,'-r')
% % end
% ylim([0,1])
% ylabel('10-trial running hit rate')
% xlabel('trial')
% title('CCGP Task - Session Learning (n = 11 subjects)')

% First two blocks

% Cumulative correct version
% figure
% hold on
% for i = good_subjects'
%     plot(cumsum([corrects{i,1}; corrects{i,3}]),'-')
% end
% all_learning = [corrects{:,1}; corrects{:,3}]';
% plot(cumsum(mean(all_learning)),'k','LineWidth',2)
% title('Ctx 1 Learning (Blocks 1 & 3)')
% xlabel('trial')
% ylabel('cumultive correct')
%
% figure
% hold on
% for i = good_subjects'
%     plot(cumsum([corrects{i,2}; corrects{i,4}]),'-')
% end
% all_learning = [corrects{:,2}; corrects{:,4}]';
% plot(cumsum(mean(all_learning)),'k','LineWidth',2)
% title('Ctx 2 Learning (Blocks 2 & 4)')
% xlabel('trial')
% ylabel('cumultive correct')

% HR version
% figure
% hold on
% for i = good_subjects'
%     plot(smoothdata([corrects{i,1}; corrects{i,3}],'gaussian',4))
% end
% all_learning = [corrects{:,1}; corrects{:,3}]';
% plot(smoothdata(mean(all_learning),'gaussian',4),'k','LineWidth',2)
% title('Ctx 1 Learning (Blocks 1 & 3)')
% xlabel('trial')
% ylabel('4-trial running HR')

% figure
% hold on
% for i = good_subjects'
%     plot(smoothdata([corrects{i,2}; corrects{i,4}],'gaussian',4))
% end
% all_learning = [corrects{:,2}; corrects{:,4}]';
% plot(smoothdata(mean(all_learning),'gaussian',4),'k','LineWidth',2)
% title('Ctx 2 Learning (Blocks 2 & 4)')
% xlabel('trial')
% ylabel('4-trial running HR')

% HR plot - average C1 and C2
%data = parse_amazon_turk(pwd,'sd');
% data = parse_amazon_turk(pwd,'ccgp');
% HR = zeros(length(data),1);
% for i = 1:length(data)
%     HR(i) = sum(data(i).correct)/length(data(i).correct);
% end
% good_subjects = find(HR>.5);
% 
% corrects = cell(length(data), max(cell2mat(data(1).task(:,7))));
% cumsums = cell(length(data), max(cell2mat(data(1).task(:,7))));
% for i = 1:length(data)
%     blocks = 1:max(cell2mat(data(i).task(:,7)));
%     for b = blocks
%         corrects{i,b} = data(i).correct(cell2mat(data(i).task(:,7))==b);
%         cumsums{i,b} = cumsum(data(i).correct(cell2mat(data(i).task(:,7))==b));
%     end
% end
% 
% figure
% hold on
% c1_learning = [corrects{:,1}; corrects{:,3}]';
% c2_learning = [corrects{:,2}; corrects{:,4}]';
% for i = good_subjects'
%     plot(smoothdata(mean([c1_learning(i,:); c2_learning(i,:)]),'gaussian',6),':','LineWidth',2);
% end
% plot(smoothdata(mean([c1_learning; c2_learning]),'gaussian',6),'-k','LineWidth',3);
% %title('Learning Curves (Average Ctx 1 and Ctx 2)')
% xlabel('trial number')
% ylabel('performance (6-trial average)')
% ax = gca;
% ax.FontSize = 25;

% % SD Task - SC vs overall performance
% data = parse_amazon_turk(pwd,'sd');
% HR = zeros(length(data),1);
% SC_performance = zeros(length(data),1);
% for i = 1:length(data)
%     SC_on = cellfun(@(x) isequal(x,"TRUE"),data(i).task(:,8));
%     SC_trials = data(i).correct(SC_on);
%     SC_performance(i) = sum(SC_trials)/length(SC_trials);
%     HR(i) = sum(data(i).correct)/length(data(i).correct);
% end
% good_subjects = find(HR>.5);
% 
% figure
% scatter(HR(good_subjects), SC_performance(good_subjects),'filled')
% %title('SC Trial Performance vs. Overall Performance (n = 11 subjects)')
% ax = gca;
% ax.FontSize = 15;
% xlabel('overall performance','FontSize',25)
% ylabel('performance (switch cue trials)','FontSize',25)

%% EFGH Task
% Parse Data
data = parse_amazon_turk(pwd,'efgh');
HR = zeros(length(data),1);
ABCD_HR = zeros(length(data),1);
EFGH_HR = zeros(length(data),1);
corrects = cell(length(data), max(cell2mat(data(1).task(:,7))));

for i = 1:length(data)
    ABCD = cellfun(@(x) isequal(x,1),data(i).task(:,4));
    EFGH = cellfun(@(x) isequal(x,2),data(i).task(:,4));
    blocks = 1:max(cell2mat(data(i).task(:,7)));
    for b = blocks
        corrects{i,b} = data(i).correct(cell2mat(data(i).task(:,7))==b);
    end

    HR(i) = sum(data(i).correct)/length(data(i).correct);
    ABCD_HR(i) = sum(data(i).correct(ABCD))/length(data(i).correct(ABCD));
    EFGH_HR(i) = sum(data(i).correct(EFGH))/length(data(i).correct(EFGH));
end
%% Overall HR
figure
bar(HR)
xlabel('subject')
ylabel('overall performance')
title('EFGH Task')

%% ABCD vs. EFGH
figure
scatter(ABCD_HR,EFGH_HR)
axis square
xlim([0 1])
ylim([0 1])
xlabel('ABCD performance')
ylabel('EFGH performance')
title('Set 1 vs Set 2')

%% Performance per block
block_performance = zeros(size(corrects));
for i = 1:length(data)
    for b = 1:size(corrects, 2)
        block_performance(i,b) = sum(corrects{i,b})/length(corrects{i,b});
    end
end
figure
boxplot(block_performance)
xlabel('block')
ylabel('performance')
title('Learning Across Blocks')

%% Fractal-Wise Performance
fractal_performance = zeros(length(data), 8);
A_corr = [];
B_corr = [];
C_corr = [];
D_corr = [];
E_corr = [];
F_corr = [];
G_corr = [];
H_corr = [];

for i = 1:length(data)
    A = cellfun(@(x) isequal(x,'img_1.bmp'),data(i).task(:,1));
    B = cellfun(@(x) isequal(x,'img_2.bmp'),data(i).task(:,1));
    C = cellfun(@(x) isequal(x,'img_3.bmp'),data(i).task(:,1));
    D = cellfun(@(x) isequal(x,'img_4.bmp'),data(i).task(:,1));
    E = cellfun(@(x) isequal(x,'img_5.bmp'),data(i).task(:,1));
    F = cellfun(@(x) isequal(x,'img_6.bmp'),data(i).task(:,1));
    G = cellfun(@(x) isequal(x,'img_7.bmp'),data(i).task(:,1));
    H = cellfun(@(x) isequal(x,'img_8.bmp'),data(i).task(:,1));
    
    fractal_performance(i,1) = sum(data(i).correct(A))/length(data(i).correct(A));
    fractal_performance(i,2) = sum(data(i).correct(B))/length(data(i).correct(B));
    fractal_performance(i,3) = sum(data(i).correct(C))/length(data(i).correct(C));
    fractal_performance(i,4) = sum(data(i).correct(D))/length(data(i).correct(D));
    fractal_performance(i,5) = sum(data(i).correct(E))/length(data(i).correct(E));
    fractal_performance(i,6) = sum(data(i).correct(F))/length(data(i).correct(F));
    fractal_performance(i,7) = sum(data(i).correct(G))/length(data(i).correct(G));
    fractal_performance(i,8) = sum(data(i).correct(H))/length(data(i).correct(H));
    
    A_corr = [A_corr; data(i).correct(A)];
    B_corr = [B_corr; data(i).correct(B)];
    C_corr = [C_corr; data(i).correct(C)];
    D_corr = [D_corr; data(i).correct(D)];
    E_corr = [E_corr; data(i).correct(E)];
    F_corr = [F_corr; data(i).correct(F)];
    G_corr = [G_corr; data(i).correct(G)];
    H_corr = [H_corr; data(i).correct(H)];
end
figure
boxplot(fractal_performance)
xlabel('stimulus')
xticklabels({'A','B','C','D','E','F','G','H'})
ylabel('performance')
title('Performance by Stimulus')
%% First trial in block
block_starts = [1,25,49,65,81,97,113,129,145,161,177,193,209,225,241,257,273,289,305,321];
first_trial_type = zeros(length(data),length(blocks));
first_trial_correct = zeros(length(data),length(blocks));
nl_HR = zeros(length(data),1);
n_learning_blocks = 2;
for i = 1:length(data)
    for b = 1:length(blocks)
        first_trial_type(i,b) = str2double(data(i).task{block_starts(b),1}(5));
        first_trial_correct(i,b) = data(i).correct(block_starts(b));
    end
    correct = data(i).correct;
    correct = correct(block_starts(n_learning_blocks+1):end);
    remove = block_starts(n_learning_blocks+1:end)-block_starts(n_learning_blocks+1)+1;
    correct(remove) = [];
    nl_HR(i) = mean(correct);
end
first_trial_type = first_trial_type(:,n_learning_blocks+1:end);
first_trial_correct = first_trial_correct(:,n_learning_blocks+1:end);

figure
scatter(nl_HR,mean(first_trial_correct'))
axis square
refline(1,0)
xlabel('other trial performance')
ylabel('first trial performance')
%title('Overall vs. First Trial Performance (blocks 3-20)')

%% First trial performance by type
first_fractal_HR = zeros(8,1);
for s = 1:8
    first_fractal_HR(s) = mean(first_trial_correct(find(first_trial_type==s)));
end
fractal_HR = [mean(A_corr); mean(B_corr); mean(C_corr); mean(D_corr); mean(E_corr); mean(F_corr); mean(G_corr); mean(H_corr)];
figure
hold on
for s = 1:8
    scatter(fractal_HR(s), first_fractal_HR(s));
end
xlabel('overall performance')
ylabel('first trial performance')
title('Overall vs. First Trial Performance by Stimulus')
legend({'A','B','C','D','E','F','G','H'})

%% Learning Curves
figure
hold on
c1_learning = [corrects{:,1}; corrects{:,3}]';
c2_learning = [corrects{:,2}; corrects{:,4}]';
for i = 1:length(data)
    plot(smoothdata(mean([c1_learning(i,:); c2_learning(i,:)]),'gaussian',6),':','LineWidth',2);
end
plot(smoothdata(mean([c1_learning; c2_learning]),'gaussian',6),'-k','LineWidth',3);
%title('EFGH Task Learning Curves')
xlabel('trial number')
ylabel('performance (6-trial average)')
ax = gca;
ax.FontSize = 25;

%% First N trials in block
block_starts = [1,25,49,65,81,97,113,129,145,161,177,193,209,225,241,257,273,289,305,321];
n_trials = 4;
first_n_trials = zeros(length(data),length(blocks)*n_trials);
nl_HR = zeros(length(data),1);
n_learning_blocks = 2;
for i = 1:length(data)
    for b = 1:length(blocks)
        first_n_trials(i,b*n_trials-(n_trials-1):b*n_trials) = data(i).correct(block_starts(b):block_starts(b)+n_trials-1);
    end
     correct = data(i).correct;
     correct = correct(block_starts(n_learning_blocks+1):end);
     remove = block_starts(n_learning_blocks+1:end)-block_starts(n_learning_blocks+1)+1;
     for j = 1:n_trials-1
         remove = sort(unique([remove remove+1]));
     end
     correct(remove) = [];
     nl_HR(i) = mean(correct);
end
first_n_trials = first_n_trials(:,n_learning_blocks*n_trials+1:end);

figure
scatter(nl_HR,mean(first_n_trials'))
axis square
refline(1,0)
xlabel('other trial performance')
ylabel(['first ' num2str(n_trials) '-trial performance'])
title(['First ' num2str(n_trials) '-Trial Performance (blocks 3-20)'])