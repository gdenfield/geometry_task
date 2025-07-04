% New version of task for geometry project: 3 fractals, 3 contexts GHD
% 11/26/24 incorporating contrast adjustment for instruction purposes

function [C,timingfile,userdefined_trialholder] = geometry_3_userloop_Piglet(MLConfig,TrialRecord)
% Training Variables
block_length = 27; % Number of trials before context switch
num_contexts = 3; % Number of contexts
sequence_depth = repmat([2, 2, 2], 1, num_contexts); % Number of times each condition should be shown in a given trial sequence; ADJUST HERE FOR SUBSET FRACTALS
n_fractals = 3; % 1-6, set to 6 for full set of fractals
cl_counter = 2; % adjust for when to trigger correction loop

% Initialization
C = [];
timingfile = 'geometry_3_timingfile_Piglet.m';
userdefined_trialholder = '';
persistent trials_left_in_sequence % number of time each fractal has been completed successfully
persistent CL_trials % index of CL trials
persistent correct_counts % running tally correct of answers
persistent incorrect_counts % running tally of incorrect answers
persistent first_context
persistent context
persistent timing_filename_returned
persistent rem_ctxs
if isempty(trials_left_in_sequence) || TrialRecord.BlockChange %Reset counters if start of session or block change happened
    trials_left_in_sequence = sequence_depth + zeros(1,num_contexts*n_fractals);
    correct_counts = zeros(1,num_contexts*n_fractals);
    incorrect_counts = zeros(1,num_contexts*n_fractals);
    CL_trials = 0;
    TrialRecord.User.contrast = 1;
    TrialRecord.User.switch = 0;
    TrialRecord.User.block_length = block_length;
    
    %Update counters for correction loop
    TrialRecord.User.up_count = 0;
    TrialRecord.User.right_count = 0;
    TrialRecord.User.left_count = 0;
    TrialRecord.User.cond_count = zeros(1,num_contexts*n_fractals);
end
if isempty(timing_filename_returned)
    timing_filename_returned = true;
    return
end
contrast = TrialRecord.User.contrast; % 0-1 for off-target FPs
TrialRecord.User.correct_counts = correct_counts;
TrialRecord.User.incorrect_counts = incorrect_counts;

% Experimental conditions
target_distance = 7; %degrees from center, for all target locations (up, right, down, left)
down = [0 -target_distance];
right = [target_distance 0];
left = [-target_distance 0];

target_color = [255 255 255];
% Context 1: rows 1-3, Context 2: rows 4-6, Context 3: rows 7-9
% [stimulus ctx_cue target off_target1 off_target2]
conditions =... 
   [1 4 down right left;  
    2 4 right left down;  
    3 4 left down right;  
    1 5 left down right;  
    2 5 down right left;
    3 5 right left down;
    1 6 right left down;
    2 6 left down right;
    3 6 down right left];
ctxs = 1:3;

% If first trial, randomly select block and load sounds
if isempty(TrialRecord.TrialErrors)
    first_context = randi([1,num_contexts]); %ADJUST HERE TO FIX STARTING CONTEXT
    context = first_context;
    rem_ctxs = ctxs(ctxs ~= context);
    
    rewMult = 0; %randi([0,1]); % determine first reward multiplier value
    if rewMult
        fpColor = [50 205 50];
    else
        fpColor = [255 255 255];
    end
    TrialRecord.User.FP_color = fpColor;
    
    TrialRecord.User.SC = 0;
    TrialRecord.User.ChangeTriggeredAtBlock = [];
    TrialRecord.User.ChangeTriggeredAtBlock = [TrialRecord.User.ChangeTriggeredAtBlock, 1];
    TrialRecord.User.CL_trials = [];
    TrialRecord.User.BlockRewMult = [];
    TrialRecord.User.BlockRewMult = [TrialRecord.User.BlockRewMult, rewMult];
    TrialRecord.User.RewardGiven = [];
    TrialRecord.User.BlockPerf = [];
    TrialRecord.User.NewCuesOnes = cell(10, 1);
    TrialRecord.User.NewCuesTwos = cell(10, 1);
    TrialRecord.User.NewCuesThrees = cell(10, 1);
    TrialRecord.User.cueCounter = 1;
    
    % Specify name of CC to start
    TrialRecord.User.ccOneName = 'cc_1_Piglet.png';
    TrialRecord.User.ccTwoName = 'cc_2_Piglet.png';
    TrialRecord.User.ccThreeName = 'cc_3_Piglet.png';
    
    [TrialRecord.User.abfx, TrialRecord.User.abFs] = audioread('C:\Users\silvia_ML\Documents\geometry_task\geometry_v3\soundfx\flap.mp3');
    [TrialRecord.User.infx, TrialRecord.User.inFs] = audioread('C:\Users\silvia_ML\Documents\geometry_task\geometry_v3\soundfx\wrong-100536.mp3');
    [TrialRecord.User.rbfx, TrialRecord.User.rbFs] = audioread('C:\Users\silvia_ML\Documents\geometry_task\geometry_v3\soundfx\point.mp3');
    [TrialRecord.User.rsfx, TrialRecord.User.rsFs] = audioread('C:\Users\silvia_ML\Documents\geometry_task\geometry_v3\soundfx\point.mp3');
