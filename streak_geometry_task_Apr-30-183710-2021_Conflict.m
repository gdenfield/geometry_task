function [longest, streaks] = streak(varargin)
% STREAK  Calculate longest streak in a series of trials.
%   longest = STREAK(trials, trial_type) returns longest streak of given
%   trial_type.
%   
%   [longest, streaks] = STREAK(trials, trial_type) returns the longest
%   streak for the given trial_type, and vector of shorter streak instances.
    switch nargin
        case 1
            trials = varargin{1};
            trial_type = 0;
        case 2
            trials = varargin{1};
            trial_type = varargin{2};
    end
    
    disp(['trials length: ' num2str(length(trials))])
    disp(['trial type: ' num2str(trial_type)])
    
    for t = 1:length(trials)
    end
    
end