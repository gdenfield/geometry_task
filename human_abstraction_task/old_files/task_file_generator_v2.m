% New task-file generator

% Parameters
n_learning_blocks = 2; % long blocks to learn basic contingencies
learning_block_length = 25; % trials
n_inference_trials = 4; % number of times held-out fractal is shown with new contextual cues
n_contextual_cues = 4; % number of trials to show contextual cues at beginning of block
block_length = 10; % trials
blocks_per_inference_trial = 6; % four leave-one-out blocks, two full blocks

% Block
block = [];
for i = 1:n_learning_blocks
    block = [block; repmat(i,learning_block_length,1)];
end

for i = n_learning_blocks+1:(blocks_per_inference_trial*n_inference_trials)+n_learning_blocks+2 % plus two for two short blocks following long learning blocks
    block = [block; repmat(i,block_length,1)];
end

% Trial number
trial_number = [1:length(block)]';

% Context (1 or 2)
context =  -(mod(block,2)-2);

% Contextual Cue 
% (In the monkey experiment, I show this for first 15 trials per block, but I'm filling in whole block for reference here)
contextual_cue = context(1:(n_learning_blocks*learning_block_length)+(2*block_length)); % for first learning blocks (2 long and 2 short)
for i = 3:2:(n_inference_trials*blocks_per_inference_trial/2)-2
    contextual_cue = [contextual_cue; repmat([zeros(block_length,1)+i; zeros(block_length,1)+i+1],blocks_per_inference_trial/2,1)];
end

% Show Contextual Cue (1 = on, 0 = off)
cc_on = repmat([ones(n_contextual_cues,1); zeros(learning_block_length-n_contextual_cues,1)],n_learning_blocks,1);
for i = n_learning_blocks+1:block(end)
    cc_on = [cc_on; ones(n_contextual_cues,1); zeros(block_length-n_contextual_cues,1)];
end

% Stimuli (fractals 1-4)
stimuli = randi(4,learning_block_length*n_learning_blocks,1); % for long learning blocks (all stimuli)
stimuli = [stimuli; randi(4,block_length*2,1)]; % for 2 short learning blocks
% for i = 1:n_inference_trials
%     held_out = randi(4); % choose held-out stimulus
%     switch held_out
%         case 1
%             fractals_in = [2 3 4];
%         case 2
%             fractals_in = [1 3 4];
%         case 3
%             fractals_in = [1 2 4];
%         case 4
%             fractals_in = [1 2 3];
%     end
%     stimuli = [stimuli; randsample(fractals_in,block_length*blocks_per_inference_trial-2,true)'; held_out; randi(4,block_length-1,1)];
% end