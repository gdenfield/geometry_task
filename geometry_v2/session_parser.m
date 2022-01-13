% SESSION_PARSER takes output from mlread and outputs a parsed session struct
function session = session_parser(data,TrialRecord,MLConfig)
% MJP 11/10/2021

% Initialize struct
session = struct('trial', cell(1, length(data)));

% Parse data
for t = 1:length(data)
    % Trial Properties
    session(t).trial = data(t).Trial;
    
    session(t).block = TrialRecord.BlockCount(t);
    
    session(t).condition = data(t).Condition;
    
    session(t).context = TrialRecord.BlocksPlayed(t);
    
    % ADD LATER: session(t).contextual_cue % contextual cue number (for CCGP task)
    
    stimuli = repmat(1:4,1,2);
    session(t).stimulus = stimuli(session(t).condition);
    
    correct_responses = [1 2 3 4 2 3 4 1];
    session(t).correct_response = correct_responses(session(t).condition);
    
    rewards = [1 1 0 0 0 1 1 0];
    session(t).rewardedness = rewards(session(t).condition);
    
    session(t).cc_on = TrialRecord.User.CC_trials(t);
    
    session(t).sc_on = TrialRecord.User.SC_trials(t);
    
    session(t).CL_trial = TrialRecord.User.CL_trials(t);
    
    session(t).cc_file = data(t).TaskObject.Attribute(4).Name;
    session(t).stimulus_file = data(t).TaskObject.Attribute(3).Name;
    
    session(t).subject = MLConfig.SubjectName;
    
    % Trial Events
    session(t).datetime = datetime(data(t).TrialDateTime);
    
    session(t).outcome = TrialRecord.TrialErrors(t);
    
    session(t).correct = session(t).outcome==0;
    
    if session(t).correct
        session(t).choice = correct_responses(session(t).condition);
    elseif ismember(session(t).outcome, 1:4)
        session(t).choice = session(t).outcome;
    else
        session(t).choice = NaN;
    end
    
    session(t).drops = sum(data(t).BehavioralCodes.CodeNumbers==99);
    
    session(t).rt = TrialRecord.ReactionTimes(t);
    
    session(t).eye = data(t).AnalogData.Eye;
    
    session(t).pupil = data(t).AnalogData.General.Gen2;
    
    session(t).lick = data(t).AnalogData.General.Gen1;
    
    session(t).event_codes = data(t).BehavioralCodes;
    session(t).event_codes.key = TrialRecord.TaskInfo.BehavioralCodes;
end
end
