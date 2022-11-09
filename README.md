```shell
export GCP_REGION="europe-central2-c"
export GCP_CLUSTER="gcp-cluster"
export PROJECT_ID="trusty-acre-367607"
```

# Task 3. Deploy to Kubernetes
```shell
gcloud container clusters get-credentials $GCP_CLUSTER --region $GCP_REGION
kubectl create -f ./kuber/
```
