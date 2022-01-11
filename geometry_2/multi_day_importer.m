% Multi-day import
tic
files = dir('*.bhv2');
data = cell(1,length(files));
TR = cell(1,length(files));

for i = 1:length(files)
    disp(['loading file ' num2str(i) ' of ' num2str(length(files))])
    [data{i}, ~, TR{i}, ~] = mlread(files(i).name);
    toc
end