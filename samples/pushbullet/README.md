# PushBullet Notification

This cloud hook posts a notification to a PushBullet after a code deployment
has been performed on Acquia Cloud.

### Example Scenario

1. A new tag is deployed to the production environment.
2. A PushBullet notification is posted and sent to your devices indicating that a tag has been deployed.

### Installation Steps

Installation Steps (assumes PushBullet account and Acquia Cloud Hooks installed in repo):

* See the API documentation at https://docs.pushbullet.com/#push
* Visit https://www.pushbullet.com/#settings create an access token `AUTH_TOKEN`.
* Store the AUTH_TOKEN in `$HOME/pushbullet_settings` file on your Acquia Cloud Server (see pushbullet_settings file).
* Set the execution bit to on e.g. `chmod a+x pushbullet_settings` (On windows `git update-index --chmod=+x pushbullet_settings`)
* Add `pushbullet.sh` to dev, test, prod or common __post-cody-deploy__ hook.
