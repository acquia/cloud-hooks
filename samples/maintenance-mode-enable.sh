#!/bin/sh
#
# Cloud Hook: maintenance-mode-enable
#
# Enable Drupal maintenance mode before a site-level code deployment.
# This script is intended to be used as a pre-site-code-deploy hook to
# ensure the site is in maintenance mode during deployment.
#
# Usage: maintenance-mode-enable site target-env source-branch deployed-tag
#                                repo-url repo-type site-name extra-args

site="$1"
target_env="$2"
source_branch="$3"
deployed_tag="$4"
repo_url="$5"
repo_type="$6"
site_name="$7"
extra_args="$8"

echo "$site.$target_env: Enabling maintenance mode for site $site_name before deployment."

# Enable maintenance mode for Drupal 8/9/10/11
# For Drupal 7, use: drush @$site.$target_env vset maintenance_mode 1
drush @$site.$target_env state:set system.maintenance_mode 1 --input-format=integer

echo "$site.$target_env: Maintenance mode enabled for $site_name."
