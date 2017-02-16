#!/bin/sh
#
# Cloud Hook: post-code-deploy
#
# The post-code-deploy hook is run whenever you use the Workflow page to
# deploy new code to an environment, either via drag-drop or by selecting
# an existing branch or tag from the Code drop-down list. See
# ../README.md for details.
#
# Usage: post-code-deploy site target-env source-branch deployed-tag repo-url
#                         repo-type

site="$1"
target_env="$2"
source_branch="$3"
deployed_tag="$4"
repo_url="$5"
repo_type="$6"

# Load the Pushbullet API URL (which is not stored in this repo).
. $HOME/pushbullet_settings

# Link to your enviorment
push_url="http://www.acquia.com/"

# Post deployment notice to Pushbullet
curl -k -u $AUTH_TOKEN: -X POST $PUSHBULLET_API_URL --header 'Content-Type: application/json' -d "{\"type\": \"link\", \"title\": \"$site.$target_env\", \"body\": \"Deployed $deployed_tag\", \"url\": \"$push_url\"}"