end

% Define fpColor
fpColor = TrialRecord.User.FP_color;

% Switch Procedure
threshold = 0.65; % Hit rate
window = 12; % trials
blockThreshold = 0.95; % blockwise performance threshold for CC switch

% Number of blocks needed above threshold to trigger CC switch
nBlockTrigger = 80; 

ncl = ~TrialRecord.User.CL_trials; %non-correction-loop trials
completed = ismember(TrialRecord.TrialErrors, 0:4);
A = TrialRecord.TrialErrors(ncl&completed) == 0;
B = smoothdata(A,'gaussian',window);
above = B>threshold;
if length(above) > window
    criterion = isequal(above(end-window+1:end), ones(1,window));
    disp(['Criterion Performance: ' num2str(sum(above(end-window+1:end))) ' of ' num2str(window)])
else
    criterion = 0;
end

if ((TrialRecord.CurrentTrialWithinBlock >= TrialRecord.User.block_length && criterion) || TrialRecord.User.switch == 1 ) && TrialRecord.TrialErrors(end)==0
    TrialRecord.User.SC = 1; % SC on
    TrialRecord.User.switch = 1; % once triggered, stay triggered!
    switch_test = randi([0,1]); % Determine if actual switch will occur
    if switch_test
        
        % Calculate if Reward Multiplier active
        rewMult = 0; %randi([0,1]); % ADJUST HERE FOR RANDOM REWARD MULTIPLIER
        if rewMult
            fpColor = [50 205 50];
        else
            fpColor = [255 255 255];
        end
        TrialRecord.User.BlockRewMult = [TrialRecord.User.BlockRewMult, rewMult];
        TrialRecord.User.FP_color = fpColor;
        
        % Before switch occurs, calculate block performance for CC change
        % criterion
        currBlock = TrialRecord.CurrentBlockCount;
        blockToCalc = TrialRecord.BlockCount == currBlock;
        blockTrials = TrialRecord.TrialErrors(ncl&completed&blockToCalc) == 0;
        blockPerf = sum(blockTrials) / numel(blockTrials);
        TrialRecord.User.BlockPerf = [TrialRecord.User.BlockPerf, blockPerf];
        
        % Update CC here if CC change criterion met
        if (TrialRecord.CurrentBlockCount - (TrialRecord.User.ChangeTriggeredAtBlock(end)-1)) >= nBlockTrigger ...
                && (sum(TrialRecord.User.BlockPerf(end-(nBlockTrigger-1):end) > blockThreshold) >= nBlockTrigger)
            
            % Record block number when cues changed
            TrialRecord.User.ChangeTriggeredAtBlock = [TrialRecord.User.ChangeTriggeredAtBlock, TrialRecord.CurrentBlockCount+1];
            
            % Pick new context cues
            d = 'C:\Users\silvia_ML\Documents\geometry_task\diag_CC_3\';
            f = dir([d '*.png']);
            n = numel(f);
            idx = randperm(n, num_contexts);
            TrialRecord.User.ccOneName = f(idx(1)).name;
            TrialRecord.User.ccTwoName = f(idx(2)).name;
            TrialRecord.User.ccThreeName = f(idx(3)).name;
            
            % Record name of new cues, copy to task dir, move to used dir,
            % copy over old CC names
            TrialRecord.User.NewCuesOnes{TrialRecord.User.cueCounter} = TrialRecord.User.ccOneName;
            TrialRecord.User.NewCuesTwos{TrialRecord.User.cueCounter} = TrialRecord.User.ccTwoName;
            TrialRecord.User.NewCuesThrees{TrialRecord.User.cueCounter} = TrialRecord.User.ccThreeName;
            
            copyfile([d TrialRecord.User.ccOneName], 'C:\Users\silvia_ML\Documents\geometry_task\geometry_v3','f')
            copyfile([d TrialRecord.User.ccTwoName], 'C:\Users\silvia_ML\Documents\geometry_task\geometry_v3','f')
            copyfile([d TrialRecord.User.ccThreeName], 'C:\Users\silvia_ML\Documents\geometry_task\geometry_v3','f')
             
            copyfile([d TrialRecord.User.ccOneName], 'C:\Users\silvia_ML\Documents\geometry_task\geometry_v3\cc_1.png','f')
            copyfile([d TrialRecord.User.ccTwoName], 'C:\Users\silvia_ML\Documents\geometry_task\geometry_v3\cc_2.png','f')
            copyfile([d TrialRecord.User.ccThreeName], 'C:\Users\silvia_ML\Documents\geometry_task\geometry_v3\cc_3.png','f')
            
            movefile([d TrialRecord.User.ccOneName], 'C:\Users\silvia_ML\Documents\geometry_task\used_diag_CC_3','f')
            movefile([d TrialRecord.User.ccTwoName], 'C:\Users\silvia_ML\Documents\geometry_task\used_diag_CC_3','f')
            movefile([d TrialRecord.User.ccThreeName], 'C:\Users\silvia_ML\Documents\geometry_task\used_diag_CC_3','f')
            
            TrialRecord.User.cueCounter = TrialRecord.User.cueCounter + 1;
        end
        
        % DETERMINE NEXT CONTEXT
        cc_idx = randi([1,numel(rem_ctxs)]);
        while rem_ctxs(cc_idx) == context
            cc_idx = randi([1,numel(rem_ctxs)]);
        end
        context = rem_ctxs(cc_idx);
        rem_ctxs = rem_ctxs(rem_ctxs ~= context);
        if isempty(rem_ctxs)
            rem_ctxs = ctxs;
        end
        
