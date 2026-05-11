# ECS Fargate End-to-End CI/CD Deployment Project (Threat Composer)

# =========================================================
# OVERVIEW
# =========================================================

# This project demonstrates a fully automated, cloud-native
# CI/CD deployment pipeline on AWS using:
#
# - Amazon ECS Fargate
# - Docker
# - Terraform
# - GitHub Actions
# - Amazon ECR
# - Application Load Balancer (ALB)
# - Cloudflare DNS
# - AWS ACM
# - CloudWatch
#
# The application is containerised using a production-style
# multi-stage Docker build and deployed to ECS Fargate
# behind an Application Load Balancer within a secure
# multi-AZ VPC architecture.
#
# Infrastructure provisioning is fully automated using
# Terraform, enabling Infrastructure as Code (IaC)
# for repeatable deployments.
#
# CI/CD automation is implemented using GitHub Actions,
# where Docker images are built, tagged using the Git
# commit SHA, pushed to Amazon ECR, and deployed to ECS.
#
# ECS Fargate was chosen over EC2 to remove server
# management responsibilities.

# =========================================================
# LIVE APPLICATION
# =========================================================

https://tm.<your-domain>

# =========================================================
# APPLICATION
# =========================================================

# Health endpoint

GET /health

# Example response

{
  "status": "ok"
}

# =========================================================
# ARCHITECTURE
# =========================================================

# User
#   |
# Cloudflare
#   |
# Route53
#   |
# Application Load Balancer
#   |
# ECS Fargate Tasks (Private Subnets)
#   |
# CloudWatch Logs
#
# GitHub
#   |
# GitHub Actions
#   |
# Amazon ECR
#   |
# ECS Deployment

# =========================================================
# FEATURES
# =========================================================

# - Multi-stage Docker containerisation
# - ECS Fargate deployment
# - Application Load Balancer
# - Public/private subnet architecture
# - Terraform Infrastructure as Code
# - CI/CD with GitHub Actions
# - Cloudflare DNS integration
# - HTTPS using ACM
# - CloudWatch logging and monitoring
# - Remote Terraform state using S3 + DynamoDB locking
# - Multi-AZ deployment architecture
# - Git SHA image versioning
# - OIDC GitHub authentication

# =========================================================
# CI/CD PIPELINES
# =========================================================

# ---------------------------
# BUILD & PUSH PIPELINE
# ---------------------------

# Responsibilities:
#
# - Build Docker image
# - Tag image using Git SHA
# - Push image to Amazon ECR

# Example

docker build -t threat-composer .

docker tag threat-composer:latest \
<ecr-repo>:<git-sha>

docker push <ecr-repo>:<git-sha>

# ---------------------------
# DEPLOY PIPELINE
# ---------------------------

# Responsibilities:
#
# - Terraform init
# - Terraform plan
# - Terraform apply
# - ECS service update
# - Post deployment health check

curl https://tm.<your-domain>/health

# ---------------------------
# DESTROY PIPELINE
# ---------------------------

# Responsibilities:
#
# - Scale ECS services down
# - Terraform destroy
# - Clean infrastructure removal

# =========================================================
# REPOSITORY STRUCTURE
# =========================================================

ecs-project/
│
├── app/
│
├── Dockerfile
├── .dockerignore
├── .gitignore
├── yarn.lock
│
├── infra/
│   ├── backend.tf
│   ├── main.tf
│   ├── outputs.tf
│   ├── terraform.tfvars
│   ├── variables.tf
│   │
│   └── modules/
│       ├── acm/
│       ├── alb/
│       ├── cloudflare/
│       ├── cloudflare_validation/
│       ├── ecr/
│       ├── ecs/
│       ├── iam/
│       └── vpc/
│
└── .github/
    └── workflows/
        ├── build.yml
        ├── deploy.yml
        └── destroy.yml

# =========================================================
# HOW IT WORKS
# =========================================================

# 1. Developer pushes code to GitHub
# 2. GitHub Actions pipeline starts
# 3. Docker image is built
# 4. Image is tagged using Git SHA
# 5. Image is pushed to Amazon ECR
# 6. Terraform deploys infrastructure
# 7. ECS Fargate pulls latest image
# 8. ECS tasks run behind ALB
# 9. HTTPS traffic is routed securely
# 10. CloudWatch collects logs

