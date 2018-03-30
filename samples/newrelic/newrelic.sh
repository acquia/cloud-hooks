#!/bin/sh
#
# This sample a Cloud Hook script to update New Relic whenever there is a new code deployment 

site=$1         # The site name. This is the same as the Acquia Cloud username for the site.
targetenv=$2    # The environment to which code was just deployed.
sourcebranch=$3 # The code branch or tag being deployed.  
deployedtag=$4  # The code branch or tag being deployed. 
repourl=$5      # The URL of your code repository.
repotype=$6     # The version control system your site is using; "git" or "svn".


#Load the New Relic APPID and APPKEY variables.
. $HOME/newrelic_settings

#https://docs.newrelic.com/docs/apm/new-relic-apm/maintenance/recording-deployments#post-deployment
curl -X POST "https://api.newrelic.com/v2/applications/$APPID/deployments.json" \
     -H "X-Api-Key:$APIKEY" -i \
     -H "Content-Type: application/json" \
     -d \
"{
  \"deployment\": {
    \"revision\": \"$deployedtag\",
    \"changelog\": \"$deployedtag deployed to $site.$targetenv\",
    \"description\": \"$deployedtag deployed to $site.$targetenv\",
    \"user\": \"$username\"
  }
}"