%         % FOR SUBSET OF TWO CONTEXTS
%          switch context
%             case 2
%                 context = 3;
%             case 3
%                 context = 2;
%         end
       
        trials_left_in_sequence = sequence_depth + zeros(1,num_contexts*n_fractals);
        TrialRecord.User.switch = 0;
    end
else
    TrialRecord.User.SC = 0;
end

% Increase sequence counter based on last trial
if ~isempty(TrialRecord.TrialErrors)
    if TrialRecord.TrialErrors(end)==0
        trials_left_in_sequence(TrialRecord.CurrentCondition) = trials_left_in_sequence(TrialRecord.CurrentCondition)-1;
        correct_counts(TrialRecord.CurrentCondition) = correct_counts(TrialRecord.CurrentCondition)+1;
        CL_trials = [CL_trials 0];
        disp('Correct!')
    elseif ismember(TrialRecord.TrialErrors(end), [1 2 3 4]) && any(TrialRecord.User.cond_count == cl_counter) % 09/22/23 GD: need N=cl_counter wrongs on a condition to trigger CL
        %trials_left_in_sequence(TrialRecord.CurrentCondition) = trials_left_in_sequence(TrialRecord.CurrentCondition)+1;
        TrialRecord.User.cond_to_repeat = find(TrialRecord.User.cond_count == cl_counter);
        TrialRecord.User.cond_count(find(TrialRecord.User.cond_count == cl_counter)) = 0;
        incorrect_counts(TrialRecord.CurrentCondition) = incorrect_counts(TrialRecord.CurrentCondition)+1;
        CL_trials = [CL_trials 1];
        disp('CL Trial!')
    elseif CL_trials(end) == 1 % add to CL_trial vector for incomplete trials
        CL_trials = [CL_trials 1];
        disp('Still CL Trial!')
    else
        CL_trials = [CL_trials 0];
        disp('Not CL Trial')
    end
