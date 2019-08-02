#!/bin/sh
#
# Cloud Hook: drush-cache-clear
#
# Run drush cache-clear all in the target environment. This script works as
# any Cloud hook.

drush_alias=$1

# Execute a standard drush command.
drush @$drush_alias --yes cache-clear all
