# human_abstraction_task
This is the human analog version of the task I created using jspsych for preliminary data collection on mturk.

We piloted three separate versions of the task:
- SD_task: simple two context version of the task. Contextual cues do not change.
- CCGP_task: full version of the task, with switch cues and novel contextual cues, requiring generalization.
- EFGH_task: alternative version of the task with two sets of fractals: ABCD for context 1 contingencies, and EFGH for context 2 contingencies

## Organization
- PNG and BMP files: Media used in the instructions or in the actual task.
- Task Files: CSV files determining the relevant data for each trial in the task. Each task featured several different versions, so different subjects experienced slightly different trial sequences. These were created using MATLAB scripts with titles featuring _task_file_generator_. See those scripts for column headings in the CSV files.
- append_block, append_EFGH: helper script for task_file_generator scripts.
- max_abstraction_v5.php, EFGH_task.php: Tasks for the SD/CCGP and EFGH tasks, respectively. These are meant to run on a web-browser and require the jspsych folder to be in the same directory.
- write_data.php: collects subject sessions and saves data in dedicated CSV files.

## Data and Analyses
All final data and analyses run can be found in the path Grants --> U19 --> Human Data (in this repository).
