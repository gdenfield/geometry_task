figure
hold on

%plot(cumsum(ncl_trials==0))
for s = 1:8
    plot(cumsum(ncl_trials==0&ncl_conditions==s))
end

for i = 1:length(ncl_session_close)
    xline(ncl_session_close(i))
end

for i = 1:length(ncl_context_close)
    xline(ncl_context_close(i),'r')
end

figure
hold on

