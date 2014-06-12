#Example of Acquia Cloud Hook to notify Slack of deployments

Installation Steps (assumes Slack subscription setup and Acquia Cloud Hooks installed in repo):

* Login to Slack and click the "Integrations" link in the header
* Follow the instructions and make note of "Your Unique Webhook URL." Store this URL in $HOME/slack_settings file on your Acquia Cloud Server (see example file).
* Set the execution bit to on i.e. chmod a+x slack_settings
* Add slack.sh to dev, test, prod or common post-cody-deploy hook.

