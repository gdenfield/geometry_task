% Generate task file for mturk experiment
% MJP 10/07/21

% Task parameters
n_inference_trials = 4; % number of times held-out fractal is shown with new contextual cues
block_length = 25; % trials
n_contextual_cues = 5; % number of trials to show contextual cues at beginning of block

% Block
block = [];
for i = 1:(n_inference_trials*3)+2 % x3 for two held-out blocks & one complete block per inference, plus 2 for first two blocks
    block = [block; repmat(i,block_length,1)];
end

% Context (1 or 2)
context =  -(mod(block,2)-2);

% Contextual Cue 
% (In the monkey experiment, I show this for first 15 trials per block, but I'm filling in whole block for reference here)
contextual_cue = context(1:block_length*2); % for first two blocks
for i = 1:2:n_inference_trials*2
    contextual_cue = [contextual_cue; zeros(block_length,1)+i; zeros(block_length,1)+i+1; zeros(block_length,1)+i];
end

% Show Contextual Cue (1 = on, 0 = off)
cc_on = [];
for i = 1:(n_inference_trials*3)+2
    cc_on = [cc_on; ones(n_contextual_cues,1); zeros(block_length-n_contextual_cues,1)];
end

% Stimuli (fractals 1-4)
stimuli = randi(4,block_length*2,1); % for first two blocks (all stimuli)
for i = 1:n_inference_trials
    held_out = randi(4); % choose held-out stimulus
    switch held_out
        case 1
            fractals_in = [2 3 4];
        case 2
            fractals_in = [1 3 4];
        case 3
            fractals_in = [1 2 4];
        case 4
            fractals_in = [1 2 3];
    end
    stimuli = [stimuli; randsample(fractals_in,block_length*2,true)'; held_out; randi(4,block_length-1,1)];
end

% Switch Cue (1 = on, 0 = off)
switch_cue = [];
for i = 1:(n_inference_trials*3)+2 
    % determine number of SC trials in given block
    coin_flip = 1;
    n_SC_trials = -1;
    while coin_flip
        n_SC_trials = n_SC_trials + 1;
        coin_flip = randi([0 1]);
    end
    
    switch_cue = [switch_cue; 1; zeros(block_length-n_SC_trials-1,1); ones(n_SC_trials,1)];
end
switch_cue(1) = 0; % no switch cue on first trial of first block

% Correct response (1 = up, 2 = right, 3 = down, 4 = left)
response = zeros(length(stimuli),1);
response(stimuli==1 & context==1) = 1;
response(stimuli==2 & context==1) = 2;
response(stimuli==3 & context==1) = 3;
response(stimuli==4 & context==1) = 4;
response(stimuli==1 & context==2) = 2;
response(stimuli==2 & context==2) = 3;
response(stimuli==3 & context==2) = 4;
response(stimuli==4 & context==2) = 1;

% Reward (1 = high, 0 = low)
reward = zeros(length(stimuli),1);
reward(stimuli==1 & context==1) = 1;
reward(stimuli==2 & context==1) = 1;
reward(stimuli==3 & context==1) = 0;
reward(stimuli==4 & context==1) = 0;
reward(stimuli==1 & context==2) = 0;
reward(stimuli==2 & context==2) = 1;
reward(stimuli==3 & context==2) = 1;
reward(stimuli==4 & context==2) = 0;

% Collect in structure
task_file.block = block;
task_file.cc_on = cc_on;
task_file.context = context;
task_file.contextual_cue = contextual_cue;
task_file.response = response;
task_file.reward = reward;
task_file.stimuli = stimuli;
task_file.switch_cue = switch_cue;