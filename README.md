# README

This is a demo [Rails](https://rubyonrails.org/) application used to highlight some of the steps needed for local development, remote CI/CD with Google Cloud Build, and deploying different environments in Kubernetes.

## Local Development

`docker-compose up`

`docker-compose run app bin/rails db:migrate RAILS_ENV=development`

## Deployment

This app is setup to be deployed with [Cloud Build](https://cloud.google.com/cloud-build/docs/) and [Helm](https://helm.sh/) to [Google Kubernetes Engine (GKE)](https://cloud.google.com/kubernetes-engine/docs/).

The deployment steps are outlined in the files in the [deploy](deploy) folder.

### cloudbuild.yaml

Every commit pushed to GitHub will automatically kick off a build defined in `cloudbuild.yaml`. This builds a new container with the current code and publishes it to Google Container Registry.

### cloudbuild-deploy.yaml

Deployment is triggered by git tags, for example, either a `prod` or `stage` tag.

### cloudbuild-cache.yaml

This trigger runs on merges to the `master` branch and builds a new fresh cache of the image that will be used in future builds to speed up build time.

## Secrets

Secrets are encrypted with [sops](https://github.com/mozilla/sops) and [Google KMS](https://cloud.google.com/kms/docs/) in the repo. If a secret needs to be updated, you must use `sops` to edit the files. Even when just deleting a secret, use `sops` to remove it so that the fingerprint of the file is updated.

At deploy time, the secrets are decrypted in place with Cloud Build and applied with helm.

See the [cloudbuild-deploy.yaml](deploy/cloudbuild-deploy.yaml) file for details.

## Database

This application is configured to use a throwaway temporary database in staging and a hosted [Google CloudSQL](https://cloud.google.com/sql/docs/postgres/) in production. This is toggled using [Helm conditions](https://github.com/helm/helm/blob/master/docs/charts.md#tags-and-condition-fields-in-requirementsyaml).

## Database migrations

This app is configured to run `db:migrate` as a [Kubernetes Job](https://kubernetes.io/docs/concepts/workloads/controllers/jobs-run-to-completion/) and is managed with a [Helm hook](https://docs.helm.sh/developing_charts/#hooks). The annotations in [k8s/rails-k8s-demo/templates/db-migrate-job.yaml](k8s/rails-k8s-demo/templates/db-migrate-job.yaml) are intended to make sure that the job runs before the application version is upgraded in the Deployment, and once it finishes successfully the job is deleted in k8s.

If that step ever fails for any reason, the job will *not* be automatically deleted. *This means future deploys will fail*. The intention here is the job is left around in k8s so that a developer can go troubleshoot, look at the failed job, and resolve the issue. Once resolved, the job will need to be manually deleted, and future automatic deploys can proceed.

## GCP Setup

TODO: Automate this

- Create separate service accounts for the app for each environment
- Create GKE cluster(s)
- Grant Kubernetes Developer IAM permission for the Cloud Build service account
- [Enable the CloudSQL API](https://console.developers.google.com/apis/api/sqladmin.googleapis.com/overview)
- [Install helm](https://helm.sh/docs/using_helm/) in the cluster(s)

## TODO

- [ ] Use [GCP managed-certs](https://github.com/GoogleCloudPlatform/gke-managed-certs), or use [cert-manager](https://github.com/jetstack/cert-manager).
- [ ] Add [External-DNS](https://github.com/kubernetes-incubator/external-dns) to automate DNS records
