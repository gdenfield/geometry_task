%% INITIALIZATION
if ~exist('eye_','var'), error('This task requires eye signal input. Please set it up or try the simulation mode.'); end
hotkey('x', 'escape_screen(); assignin(''caller'',''continue_'',false);');
hotkey('s', 'TrialRecord.User.switch = 1;'); % press 's' key during task to manually trigger context switch (with SC trials)
hotkey('d', 'TrialRecord.User.block_length = TrialRecord.User.block_length * 2;'); % press 'd' to double block length
hotkey('h', 'TrialRecord.User.block_length = TrialRecord.User.block_length / 2;'); % press 'h' to half block length
hotkey('t', 'idle(120000, [75 0 130], 666);') % press 't' to give a 2-minute timeout

% Behavioral Codes
bhv_code(...
    01,'SC',...
    10,'FP1',...
    11,'Fixation Acquired',...
    20,'Stimulus',...
    30,'FP2',...
    40,'CC Trial',...
    42,'Switch Trial',...
    45,'None Trial',...
    46,'Break Fix',...
    50,'Targets On',...
    55,'Early Answer',...
    60,'Go',...
    61,'Saccade Initated',...
    62,'Making Choice',...
    65,'Break Choice',...
    66,'Choice Made',...
    70,'Pre-Reward, Large',...
    71,'Pre-Reward, Small',...
    99,'Reward',...
    666,'Tantrum'); 

% Error Codes
trialerror(... 
    0, 'Correct',...
    1, 'Up',...
    2, 'Right',...
    3, 'Down',...
    4, 'Left',...
    5, 'No Fix',...
    6, 'Break Fix',...
    7, 'Early Answer',...
    8, 'No Choice',...
    9, 'Break Choice/ Double Saccade');

% Online Editable Variables
editable(...
    'weight',...
    'fix_radius',...
    'wait_for_fix',...
    'fix_time',...
    'stim_time',...
    'stim_trace_time',...
    'ctx_cue_time',...
    'ctx_cue_trace_time',...
    'max_decision_time',...
    'decision_fix_time',...
    'decision_trace_time',...
    'double_thresh',...
    'blink_time',...
    'solenoid_time',...
    'big_drops',...
    'little_drops',...
    'drop_gaps',...
    'training_rewards',...
    'training_reward_prob',...
    'time_out_sr',...
    'time_out_lr',...
    'n_cc_trials');


TrialRecord.MarkSkippedFrames = true; % Records eventcode 13 as skipped frames

persistent CC_trials
persistent SC_trials
persistent None_trials
persistent correct_count

if isempty(CC_trials)
    CC_trials = [];
    SC_trials = [];
    None_trials = [];
end

if isempty(correct_count)
    correct_count = 0;
else
    correct_count = [correct_count sum(TrialRecord.TrialErrors==0)];
end

z=round(rand(1)*100);
TrialRecord.User.correct_count = correct_count;
dashboard(3, ['Correct Trials: ' num2str(sum(TrialRecord.TrialErrors==0) + sum(TrialRecord.TrialErrors==9)) ', Completed Trials: ' num2str(sum(TrialRecord.TrialErrors==0) + sum(TrialRecord.TrialErrors==1) + sum(TrialRecord.TrialErrors==2) + sum(TrialRecord.TrialErrors==3) + sum(TrialRecord.TrialErrors==4))], [0 255 255]);

%% PARAMETERS
% Time intervals (in ms):
wait_for_fix = 5000;
fix_time = 500;
stim_time = 300;
stim_trace_time = 1000;
ctx_cue_time = 300;
ctx_cue_trace_time = [180 230]; % time maintain fixation after ctx_cue
max_decision_time = 1500;
double_thresh = 50; % threshold to prevent double saccades
blink_time = 200; % threshold for loose hold breaks (for blinking)
decision_fix_time = 100; % time to register choice
decision_trace_time = 300; % period before reward delivery
time_out_sr = 2000; % increased ITI for wrong answers; gd 3/30/22
time_out_lr = 1000; % increased ITI for wrong answers on large reward trials gd 3/30/22
sc_duration = 1000;

% Training variables:
weight = NaN;
TrialRecord.User.weight = weight;
fix_radius = 2.5; % degrees
performance_window = 10; % compute running HR based on n trials back
n_cc_trials = 5; % # trials to show context cue independent of performance

