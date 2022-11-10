```shell
EXPORT GCP_ARTIFACT_LOCATION="europe-central2"
export GCP_REGION="europe-central2-c"
export GCP_CLUSTER="gcp-cluster"
export PROJECT_ID="trusty-acre-367607"
```

# Task 1. Build docker image
```shell
docker build -t gcp:0.1 .
docker tag gcp:0.1 ${GCP_ARTIFACT_LOCATION}-docker.pkg.dev/${PROJECT_ID}/gcp-final-task/gcp:0.1
docker push ${GCP_ARTIFACT_LOCATION}-docker.pkg.dev/${PROJECT_ID}/gcp-final-task/gcp:0.1
```

# Task 3. Deploy to Kubernetes
Deploy:
```shell
gcloud container clusters get-credentials ${GCP_CLUSTER} --region ${GCP_REGION}
kubectl create -f ./kuber/
```
Update the image:
```shell
kubectl edit pod gcp-final-task
```

# Task 7. Apply migration
```shell
alembic upgrade head
```

# Block diagram
```mermaid
C4Context
      title Block diagram for the application
      Boundary(b0, "") {

        Person(customerA, "Regular user")

        Boundary(b1, "Google Cloud", "") {

          Boundary(b2, "Managed instance of Kubernetes", "Kubernetes") {
            System(SystemA, "Ingress", "External Load Balancer with static IP")
            System(SystemB, "Service", "A service that exposes the pod with the application")
            Boundary(b3, "Deployed application with Cloud SQL proxy", "pod") {
              Container(SystemF, "Instance of the application")
              Container(SystemG, "Cloud SQL Proxy")
            }
          }
          SystemDb(SystemE, "Cloud SQL", "Managed PostgresQL instance that stores all data for the application")
        }
       
      }

      Rel(customerA, SystemA, "")
      BiRel(SystemA, SystemB, "")
      Rel(SystemB, SystemF, "")
      BiRel(SystemF, SystemG, "")
      BiRel(SystemG, SystemE, "")


      UpdateLayoutConfig($c4ShapeInRow="3", $c4BoundaryInRow="1")
```

# Automatic deployment flow
```mermaid
sequenceDiagram
autonumber
    actor Developer
    Developer->>GitHub: Commits and push new changes
    GitHub->>CloudBuild: Triggers new build
    CloudBuild->>CloudBuild: Build an image
    CloudBuild->>CloudBuild: Test the image
    CloudBuild->>Kubernetes: Update the image for deployment
    CloudBuild->>CloudBuild: Build an migrator image
    CloudBuild->>Cloud SQL: Apply migrations
```

# CI/CD pipeline
```mermaid
flowchart TB

A[Build docker image] --> B[Run tests on built image]
B --> C[Push built image to Google Artifact Registry]
C --> D[Deploy updated image on Kubernetes cluster for deployment]
D --> E[Build migrator docker image]
E --> F[Run database migration]
```
