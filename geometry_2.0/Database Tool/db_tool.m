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

%% Import daily session
disp('Importing session...')
sessionname = uigetfile('*.bhv2');
[data, MLConfig, TrialRecord, sessionname] = mlread(sessionname);
%% Parse daily session
disp('Parsing session...')
session = session_parser(data,TrialRecord,MLConfig);
%% Load database
disp('Loading database...')
if isempty(dir('*.mat'))
    old_db = [];
    db = [];
else
    old_db = uigetfile('db*.mat');
    load(old_db,'db');
end
%% Add daily session to database
db = session_append(session,db);
%% Save updated database
disp('Saving database...')
first = min([db.datetime]);
last = max([db.datetime]);
dbname = ['db_', char(datetime(first,'Format','ddMMyyyy')), '_', char(datetime(last,'Format','ddMMyyyy')), '.mat'];
save(dbname, 'db');
delete(old_db);
%% Move .bhv2 file to archive folder
disp('Archiving behavior file...')
archivename = [pwd '/bhv_files/'];
if ~isdir(archivename)
    mkdir(archivename)
end
movefile(sessionname,archivename)
clear data MLConfig TrialRecord first last archivename old_db