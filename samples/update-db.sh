#!/bin/sh
#
# Cloud Hook: update-db
#
# Run drush updatedb in the target environment. This script works as
# any Cloud hook.

site="$1"
target_env="$2"

# Do not proceed on the RA environment 
if [ "$target_env" == "ra" ]; then 
exit 
fi

drush @$site.$target_env updatedb --yes