end
    
disp(['     trials left: ' num2str(trials_left_in_sequence(1:n_fractals)) ' || ' num2str(trials_left_in_sequence((1:n_fractals)+n_fractals)) ' || ' num2str(trials_left_in_sequence((1:n_fractals)+(n_fractals*2)))])
% disp(['  correct counts: ' num2str(correct_counts(1:n_fractals)) ' || ' num2str(correct_counts((1:n_fractals)+n_fractals))])
% disp(['incorrect counts: ' num2str(incorrect_counts(1:n_fractals)) ' || ' num2str(incorrect_counts((1:n_fractals)+n_fractals))])

%Reset sequence count if each fractal has been encountered enough times -


if sum(trials_left_in_sequence(1,(1:n_fractals)+( (context - 1) * n_fractals))) == 0 %ADJUST HERE FOR SUBSET CONDITIONS
    trials_left_in_sequence = sequence_depth + zeros(1,num_contexts*n_fractals);
    TrialRecord.User.cond_count = zeros(1,num_contexts*n_fractals); %09/22/23 GD: reset cond_counter each block
end

%Pick fractal
if CL_trials(end) == 1 % if CL trial, repeat condition
    % condition = TrialRecord.ConditionsPlayed(end); % old version
    % condition = find(TrialRecord.User.cond_count >= 2); % 09/22/23 GD: set condition equal to one missed twice, triggering CL
    condition = TrialRecord.User.cond_to_repeat;
    chosen_condition = conditions(condition,:);
else % if not CL
    while true
        % *** ADJUST HERE FOR SUBSET CONDITIONS ***
        condition = randi(n_fractals)+((context-1)*n_fractals); % condition numbering depends on n_fractals
        
%         condProb = rand(1)*100;
%         if context == 1
%             if condProb >= 87.5 % opposes fractal 4
%                 fractal = 8;
%             elseif condProb >= 75 && condProb < 87.5 % opposes fractal 8
%                 fractal = 4;
%             elseif condProb >= 62.5 && condProb < 75 % opposes fractal 3
%                 fractal = 7;
%             elseif condProb >= 50 && condProb < 62.5 % opposes fractal 7
%                 fractal = 3;
%             elseif condProb >= 37.5 && condProb < 50 % opposes fractal 2
%                 fractal = 6;
%             elseif condProb >= 25 && condProb < 37.5 % opposes fractal 6
%                 fractal = 2;
%             elseif condProb >= 12.5 && condProb < 25 % opposes fractal 1
%                 fractal = 5;
%             else
%                 fractal = 1;
%             end
%         elseif context == 2
%             if condProb >= 87.5 % opposes fractal 2
%                 fractal = 8;
%             elseif condProb >= 75 && condProb < 87.5 % opposes f 8
%                 fractal = 2;
%             elseif condProb >= 62.5 && condProb < 75 % opposes f 3
%                 fractal = 5;
%             elseif condProb >= 50 && condProb < 62.5 % opposes f 5
%                 fractal = 3;
%             elseif condProb >= 37.5 && condProb < 50 % opposes f 4
%                 fractal = 6;
%             elseif condProb >= 25 && condProb < 37.5 % opposes f 6
%                 fractal = 4;
%             elseif condProb >= 12.5 && condProb < 25 % opposes f 1
%                 fractal = 7;
%             else
%                 fractal = 1;
%             end
%         end
%        condition = fractal + ((context-1)*n_fractals);
    if trials_left_in_sequence(condition) ~= 0
        chosen_condition = conditions(condition,:);
        break
    end
    end
end

% Repeat SC trial if not completed
if ~isempty(TrialRecord.TrialErrors)
    if (TrialRecord.User.SC_trials(end) == 1) && (~ismember(TrialRecord.TrialErrors(end), 0:4))
        TrialRecord.User.SC = 1;
        condition = TrialRecord.ConditionsPlayed(end);
        chosen_condition = conditions(condition,:);
    end
end