# =========================================================
# DOCKER CONTAINERISATION
# =========================================================

# Build Docker image

docker build -t threat-composer-app .

# Run container

docker run -p 3000:3000 threat-composer-app

# Verify health endpoint

curl http://localhost:3000/health

# =========================================================
# RUN APPLICATION LOCALLY
# =========================================================

# Clone repository

git clone <your-repository-url>

# Navigate into app directory

cd app

# Install dependencies

npm install

# Run application

npm start

# Open in browser

http://localhost:3000

# =========================================================
# TERRAFORM INFRASTRUCTURE
# =========================================================

# Resources created:
#
# - VPC
# - Public Subnets
# - Private Subnets
# - Internet Gateway
# - NAT Gateways
# - Route Tables
# - Security Groups
# - ECS Cluster
# - ECS Services
# - ECS Task Definitions
# - Application Load Balancer
# - Target Groups
# - Route53 Records
# - ACM Certificates
# - CloudWatch Log Groups
# - IAM Roles & Policies
# - Amazon ECR Repository

# =========================================================
# ECS FARGATE
# =========================================================

# ECS Fargate removes the need to manage EC2 instances.
#
# AWS automatically handles:
#
# - Scaling
# - Provisioning
# - Availability
# - Infrastructure maintenance
# - Server patching

# =========================================================
# NETWORKING ARCHITECTURE
# =========================================================

# Public Subnets:
#
# - Application Load Balancer
# - NAT Gateways
#
# Private Subnets:
#
# - ECS Fargate Tasks
#
# ECS tasks are not publicly accessible directly.
# Traffic only enters through the ALB.

# =========================================================
# SECURITY
# =========================================================

# HTTPS:
#
# - ACM certificates
# - HTTPS listeners
# - HTTP to HTTPS redirects
#
# IAM:
#
# - Least privilege access
# - GitHub OIDC authentication
# - No long-lived AWS credentials

# =========================================================
# CLOUDWATCH LOGGING
# =========================================================

# Application logs are sent to CloudWatch Logs
# for monitoring and debugging.

# =========================================================
# REMOTE TERRAFORM STATE
# =========================================================

# Terraform state stored using:
#
# - Amazon S3
# - DynamoDB state locking

# =========================================================
# REQUIREMENTS
# =========================================================

# Local tools:
#
# - Docker
# - Terraform
# - AWS CLI
# - Node.js
# - Git

# AWS Services:
#
# - ECS Fargate
# - ECR
# - ALB
# - Route53
# - ACM
# - CloudWatch
# - IAM
# - VPC

# =========================================================
# SCREENSHOTS
# =========================================================

# Recommended screenshots:
#
# - ECS Cluster Running
# - ECS Tasks Healthy
# - ALB Healthy Targets
# - Successful GitHub Actions Pipelines
# - Terraform Apply Output
# - Live HTTPS Website
# - CloudWatch Logs
# - Docker Container Running Locally

# =========================================================
# FUTURE IMPROVEMENTS
# =========================================================

# - Blue/Green Deployments
# - ECS Auto Scaling
# - WAF Integration
# - Secrets Manager
# - Terragrunt
# - Canary Deployments
# - Slack Notifications
# - Trivy Vulnerability Scanning

# =========================================================
# USEFUL COMMANDS
# =========================================================

# Terraform

terraform init

terraform plan

terraform apply

terraform destroy

# Docker

docker build -t threat-composer-app .

docker run -p 3000:3000 threat-composer-app

# ECS

aws ecs list-clusters

aws ecs list-services --cluster <cluster-name>

# =========================================================
# USEFUL LINKS
# =========================================================

# Terraform AWS Provider
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs

# Amazon ECS Docs
# https://docs.aws.amazon.com/ecs/

# Docker Docs
# https://docs.docker.com/

# GitHub Actions Docs
# https://docs.github.com/en/actions

# =========================================================
# AUTHOR
# =========================================================

# Hassan Ibrahim
# Cloud / DevOps Engineer Journey
