#!/bin/bash

# Configuration
export PROJECT_ID="cubz-sample-project-gcp"
export CLUSTER_NAME="autopilot-cluster-1"
export CLUSTER_REGION="asia-southeast1"

# Build the Docker image using Cloud Build
echo "Building Docker image..."
gcloud builds submit --tag gcr.io/${PROJECT_ID}/hi-world:latest .

# Get GKE credentials
echo "Getting GKE credentials..."
gcloud container clusters get-credentials ${CLUSTER_NAME} --region ${CLUSTER_REGION} --project ${PROJECT_ID}

# Deploy to GKE
echo "Deploying to GKE..."
kubectl apply -f deployment.yaml

# Wait for deployment to be ready
echo "Waiting for deployment to be ready..."
kubectl rollout status deployment/hi-world

# Get the external IP
echo "Getting external IP..."
kubectl get service hi-world 