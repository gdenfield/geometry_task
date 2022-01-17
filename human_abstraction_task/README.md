# human_abstraction_task
This is the human analog version of the task I created using jspsych for preliminary data collection on mturk.

We piloted three separate versions of the task:
- SD_task: simple two context version of the task. Contextual cues do not change.
- CCGP_task: full version of the task, with switch cues and novel contextual cues, requiring generalization.
- EFGH_task: alternative version of the task with two sets of fractals: ABCD for context 1 contingencies, and EFGH for context 2 contingencies

## Structure
- PNG and BMP files: Media used in the instructions or in the actual task.
- Task Files: CSV files determining the relevant data for each trial in the task. Each task featured several different versions, so different subjects experienced slightly different trial sequences. These were created using MATLAB scripts with titles featuring _task_file_generator_. See those scripts for column headings in the CSV files.
- append_block, append_EFGH: helper script for task_file_generator scripts.
- write_data.php: collects subject sessions and saves data in dedicated CSV files.
