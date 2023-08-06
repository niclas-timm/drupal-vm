# VM

## What's inside

This is a small repo to help you bootstrap a dockerized Drupal environment. There is no magic to it, it's just a starting point that glues together all the moving parts in a Drupal environment. It comes with:

- An Apache webserver with PHP 8.1
- A MySQL database
- Redis
- Mailhog for email testing
- Apache Solr for enhanced search functionality
- XDebug
- Helper scripts to facilitate execiting commands (e.g., Drush) inside your containers.

## How this repo should be used

This repo is meant to be installed into an existing Drupal project. So the best way for you to work with it is to download it and paste it into the root directory of your project.
From there on, you can tweak the VM towards your needs (e.g. use another PHP version).

## Requirements

- You must have Docker installed on your machine
- You must have an existing Drupal project you can paste the VM into. The VM has been tested with V9, but it should also work with V8 and V10.
- If you want to customize the VM to your needs, you should have some (basic) Docker knowledge.

## Getting started

### Setup

There are a few helper scripts that make it easy for you to get started. To utilize them, make them executable by
running the following commands (from the root directory of your project):

```bash
chmod +x ./vm
chmod + x ./docker/build
chmod + x ./docker/start
chmod + x ./docker/stop
chmod + x ./docker/import-db
```

Next, make sure that your environment variables for the database and cache look like this:

```shell
# Database connection.
MYSQL_HOSTNAME=database
MYSQL_DATABASE=drupal9
MYSQL_PORT=3306
MYSQL_USER=root
MYSQL_PASSWORD=drupal9

# Redis
REDIS_HOST=cache
REDIS_PORT=6379
```

### First build

We're now ready to build the docker image for our project for the first time. Again from the root directory, execute
this:

```shell
./docker/build
```

You're now seeing a bunch of log outputs from the containers that are being started. Make sure to watch out for errors.

### Run in background

White it's nice to see the log outputs in the foreground on the first build, you probably will get annoyed by them soon
and want the containers to run in the backgorund. To do this, terminate the running command by hitting `control+c`.
Then, run:

```shell
./docker/start
```

### Database import

Our application is up and running. But it's not very useful without data. Luckily, we have a small script that helps you
import a new database. From the root directory, execute:

```shell
./docker/import-db <RELATIVE_PATH_TO_YOUR_DUMP>
```

For example:

```shell
./docker/import-db ./dumps/backup-64c30c97.sql
```

After that, you probably want to do the "business as usual" cleanups, like updating the database and importing the
config. Lear how to do that in the next section.

## Executing commands inside the container

Our Drupal application now runs inside docker. This means it is isolated from the rest of our local machine, and we must
ssh into the drupal container in order to execute drush commands (or any other cli command).
To facilitate this, there is a small script called `vm` at the root of our application. Its very simple, but abstracts
away some of the boilerplate syntax you would normally have to write everytime. Just execute `./vm <YOUR_COMMAND>` to
execute any command inside the docker container. For example:

```shell
./vm drush status;

./vm drush updb;

./vm drush cim -y;

./vm drush sqlc;

./vm composer update;

./vm composer outdated;
```