% Reward variables:
training_rewards = [0 0 0 0 0]; % change to 1 to turn on training rewards for given scene (1-5)
training_reward_prob = .5; % probability of random reward delivery
solenoid_time = 200; %ms
drop_gaps = 0; %ms
little_drops = 1; %number of pulses
big_drops = 2; %number of pulses
training_drops = 1; %number of pulses

% TaskObjects defined in the conditions file:
fixation_point = 1;
FP_background = 2;
stimulus = 3;
ctx_cue = 4;
up = 5;
right = 6;
down = 7;
left = 8;
switch_cue = 9;

%Lick monitor
aim = AnalogInputMonitor(null_);
aim.Channel = 1;                  % General Input 1
aim.Position = [800 600 500 40];   % [left top width height]
aim.YLim = [0 5];
aim.Title = 'Lick Detector';
tc = TimeCounter(aim);
tc.Duration = 50000;

% SCENES:
% scene 0: switch-cue
tc = TimeCounter(null_);
tc.Duration = sc_duration;
scene0 = create_scene(tc); %add here switch_cue if you want to display it

% scene 1: fixation
fix1 = SingleTarget(eye_);
fix1.Target = fixation_point;
fix1.Threshold = fix_radius;
wth1 = WaitThenHold(fix1);       
wth1.WaitTime = wait_for_fix;
wth1.HoldTime = fix_time;
con1 = Concurrent(wth1);
con1.add(tc);
scene1 = create_scene(con1, fixation_point);

% scene 2: stimulus
fix2 = SingleTarget(eye_);
fix2.Target = fixation_point;
fix2.Threshold = fix_radius;
lh2 = LooseHold(fix2);
lh2.HoldTime = stim_time;
lh2.BreakTime = blink_time; % To allow for blinks
con2 = Concurrent(lh2);
con2.add(tc);
scene2 = create_scene(con2, [fixation_point FP_background stimulus]);

% scene 3: stimulus trace
fix3 = SingleTarget(eye_);
fix3.Target = fixation_point;
fix3.Threshold = fix_radius;
lh3 = LooseHold(fix3);
lh3.HoldTime = stim_trace_time;
lh3.BreakTime = blink_time;
con3 = Concurrent(lh3);
con3.add(tc);
scene3 = create_scene(con3,fixation_point);

% scene 4: context cue/ none cue
fix4 = SingleTarget(eye_);
fix4.Target = fixation_point;
fix4.Threshold = fix_radius;
lh4 = LooseHold(fix4);
lh4.HoldTime = ctx_cue_time;
lh4.BreakTime = blink_time;
con4 = Concurrent(lh4);
con4.add(tc);

% Test for CC Trial
TrialRecord.User.CC = TrialRecord.CurrentTrialWithinBlock<=n_cc_trials || TrialRecord.User.SC;

%Build Scene    
if TrialRecord.User.CC || z<90
    CC_trials = [CC_trials 1];
    None_trials = [None_trials 0];
    if TrialRecord.User.SC
        dashboard(2, 'SC Trial', [255 255 0])
    else
        dashboard(2, 'CC Trial',[255 0 255])
    end
    scene4 = create_scene(con4,[fixation_point FP_background ctx_cue stimulus]); %7/13/22 gd: added stimulus to cc scene

    else
    CC_trials = [CC_trials 0];
    None_trials = [None_trials 1];
    dashboard(2, 'None Trial', [255 255 255])
    scene4 = create_scene(con4,[fixation_point FP_background stimulus]); %7/13/22 gd: added stimulus to cc scene
end
TrialRecord.User.CC_trials = CC_trials;
TrialRecord.User.None_trials = None_trials;

% scene 5: context trace, targets on
fix5 = SingleTarget(eye_);
fix5.Target = fixation_point;
fix5.Threshold = fix_radius;
lh5 = LooseHold(fix5);
lh5.BreakTime = blink_time;
lh5.HoldTime = exprnd(300)+ ctx_cue_trace_time(1); % add noise from exponential distribution (i.e. flat hazard rate)
if lh5.HoldTime > ctx_cue_trace_time(2)
    lh5.HoldTime = ctx_cue_trace_time(2); % don't let the interval get too long
end
dashboard(6, sprintf('CC Delay: %.2f', lh5.HoldTime));
con5 = Concurrent(lh5);
con5.add(tc);
scene5 = create_scene(con5,[fixation_point up right down left]);

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
scene6a = create_scene(con6a,[up right down left]);

