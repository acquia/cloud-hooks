#!/bin/sh
#
# db-copy Cloud hook: db-scrub
#
# Apply the SQL scrub script db-scrub.sql. To this use this hook
# script, be sure to put db-scrub.sql in the same directory.
#
# Usage: db-copy site target-env db-name source-env

site="$1"
target_env="$2"
db_name="$3"
source_env="$4"

scrub=/var/www/html/$site.$target_env/hooks/$target_env/db-scrub.sql
echo "$site.$target_env: Scrubbing database $db_name"
cat $scrub | drush @$site.$target_env ah-sql-cli --db=$db_name
