function B = multi_day_running_HR(official, window)

figure
hold on
for i = 1:length(official.context_indices)
    x = official.context_indices{i};
    A = official.trials(x)==0;
    B = smoothdata(A,'gaussian',window);
    if official.context(x(1))==1
        c1 = plot(x,B,'r');
    else
        c2 = plot(x,B,'b');
    end
end
title([num2str(window) '-Trial Running HR by Context'])
xlabel('trial')
ylabel('hit-rate')
yline(0.25, 'k')
legend([c1 c2],{'Context 1','Context 2'})


% for i = 1:length(official.eod)
%     xline(official.eod(i),'--k')
% end
% 
% for i = 2:length(official.switches)-1
%     xline(official.switches(i),'r')
% end


% yline(0.5, '--k')
% yline(0.6, '--k')

% For output
A = official.trials==0;
B = smoothdata(A,'gaussian',window);
end