% scene 6: choice
mul6 = MultiTarget(eye_);
mul6.Target = [up right down left];
mul6.Threshold = fix_radius;
mul6.WaitTime = double_thresh;
mul6.HoldTime = decision_fix_time;
mul6.TurnOffUnchosen = false;
con6 = Concurrent(mul6);
con6.add(tc);
scene6 = create_scene(con6,[up right down left]);


%% TASK:
%Dashboard settings
allTrials = TrialRecord.TrialErrors;
ncl = ~TrialRecord.User.CL_trials(1:end-1);
blocks = TrialRecord.BlocksPlayed;
conditions = TrialRecord.ConditionsPlayed;

% Contexts
c1 = blocks == 1;
c2 = blocks == 2;

% Conditions
s1 = conditions == 1;
s2 = conditions == 2;
s3 = conditions == 3;
s4 = conditions == 4;
s5 = conditions == 5;
s6 = conditions == 6;
s7 = conditions == 7;
s8 = conditions == 8;
s9 = conditions == 9;
s10 = conditions == 10;
s11 = conditions == 11;
s12 = conditions == 12;
s13 = conditions == 13;
s14 = conditions == 14;
s15 = conditions == 15;
s16 = conditions == 16;

if length(TrialRecord.TrialErrors) <= performance_window
    windowTrials = TrialRecord.TrialErrors;
else
    windowTrials = TrialRecord.TrialErrors(end-performance_window:end);
end

running_HR = hit_rate_2(windowTrials);

c1t = allTrials(c1&ncl);
c2t = allTrials(c2&ncl);
s1t = allTrials(s1&ncl);
s2t = allTrials(s2&ncl);
s3t = allTrials(s3&ncl);
s4t = allTrials(s4&ncl);
s5t = allTrials(s5&ncl);
s6t = allTrials(s6&ncl);
s7t = allTrials(s7&ncl);
s8t = allTrials(s8&ncl);
s9t = allTrials(s9&ncl);
s10t = allTrials(s10&ncl);
s11t = allTrials(s11&ncl);
s12t = allTrials(s12&ncl);
s13t = allTrials(s13&ncl);
s14t = allTrials(s14&ncl);
s15t = allTrials(s15&ncl);
s16t = allTrials(s16&ncl);

ctx1_HR = hit_rate_2(c1t);
ctx2_HR = hit_rate_2(c2t);
s1_HR = hit_rate_2(s1t);
s2_HR = hit_rate_2(s2t);
s3_HR = hit_rate_2(s3t);
s4_HR = hit_rate_2(s4t);
s5_HR = hit_rate_2(s5t);
s6_HR = hit_rate_2(s6t);
s7_HR = hit_rate_2(s7t);
s8_HR = hit_rate_2(s8t);
s9_HR = hit_rate_2(s9t);
s10_HR = hit_rate_2(s10t);
s11_HR = hit_rate_2(s11t);
s12_HR = hit_rate_2(s12t);
s13_HR = hit_rate_2(s13t);
s14_HR = hit_rate_2(s14t);
s15_HR = hit_rate_2(s15t);
s16_HR = hit_rate_2(s16t);

disp(table([ctx1_HR; ctx2_HR], [s1_HR; s9_HR], [s2_HR; s10_HR], [s3_HR; s11_HR], [s4_HR; s12_HR], [s5_HR; s13_HR], [s6_HR; s14_HR], [s7_HR; s15_HR], [s8_HR; s16_HR], 'VariableNames',{'Combined', 'F1', 'F2', 'F3', 'F4', 'F5', 'F6', 'F7', 'F8'},'RowNames',{'C1','C2'}));

try
    ctx1_10 = hit_rate_2(c1t(end-10:end));
    s1_10 = hit_rate_2(s1t(end-10:end));
    s2_10 = hit_rate_2(s2t(end-10:end));
    s3_10 = hit_rate_2(s3t(end-10:end));
    s4_10 = hit_rate_2(s4t(end-10:end));
    s5_10 = hit_rate_2(s5t(end-10:end));
    s6_10 = hit_rate_2(s6t(end-10:end));
    s7_10 = hit_rate_2(s7t(end-10:end));
    s8_10 = hit_rate_2(s8t(end-10:end));
