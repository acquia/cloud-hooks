#!/bin/sh
#
# Cloud Hook: drush-cache-clear
#
# Run drush cache-clear all in the target environment. This script works as
# any Cloud hook.


# Map the script inputs to convient names.
site=$1
target_env=$2
drush_alias=$site'.'$target_  env

# Execute a standard drush command.
drush @$drush_alias cc all
