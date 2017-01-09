# Slack Notification

This cloud hook posts a notification to Slack chat room after a code deployment
has been performed on Acquia Cloud.

### Example Scenario

1. A new tag is deployed to the production environment.
2. A slack notification is posted indicating that a tag has been deployed.

### Installation Steps

Installation Steps (assumes Slack subscription setup and Acquia Cloud Hooks installed in repo):

* See the API documentation at https://api.slack.com/ to set up an Incoming Webhook.
* Store the webhook URL in `$HOME/slack_settings` file on your Acquia Cloud Server (see slack_settings file).
* Add `slack.sh` to dev, test, prod or common __post-code-deploy__ and __post-code-update__ hooks.


