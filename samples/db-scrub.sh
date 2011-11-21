#!/bin/sh
#
# db-copy Cloud hook: db-scrub
#
# Scrub important information from a Drupal database.
#
# Usage: db-copy site target-env db-name source-env

site="$1"
target_env="$2"
db_name="$3"
source_env="$4"

echo "$site.$target_env: Scrubbing database $db_name"

(cat <<EOF
-- 
-- Scrub important information from a Drupal database.
-- 

-- Remove all email addresses.
UPDATE users SET mail=CONCAT('user', uid, '@example.com') WHERE uid != 0;

-- Example: Disable a module by setting its system.status value to 0.
-- UPDATE system SET status = 0 WHERE name = 'securepages';

-- Example: Update or delete variables via the variable table.
-- DELETE FROM variable WHERE name='secret_key';
-- UPDATE variable SET url='http://test.gateway.com/' WHERE name='payment_gateway';

-- IMPORTANT: If you change the variable table, clear the variables cache.
-- DELETE FROM cache WHERE cid = 'variables';

EOF
) | drush @$site.$target_env ah-sql-cli --db=$db_name
