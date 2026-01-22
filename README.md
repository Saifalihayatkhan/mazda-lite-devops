🚗 Mazda-Lite: DevOps P&A Project
📖 Overview
Mazda-Lite is a microservices-based web application designed to replicate a real-world Parts & Accessories (P&A) ordering system.

This project was built from scratch to demonstrate a complete DevOps Lifecycle on the AWS Free Tier. It uses Infrastructure as Code (IaC) to provision servers, Docker for containerization, Kubernetes for orchestration, and GitOps (ArgoCD) for continuous deployment.

🏗️ Architecture
The project follows a modern 3-tier architecture deployed on a single AWS EC2 instance acting as a Kubernetes Cluster.

Frontend: A responsive Web UI (HTML5/Bootstrap/JS) serving the Dealer Portal.

Backend: A Python Flask API managing inventory data (Parts, Prices, Stock).

Infrastructure: AWS EC2 (t2.medium) provisioned via Terraform.

Orchestration: Lightweight Kubernetes (K3s) with Traefik Ingress.

Deployment: Fully automated GitOps pipeline using ArgoCD.

🛠️ Tech Stack
Component	      Technology	           Role
Cloud Provider	  AWS (EC2)	        Hosting the infrastructure
IaC	              Terraform	        Provisioning Security Groups, Keys, and Servers
Containerization  Docker	        Packaging the Python API and Nginx Frontend
Orchestration	  K3s (Kubernetes)  Managing Pods, Services, and Ingress
CICD / GitOps	  ArgoCD	        Syncing GitHub changes to the live cluster
Frontend	      HTML/JS/Bootstrap	Dealer Interface (v4 with Cart Modal)
Backend	          Python Flask	    REST API for Inventory Data


🚀 Project Journey (Step-by-Step)
Phase 1: Application Development
We built a decoupled application to mimic a production environment.

Backend: Created a Flask app serving JSON data at /api/parts.

Frontend: Created an Nginx web server serving a dynamic HTML page.

Dockerization: Wrote Dockerfiles for both services and pushed images to Docker Hub.

Repo: your-dockerhub-username/mazda-backend

Repo: your-dockerhub-username/mazda-frontend


Phase 2: Infrastructure as Code (Terraform)
Instead of clicking buttons in AWS, we wrote code to build the "Data Center."

Provider: AWS (us-east-1)

Resources Created:

aws_instance: Ubuntu 24.04 (t2.medium for performance).

aws_security_group: Opened Ports 22 (SSH), 80 (Web), and 30000-32767 (ArgoCD).

aws_key_pair: Automatically generated SSH keys (mazda-key.pem).

Command: terraform apply



Phase 3: Kubernetes Setup (K3s)
We transformed the raw Linux server into a Cluster.

SSH Access: Logged in using the Terraform-generated key.

K3s Installation: Installed lightweight Kubernetes (curl -sfL https://get.k3s.io | sh -).

Manifests: Created Kubernetes YAML files:

deployment.yaml (Defines Pods)

service.yaml (Networking)

ingress.yaml (Routing / to Frontend and /api to Backend).


Phase 4: GitOps with ArgoCD
We automated deployment so we never have to manually run kubectl apply.

Install: Deployed ArgoCD into the cluster.

Expose: Used NodePort to access the ArgoCD UI securely via HTTPS.

Sync: Connected ArgoCD to this GitHub repository.

Result: Any change pushed to GitHub is instantly deployed to the server.


Phase 5: Feature Rollouts (Real-world Simulation)
We simulated a real developer workflow:

v1: Basic Text UI.

v2: Connected Frontend to Backend API via Ingress.

v3: Added "Search Bar" and Styling (Bootstrap).

v4: Added "Shopping Cart" Modal (Logic & UI).

Process: Code Change -> Docker Build -> Git Push -> ArgoCD Auto-Sync.


💻 How to Recreate This Project
Prerequisites
AWS Account (IAM User with Admin access).

Terraform installed.

Docker Hub Account.

VS Code & Git.



1. Provision Infrastructure
Bash

cd infrastructure
terraform init
terraform apply -auto-approve


2. Configure Server
SSH into the new IP (found in terraform output):

Bash

ssh -i mazda-key.pem ubuntu@<SERVER_IP>


Install K3s & ArgoCD:

Bash

curl -sfL https://get.k3s.io | sh -
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml


3. Deploy App via ArgoCD
Login to ArgoCD UI.

Create New App -> Source: This Git Repo, Path: k8s.

Sync -> Watch the application launch!


📂 Folder Structure
Plaintext

mazda-lite-devops/
├── backend/                # Python Flask API
│   ├── app.py
│   └── Dockerfile
├── frontend/               # Nginx & HTML UI
│   ├── index.html
│   └── Dockerfile
├── infrastructure/         # Terraform Code
│   ├── main.tf
│   └── mazda-key.pem       # (Ignored by Git)
├── k8s/                    # Kubernetes Manifests
│   ├── backend.yaml
│   ├── frontend.yaml
│   └── ingress.yaml
└── README.md


⚠️ Cost Management
To avoid AWS charges, always destroy resources after testing:

Bash

cd infrastructure
terraform destroy -auto-approve
Project created by Saifali as part of a DevOps Masterclass simulation.