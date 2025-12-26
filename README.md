# Global Gaming League (GGL) — Terraform (Infra) + K8s Manifest

This repo contains the **Terraform** side for the "Global Gaming League" assignment:
- Modular **GKE (regional)** cluster spread across **two zones**
- **Workload Identity** enabled for Kubernetes pods
- **Remote state** (GCS backend) via a bootstrap folder
- Two CI/CD service accounts:
  - `arena-builder-sa` (Terraform apply/destroy)
  - `scoreboard-deployer-sa` (kubectl deploy only)
- **Workload Identity Federation (WIF)** objects for GitHub OIDC (so CI uses **no JSON keys**)
- Outputs needed for the deployment pipeline (cluster name/location + WI info)

> Today focus: Terraform. CI/CD workflow can be added after infra is validated.

---

## Prereqs (local / Cursor)
1. Install Google Cloud SDK (`gcloud`).
2. Login:
   ```bash
   gcloud auth login
   gcloud auth application-default login
   ```
3. Set your project + region:
   ```bash
   gcloud config set project <PROJECT_ID>
   gcloud config set compute/region us-central1
   ```
4. Enable required APIs:
   ```bash
   gcloud services enable      container.googleapis.com      compute.googleapis.com      iam.googleapis.com      iamcredentials.googleapis.com      cloudresourcemanager.googleapis.com      storage.googleapis.com      sts.googleapis.com
   ```

---

## Step 1 — Bootstrap the Terraform State Bucket (one-time)
Terraform can’t create its own backend bucket in the same state it stores, so we bootstrap it first.

```bash
cd terraform/backend
terraform init
terraform apply
```

This creates the GCS bucket for state. Note the bucket name output.

---

## Step 2 — Run the main Terraform (envs/prod)
```bash
cd ../envs/prod

# IMPORTANT: backend bucket is supplied at init-time
terraform init -backend-config="bucket=<STATE_BUCKET_NAME>"

terraform plan  -var="project_id=<PROJECT_ID>" -var="github_owner=<GITHUB_OWNER>" -var="github_repo=<GITHUB_REPO>"
terraform apply -var="project_id=<PROJECT_ID>" -var="github_owner=<GITHUB_OWNER>" -var="github_repo=<GITHUB_REPO>"
```

It will provision:
- VPC + subnet
- GKE regional cluster with `node_locations` in 2 zones
- Workload Identity enabled
- `arena-builder-sa` and `scoreboard-deployer-sa`
- WIF pool + provider for GitHub OIDC
- IAM bindings to allow GitHub repo to impersonate the SAs
- Namespace `scoreboard` and a RoleBinding granting deployer SA **edit** in that namespace

---

## Useful Outputs
After apply, Terraform prints:
- Cluster name / region
- Workload Identity pool
- Service account emails
- WIF provider resource name (for CI auth later)

---

## Cleanup
```bash
cd terraform/envs/prod
terraform destroy -var="project_id=<PROJECT_ID>" -var="github_owner=<GITHUB_OWNER>" -var="github_repo=<GITHUB_REPO>"
```

If you also want to remove the state bucket (careful!):
```bash
cd ../../backend
terraform destroy -var="project_id=<PROJECT_ID>"
```

---

## K8s manifest
`k8s/scoreboard.yaml` deploys `nginxdemos/hello:latest` and exposes it via a LoadBalancer Service.
