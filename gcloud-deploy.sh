# /bin/bash

gcloud run deploy inka-backoffice \
     --platform managed \
     --region us-central1 \
     --image gcr.io/inka-backoffice/inka-backoffice
