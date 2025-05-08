# GKE Deployment Sample

This project demonstrates a simple deployment of a containerized application to Google Kubernetes Engine (GKE) using an Autopilot cluster.

## Prerequisites

Before you begin, ensure you have the following installed and configured:

1. [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)
2. [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
3. A Google Cloud project with billing enabled
4. GKE API enabled in your project
5. Docker installed locally

## Project Structure

- `deploy.sh`: Deployment script
- `deployment.yaml`: Kubernetes deployment and service configuration
- `Dockerfile`: Container image definition

## Deployment Steps

The `deploy.sh` script automates the deployment process. Here's what each step does:

### 1. Configuration
The script sets up the following environment variables:
- `PROJECT_ID`: Your Google Cloud project ID
- `CLUSTER_NAME`: Name of your GKE Autopilot cluster
- `CLUSTER_REGION`: Region where your cluster is located

### 2. Docker Image Build
The script builds and pushes your Docker image to Google Container Registry (GCR):
```bash
gcloud builds submit --tag gcr.io/${PROJECT_ID}/hi-world:latest .
```
This step:
- Builds your Docker image using Cloud Build
- Pushes the image to GCR
- Tags it as 'latest'

### 3. GKE Authentication
The script authenticates kubectl with your GKE cluster:
```bash
gcloud container clusters get-credentials ${CLUSTER_NAME} --region ${CLUSTER_REGION} --project ${PROJECT_ID}
```
This step:
- Retrieves cluster credentials
- Configures kubectl to use these credentials
- Sets the current context to your cluster

### 4. Kubernetes Deployment
The script applies the Kubernetes configuration:
```bash
kubectl apply -f deployment.yaml
```
This step:
- Creates a Deployment with 1 replica
- Sets up a LoadBalancer service
- Configures resource limits and requests
- Exposes the application on port 80

### 5. Deployment Verification
The script waits for the deployment to be ready:
```bash
kubectl rollout status deployment/hi-world
```
This step:
- Monitors the deployment progress
- Ensures all pods are running successfully

### 6. Service Information
Finally, the script retrieves the external IP:
```bash
kubectl get service hi-world
```
This step:
- Displays the LoadBalancer's external IP
- Shows the service status

## Running the Deployment

1. Make the deployment script executable:
   ```bash
   chmod +x deploy.sh
   ```

2. Run the deployment script:
   ```bash
   ./deploy.sh
   ```

## Accessing the Application

Once the deployment is complete, you can access the application using the external IP address shown in the final step. The application will be available on port 80.

## Cleanup

To clean up the deployment, run:
```bash
kubectl delete -f deployment.yaml
```

## Troubleshooting

If you encounter any issues:

1. Check your Google Cloud project configuration
2. Verify that the GKE cluster is running
3. Ensure you have the necessary permissions
4. Check the deployment status with:
   ```bash
   kubectl get pods
   kubectl describe deployment hi-world
   ``` 