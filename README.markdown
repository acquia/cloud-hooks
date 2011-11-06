# Automating tasks with Cloud Hooks

## What are Cloud Hooks?

The Acquia Cloud Workflow page automates the most common tasks involved in developing a Drupal site: deploying code from a version control system and migrating code, databases, and files across your Development, Staging, and Production environments. Cloud Hooks allow you to automate other tasks as part of these migrations.

A Cloud Hook is simply a script in your code repository that Acquia Cloud executes on your behalf when a triggering action occurs. Examples of tasks that you can automate with Cloud Hooks include:

* Perform Drupal database updates each time new code is deployed.
* “Scrub” your production database each time it is copied to Dev or Staging by removing customer emails or disabling production-only modules.
* Run your test suite or a site performance test each time new code is deployed.

## Installing Cloud Hooks

Cloud hooks live in your Acquia Cloud code repository. In each branch of your repo, there is a directory named docroot that contains your site's source code. Cloud hooks live in the directory hooks NEXT TO docroot (not inside of docroot).

To install the directory structure and sample hook scripts, copy this repo into your Acquia Cloud repo. If you are using Git:

    cd /my/repo
    curl -o hooks.tar.gz      https://github.com/acquia/cloud-hooks/tarball/master
    tar xzf acquia-cloud-hooks.tar.gz
    mv acquia-cloud-hooks-* hooks
    git add hooks
    git commit -m 'Import Cloud hooks directory and sample scripts.'

## Quick Start

To get an idea of the power of Cloud Hooks, let's run the "Hello, Cloud!" script when new code is deployed in your production environment.

1. Install the hello-world.sh script to run on code deployments to Dev.
```
    cp hooks/samples/hello-world.sh hooks/dev/code-deploy
    git commit -a 'Run the hello-world script on code-deploy to Dev.'
```
2. Visit the Workflow page in the Acquia Cloud UI. Drag code from your Prod environment to Dev (you can switch Dev back to whatever it is running easily). 
3. Scroll down on the Workflow page. When the code deployment task is done, click its "Show" link to see the hook's output.

Ta-da!

## The Cloud Hooks directory

The hooks directory in your repo has a directory structure like this:

    /hooks / <env> / <hook> / <script>

* <env> is a directory whose name is an environment name: 'dev' for Development, 'test' for Staging, and 'prod' for Production. 

* <hook> is a directory whose name is a Cloud Hook name: see below for supported hooks.

* <script> is a program or shell script within the <env>/<hook> directory.

Each time a hookable action occurs, Acquia Cloud runs scripts in the directory for the target environment and specific hook name. All scripts in the hook directory are run, in lexicographical (shell glob) order. If one of the hook scripts exits with non-zero status, the remaining hook scripts are skipped, and the task is marked "failed" on the Workflow page so you know to check it. All stdout and stderr output from all the hooks that ran are displayed in the task log on the Workflow page.

## Sample scripts

The samples directory contains bare-bones example scripts for each of the supported hooks, plus a variety of useful user-contributed scripts. Each script starts with comments explaining what it is for and how it works.

## Supported hooks

This section defines the currently supported Cloud Hooks and the command-line arguments they receive.

### code-deploy

The code-deploy hook is run whenever you use the Workflow page to deploy new code to environment, either via drag-drop or by selecting an existing branch or tag from the Code drop-down list.

Usage: code-deploy site target-env source-branch deployed-tag repo-url repo-type

* site: The site name. This is the same as the Acquia Cloud username for the site.
* target-env: The environment to which code was just deployed.
* source-branch: The code branch or tag being deployed. See below.
* deployed-tag: The code branch or tag being deployed. See below.
* repo-url: The URL of your code repository.
* repo-type: The version control system your site is uing; "git" or "svn".

The meaning of source-branch and deployed-tag depends on whether you use drag-drop to move code from one environment to another or whether you select a new branch or tag for an environment from the Code drop-down list:

* With drag-drop, the "source branch" is the branch or tag that the environment you dragged from is set to, and the "deployed tag" is the  tag just deployed in the target environment. If source-branch is a branch (does not start with "tags/"), deployed-tag will be a newly created tag pointing at the tip of source-branch. If source-branch is a tag, deployed-tag will be the same tag.

* With the Code drop-down list, source-branch and deployed-tag will both be the name of branch or tag selected from the drop-down list.

Example: If the Dev environment is deploying the master branch and you drag Dev code to Stage, the code-deploy arguments will be like:

    code-deploy mysite test master tags/2011-11-05 mysite@svn-3.devcloud.hosting.acquia.com:mysite.git git

### db-copy

The db-copy hook is run whenever you use the Workflow page to copy a database from one environment to another.

Usage: db-copy site target-env db-name source-env

* site: The site name. This is the same as the Acquia Cloud username for the site.
* target-env: The environment to which the database was copied.
* db-name: The name of the database that was copied. See below.
* source-env: The environment from which the database was copied.

db-name is not the actual MySQL database name but rather the common name for the database in all environments. Use the drush ah-sql-cli  to connect to the actual MySQL database, or use th drush ah-sql-connect command to convert the site name and target environment into the specific MySQL database name and credentials. (The drush sql-cli and sql-connect commands work too, but only if your Drupal installation is set up correctly.)

Example: You can "scrub" your production database every time it is copied into your Stage environment by putting this script into /hooks/test/db-copy/delete-users.sh:

    #!/bin/bash
    site=$1
    env=$2
    db=$3
    echo "DELETE FROM users" | drush @$site.$env ah-sql-cli --db=$db

### files-copy

The files-copy hook is run whenever you use the Workflow page to copy the user-uploaded files directory from one environment to another.

Usage: files-copy site target-env source-env

* site: The site name. This is the same as the Acquia Cloud username for the site.
* target-env: The environment to which files were copied.
* source-env: The environment from which the files were copied.

Example: When you use the Workflow page to drag files from Prod to Dev, the files-copy hook will be run like:

    files-copy mysite prod dev
