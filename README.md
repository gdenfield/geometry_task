# geometry_task
MonkeyLogic files for geometry task.

Over the course of training, I've created two versions of the task. **V2.0** is close to the task we've discussed in project proposals, but V1.0 might come in handy for training new animals (due to greater control over the number of stimuli and the contrast of targets, which can be adjusted in real-time while the animal trains).

## Timing Variables
fix_time
stim_time
stim_trace_time
ctx_cue_time
ctx_cue_trace_time
max_decision_time
decision_fix_time
decision_trace_time
ITI_time

## Fixation Window
fix_radius

## Reward Variables
solenoid_time
little_drops
big_drops

## Task Objects
fixation_point = 1;
FP_background = 2;
stimulus = 3;
ctx_cue = 4;
target = 5;
off_target1 = 6;
off_target2 = 7;
off_target3 = 8;

## Scenes:
For all: success --> next scene, failure --> scene 1
1: FP on, single target wth: fix_time, little_drops
2: stim on, FP on, multi target wth: stim_time, little_drops
3: FP on, single target wth: stim_trace_time, little_drops
4: ctx_cue on, FP on, single target wth: ctx_cue_time
5: FP on, target & off_targets on, single target wth: ctx_cue_trace_time, little_drops
6: target & off targets on, multiple target wth: decision_fix_time, decision_trace_time, big_drops +/-, ITI

## Behavioral Codes
10, 'FP1'
11, 'Fixation Acquired'
13, 'Skipped Frame'
20, 'Stimulus'
30, 'FP2'
40, 'CC trial'
42, 'Switch trial'
45, 'None trial'
46, 'Break Fix'
50, 'Targets On'
55, 'Early Answer'
60, 'Go'
61, 'Saccade Initiated'
62, 'Scene 6'
65, 'Break Choice'
66, 'Choice Made'
70, 'Pre-Reward'
99, 'Reward'

## Error Codes
0, 'Correct'
1, 'Alternative'
2, 'Across'
3, 'Random'
4, 'No Fixation'
5, 'Break Fix'
6, 'Early Answer'
7, 'No Choice/ Break Choice/ Double Saccade'
8, 'Incorrect, CL trial'
9, 'Correct, CL trial'

## Directions
Up, 1
Right, 2
Down, 3
Left, 4
