# Email Notification

This cloud hook sends an email after a code deployment has been performed on
Acquia Cloud.

### Example Scenario

1. A new tag or branch is deployed to the production environment.
2. An email is sent indicating that the code has been deployed.

### Installation Steps

* Define the email(s) you want to send to in MAILTO variable in `email.sh`.
* Add `email.sh` (but _not_ README.md) to the dev, test, prod or common
 __post-code-deploy__ hook folder.
