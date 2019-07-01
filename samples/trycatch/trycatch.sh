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

(
  set -ev
  ls
  # example of a failure:
  # cd blah
  ls
  set +v
)

retVal=$(($? + 0))
if [ $retVal -eq 0 ]; then
    echo "Cloudhook Completed Successfully"
else
    if [ "$source_branch" != "$deployed_tag" ]; then
        ERROR_MESSAGE="Acquia code deploy failed: **$site.$target_env** using branch **$source_branch** as **$deployed_tag**!"

    else
        ERROR_MESSAGE="Acquia code deploy failed: **$site.$target_env** using tag **$deployed_tag**!"
    fi

    echo "$ERROR_MESSAGE"
fi
