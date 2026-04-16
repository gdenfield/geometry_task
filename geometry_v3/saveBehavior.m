

% upload the file to Matlab - update name for proper subject and data
[data, MLConfig, TrialRecord, filename] = mlread();

% save data on desktop - PP - data_PP_yymmdd
data_PP_250915 = {data, MLConfig, TrialRecord}; 
save('C:\Users\silvia_ML\Desktop\dataML_PP_250815.mat', 'data_PP_250915')


% save data on desktop - Piglet - data_yymmdd
data_260109 = {data, MLConfig, TrialRecord}; 
save('C:\Users\silvia_ML\Desktop\dataML_260109.mat', 'data_260109')


