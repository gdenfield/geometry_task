% Generate task file for mturk experiment
% MJP 10/07/21
clear
% Task parameters
n_inference_trials = 8; % number of times held-out fractal is shown with new contextual cues
block_length = 8; % trials
first_block_length = 20; % trials for longer initial block
n_contextual_cues = 4; % number of trials to show contextual cues at beginning of block

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
cc_on(logical(switch_cue)) = 1; % always show CC with SC trials

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


stimuli_names  = {'img_1.bmp',...
                  'img_2.bmp',...
                  'img_3.bmp',...
                  'img_4.bmp'};
reward_size     = {'0','1'};
resp_indicators = {'uparrow','rightarrow','downarrow','leftarrow'};
cc_cue          = {'FALSE','TRUE'};
sc_cue          = {'FALSE','TRUE'};




% Collect in structure
task_file(:,1) = stimuli_names(stimuli)';  % stimulus 
task_file(:,2) = resp_indicators(response)'; % response
task_file(:,3) = reward_size(reward+1)';   % reward  
task_file(:,4) = cellfun(@(x) num2str(x),num2cell(contextual_cue),'UniformOutput',false)'; % context cue
task_file(:,5) = cc_cue(cc_on+1)';    % show context cue?
task_file(:,6) = cellfun(@(x) num2str(x),num2cell(context),'UniformOutput',false);  % latent context
task_file(:,7) = num2cell(block);    % block number
task_file(:,8) = sc_cue(switch_cue+1)'; % show switch cue?


             



writecell(task_file,'task_1.csv');




