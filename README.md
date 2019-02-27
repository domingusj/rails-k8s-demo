# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

Cloud Build triggers
KMS keys (dev, stage, prod)
CloudSQL (stage, prod)
GCP service accounts (dev, stage, prod)
GKE clusters (dev, prod)
grant IAM perms for Cloud Build to GKE
enable CloudSQL API: https://console.developers.google.com/apis/api/sqladmin.googleapis.com/overview?project=domingusj-182921

kubectl apply -f helm-auth.yaml
helm init --service-account tiller


cert-maanger?
External-DNS

