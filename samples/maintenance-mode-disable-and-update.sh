#!/bin/sh
#
# Cloud Hook: maintenance-mode-disable-and-update
#
# Disable Drupal maintenance mode after a site-level code deployment and
# optionally run database updates if requested via extra-args. This script
# is intended to be used as a post-site-code-deploy hook.
#
# To trigger database updates, pass "update-db" or "updatedb" in the
# extra-args parameter when deploying via the Acquia Cloud UI or API.
#
# Usage: maintenance-mode-disable-and-update site target-env source-branch
#                                            deployed-tag repo-url repo-type
#                                            site-name extra-args

site="$1"
target_env="$2"
source_branch="$3"
deployed_tag="$4"
repo_url="$5"
repo_type="$6"
site_name="$7"
extra_args="$8"

echo "$site.$target_env: Disabling maintenance mode for site $site_name after deployment."

# Disable maintenance mode for Drupal 8/9/10/11
# For Drupal 7, use: drush @$site.$target_env vset maintenance_mode 0
drush @$site.$target_env state:set system.maintenance_mode 0 --input-format=integer

echo "$site.$target_env: Maintenance mode disabled for $site_name."

# Check if database updates were requested via extra-args
if echo "$extra_args" | grep -q "update-db\|updatedb"; then
    echo "$site.$target_env: Running database updates for $site_name (requested via extra-args)."
    drush @$site.$target_env updatedb --yes
    echo "$site.$target_env: Database updates completed for $site_name."
else
    echo "$site.$target_env: No database updates requested for $site_name."
fi
