.github/workflows/
├── terraform-plan-apply.yml
├── helm-deploy.yml

docs/
├── architecture-diagram.png  # placeholder diagram
└── usage-guide.md            # walkthrough instructions

---

### 📁 `.github/workflows/terraform-plan-apply.yml` — CI/CD for Terraform (EKS or AKS)

```yaml
name: Terraform Plan and Apply
# ... [unchanged content above]
```

This workflow supports:
- ✅ Deployment to both AWS and Azure based on `DEPLOY_TARGET` (`aws` or `azure`)
- 🔐 Secure use of GitHub Secrets for AWS and Azure credentials
- 🔄 Automates plan/apply on changes to `main` or PRs

> You can set the target in repo/environment secrets like:
> - `DEPLOY_TARGET=aws`
> - `DEPLOY_TARGET=azure`

---

### 📁 `.github/workflows/helm-deploy.yml` — Deploy FastAPI via Helm to EKS or AKS

```yaml
name: Helm Deploy to Kubernetes
# ... [unchanged content above]
```

This Helm deployment workflow will:
- Deploy the FastAPI app to either EKS or AKS
- Use GitHub secrets to pull the container image (`CONTAINER_IMAGE`)
- Automatically update the cluster and install/update the Helm chart

---

### 📁 `docs/architecture-diagram.png`

> 🧭 Placeholder: Add a visual diagram here showing:
> - Left: Developer (GitHub Push)
> - Middle: GitHub Actions CI/CD (Terraform → EKS/AKS → Helm)
> - Right: Kubernetes cluster (Pods, Service, Ingress)

---

### 📁 `docs/usage-guide.md`

```md
# Usage Guide: Multi-Cloud Kubernetes Platform

This guide explains how to provision infrastructure and deploy a FastAPI app using Terraform, Helm, and GitHub Actions on AWS (EKS) or Azure (AKS).

## 1️⃣ Set Deployment Target
Set this in your GitHub repo secrets:
- `DEPLOY_TARGET=aws` or `DEPLOY_TARGET=azure`

## 2️⃣ Define Secrets
Depending on your cloud provider, set these in GitHub:

### For AWS
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `CONTAINER_IMAGE=your-registry/fastapi-app`

### For Azure
- `AZURE_CREDENTIALS` (JSON string from `az ad sp create-for-rbac`)
- `CONTAINER_IMAGE=your-registry/fastapi-app`

## 3️⃣ Trigger Deployment
- Push to `main` or open PR — triggers Terraform plan/apply
- App changes also trigger Helm redeploy automatically

## 4️⃣ Access the App
Once deployed, access the app via Ingress:
```
http://<your-ingress-hostname>/hello
```

> 🔍 You can test the app with:
```bash
curl http://<host>/health
curl http://<host>/hello
```

## 5️⃣ Clean Up
```bash
cd terraform/aws && terraform destroy
# or
cd terraform/azure && terraform destroy
```

---

## 🚀 Local Deployment with Minikube (No Cloud Required)

### ✅ Prerequisites
Install:
- [Docker](https://docs.docker.com/get-docker/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Helm](https://helm.sh/docs/intro/install/)
- [Minikube](https://minikube.sigs.k8s.io/docs/start/)

### ▶️ Steps

```bash
minikube start --cpus=2 --memory=4g
cd app
docker build -t fastapi-app:local .
minikube image load fastapi-app:local
cd ..

# Update Helm chart to use local image
sed -i '' 's|repository: .*|repository: fastapi-app|' helm/microservice-chart/values.yaml
sed -i '' 's|tag: .*|tag: local|' helm/microservice-chart/values.yaml

# Deploy to local cluster
helm upgrade --install fastapi ./helm/microservice-chart

# Access the app
minikube service fastapi
```

### 🧪 Test it:
```bash
curl http://127.0.0.1:<port>/health
curl http://127.0.0.1:<port>/hello
```

Leave your terminal open while the Minikube tunnel is running.
```
