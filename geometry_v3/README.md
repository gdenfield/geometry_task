# geometry_v2
Similar conventions to V1, but with more organization, different switch-cue, correction-loop error code structure.

## Scenes
For all: success --> next scene, failure --> scene 1 (or scene 0 for switch-cue trials)
- 0: switch cue (SC) on, time counter with: sc_duration
- 1: FP on, single target wth: fix_time
- 2: stim on, FP on, multi target wth: stim_time
- 3: FP on, single target wth: stim_trace_time, little_drops
- 4: ctx_cue on, FP on, single target wth: ctx_cue_time
- 5: FP on, target & off_targets on, single target wth: ctx_cue_trace_time, little_drops
- 6: target & off targets on, multiple target wth: decision_fix_time, decision_trace_time, big_drops +/-, ITI

## Directions
**If categorically labeling target directions, ALWAYS use the following convention: start with 1 as up, and proceed clockwise...**
- Up, 1
- Right, 2
- Down, 3
- Left, 4

## Rewards
I've found it easiest to vary the number of reward pulses instead of varying the solenoid opening time. Three variables describe the reward contingencies:
- _little_drops_: number of pulses to use for low reward conditions. This can be set to zero to create an unrewarded condtion.
- _big_drops_: number of pulses to use for large reward conditions.
- _training_drops_: number of pulses to use at end of select scenes to keep animals engaged in early parts of training. To turn on these rewards, change the values in the _training_rewards_ variable from 0's to 1's.

## Error Codes
Changed error codes in this version to reflect absolute error directions, as opposed to directions relative to the correct choice (as in v1).
- 0: Correct
- 1: Incorrect - Up
- 2: Incorrect - Right
- 3: Incorrect - Down
- 4: Incorrect - Left
- 5-9: see timingfile

## Hot Keys
- 's' to manually trigger context switch (with random number of SC trials)
- 'd' to double the number of trials in a given block (context)
- 'h' to halve the  number of trials in a given block (context)
- 't' to trigger a 2-minute timeout with a purple background screen (negative reinforcement for shaking)

## Data and Analyses
- Data are all stored on the "silvia_ML" computer in rig A, and are backed up to the lab server and my Columbia Google Drive.
- The **Analysis_scripts** folder contains many .m files, but in practice I mostly run _daily_report_2.m_ at the end of each session to see several useful daily summaries of performance. The _multi_day_X.m_ files are useful for importing, parsing, and analysing multiple sessions to look for trends across a week or a month, etc.

## Equipment 
- MonkeyLogic, running on the silvia_ML computer.
- National Instruments (NI) DAQ
- EyeLink 1000, connected to the NI Board via analog out BNC cables 
  - AI0: X signal
  - AI1: Y signal
  - AI2: pupil signal
  - NOTE: It is also possible to connect EyeLink via an ethernet cable, but I found the signal to be much less noisy with fewer dropped frames in ML using the analog output.
- Custom-built optical lick (luck) detector (designed by Lee Lovejoy, luck joke also attributed to him).
  - Communicates with NI board via BNC to the AI7 port.
- Custom-built reward delivery system
  - Triggered by NI board from AO0 port.


