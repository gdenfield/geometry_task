
function [task_file] = append_block(task_file, n_repeats, cc, n_contextual_cues, fractals_in, held_out)
    % import values
    if isempty(task_file.stimuli)
        block_number = 1;
        context = randi(2);        
    else
        block_number = task_file.block_number(end)+1;
        switch task_file.context(end)
            case 1
                context = 2;
            case 2
                context = 1;
        end
    end
    
    block_length = length(fractals_in)*n_repeats;
    
    % stimuli
    if isempty(held_out)
        stimuli = [];
        for i = 1:n_repeats
            stimuli = [stimuli; fractals_in(randperm(length(fractals_in)))'];
        end
    else
        stimuli = [held_out];
        for i = 1:n_repeats
            stimuli = [stimuli; fractals_in(randperm(length(fractals_in)))'];
        end
        stimuli(end) = [];
    end
    task_file.stimuli = [task_file.stimuli; stimuli];
    
    % response
    response = zeros(block_length,1);
    response(stimuli==1 & context==1) = 1;
    response(stimuli==2 & context==1) = 2;
    response(stimuli==3 & context==1) = 3;
    response(stimuli==4 & context==1) = 4;
    response(stimuli==1 & context==2) = 2;
    response(stimuli==2 & context==2) = 3;
    response(stimuli==3 & context==2) = 4;
    response(stimuli==4 & context==2) = 1;
    task_file.response = [task_file.response; response];
    
    % context
    task_file.context = [task_file.context; repmat(context,block_length,1)];
    
    % cc
    task_file.cc = [task_file.cc; repmat(cc,block_length,1)];
    
    % reward
    reward = zeros(block_length,1);
    reward(stimuli==1 & context==1) = 1;
    reward(stimuli==2 & context==1) = 1;
    reward(stimuli==3 & context==1) = 0;
    reward(stimuli==4 & context==1) = 0;
    reward(stimuli==1 & context==2) = 0;
    reward(stimuli==2 & context==2) = 1;
    reward(stimuli==3 & context==2) = 1;
    reward(stimuli==4 & context==2) = 0;
    task_file.reward = [task_file.reward; reward];  

    % block number
    task_file.block_number = [task_file.block_number; repmat(block_number,block_length,1)];   

    % sc_on
    n_sc_trials = geornd(0.5);
    sc_on = [1; zeros(block_length-n_sc_trials-1,1); ones(n_sc_trials,1)];
    task_file.sc_on = [task_file.sc_on; sc_on];
    
    % cc_on
    cc_on = [ones(n_contextual_cues,1); zeros(block_length-n_contextual_cues,1)];
    cc_on(logical(sc_on)) = 1;
    task_file.cc_on = [task_file.cc_on; cc_on];
end