% task_file generator v.3

% initialize task_file
clear
task_file.stimuli = [];
task_file.response = [];
task_file.context = [];
task_file.cc = [];
task_file.cc_on = [];
task_file.reward = [];
task_file.block_number = [];
task_file.sc_on = [];

% parameters
n_long_blocks = 2;
n_short_blocks = 0;%18;
long_block_repeats = 6;
short_block_repeats = 4;
n_contextual_cues = 0;

% generate long (learning) blocks
for i = 1:(n_long_blocks/2)
    task_file = append_EFGH(task_file, long_block_repeats, 1, n_contextual_cues, 1:4,[]);
    task_file = append_EFGH(task_file, long_block_repeats, 2, n_contextual_cues, 5:8,[]);
end


% generate short (regular) blocks
for j = 1:(n_short_blocks/2)
    task_file = append_EFGH(task_file, short_block_repeats, 1, n_contextual_cues, 1:4,[]);
    task_file = append_EFGH(task_file, short_block_repeats, 2, n_contextual_cues, 5:8,[]);
end

% Collect in structure
stimuli_names  = {'img_1.bmp',...
                  'img_2.bmp',...
                  'img_3.bmp',...
                  'img_4.bmp',...
                  'img_5.bmp',...
                  'img_6.bmp',...
                  'img_7.bmp',...
                  'img_8.bmp'};
reward_size     = {'0','1'};
resp_indicators = {'uparrow','rightarrow','downarrow','leftarrow'};
cc_cue          = {'FALSE','TRUE'};
sc_cue          = {'FALSE','TRUE'};

output(:,1) = stimuli_names(task_file.stimuli)';  % stimulus 
output(:,2) = resp_indicators(task_file.response)'; % response
output(:,3) = reward_size(task_file.reward+1)';   % reward  
output(:,4) = cellfun(@(x) num2str(x),num2cell(task_file.cc),'UniformOutput',false)'; % context cue
output(:,5) = cc_cue(task_file.cc_on+1)';    % show context cue?
output(:,6) = cellfun(@(x) num2str(x),num2cell(task_file.context),'UniformOutput',false);  % latent context
output(:,7) = num2cell(task_file.block_number);    % block number
output(:,8) = sc_cue(task_file.sc_on+1)'; % show switch cue?

writecell(output,'task_1.csv');