#!/bin/sh
#
# A sample cloud hook to run a Drush Cache Clear.
# 

# Map the script inputs to convient names.
site=$1                       # The site name. This is the same as the Acquia Cloud username for the site.
targetenv=$2                  # The environment to which code was just deployed.
sourcebranch=$3               # The code branch or tag being deployed.  
deployedtag=$4                # The code branch or tag being deployed. 
repourl=$5                    # The URL of your code repository.
repotype=$6                   # The version control system your site is using; "git" or "svn".
drushalias=$site'.'$targetenv # The drush alias for the site and environment. (This makes the assumption that the alias is always a combination of site name and environment.)

# Setup some environment variables that aren't available normally in CLI mode but could be used in settings files.
export AH_SITE_NAME=$drushalias
export AH_SITE_GROUP=$site
export AH_SITE_ENVIRONMENT=$targetenv

export AH_NON_PRODUCTION=1
if [ $targetenv = 'prod' ] 
  then
    export AH_NON_PRODUCTION=0
fi

# Execute a standard drush command.
/usr/local/bin/drush @$drushalias cc all

