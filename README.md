# GKE Scoreboard Infrastructure

This repository contains the infrastructure and deployment setup for the **Scoreboard** application running on Google Kubernetes Engine (GKE).

The project demonstrates a complete, reproducible GCP + Kubernetes setup using Terraform and GitHub Actions, including workload identity, CI/CD-based deployment, and high availability across zones.

---

## Overview

The infrastructure provisions:

- A custom VPC with a regional subnet
- A regional GKE cluster
- A managed node pool spread across multiple zones
- Kubernetes namespace and RBAC for deployment
- GitHub Actions authentication using GCP Workload Identity (no static secrets)

Application deployment is handled through CI/CD and runs inside the cluster as a standard Kubernetes Deployment.

---

## High Availability

The cluster is configured with nodes in **multiple zones** within the same region.  
The application runs with **multiple replicas**, and Kubernetes scheduling ensures replicas are placed on different nodes and zones when available.

This allows the application to remain available in case of:
- Node failure
- Zone-level issues

---

## Authentication & Security

- GitHub Actions authenticates to GCP using **Workload Identity Federation**
- No long-lived service account keys are stored in the repository
- GCP IAM permissions are scoped per service account
- Kubernetes access is restricted via RBAC

---

## Infrastructure as Code

All infrastructure is defined using Terraform and can be created or destroyed without manual steps.

The project is split into:
- A bootstrap phase (IAM, identity, backend)
- A deployment phase (GKE, networking, Kubernetes resources)

State is stored remotely in a GCS backend.

---

## Validation

After deployment, the following confirms correct behavior:

- GKE nodes exist in multiple zones
- Application replicas are running on different nodes
- Deployment reaches a healthy rollout state

Example checks:
```bash
kubectl get nodes -L topology.kubernetes.io/zone
kubectl get pods -n scoreboard -o wide
kubectl rollout status deployment/scoreboard -n scoreboard
