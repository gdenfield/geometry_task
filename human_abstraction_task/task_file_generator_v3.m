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

% generate long learning blocks
n_long_blocks = 2;
learning_block_repeats = 5;
n_contextual_cues = 4;

for i = 1:n_long_blocks
    task_file = append_block(task_file, learning_block_repeats, i, n_contextual_cues, 1:4,[]);
end
task_file.sc_on(1) = 0;

% generate short learning blocks
block_repeats = 3;
for j = 1:12
for i = 1:2
    task_file = append_block(task_file, block_repeats, i, n_contextual_cues, 1:4,[]);
end
end

% generate leave-one-out blocks
% n_novel_blocks = 5;
% held_out_order = randperm(4);
% for n = 1:n_novel_blocks
%     ccs = [task_file.cc(end)+1, task_file.cc(end)+2];
%     held_out = held_out_order(mod(n-1,4)+1);
%     fractals_in = setdiff(1:4,held_out);
%     for i = 1:4
%         task_file = append_block(task_file, block_repeats, ccs(-mod(i,2)+2), n_contextual_cues, fractals_in,[]);
%     end
%     for i = 1:2
%         task_file = append_block(task_file, block_repeats, ccs(-mod(i,2)+2), n_contextual_cues, fractals_in, held_out);
%     end
% end

% Collect in structure
stimuli_names  = {'img_1.bmp',...
                  'img_2.bmp',...
                  'img_3.bmp',...
                  'img_4.bmp'};
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

%writecell(output,'task_4.csv');