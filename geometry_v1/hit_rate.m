%Calculate hit-rate based on trial error record
function HR = hit_rate(trials)

correct = sum(trials==0);
incorrect = sum(trials==1|trials==2|trials==3|trials==4);
HR = correct/ (correct + incorrect);

if isnan(HR) %for early trials, before any correct/ incorrect trials are completed
    HR = 0;
end

end