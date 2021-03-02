if ~exist('eye_','var'), error('This task requires eye signal input. Please set it up or try the simulation mode.'); end
hotkey('x', 'escape_screen(); assignin(''caller'',''continue_'',false);');

% Behavioral Codes
bhv_code(...
    10,'FP1',...
    11,'Fixation Acquired',...
    20,'Stimulus',...
    30,'FP2',...
    40,'CC Trial',...
    42,'Switch Trial',...
    45, 'None Trial',...
    46,'Break Fix',...
    50,'Targets On',...
    55,'Early Answer',...
    60,'Go',...
    61,'Saccade Initated',...
    62,'Scene 6',...
    65,'Break Choice',...
    66,'Choice Made',...
    70,'Pre-Reward',...
    99,'Reward'); 

% Error Codes
trialerror(... 
    0, 'Correct',...
    1, 'Alternative',...
    2, 'Across',...
    3, 'Random',...
    4, 'No Fixation',...
    5, 'Break Fix',...
    6, 'Early Answer',...
    7, 'No Choice/ Break Choice',...
    8, 'Incorrect, CL',...
    9, 'Correct, CL');

% Online Editable Variables
editable('weight','fix_radius','wait_for_fix','fix_time','stim_time','stim_trace_time','ctx_cue_time','ctx_cue_trace_time','max_decision_time','decision_fix_time','decision_trace_time','double_thresh', 'break_time', 'solenoid_time','big_drops','drop_gaps','training_rewards', 'time_out', 'performance_thresh', 'hint');

persistent CC_trials
persistent reward_count
persistent directions

if isempty(CC_trials)
    CC_trials = [];
    
    directions = [];
end

if isempty(reward_count)
    reward_count = 0;
else
    reward_count = [reward_count (reward_count(end) + sum(TrialRecord.LastTrialCodes.CodeNumbers==99))];
end
TrialRecord.User.reward_count = reward_count;
dashboard(3, sprintf(['Total Reward: ' num2str(reward_count(end)) ' drops, %.2f drops/ trial'], (reward_count(end)./ TrialRecord.CurrentTrialNumber)), [0 255 255]);

% PARAMETERS
% Time intervals (in ms):
wait_for_fix = 5000;
fix_time = 500;
stim_time = 300;
stim_trace_time = 1000;
ctx_cue_time = 300;
ctx_cue_trace_time = [180 230]; % time maintain fixation after ctx_cue
max_decision_time = 1500;
double_thresh = 50; % threshold to prevent double saccades
break_time = 200; % threshold for loose hold breaks (for blinking)
decision_fix_time = 100; % time to register choice
decision_trace_time = 0; % period before reward delivery
time_out = 2000; % increased ITI for wrong answers

% Training variables:
weight = NaN;
TrialRecord.User.weight = weight;
fix_radius = 2.5; % degrees
performance_thresh = 0; % running HR threshold to turn off ctx_cue
performance_window = 10; % compute running HR based on n trials back
hint = 10; % # trials to show context cue independent of performance

% Reward variables:
training_rewards = [0 0 0 0 0]; % change to 1 to turn on training rewards for given scene (1-5)
solenoid_time = 200; %ms
drop_gaps = 0; %ms
little_drops = 1; %number of pulses
big_drops = 2; %number of pulses

% TaskObjects defined in the conditions file:
fixation_point = 1;
FP_background = 2;
stimulus = 3;
ctx_cue = 4;
target = 5;
off_target1 = 6;
off_target2 = 7;
off_target3 = 8;

%Lick monitor
aim = AnalogInputMonitor(null_);
aim.Channel = 1;                  % General Input 1
aim.Position = [800 600 500 40];   % [left top width height]
aim.YLim = [0 5];
aim.Title = 'Lick Detector';
tc = TimeCounter(aim);
tc.Duration = 50000;

% SCENES:
% scene 1: fixation
fix1 = SingleTarget(eye_);
fix1.Target = fixation_point;
fix1.Threshold = fix_radius;
wth1 = WaitThenHold(fix1);       
wth1.WaitTime = wait_for_fix;
wth1.HoldTime = fix_time;
con1 = Concurrent(wth1);
con1.add(tc);
scene1 = create_scene(con1,fixation_point); 

% scene 2: stimulus
fix2 = SingleTarget(eye_);
fix2.Target = fixation_point;
fix2.Threshold = fix_radius;
lh2 = LooseHold(fix2);
%wth2.WaitTime = 0; % Fixation is already acquired, so don't wait.
lh2.HoldTime = stim_time;
lh2.BreakTime = break_time; % To allow for blinks
con2 = Concurrent(lh2);
con2.add(tc);
scene2 = create_scene(con2, [fixation_point FP_background stimulus]);

% scene 3: stimulus trace
fix3 = SingleTarget(eye_);
fix3.Target = fixation_point;
fix3.Threshold = fix_radius;
lh3 = LooseHold(fix3);
%wth3.WaitTime = 0;
lh3.HoldTime = stim_trace_time;
lh3.BreakTime = break_time;
con3 = Concurrent(lh3);
con3.add(tc);
scene3 = create_scene(con3,fixation_point);

