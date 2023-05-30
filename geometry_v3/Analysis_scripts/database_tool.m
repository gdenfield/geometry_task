%% Database Tool
% Script for daily data processing and database maintainance.
% MJP 11/10/2021

% Requires the following:
%   * MonkeyLogic library for .bhv2 file importing
%   * session_parser function
%   * session_append function
%   * daily .bhv2 file
%   * database .mat file
%   * archive folder in current directory
tic
files = dir('*.bhv2');
for i = 1:length(files)
    %% Import session
    clear sessionname session dbname
    disp(['Loading session ' num2str(i) ' of ' num2str(length(files))])
    sessionname = [files(i).folder '\' files(i).name];%uigetfile('*.bhv2');
    disp(['-File: ' files(i).name])
    [data, MLConfig, TrialRecord, sessionname] = mlread(sessionname);
    %% Parse daily session
    disp('-Parsing session...')
    session = session_parser(data,TrialRecord,MLConfig);
    %% Load database
    if ~exist('db','var') % if db not already loaded
        if isempty(dir('db*.mat')) % create empty db (for first run)
            disp('-Creating database...')
            db = [];
        else % load db
            disp('-Loading database...')
            old_db = dir('db*.mat');
            old_db = [old_db.folder '\' old_db.name];
            load(old_db,'db');
        end
    else
        disp('-Database in workspace...')
    end
    %% Add daily session to database
    disp('-Appending session...')
    db = session_append(session,db);
    %% Save updated database
%     if i == length(files)
%         disp('Saving database...')
%         first = min([db.datetime]);
%         last = max([db.datetime]);
%         dbname = ['db_', char(datetime(first,'Format','ddMMyyyy')), '_', char(datetime(last,'Format','ddMMyyyy')), '.mat'];
%         save(dbname, 'db','-v7.3');
%     end
    %% Move .bhv2 file to archive folder
    disp('-Archiving behavior file...')
    archivename = [pwd '\bhv_files\'];
    if ~isdir(archivename)
        mkdir(archivename)
    end
    movefile(sessionname,archivename,'f')
    clear data MLConfig TrialRecord first last archivename old_db
end