% Stimuli % ADJUST HERE FOR SUBSET OF STIMULI
% image_list = {'stim_0004v2.bmp','stim_0180v5.bmp','stim_0183v5.bmp', 'stim_0232v2.bmp', 'stim_0262v5.bmp','stim_0370v2.bmp', TrialRecord.User.ccOneName, TrialRecord.User.ccTwoName, TrialRecord.User.ccThreeName};
image_list = {'stim_J.bmp','stim_K.bmp','stim_L.bmp', TrialRecord.User.ccOneName, TrialRecord.User.ccTwoName, TrialRecord.User.ccThreeName};
stimulus = image_list{chosen_condition(1)};
ctx_cue = image_list{chosen_condition(2)};

target_color = [255 255 255];
off_target_color = [contrast*255 contrast*255 contrast*255];

target_x = chosen_condition(3);
target_y = chosen_condition(4);
off1_x = chosen_condition(5);
off1_y = chosen_condition(6);
off2_x = chosen_condition(7);
off2_y = chosen_condition(8);


% TaskObjects:
%1: fixation_point
C(1).Type = 'crc';
C(1).Radius = 0.1;     % visual angle
C(1).Color = fpColor;  % [R G B]
C(1).FillFlag = 1;
C(1).Xpos = 0;
C(1).Ypos = 0;

%2: FP_background
C(2).Type = 'crc';
C(2).Radius = 0.5;     % visual angle
C(2).Color = [0 0 0];  % [R G B]
C(2).FillFlag = 1;
C(2).Xpos = 0;
C(2).Ypos = 0;

%3: stimulus
C(3).Type = 'pic';
C(3).Name = stimulus;
C(3).Xpos = 0;
C(3).Ypos = 0;
C(3).Colorkey = [0 0 0]; %sets black as transparent

%4: ctx_cue
C(4).Type = 'pic';
C(4).Name = ctx_cue;
C(4).Xpos = 0;
C(4).Ypos = 0;
C(4).Colorkey = [0 0 0]; %sets black as transparent

%5: target
C(5).Type = 'crc';
C(5).Radius = 0.1;     % visual angle
C(5).Color = target_color;  % [R G B]
C(5).FillFlag = 1;
C(5).Xpos = target_x;
C(5).Ypos = target_y;

%6: off_target1
C(6).Type = 'crc';
C(6).Radius = 0.1;     % visual angle
C(6).Color = off_target_color;  % [R G B]
C(6).FillFlag = 1;
C(6).Xpos = off1_x;
C(6).Ypos = off1_y;

%7: off_target2
C(7).Type = 'crc';
C(7).Radius = 0.1;     % visual angle
C(7).Color = off_target_color;  % [R G B]
C(7).FillFlag = 1;
C(7).Xpos = off2_x;
C(7).Ypos = off2_y;


% 
% %5: up
% C(5).Type = 'crc';
% C(5).Radius = 0.1;     % visual angle
% C(5).Color = target_color;  % [R G B]
% C(5).FillFlag = 1;
% C(5).Xpos = up(1);
% C(5).Ypos = up(2);
% 
% %6: right
% C(6).Type = 'crc';
% C(6).Radius = 0.1;     % visual angle
% C(6).Color = target_color;  % [R G B]
% C(6).FillFlag = 1;
% C(6).Xpos = right(1);
% C(6).Ypos = right(2);

% %7: down
% C(7).Type = 'crc';
% C(7).Radius = 0.1;     % visual angle
% C(7).Color = target_color;  % [R G B]
% C(7).FillFlag = 1;
% C(7).Xpos = down(1);
% C(7).Ypos = down(2);
% 
% %8: left
% C(7).Type = 'crc';
% C(7).Radius = 0.1;     % visual angle
% C(7).Color = target_color;  % [R G B]
% C(7).FillFlag = 1;
% C(7).Xpos = left(1);
% C(7).Ypos = left(2);

%9: SC
C(8).Type = 'pic';
C(8).Name = 'sc.png';
C(8).Xpos = 0;
C(8).Ypos = 0;
C(8).Colorkey = [0 0 0]; %sets black as transparent


TrialRecord.User.CL_trials = CL_trials;
TrialRecord.NextBlock = context;
TrialRecord.NextCondition = condition;
end