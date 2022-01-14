# Task files and analyses for V1

This was the first version of the task that I coded. It might come in handy when training new animals on the task, as parameters such as off-target contrast can be adjusted on the fly. Also this version allows for automatic dimming of contrast after a certain number of incorrect choices within a correction loop (CL), based on the _instructed_threshold_ variable.

At the time I wrote this version, I was using dedicated fractals for the contextual cues (CCs), but have subsequently moved to a rectangular frame so these cues are visually distinct from the stimuli.

## Files
As usual, the task is specified in **userloop** and **timingfile** scripts, with a pointer text file called **geometry_task**.

I have also created a custom **performance_monitor** that shows trial history and running hit rates. This, in turn depends on the custom **hit_rate** function. 

NOTE: In this version, trial errors are coded relative to the correct saccade direction. For example 0 corresponds to a correct choice, and 1 corresponds to the correct choice in the other context. 2 refers to the target directly across the fixation point from the correct target (i.e. down, if the correct choice is up), and 3 refers to the remaining choice direction. Error codes 8 and 9 refer to incorrect and correct choices within correction loops (CLs), respectively.

## Hotkeys
- 's' triggers a manual context switch.
- 'd' doubles the fixed block length, if you want to keep the monkey in a given context longer.
- 'h' halves the fixed block length
- 'u' increases the contrast of the incorrect saccade targets
- 'j' decreases the contrast of the incorrect saccade targets, making the task easier for monkeys to learn.
