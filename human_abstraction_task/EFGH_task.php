<!DOCTYPE html>
<html>
  
  <head>
    <title>Picture Learning Game</title>
    <script src="jspsych-6.1.0/jspsych.js"></script>
    <script src="jspsych-6.1.0/plugins/jspsych-html-keyboard-response.js"></script>
    <script src="jspsych-6.1.0/plugins/jspsych-image-keyboard-response.js"></script>
    <script src="jspsych-6.1.0/plugins/jspsych-survey-text.js"></script>
    <script src="jspsych-6.1.0/plugins/jspsych-vsl-grid-scene.js"></script>
    <script src="jspsych-6.1.0/plugins/jspsych-survey-html-form.js"></script>
    <script src="jspsych-6.1.0/plugins/jspsych-instructions.js"></script>
    <script src="jspsych-6.1.0/plugins/jspsych-animation.js"></script>
    <link href="jspsych-6.1.0/css/jspsych.css" rel="stylesheet" type="text/css"></link>
  </head>

  <body></body>

  <div id="preloadImages">
  	<p>
      <?php

      $behavior=array_map('str_getcsv', file('behavioral_files.csv'));
      $randIndex = array_rand($behavior);
      $file=strval($behavior[$randIndex][0]);
      $csv = array_map('str_getcsv', file($file));
      for ($x = 0; $x < sizeof($csv); $x++) {
        $temp[$x]=$csv[$x][0];}
      $unique=array_unique($temp);
      $unique=array_values($unique);
      shuffle($unique);
      ?>
      <?php for ($x = 0; $x < sizeof($csv); $x++) { ?>
        <img src="<?php echo $csv[$x][0] ?>">
        <?php
      }?>
    </p>
  </div>


  <script>
    /* create timeline */
    var timeline = [];

    /* define welcome message trial */
    var welcome = {
      type: "html-keyboard-response",
      stimulus: `<p><b>Welcome to the Picture Learning Game!</b></p>
      <p>The game will take ~35 minutes to complete, and you can make up to $17.50.</p>
      <p>You must use a desktop or laptop computer computer (no mobile devices).</p>
      <p><em>Press any key to continue.</em></p>`
    };
    timeline.push(welcome);
    
    /* input MTurk identification */
    var id = { type: 'survey-text',
               questions: [
               {prompt: "Please enter your Amazon worker ID:", name:'aws', required:true}],
                on_finish: function(data){
                var id_response=jsPsych.data.get().last(1).values()[0].responses;
                name_pre=JSON.parse(id_response);
                },
    };
    timeline.push(id);

    /* input screening questions */
    var screening = {
      type: 'survey-text',
      questions: [
        {prompt: "How old are you?", name:'age'},{prompt: "Are you fluent in English? (Y/N)", name:'english'},{prompt: "Are you right or left handed? (R/L)", name:'handedness'},{prompt: "Are you using a desktop or laptop computer? (Y/N)", name:'desktop'}
      ],
    };
    timeline.push(screening);

    /* instructions */
    var instructions = {
      type: "instructions",
      pages: [
        `<p><b>Instructions</b></p><p>Click next to begin.</p>`,
        
        `<p>In this game, <b>pictures</b> will appear one at a time in the center of the screen:</p><img src=sample1.bmp></img><p>Your goal is to learn the <em>correct direction</em> (<b>up</b>, <b>down</b>, <b>left</b>, and <b>right</b>) associated with each picture.</p><p>For example, this is a picture of a garden, and its correct direction is <b>up</b>.</p>`,
        
        `<p>After each picture, <b>response arrows</b> will appear:</p><img src='arrows.png' width=300 height=300/><p>When you see the response arrows, use your keyboard to enter the correct direction.`,


        `<p>There are <b>eight</b> pictures, each with its own correct direction.</p>
          <p>(Note: this is an example. The pictures in the game will be different from the ones you see here.)</p>
          <div style='float: left;'>
          <p><img src='sample1.bmp' width=50 height=50/> ,<img src='arrows.png' width=50 height=50/> Press the <b>⬆️</b> key.</p>
          <p><img src='sample2.bmp' width=50 height=50/> ,<img src='arrows.png' width=50 height=50/> Press the <b>➡️</b> key.</p>
          <p><img src='sample3.bmp' width=50 height=50/> ,<img src='arrows.png' width=50 height=50/> Press the <b>⬇️</b> key.</p>
          <p><img src='sample4.bmp' width=50 height=50/> ,<img src='arrows.png' width=50 height=50/> Press the <b>⬅️</b> key.</p></div>

          <div style='float: right;'>
          <p><img src='sample5.bmp' width=50 height=50/> ,<img src='arrows.png' width=50   height=50/> Press the <b>⬆️</b> key.</p>
          <p><img src='sample6.bmp' width=50 height=50/> ,<img src='arrows.png' width=50 height=50/> Press the <b>➡️</b> key.</p>
          <p><img src='sample7.bmp' width=50 height=50/> ,<img src='arrows.png' width=50 height=50/> Press the <b>⬇️</b> key.</p>
          <p><img src='sample8.bmp' width=50 height=50/> ,<img src='arrows.png' width=50 height=50/> Press the <b>⬅️</b> key.</p></div>`,

          `<p>Try for yourself on the next screen. Remember, the correct direction for the garden picture is <b>up</b>.</p>`
          ],
          show_clickable_nav: true
    };
    timeline.push(instructions);

    var example_stim = {
      type: 'image-keyboard-response',
      stimulus: 'sample1.bmp', 
      choices: jsPsych.NO_KEYS,
      trial_duration: 1000,
      post_trial_gap: 300
    };
    timeline.push(example_stim);

    example_up = {
      type: 'image-keyboard-response',
      stimulus: 'arrows.png', 
      choices: ['uparrow'],
    };
    timeline.push(example_up);

    /*var instructions2 = {
      type: 'instructions',
      pages: [
      `<p>Correct!</p>`,

      '<p>Sometimes you will see a <b>colored square</b> <em>after</em> the picture and <em>before</em> the response arrows:</p><img src="CC1.png" width=300 height=300/><p>When the square changes color, so do the correct directions for each picture.</p><p>This square will change color many times during the game.</p>',

      `<p>For example, here is the garden picture you just saw followed by a blue square.</p><p>Remember, the correct direction is still <b>up</b>.</p>`
      ],
      show_clickable_nav: true
    };
    timeline.push(instructions2)

    var example_cc1 = {
      type: 'html-keyboard-response',
      stimulus: '<img src="CC1.png" width=200 height=200/>',
      choices: jsPsych.NO_KEYS,
      trial_duration: 1000,
      post_trial_gap: 300
    };
    timeline.push(example_stim, example_cc1, example_up)

    var instructions3 = {
      type: 'instructions',
      pages: [
      `<p>Great!</p>`,

      `<p>Now you will see the garden picture followed by a red square.</p><p>Since the color has changed, the correct direction has changed. The correct direction for the garden picture is now <b>right</b>.</p>`
      ],
      show_clickable_nav: true
    };
    timeline.push(instructions3)

    var example_cc2 = {
      type: 'html-keyboard-response',
      stimulus: '<img src="CC2.png" width=200 height=200/>',
      choices: jsPsych.NO_KEYS,
      trial_duration: 1000,
      post_trial_gap: 300
    };

    var example_sc = {
      type: 'image-keyboard-response',
      stimulus: 'switch_cue.png',
      choices: jsPsych.NO_KEYS,
      trial_duration: 1000,
      post_trial_gap: 300
    };

    var example_correct = {
      type: 'html-keyboard-response',
      stimulus: '<p style="color: green; font-size:300%;">correct</p>',
      choices: jsPsych.NO_KEYS,
      trial_duration: 1000,
      post_trial_gap: 300
    };

    var example_right = {
      type: 'image-keyboard-response',
      stimulus: 'arrows.png', 
      choices: ['rightarrow'],
    };
    timeline.push(example_stim, example_cc2, example_right);

    var instructions4 = {
      type: 'instructions',
      pages: [
      `<p>Brilliant!</p>`,

      `<p>When the colored square changes, the correct directions will change for all four pictures <em>at the same time</em>.</p>
      <p>When this happens, try to learn the new correct directions associated with that color.</p>`,

      `<p>For example when the square changes from blue to red, the correct directions for the four pictures might change like this:</p>
      <div style='float: left;'><p class='small'>
      <p><img src='sample1.bmp' width=50 height=50/> ,<img src='CC1.png' width=50 height=50/> ,<img src='arrows.png' width=50 height=50/> Press the <b>⬆️</b> key.</p>
      <p><img src='sample2.bmp' width=50 height=50/> ,<img src='CC1.png' width=50 height=50/> ,<img src='arrows.png' width=50 height=50/> Press the <b>➡️</b> key.</p>
      <p><img src='sample3.bmp' width=50 height=50/> ,<img src='CC1.png' width=50 height=50/> ,<img src='arrows.png' width=50 height=50/> Press the <b>⬇️</b> key.</p>
      <p><img src='sample4.bmp' width=50 height=50/> ,<img src='CC1.png' width=50 height=50/> ,<img src='arrows.png' width=50 height=50/> Press the <b>⬅️</b> key.</p></p></div>

      <div style='float: right;'><p class='small'>
      <p><img src='sample1.bmp' width=50 height=50/> ,<img src='CC2.png' width=50 height=50/> ,<img src='arrows.png' width=50   height=50/> Press the <b>➡️</b> key.</p>
      <p><img src='sample2.bmp' width=50 height=50/> ,<img src='CC2.png' width=50 height=50/> ,<img src='arrows.png' width=50 height=50/> Press the <b>⬇️</b> key.</p>
      <p><img src='sample3.bmp' width=50 height=50/> ,<img src='CC2.png' width=50 height=50/> ,<img src='arrows.png' width=50 height=50/> Press the <b>⬅️</b> key.</p>
      <p><img src='sample4.bmp' width=50 height=50/> ,<img src='CC2.png' width=50 height=50/> ,<img src='arrows.png' width=50 height=50/> Press the <b>⬆️</b> key.</p></p></div>`,

      '<p>The colored square does not appear after every picture, but the correct directions will not change until the colored square changes again.</p>',

      `<p>Give it a try: You will see the garden picture again, but this time no colored square will appear.</p><p>Try to remember the correct direction for this picture given the last colored square you saw (red).</p>`
      ],
      show_clickable_nav: true
    };
    timeline.push(instructions4);

    timeline.push(example_stim, example_right);

    var instructions5 = {
      type: 'instructions',
      pages: [
          `<p>Perfect!</p><p>Since the correct direction for the garden picture was <b>right</b> with the red colored square, that is still the correct direction for this picture.`,

          `<p>Sometimes you will see an <b>alert sign</b> before the next picture:</p>
          <img src='switch_cue.png' width=300 height=300/>
          <p>When you see this, it means there is a 50% chance that the colored square will change on the next picture.</p><p>There is also a 50% chance that the colored square will stay the same, so pay attention!</p>`,

          `<p>Try a few more examples with the garden picture:</p><p>If the colored square changes, the correct directions will change. If the colored square stays the same, the correct directions will stay the same.`
      ],
      show_clickable_nav: true
    };
    timeline.push(instructions5);

    timeline.push(example_stim, example_right, example_correct);
    timeline.push(example_sc, example_stim, example_cc2, example_right, example_correct);
    timeline.push(example_sc, example_stim, example_cc1, example_up, example_correct);*/

    var instructions6 = {
      type: 'instructions',
      pages: [
        `<p>Correct!</p>`,

        `<b>Compensation</b>`,

        `<p>You will earn $5 for completing the game.</p>
          <p>You will earn an additional $5 for completing more than 50% correct.</p>
          <p>Finally, you can win a performance-based bonus of $0, $2.50, or $7.50.</p>`,

        `<p><b>Performance-Based Bonus</b></p><p>At the end of your game, we will select a random response from your session.</p><p>If the response was incorrect, you will not receive a bonus. If your response was correct, you will recieve either $2.50 or $7.50, depending on the picture.</p><p>Respond as accurately as you can to maximize your chances of winning!</p>`,

        `<p>Pictures will appear and disappear very quickly, so pay close attention.</p><p>When the response arrows appear, answer as soon as you want.</p><p>You will have 7 seconds to make your choice or else your answer will count as incorrect.</p>`,

        `<p>Initially, you will not know the correct direction for each picture, so take a guess.</p><p>This is a challenging game and will require your undivided attention.</p>`,

        `<p>Good luck!</p><p><em>Press next to begin.</em></p>`,
      ],
      show_clickable_nav: true,
      on_close: function() {
      // set progress bar to 0 at the start of experiment
        jsPsych.setProgressBar(0);
      },
    };
    timeline.push(instructions6)

    /* test trials */
    var i;
    var stimdata = <?php echo json_encode($csv)?>;
    var length=Object.keys(stimdata).length;
    var test_stimuli= [];
    for (i=0; i<length; i++){
          test_stimuli.push({ stimulus: stimdata[i][0],  data: { test_part: 'test', correct_response: stimdata[i][1], outcome: stimdata[i][2],context:stimdata[i][3],cc:stimdata[i][4],sc:stimdata[i][7]}})
      }


    var fixation_1 = {
      type: 'html-keyboard-response',
      stimulus: '<div style="font-size:60px;"> </div>',
      choices: jsPsych.NO_KEYS,
      trial_duration: 300,
      data: {test_part: 'fixation_1'}
    }

    var switch_cue = {
      type: "image-keyboard-response",
      stimulus_width: 200,
      stimulus_length:200,
      stimulus: function(){
      current_trial = jsPsych.currentTrial()
      show_switch_cue = current_trial.data.sc=="TRUE"
      console.log(current_trial)
       if(show_switch_cue){return 'switch_cue.png'}
       else {return ''}  
      },
      choices: jsPsych.NO_KEYS,
      data: jsPsych.timelineVariable('data'),
      trial_duration: function(){
      current_trial = jsPsych.currentTrial()
      show_switch_cue = current_trial.data.sc=="TRUE"
       if(show_switch_cue){return 1000}
       else {return 0} 
      },
    }

    var fixation_2 = {
      type: 'html-keyboard-response',
      stimulus: '<div style="font-size:60px;"> </div>',
      choices: jsPsych.NO_KEYS,
      trial_duration: 300,
      data: {test_part: 'fixation_2'}
    }

   var img_on = {
      type: "image-keyboard-response",
      stimulus: jsPsych.timelineVariable('stimulus'),
      choices: jsPsych.NO_KEYS,
      trial_duration: 1000,
      data: {test_part: 'img_on'}
    }

    var fixation_3 = {
      type: 'html-keyboard-response',
      stimulus: '<div style="font-size:60px;"> </div>',
      choices: jsPsych.NO_KEYS,
      trial_duration: 300,
      data: {test_part: 'fixation_3'}
    }

    var context_cue = {
      type: "html-keyboard-response",
      stimulus: function(){
      current_trial = jsPsych.currentTrial()
      show_context_cue = current_trial.data.cc=="TRUE"
      context          = current_trial.data.context
      context_cues     = ['CC1.png','CC2.png','CC3.png', 'CC4.png','CC5.png','CC6.png','CC7.png','CC8.png', 'CC9.png', 'CC10.png', 'CC11.png', 'CC12.png']
       if(show_context_cue){return '<img src="'+context_cues[context-1]+'" width=200 height=200/>'}
       else {return ''}
      },
      choices: jsPsych.NO_KEYS,
      data: jsPsych.timelineVariable('data'),
      trial_duration: function(){
      current_trial = jsPsych.currentTrial()
      show_context_cue = current_trial.data.cc=="TRUE"
      console.log(show_context_cue)
       if(show_context_cue){return 1000}
       else {return 0}  
      },
    }

    var fixation_4 = {
      type: 'html-keyboard-response',
      stimulus: '<div style="font-size:60px;"> </div>',
      choices: jsPsych.NO_KEYS,
      trial_duration: 300,
      data: {test_part: 'fixation_4'}
    }
 
    var test = {
      type: "image-keyboard-response",
      stimulus: "arrows.png",
      stimulus_width: 300,
      stimulus_length: 300,
      choices: ['uparrow','rightarrow','downarrow','leftarrow'],
      data: jsPsych.timelineVariable('data'),
      on_finish: function(data){
        data.correct = data.key_press == jsPsych.pluginAPI.convertKeyCharacterToKeyCode(data.correct_response);
      },
        trial_duration:7000, //time out period
        post_trial_gap:250,  
    }

    var feedback = {
      type: 'html-keyboard-response',
      choices: jsPsych.NO_KEYS,
      trial_duration: 1000,
      stimulus: function(){
        var last_trial_correct = jsPsych.data.get().last(1).values()[0].correct;
        var outcome=jsPsych.data.get().last(1).values()[0].outcome;
        if(last_trial_correct && outcome=='1'){
          return '<p style="color: green; font-size:300%;">correct: $7.50</p>';
        } else if(last_trial_correct && outcome=='0'){
          return '<p style="color: green; font-size:300%;">correct: $2.50</p>';
        }else {
          return '<p style="color: red; font-size:300%;">incorrect: $0</p>';
        }
      },
      on_finish: function() {
        // at the end of each trial, update the progress bar
        // based on the current value and the proportion to update for each trial
        var curr_progress_bar_value = jsPsych.getProgressBarCompleted();
        jsPsych.setProgressBar(curr_progress_bar_value + (1/length));
      },
      post_trial_gap:function(){
        return jsPsych.randomization.sampleWithoutReplacement([250, 500, 750, 1000, 1250], 1)[0];
      }
    }
    
    var test_procedure = {
      timeline: [fixation_1, switch_cue, fixation_2, img_on, fixation_3, context_cue,fixation_4, test, feedback],
      timeline_variables: test_stimuli,
      repetitions: 1,
      randomize_order: false,
    }
    timeline.push(test_procedure);

    var enddata = <?php echo json_encode($unique)?>;
    var pattern = [
      [enddata[0], enddata[1]],
      [ enddata[3], enddata[5]]
    ];

    var image_size = 100; // pixels
    var timing_duration=5000;
    var grid_stimulus = jsPsych.plugins['vsl-grid-scene'].generate_stimulus(pattern, image_size, timing_duration);

    function saveData(name, data){
      var xhr = new XMLHttpRequest();
      xhr.open('POST', 'write_data.php'); // 'write_data.php' is the path to the php file described above.
      xhr.setRequestHeader('Content-Type', 'application/json');
      xhr.send(JSON.stringify({filename: name, filedata: data}));
    }

    /* debrief */
    var debrief_block = {
      type: "html-keyboard-response",
      stimulus: function() {

        var trials = jsPsych.data.get().filter({test_part: 'test'});
        var correct_trials = trials.filter({correct: true});
        var accuracy = Math.round(correct_trials.count() / trials.count() * 100);
        var rt = Math.round(correct_trials.select('rt').mean());

        return "<p><b>Congratulations! You finished!</b></p>"+
        "<p>You responded correctly on "+accuracy+"% of the pictures.</p>"+
        "<p>Your average response time was "+rt+" ms.</p>"+
        "<p>Please copy-paste the following completion code to the MTurk website window and then submit your HIT.</p>"+
        "<p>920153</p>"+
        "<p>Press 'q' to quit the game. Thank you!</p>";
      },
      choices: ['q'],
      
      on_start: function() {
        //jsPsych.data.displayData();
        saveData(name_pre["aws"], jsPsych.data.get().csv());
      }
    }
    timeline.push(debrief_block);

    /* start the experiment */
    jsPsych.init({
      timeline: timeline,
      show_progress_bar: true,
      auto_update_progress_bar: false
    });
  </script>
</html>