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


  <script>
    /* create timeline */
    var timeline = [];

    /* define welcome message trial */
    var welcome = {
      type: "html-keyboard-response",
      stimulus: `<p><b>Welcome to the Picture Learning Game!</b></p>
      <p>This game will take ~30 minutes to complete, and you can make up to $25.</p>
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
      type: "html-keyboard-response",
      post_trial_gap: 500,
      timeline: [
        {stimulus: "<p><b>Instructions</b></p>"},
        {stimulus: "<p>In this game, <b>pictures</b> will appear one at a time in the center of the screen:</p><img src=sample1.bmp></img><p>Your goal is to learn the <em>correct direction</em> associated with each picture (up, down, left, and right).</p>"},
        {stimulus: "<p>After each picture, <b>response arrows</b> will appear:</p><img src='arrows.png' width=300 height=300/><p>When you see the response arrows, use your keyboard to guess the correct direction (⬆️, ⬇️, ⬅️, or ➡️)."},
        {stimulus: `<p>There are four pictures, each with its own correct direction. For example when you see:</p>
          <p><img src='sample1.bmp' width=75 height=75/> , <img src='arrows.png' width=75 height=75/> Press the <b>⬆️</b> key.</p>
          <p><img src='sample2.bmp' width=75 height=75/> , <img src='arrows.png' width=75 height=75/> Press the <b>➡️</b> key.</p>
          <p><img src='sample3.bmp' width=75 height=75/> , <img src='arrows.png' width=75 height=75/> Press the <b>⬇️</b> key.</p>
          <p><img src='sample4.bmp' width=75 height=75/> , <img src='arrows.png' width=75 height=75/> Press the <b>⬅️</b> key.</p>
          <p>(The pictures in the game will be different from the ones you see here.)</p>`},
        {stimulus: `<p>Sometimes you will see a <b>colored square</b> <em>after</em> the picture, but <em>before</em> the response arrows:</p><img src='CC1.png' width=300 height=300/><p>This square will change color many times during the game.</p>`},
        {stimulus: `<p>When the square changes color, so do the correct directions associated with each picture.</p>
          <p>For example when the square changes from blue to red, the correct directions might change like this:</p>
          <div style='float: left;'><p class='small'>
          <p><img src='sample1.bmp' width=75 height=75/> ,<img src='CC1.png' width=75 height=75/> ,<img src='arrows.png' width=75 height=75/> Press the <b>⬆️</b> key.</p>
          <p><img src='sample2.bmp' width=75 height=75/> ,<img src='CC1.png' width=75 height=75/> ,<img src='arrows.png' width=75 height=75/> Press the <b>➡️</b> key.</p>
          <p><img src='sample3.bmp' width=75 height=75/> ,<img src='CC1.png' width=75 height=75/> ,<img src='arrows.png' width=75 height=75/> Press the <b>⬇️</b> key.</p>
          <p><img src='sample4.bmp' width=75 height=75/> ,<img src='CC1.png' width=75 height=75/> ,<img src='arrows.png' width=75 height=75/> Press the <b>⬅️</b> key.</p></p></div>

          <div style='float: right;'><p class='small'>
          <p><img src='sample1.bmp' width=75 height=75/> ,<img src='CC2.png' width=75 height=75/> ,<img src='arrows.png' width=75 height=75/> Press the <b>➡️</b> key.</p>
          <p><img src='sample2.bmp' width=75 height=75/> ,<img src='CC2.png' width=75 height=75/> ,<img src='arrows.png' width=75 height=75/> Press the <b>⬇️</b> key.</p>
          <p><img src='sample3.bmp' width=75 height=75/> ,<img src='CC2.png' width=75 height=75/> ,<img src='arrows.png' width=75 height=75/> Press the <b>⬅️</b> key.</p>
          <p><img src='sample4.bmp' width=75 height=75/> ,<img src='CC2.png' width=75 height=75/> ,<img src='arrows.png' width=75 height=75/> Press the <b>⬆️</b> key.</p></p></div>`},
        {stimulus: `<p>Note: When the colored square changes, the correct directions will change for all four pictures <em>at the same time</em>.</p>
          <p>These new directions will be fixed until the colored square changes again.</p>`},
        {stimulus: `<p>Sometimes you will see an <b>alert sign</b> before the next picture:</p>
          <img src='switch_cue.png' width=300 height=300/>
          <p>When you see this, it means there is a 50% chance that the colored square will change on the next picture.</p>`},
        {stimulus: `<p>Pictures will appear and disappear very quickly, so pay close attention.</p>
          <p>When the response arrows appear, you will have 5 seconds to make your choice or else your answer will count as incorrect.</p>`},
      ],
    };
    timeline.push(instructions);

    /* compensation */
    var compensation = {
      type: "html-keyboard-response",
      post_trial_gap: 500,
      timeline: [
        {stimulus: `<p><b>Compensation</b></p>`},
        {stimulus: `<p>You will earn $5 for completing the game.</p>
          <p><em>If all your guesses are in the same direction, it will not count and you will not be paid.</em></p>`},
        {stimulus: `<p>You will also have the chance to win a performance-based bonus.</p>`},
        {stimulus: `<p>After making your guess, you will find out if your guess was correct.</p>
          <p>Correct responses are associated with a $7 or $15 bonus, depending on the picture.</p>
          <p>If your response is incorrect, you will see the word "incorrect" and that trial will be associated with a $0 bonus.</p>`},
        {stimulus: `<p>At the end of your game, we will select a random response from your session.</p>
        <p>If the response was incorrect, you will recieve no bonus. If your response was correct, you will recieve either $7 or $15, depending on the picture.</p>
        <p><b>Respond as accurately as you can to maximize your chances of winning!</b></p>`}
      ],
      on_close: function() {
      // set progress bar to 0 at the start of experiment
        jsPsych.setProgressBar(0);
      },
    };
    timeline.push(compensation);

    /* show summary of instructions */
    var instruction_screen = {
      type: "image-keyboard-response",
      stimulus: 'instruction_screen.png',
      post_trial_gap: 500
    };
    timeline.push(instruction_screen);

    /* final screen before start of task */
    var good_luck = {
      type: "html-keyboard-response",
      stimulus: "<p>Initially, you will not know the correct direction for each picture, so take a guess.</p>"+
                "<p>This is a challenging game and will require your undivided attention.</p> "+
                "<p>Press any key to begin.</p>"+
                "<p><b>Good luck!</b></p>",
      post_trial_gap: 2000,
    };
    timeline.push(good_luck);


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
      context_cues     = ['&#128998','&#128997','&#129000', '&#128999','&#129003','&#129001','&#129002','&#11035']
       if(show_context_cue){return '<p style="font-size:128px;">'+ context_cues[context-1] +'</p>'}
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
        trial_duration:5000, //time out period
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
          return '<p style="color: green; font-size:300%;">$15</p>';
        } else if(last_trial_correct && outcome=='0'){
          return '<p style="color: green; font-size:300%;">$7</p>';
        }else {
          return '<p style="color: red; font-size:300%;">incorrect</p>';
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
        "<p>You responded correctly on "+accuracy+"% of the trials.</p>"+
        "<p>Your average response time was "+rt+" ms.</p>"+
        "<p>Please copy-paste the following completion code to the MTurk website window and then submit your HIT.</p>"+
        "<p>920153</p>"+
        "<p>Press any key to complete the experiment. Thank you!</p>";
      },
      
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
