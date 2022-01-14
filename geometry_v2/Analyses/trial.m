classdef trial
    %Trial objects encapsulate all data relevant to a given trial
    %   Details, details...
    
    properties
        % Behavior
        choice %subject response
        correct
        outcome
        rt
        eye
        pupil
        lick
        
        % Trial Properties
        stimulus
        condition
        correct_response
        rewardedness % large or small
        drops
        sc_on
        cc_on
        context % latent context (1 or 2)
        contextual_cue % number
        cc_file
        stimulus_file
        
        % Event Codes
        event_codes
        
        % Session Properties
        block
        
        
        % Metadata
        subject
        datetime
        
    end
    
    methods
        function obj = trial(trial_n,data,TrialRecord,MLConfig) % import data into trial object
            % Trial Properties
            obj.condition = data(trial_n).Condition;
            stimuli = repmat(1:4,1,2);
            obj.stimulus = stimuli(obj.condition);
            if ismember(obj.condition, 1:4)
                obj.correct_response = obj.condition;
            else
                obj.correct_response = mod(obj.condition,4)+1;
            end
            if ismember(obj.condition,[3 4 5 8])
                obj.rewardedness = 0;% small
            else
                obj.rewardedness = 1;% large
            end
            obj.drops = sum(data(trial_n).BehavioralCodes.CodeNumbers==99);
            obj.cc_on = TrialRecord.User.CC_trials(trial_n);
            obj.sc_on = TrialRecord.User.SC_trials(trial_n);
            obj.context = TrialRecord.BlocksPlayed(trial_n); % latent context (1 or 2)
            %obj.contextual_cue % number
            obj.cc_file = data(trial_n).TaskObject.Attribute(4).Name;
            obj.stimulus_file = data(trial_n).TaskObject.Attribute(3).Name;
            
            % Behavior
            obj.outcome = TrialRecord.TrialErrors(trial_n);
            
            if ismember(obj.outcome, 1:4)
                obj.choice = obj.outcome;
            elseif obj.outcome==0
                if ismember(obj.condition, 1:4)
                    obj.choice = obj.condition;
                else
                    obj.choice = mod(obj.condition,4)+1;
                end
            else
                obj.choice = [];
            end
            obj.correct = obj.outcome==0;
            
            obj.rt = TrialRecord.ReactionTimes(trial_n);
            obj.eye = data(trial_n).AnalogData.Eye;% x and y
            obj.pupil = data(trial_n).AnalogData.General.Gen2;
            obj.lick = data(trial_n).AnalogData.General.Gen1;
            
            % Event Codes
            obj.event_codes = data(trial_n).BehavioralCodes;
            obj.event_codes.key = TrialRecord.TaskInfo.BehavioralCodes;
            
            % Session Properties
            obj.block = TrialRecord.BlockCount(trial_n);
            
            
            % Metadata
            obj.subject = MLConfig.SubjectName;
            obj.datetime = datetime(data(trial_n).TrialDateTime);
        end
    end
end

