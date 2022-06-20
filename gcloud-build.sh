# /bin/bash

gcloud builds submit --config cloudbuild.yaml --substitutions _SERVICE_NAME=inka-backoffice,_INSTANCE_NAME=inka-backoffice-prod,_REGION=us-central1,_SECRET_NAME=inka-backoffice-prod
