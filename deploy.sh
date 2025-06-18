#!/bin/bash

# Set variables
PROJECT_ID="sonic-platform-445411-a7"
ZONE="asia-southeast1-a"
INSTANCE_NAME="todo-app"

# Create firewall rules
gcloud compute firewall-rules create allow-http \
    --allow tcp:80 \
    --target-tags=http-server \
    --description="Allow HTTP traffic"

gcloud compute firewall-rules create allow-https \
    --allow tcp:443 \
    --target-tags=https-server \
    --description="Allow HTTPS traffic"

# Create VM instance with cloud-config
gcloud compute instances create $INSTANCE_NAME \
    --zone=$ZONE \
    --machine-type=e2-medium \
    --image-family=ubuntu-2004-lts \
    --image-project=ubuntu-os-cloud \
    --tags=http-server,https-server \
    --metadata-from-file=user-data=cloud-config.yaml

# Get the external IP
EXTERNAL_IP=$(gcloud compute instances describe $INSTANCE_NAME \
    --zone=$ZONE \
    --format='get(networkInterfaces[0].accessConfigs[0].natIP)')

echo "Instance created with external IP: $EXTERNAL_IP"
echo "Please wait a few minutes for the instance to initialize and the application to deploy." 