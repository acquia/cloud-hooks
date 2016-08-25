#!/bin/sh
#
# Cloud Hook: post-code-deploy
#
# The post-code-deploy hook is run whenever you use the Workflow page to
# deploy new code to an environment, either via drag-drop or by selecting
# an existing branch or tag from the Code drop-down list. See
# ../README.md for details.
#
# Usage: email site target-env source-branch deployed-tag repo-url
#                         repo-type

# Enter the email(s) you want to send notifications to
MAILTO=address@example.com

site="$1"
target_env="$2"
source_branch="$3"
deployed_tag="$4"
repo_url="$5"
repo_type="$6"

if [ "$source_branch" != "$deployed_tag" ]; then
    MSG="$site.$target_env: Deployed branch $source_branch as $deployed_tag."
else
    MSG="$site.$target_env: Deployed $deployed_tag."
fi

echo "$MSG" | mail -s "$MSG" "$MAILTO"
