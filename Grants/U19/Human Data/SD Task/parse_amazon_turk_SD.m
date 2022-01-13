function data = parse_amazon_turk_SD(folder)


% Load task versions
versions        = load_available_versions([folder,'/sd_version/']);

% Load the subject data
folder           = [folder,'/sd_data/'];
data             = struct();
filename         = dir([folder,'/*.csv']);

% the first batch had a 2s stimulus duration time, the second batch had
% a 1s stimulus duration time.
file_date        = {filename.date};
[subjects]       = get_subjects({filename.name});


for j=1:length(filename)
    
    file_loc     = [folder,'/',filename(j).name];
    tbl          =  readtable(file_loc,'Delimiter',',');
    idx_response =  find(contains(tbl.test_part,'fixation_4'))+1;
    rt           = cellfun(@(x) str2double(x)/1e3,   tbl.rt(idx_response));
    stim         = tbl.stimulus(idx_response-4);
    task         = versions(find_version(versions,stim)).name;
    correct_response        = tbl.correct_response(idx_response);
    correct      = cellfun(@(x) contains(x,'true'),tbl.correct(idx_response));
    sc_on        = cellfun(@(x) contains(x,'TRUE'),tbl.sc(idx_response));
    cc_on        = cellfun(@(x) contains(x,'TRUE'),tbl.cc(idx_response));
    key_press    = cellfun(@(x) str2double(x), tbl.key_press(idx_response));
    context      = tbl.context(idx_response);
    reward       = tbl.outcome(idx_response);
    
    key_press(isnan(key_press)) = 0;
    
    data(j).task          = task;
    data(j).date          = file_date{j};
    data(j).sessionID     =  subjects{j};
    data(j).stim          = stim;
    data(j).correct_response = correct_response;
    data(j).user_response = remap(key_press);
    data(j).rt            = rt;
    data(j).correct       = correct;
    data(j).context       = context;
    data(j).sc_on         = sc_on;
    data(j).cc_on         = cc_on;
    data(j).reward        = reward;
    

end
    

    
end




function [name]  = get_subjects(file_names)
idx = cellfun(@(x) strfind(x,'.')-1,file_names);
name = cellfun(@(x,y) x(1:y),file_names,num2cell(idx),'UniformOutput',false);
end
function key = remap(keycode)
code = [37,38,39,40,0];
vals = {'leftarrow','uparrow', 'rightarrow', 'downarrow',NaN};
dict =containers.Map(code,vals);

key = cell(length(keycode),1);
for i=1:length(keycode)
    key{i} = dict(keycode(i));
   
end
end
function versions = load_available_versions(where)
files = dir([where,'/*.csv']);

versions = struct();

for i=1:length(files)
    versions(i).name = files(i).name;
    versions(i).tbl = readcell([where,'/',files(i).name]);
end

end

function which =  find_version(versions,stim)
check = false(1,length(versions));
for i=1:length(versions)
    check(i) = all(cellfun(@(x,y) strcmp(x,y),versions(i).tbl(:,1),stim));
end

which = find(check);
end



