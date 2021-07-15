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
    
    % initialize
    streak = 0;
    streaks = [];
    longest = 0;
    
    
    for t = 1:length(trials)
        if trials(t) == trial_type
            %count streak
            streak = streak + 1;
        else
            %if streak > 2, add streak to streaks
            if streak > 0
                streaks = [streaks streak];
            end
            
            %update longest
            if streak > longest
                longest = streak;
            end
            
            %reset streak
            streak = 0;
        end
    end
    
    disp([num2str(length(trials)) ' trials'])
    disp(['trial type: ' num2str(trial_type)])
    disp(['longest streak: ' num2str(longest)])
end