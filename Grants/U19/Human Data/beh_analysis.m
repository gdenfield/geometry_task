%{
    behavioral analysis for the MTurk dataset
%}


%% SD version of the task
data_sd      = parse_amazon_turk(pwd,'sd');
prop_correct = cellfun(@(x) mean(x),{data.correct});


ax = subplot(1,1,1);
plotSpread(ax,prop_correct','xValues',1,'showMM',false);


% compute performance on switch trials
for i=1:length(data_sd)
    is_switch_trial = data_sd(i).task(:,end);
  
end