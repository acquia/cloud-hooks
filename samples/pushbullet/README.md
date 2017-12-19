# Pushbullet Notification

This cloud hook posts a notification to Pushbullet after a code deployment
has been performed on Acquia Cloud.

### Example Scenario

1. A new tag is deployed to the production environment.
2. A Pushbullet notification is posted and sent to your devices indicating that a tag has been deployed.

### Installation Steps

Installation Steps (assumes Pushbullet account and Acquia Cloud Hooks installed in repo):

* See the API documentation at https://docs.pushbullet.com/#push
* Visit https://www.pushbullet.com/#settings create an access token `AUTH_TOKEN`.
* Store the AUTH_TOKEN in `$HOME/pushbullet_settings` file on your Acquia Cloud Server (see pushbullet_settings file).
* Set the execution bit to on e.g. `chmod a+x pushbullet_settings` (On windows `git update-index --chmod=+x pushbullet_settings`)
* Add `pushbullet.sh` to dev, test, prod or common __post-code-deploy__ hook.
