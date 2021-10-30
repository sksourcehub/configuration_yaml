# configuration_yaml

This repo is will help you create a kind cluster and run django application inside it with high availability postgresDB.

This repo also contains instruction to setup:
-  YAML configuration for kubernetes cluster
-  NFS server on ubuntu
-  Jenkins CI/CD pipeline

```
Note: The app is base on the Django==1.11 which doesn't support background task scheduling out of the box, for scheduling background task, This app is using celery with redis as a broker and the result is aved into the DB using Django_celery_results.
```
The app is also integrated with [crossbar](https://crossbar.io/), an open source networking platform for distributed and microservice applications)
