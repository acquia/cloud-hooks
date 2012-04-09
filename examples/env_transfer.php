#!/usr/bin/env php -q
<?php
/*
 * Script to automate the transfer of all databases
 * and files from one environment to another using
 * Acquia Cloud API - http://cloudapi.acquia.com/
 */

// Setup your Cloud API credentials here from the Managed Cloud, Drush
// and API section of your network.acquia.com subscription.
$user = '';
$pass = '';
$sub = '';

// Environments to transfer, typically these can be: prod, dev, test
$from_env = 'prod';
$to_env = 'test';

// You probably dont want to change anything below this line
$sleep = 20;
$debug = FALSE;

print "Checking environments:\n";
$to_env_check = $from_env_check = FALSE;
$env_info = call_api("sites/". $sub ."/envs", 'GET', $debug);
if ($env_info) {
  foreach ($env_info as $env) {
    print $env->name ."\n";

    // Some sanity checks
    if ($env->name == $from_env) {
      $from_env_check = TRUE;
    }
    if ($env->name == $to_env) {
      $to_env_check = TRUE;
    }
  }
}

if (!$to_env_check || !$from_env_check) {
  exit("An environment specified doesn't exist. Available environments are listed above.\n");
}

// Retrieve details of databases for the 'from' environment
$db_info = array();
$db_info = call_api("sites/". $sub ."/envs/". $from_env ."/dbs", 'GET', $debug);

// Loop through the retrieved details and submit the actual copies
if ($db_info) {
  foreach ($db_info as $object) {
    print "Submitting transfer for ". $object->name ."\n";
    
    // Submit our job
    $command = "sites/". $sub ."/dbs/". $object->name ."/db-copy/". $from_env ."/". $to_env;
    $ret = call_api($command, 'POST', $debug);
    
    // Now just loop around until the task is complete
    wait_for_task($ret->id);
  }
}


// Now submit the file transfer
print "Submitting transfer for files\n";
$ret = call_api("sites/". $sub ."/files-copy/". $from_env ."/". $to_env, 'POST', $debug);
wait_for_task($ret->id);
print "Finished transfer of dbs and files from ". $from_env ." to ". $to_env ."\n";

function wait_for_task($task_id) {
  global $sleep, $debug, $sub;

  $task_complete = FALSE;
  while ($task_complete == FALSE) {
    $task = call_api("sites/". $sub ."/tasks/". $task_id, 'GET', $debug);
    
    if ($task->completed > 0) {
      $task_complete = TRUE;
      print "Task ". $task_id ." complete\n";
    }
    else {
      print "Waiting for ". $task_id ." to complete\n";
      sleep($sleep);
    }
  }
}

function call_api($details, $type = 'POST', $debug = FALSE) {
  global $user, $pass;

  $full_cmd = "https://cloudapi.acquia.com/v1/". $details .".json";
  if ($debug) {
    print "Submitting command: ". $full_cmd ."\n";
  }

  $ch = curl_init($full_cmd);

  // Setup the login
  curl_setopt($ch, CURLOPT_HTTPAUTH, TRUE); 
  curl_setopt($ch, CURLOPT_USERPWD, $user .":". $pass); 
  
  // Set options
  curl_setopt($ch, CURLOPT_CUSTOMREQUEST, $type);
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE);

  // Debugging
  curl_setopt($ch, CURLOPT_VERBOSE, $debug);

  // Actually do the call
  $ret = curl_exec($ch);

  $error = curl_error($ch);
  if ($error > 0 || !$ret) {
    print "Error accessing API: ". $error ."\n";
    return FALSE;
  }

  $status = curl_getinfo($ch, CURLINFO_HTTP_CODE);
  if ($status != 200) {
    print $status;
    return FALSE;
  }

  // Close the curl handle
  curl_close($ch);

  // Now decode the results
  $ret = json_decode($ret);

  // If there was a message, output it.
  if (isset($ret->message)) {
    print "Message received from Acquia cloudapi\n". $ret->message ."\n";
  }

  // Return the results
  return $ret;
}
