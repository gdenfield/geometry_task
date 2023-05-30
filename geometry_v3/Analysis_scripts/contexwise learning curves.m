c1_1 = ncl_trials(1:ncl_context_close(1));
c1_2 = ncl_trials(ncl_context_close(2):ncl_context_close(3));
c1_3 = ncl_trials(ncl_context_close(4):end);

c2_1 = ncl_trials(ncl_context_close(1):ncl_context_close(2));
c2_2 = ncl_trials(ncl_context_close(3):ncl_context_close(4));

figure
title('Cumulative Correct by Context (all conditions)')
hold on
plot(cumsum(c1_1==0))
plot(cumsum(c1_2==0))
plot(cumsum(c1_3==0))
plot(cumsum(c2_1==0))
plot(cumsum(c2_2==0))
xlabel('trial number (all non-CL trials)')
ylabel('cumulative correct')
legend('c1 1st iteration','c1 2nd iteration','c1 3rd iteration', 'c2 1st iteration', 'c2 2nd iteration')