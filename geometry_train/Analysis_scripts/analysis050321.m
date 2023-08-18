% Streak figures:

%load_data

[l,s] = streak(trials(all_completed),0);
histogram(s)
length(trials)

title(['05/03 Distribution of Correct Streaks (n = ' num2str(length(trials(all_completed))) ' completed trials)'])


figure
tiledlayout(2,2)

nexttile
[l,s] = streak(directions(all_completed),1);
histogram(s)
title('Up')

nexttile
[l,s] = streak(directions(all_completed),2);
histogram(s)
title('Right')

nexttile
[l,s] = streak(directions(all_completed),3);
histogram(s)
title('Down')

nexttile
[l,s] = streak(directions(all_completed),4);
histogram(s)
title('Left')

sgtitle(['05/03 Streaks in Direction Choices (n = ' num2str(length(directions(all_completed))) ' completed trials)'])


figure
tiledlayout(2,2)

trials_of_interest = logical(incorrect + incorrect_CL);

nexttile
[l,s] = streak(directions(trials_of_interest),1);
histogram(s)
title('Up')

nexttile
[l,s] = streak(directions(trials_of_interest),2);
histogram(s)
title('Right')

nexttile
[l,s] = streak(directions(trials_of_interest),3);
histogram(s)
title('Down')

nexttile
[l,s] = streak(directions(trials_of_interest),4);
histogram(s)
title('Left')

sgtitle(['05/03 Streaks in Direction Choices (n = ' num2str(length(directions(trials_of_interest))) ' incorrect trials)'])