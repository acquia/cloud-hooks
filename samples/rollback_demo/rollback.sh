#!/bin/bash
#
# Cloud Hook: tests_rollback
#
# Run Drupal simpletests in the target environment using drush test-run. On failure,
# rollback to last deployed code set
#
# implements Cloud_hook post_code_deploy
# @todo needs to have pre_code_deploy for proper handling of files.
# 


site="$1"
target_env="$2"
sourcebranch=$3 # The code branch or tag being deployed. See below.
deployedtag=$4  # The code branch or tag being deployed. See below.
repourl=$5      # The URL of your code repository.
repotype=$6     # The version control system your site is uing; "git" or "svn".

#load variable settigns from $HOME/rollback_settings
. $PWD/rollback_settings

#initialize exit code so we can exit with 0 after rollback
extcode=0

# Enable the simpletest module if it is not already enabled.
simpletest=`drush @$site.$target_env pm-info simpletest | perl -F'/[\s:]+/' -lane '/Status/ && print $F[2]'`
if [ "$simpletest" = "disabled" ]; then
    echo "Temporarily enabling simpletest module."
    drush @$site.$target_env pm-enable simpletest --yes
fi

# Run the tests.
CMD=`drush @$site.$target_env test-run $TESTS`

#test output from drush 
if [ $? != 0 ]; then {

 #if simpletests fail tell the user and launch a new job rolling back to the original source 
 echo "Testing failed on deploy rolling back to $origsource"
 drush @$site.$target_env ah-deploy-code-path $origsource   

 #set exitcode to fail so this codebase does not deploy
 extcode=1

} else {
  
 #simpletests passed! Inform user then clear and set rollback_settings to new code base
 echo "Testing passed on deploy of $deployedtag"
 touch $PWD/rollback_settings
 echo  "origsource='$deployedtag'"> $PWD/rollback_settings
 echo  "TESTS='$TESTS'"> $PWD/rollback_settings

 extcode=0

} fi

# If we enabled simpletest, disable it.
if [ "$simpletest" = "disabled" ]; then
    echo "Disabling simpletest module."
    drush @$site.$target_env pm-disable simpletest --yes
fi

#cleanly exit  
exit $extcode






