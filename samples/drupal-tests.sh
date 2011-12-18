#!/bin/bash
#
# Cloud Hook: drupal-tests
#
# Run Drupal simpletests in the target environment.

site="$1"
target_env="$2"

# Select the tests to run. See Drupal's scripts/run-test.sh for options.
TESTS="--class DatabaseConnectionTestCase"
# Uncomment to run all tests.
# TESTS=--all

# Change this only if you need to use a settings.php other than sites/default.
URL=http://localhost/

# Uncomment to show verbose test output.
VERBOSE=--verbose

# Enable the simpletest module if it is not already enabled.
simpletest=`drush @$site.$target_env pm-info simpletest | perl -F'/[\s:]+/' -lane '/Status/ && print $F[2]'`
if [ "$simpletest" = "disabled" ]; then
    echo "Temporarily enabling simpletest module."
    drush @$site.$target_env pm-enable simpletest --yes
fi

# Run the tests.
cd /var/www/html/$site.$target_env/docroot
php ./scripts/run-tests.sh --url $URL $VERBOSE $TESTS

# If we enabled simpletest, disable it.
if [ "$simpletest" = "disabled" ]; then
    echo "Disabling simpletest module."
    drush @$site.$target_env pm-disable simpletest --yes
fi
