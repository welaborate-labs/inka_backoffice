# /bin/bash

gcloud run deploy inka-backoffice \
     --platform managed \
     --region us-central1 \
     --image gcr.io/inka-backoffice/inka-backoffice \
     --add-cloudsql-instances inka-backoffice:us-central1:inka-backoffice-prod \
     --allow-unauthenticated