% scene 4: context/ switch/ none cue
fix4 = SingleTarget(eye_);
fix4.Target = fixation_point;
fix4.Threshold = fix_radius;
lh4 = LooseHold(fix4);
%wth4.WaitTime = 0;
lh4.HoldTime = ctx_cue_time;
lh4.BreakTime = break_time;
con4 = Concurrent(lh4);
con4.add(tc);
try
    if hit_rate(TrialRecord.TrialErrors(end-performance_window:end))>=performance_thresh && TrialRecord.CurrentTrialWithinBlock>hint
        CC_trials = [CC_trials 0];
        dashboard(2, 'None Trial', [255 255 255])
        scene4 = create_scene(con4,[fixation_point FP_background]);
    else
        CC_trials = [CC_trials 1];
        dashboard(2, 'CC Trial',[255 0 255])
        scene4 = create_scene(con4,[fixation_point FP_background ctx_cue]);
    end
catch
    CC_trials = [CC_trials 1];
    dashboard(2, 'CC Trial',[255 0 255])
    scene4 = create_scene(con4,[fixation_point FP_background ctx_cue]);
end

TrialRecord.User.CC_trials = CC_trials;

% scene 5: context trace, targets on
fix5 = SingleTarget(eye_);
fix5.Target = fixation_point;
fix5.Threshold = fix_radius;
lh5 = LooseHold(fix5);
%lh5.WaitTime = 0;
%lh5.HoldTime = randi(ctx_cue_trace_time);
lh5.BreakTime = break_time;
lh5.HoldTime = exprnd(300)+ ctx_cue_trace_time(1); % add noise from exponential distribution (i.e. flat hazard rate)
if lh5.HoldTime > ctx_cue_trace_time(2)
    lh5.HoldTime = ctx_cue_trace_time(2); % don't let the interval get too long
end
dashboard(6, sprintf('CC Delay: %.2f', lh5.HoldTime));
con5 = Concurrent(lh5);
con5.add(tc);
scene5 = create_scene(con5,[fixation_point target off_target1 off_target2 off_target3]);

% scene 6a: Double saccade prevention
fix6a = SingleTarget(eye_);
fix6a.Target = fixation_point;
fix6a.Threshold = fix_radius;
fix6a.Color = [255 0 0];
wth6a = WaitThenHold(fix6a);
wth6a.WaitTime = 0; % fixation is already acquired
wth6a.HoldTime = max_decision_time; % allow up to max decision time to initiate saccade, when fix is broken saccade is initiated
con6a = Concurrent(wth6a);
con6a.add(tc);
scene6a = create_scene(con6a,[target off_target1 off_target2 off_target3]);

% scene 6: choice
mul6 = MultiTarget(eye_);
mul6.Target = [target off_target1 off_target2 off_target3];
mul6.Threshold = fix_radius;
mul6.WaitTime = double_thresh;
mul6.HoldTime = decision_fix_time;
mul6.TurnOffUnchosen = false;
con6 = Concurrent(mul6);
con6.add(tc);
scene6 = create_scene(con6,[target off_target1 off_target2 off_target3]);


% TASK:
%Dashboard settings
try
    running_HR = hit_rate(TrialRecord.TrialErrors(end-performance_window:end));
catch
    running_HR = hit_rate(TrialRecord.TrialErrors);
end

dashboard(1, sprintf([num2str(performance_window) '-Trial HR: %.2f, Overall HR: %.2f'], running_HR*100, hit_rate(TrialRecord.TrialErrors)*100));
if TrialRecord.User.CL
    dashboard(4, 'Correction Loop!', [255 0 0])
else
    dashboard(4, 'Good Monkey', [0 255 0])
end

direction_count = [sum(directions==1) sum(directions==2) sum(directions==3) sum(directions==4)];
dashboard(5, ['Choices [Up Right Down Left]: ' num2str(direction_count)], [255 255 0]); 
dashboard(7, sprintf('Percent Early Choices: %.2f', sum(TrialRecord.TrialErrors==6)/length(TrialRecord.TrialErrors)*100),[255 0 0]); 

directions = [directions 0];

% scene 1: fixation
run_scene(scene1,10);
if ~wth1.Success
    idle(0);
    if wth1.Waiting
        trialerror(4); % No Fixation
    else
        trialerror(5); % Break Fixation
        eventmarker(46);
    end
    return
else
    eventmarker(11) % Fixation acquired
    if training_rewards(1), goodmonkey(solenoid_time, 'numreward', little_drops); end
end

% scene 2: stimulus
run_scene(scene2,20);
if ~lh2.Success
    idle(0);
    trialerror(5); % Break Fixation
    eventmarker(46);
    return
else
    if training_rewards(2), goodmonkey(solenoid_time, 'numreward', little_drops); end
end