catch
    ctx1_10 = hit_rate_2(c1t);
    s1_10 = hit_rate_2(s1t);
    s2_10 = hit_rate_2(s2t);
    s3_10 = hit_rate_2(s3t);
    s4_10 = hit_rate_2(s4t);
    s5_10 = hit_rate_2(s5t);
    s6_10 = hit_rate_2(s6t);
    s7_10 = hit_rate_2(s7t);
    s8_10 = hit_rate_2(s8t);
end

try
    ctx2_10 = hit_rate_2(c2t(end-10:end));
    s9_10 = hit_rate_2(s9t(end-10:end));
    s10_10 = hit_rate_2(s10t(end-10:end));
    s11_10 = hit_rate_2(s11t(end-10:end));
    s12_10 = hit_rate_2(s12t(end-10:end));
    s13_10 = hit_rate_2(s13t(end-10:end));
    s14_10 = hit_rate_2(s14t(end-10:end));
    s15_10 = hit_rate_2(s15t(end-10:end));
    s16_10 = hit_rate_2(s16t(end-10:end));
catch
    ctx2_10 = hit_rate_2(c2t);
    s9_10 = hit_rate_2(s9t);
    s10_10 = hit_rate_2(s10t);
    s11_10 = hit_rate_2(s11t);
    s12_10 = hit_rate_2(s12t);
    s13_10 = hit_rate_2(s13t);
    s14_10 = hit_rate_2(s14t);
    s15_10 = hit_rate_2(s15t);
    s16_10 = hit_rate_2(s16t);
end

disp('10-trial average')
disp(table([ctx1_10; ctx2_10], [s1_10; s9_10], [s2_10; s10_10], [s3_10; s11_10], [s4_10; s12_10],[s5_10; s13_10], [s6_10; s14_10], [s7_10; s15_10], [s8_10; s16_10], 'VariableNames',{'Combined', 'F1', 'F2', 'F3', 'F4', 'F5', 'F6', 'F7', 'F8'},'RowNames',{'C1','C2'}));

dashboard(1, sprintf([num2str(performance_window) '-Trial HR: %.2f, Overall HR: %.2f'], running_HR*100, hit_rate_2(allTrials)*100));
dashboard(7, sprintf('Percent Early Choices: %.2f', sum(TrialRecord.TrialErrors==7)/length(TrialRecord.TrialErrors)*100),[255 0 0]); 
dashboard(8, sprintf('Block Length: %.f', TrialRecord.User.block_length), [255 255 0]);

% scene 1: fixation
if TrialRecord.User.SC
    SC_trials = [SC_trials 1];
    run_scene(scene0,01);
    idle(0);   % clear the screen
else
    SC_trials = [SC_trials 0];
end
TrialRecord.User.SC_trials = SC_trials;
run_scene(scene1,10);
if ~wth1.Success
    idle(0);
    if wth1.Waiting
        trialerror(5); % No Fixation
    else
        trialerror(6); % Break Fixation
        sound(TrialRecord.User.abfx, TrialRecord.User.abFs)
        eventmarker(46);
    end
    return
else
    eventmarker(11) % Fixation acquired
    if training_rewards(1), if rand(1) > (1-training_reward_prob), goodmonkey(solenoid_time, 'numreward', training_drops); end, end
end

% scene 2: stimulus
set_bgcolor([])
run_scene(scene2,20);
if ~lh2.Success
    idle(0);
    trialerror(6); % Break Fixation
    sound(TrialRecord.User.abfx, TrialRecord.User.abFs)
    eventmarker(46);
    return
else
    if training_rewards(2), if rand(1) > (1-training_reward_prob), goodmonkey(solenoid_time, 'numreward', training_drops); end, end
end

% scene 3: stimulus trace
run_scene(scene3,30);
if ~lh3.Success
    idle(0);
    trialerror(6); % Break Fixation
    sound(TrialRecord.User.abfx, TrialRecord.User.abFs)
    eventmarker(46);
    return
else
    if training_rewards(3), if rand(1) > (1-training_reward_prob), goodmonkey(solenoid_time, 'numreward', training_drops); end, end
end

% scene 4: context cue

if TrialRecord.User.CC_trials(end) 
    run_scene(scene4,40);
else
    run_scene(scene4,45);
end

if ~lh4.Success
    idle(0);
    trialerror(6); % Break Fixation
    sound(TrialRecord.User.abfx, TrialRecord.User.abFs)
    eventmarker(46);
    return
else
    if training_rewards(4), if rand(1) > (1-training_reward_prob), goodmonkey(solenoid_time, 'numreward', training_drops); end, end
end

