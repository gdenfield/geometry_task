## Scenes
For all: success --> next scene, failure --> scene 1
- 1: FP on, single target wth: fix_time, little_drops
- 2: stim on, FP on, multi target wth: stim_time, little_drops
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