% scene 3: stimulus trace
run_scene(scene3,30);
if ~lh3.Success
    idle(0);
    trialerror(5); % Break Fixation
    eventmarker(46);
    return
else
    if training_rewards(3), goodmonkey(solenoid_time, 'numreward', little_drops); end
end

% scene 4: context cue
if TrialRecord.User.CC_trials(end)
    run_scene(scene4,40);
else
    run_scene(scene4,45);
end
if ~lh4.Success
    idle(0);
    trialerror(5); % Break Fixation
    eventmarker(46);
    return
else
    if training_rewards(4), goodmonkey(solenoid_time, 'numreward', little_drops); end
end

% scene 5: context trace, targets on
run_scene(scene5, 50);
if ~lh5.Success
    idle(0);
    trialerror(6); % Early Answer
    eventmarker(55) % Early Answer
    return
else
    if training_rewards(5), goodmonkey(solenoid_time, 'numreward', little_drops); end
end

% scene 6a: Double saccade prevention
run_scene(scene6a, 60); % Go cue

if ~wth6a.Success % Saccade initiated
    eventmarker(61)
else
    trialerror(7); % No Choice
end

% scene 6: choice
run_scene(scene6, 62);
rt = mul6.RT;    

if ~mul6.Waiting
    eventmarker(66) % Choice Made 
end

if ~mul6.Success
    idle(0);
    if mul6.Waiting
        trialerror(7); % No Choice or double saccade
    else
        trialerror(7); % Break Choice
        eventmarker(65)
    end
    return
end

% Rewards
if target==mul6.ChosenTarget
    if TrialRecord.User.CL
            trialerror(9); % Correct CL trial
            idle(decision_trace_time,[], 70)
            goodmonkey(solenoid_time, 'numreward', big_drops, 'pausetime', drop_gaps, 'eventmarker',99);
    else
        trialerror(0); % Correct
        idle(decision_trace_time,[], 70)
        goodmonkey(solenoid_time, 'numreward', big_drops, 'pausetime', drop_gaps, 'eventmarker',99);
    end
    
    %Code Direction - Correct
    if TrialRecord.CurrentCondition == 1 || TrialRecord.CurrentCondition == 8
        directions(end) = 1;
    elseif TrialRecord.CurrentCondition == 2 || TrialRecord.CurrentCondition == 7
        directions(end) = 3;
    elseif TrialRecord.CurrentCondition == 3 || TrialRecord.CurrentCondition == 5
        directions(end) = 2;
    elseif TrialRecord.CurrentCondition == 4 || TrialRecord.CurrentCondition == 6
        directions(end) = 4;
    end
elseif off_target1==mul6.ChosenTarget
    if TrialRecord.User.CL
        trialerror(8); % Incorrect CL trial
        idle(time_out)
    else
        idle(time_out)
        trialerror(1); % Incorrect, correct in other context
    end
    
    %Code Direction - Other Context
    if TrialRecord.CurrentCondition == 1 || TrialRecord.CurrentCondition == 7
        directions(end) = 2;
    elseif TrialRecord.CurrentCondition == 2 || TrialRecord.CurrentCondition == 8
        directions(end) = 4;
    elseif TrialRecord.CurrentCondition == 3 || TrialRecord.CurrentCondition == 6
        directions(end) = 3;
    elseif TrialRecord.CurrentCondition == 4 || TrialRecord.CurrentCondition == 5
        directions(end) = 1;
    end
elseif off_target2==mul6.ChosenTarget
    if TrialRecord.User.CL
        trialerror(8); % Incorrect CL trial
        idle(time_out)
    else
        idle(time_out)
        trialerror(2) % Incorrect, across FP from target
    end
    
    %Code Direction - Across
    if TrialRecord.CurrentCondition == 1 || TrialRecord.CurrentCondition == 8
        directions(end) = 3;
    elseif TrialRecord.CurrentCondition == 2 || TrialRecord.CurrentCondition == 7
        directions(end) = 1;
    elseif TrialRecord.CurrentCondition == 3 || TrialRecord.CurrentCondition == 5
        directions(end) = 4;
    elseif TrialRecord.CurrentCondition == 4 || TrialRecord.CurrentCondition == 6
        directions(end) = 2;
    end
elseif off_target3==mul6.ChosenTarget
    if TrialRecord.User.CL
        trialerror(8); % Incorrect CL trial
        idle(time_out)
    else
        idle(time_out)
        trialerror(3) % Incorrect, random guess
    end
    
    %Code Direction - Random
    if TrialRecord.CurrentCondition == 1 || TrialRecord.CurrentCondition == 7
        directions(end) = 4;
    elseif TrialRecord.CurrentCondition == 2 || TrialRecord.CurrentCondition == 8
        directions(end) = 2;
    elseif TrialRecord.CurrentCondition == 3 || TrialRecord.CurrentCondition == 6
        directions(end) = 1;
    elseif TrialRecord.CurrentCondition == 4 || TrialRecord.CurrentCondition == 5
        directions(end) = 3;
    end
end

TrialRecord.User.directions = directions;