% scene 5: context trace, targets on
run_scene(scene5, 50);
if ~lh5.Success
    idle(0);
    trialerror(7); % Early Answer
    sound(TrialRecord.User.abfx, TrialRecord.User.abFs)
    eventmarker(55) % Early Answer
    return
else
    if training_rewards(5), if rand(1) > (1-training_reward_prob), goodmonkey(solenoid_time, 'numreward', training_drops); end, end
end

% scene 6a: Double saccade prevention
go = run_scene(scene6a, 60); % Go cue
if ~wth6a.Success % Saccade initiated
    eventmarker(61)
else
    trialerror(8); % No Choice
end

% scene 6: choice
saccade_initiated = run_scene(scene6, 62);
rt = saccade_initiated - go;
if ~mul6.Waiting
    eventmarker(66) % Choice Made 
end

if ~mul6.Success
    idle(0);
    if mul6.Waiting
        trialerror(9); % Double saccade
    else
        trialerror(9); % Break Choice
        sound(TrialRecord.User.abfx, TrialRecord.User.abFs)
        eventmarker(65)
    end
    return
end

%% REWARDS
trial_correct = (ismember(TrialRecord.CurrentCondition, [1 5 12 14]) && mul6.ChosenTarget == up) || (ismember(TrialRecord.CurrentCondition, [2 6 9 15]) && mul6.ChosenTarget == right) || (ismember(TrialRecord.CurrentCondition, [3 7 10 16]) && mul6.ChosenTarget == down) || (ismember(TrialRecord.CurrentCondition, [4 8 11 13]) && mul6.ChosenTarget == left);
small_reward_trial = ismember(TrialRecord.CurrentCondition,[3 4 5 6 9 12 13 16]); % Test for large/ small trial; gd 3/30/22

if trial_correct
    trialerror(0);
    
    rx = rand(1); % Option for probabilistic reward - currently not implemented
    if rx < 0.5
        ld = little_drops;
        bd = big_drops;
    else
        ld = little_drops;
        bd = big_drops;
    end
    
    if small_reward_trial % Test for large/ small trial; gd 3/30/22
        idle(decision_trace_time, [],71)
        sound(TrialRecord.User.rsfx, TrialRecord.User.rsFs)
        goodmonkey(solenoid_time, 'numreward', ld, 'pausetime', drop_gaps, 'eventmarker',99);
    else
        idle(decision_trace_time,[], 70)
        sound(TrialRecord.User.rbfx, TrialRecord.User.rbFs)
        goodmonkey(solenoid_time, 'numreward', bd, 'pausetime', drop_gaps, 'eventmarker',99);
    end
    
elseif mul6.ChosenTarget == up
    trialerror(1);
    TrialRecord.User.cond_count(TrialRecord.CurrentCondition) = TrialRecord.User.cond_count(TrialRecord.CurrentCondition) + 1; % 09/22/23 GD: increment cond_counter for CL
    sound(TrialRecord.User.infx, TrialRecord.User.inFs)
    if small_reward_trial
        idle(time_out_sr);
    else
        idle(time_out_lr);
    end
elseif mul6.ChosenTarget == right
    trialerror(2);
    TrialRecord.User.cond_count(TrialRecord.CurrentCondition) = TrialRecord.User.cond_count(TrialRecord.CurrentCondition) + 1; % 09/22/23 GD: increment cond_counter for CL
    sound(TrialRecord.User.infx, TrialRecord.User.inFs)
    if small_reward_trial
        idle(time_out_sr);
    else
        idle(time_out_lr);
    end
elseif mul6.ChosenTarget == down
    trialerror(3);
    TrialRecord.User.cond_count(TrialRecord.CurrentCondition) = TrialRecord.User.cond_count(TrialRecord.CurrentCondition) + 1; % 09/22/23 GD: increment cond_counter for CL
    sound(TrialRecord.User.infx, TrialRecord.User.inFs)
    if small_reward_trial
        idle(time_out_sr);
    else
        idle(time_out_lr);
    end
elseif mul6.ChosenTarget == left
    trialerror(4);
    TrialRecord.User.cond_count(TrialRecord.CurrentCondition) = TrialRecord.User.cond_count(TrialRecord.CurrentCondition) + 1; % 09/22/23 GD: increment cond_counter for CL
    sound(TrialRecord.User.infx, TrialRecord.User.inFs)
    if small_reward_trial
        idle(time_out_sr);
    else
        idle(time_out_lr);
    end   
end