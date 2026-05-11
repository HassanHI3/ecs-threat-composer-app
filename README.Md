# ===================================================================
# 🚀 OVERVIEW
# ===================================================================

# This project demonstrates a fully automated, production-style,
# cloud-native deployment pipeline on AWS using:
#
# • Amazon ECS Fargate
# • Docker
# • Terraform
# • GitHub Actions
# • Amazon ECR
# • Application Load Balancer (ALB)
# • Cloudflare DNS
# • AWS ACM
# • CloudWatch Logging
#
# The application is containerised using a multi-stage Docker build
# and deployed to ECS Fargate behind an Application Load Balancer
# within a secure multi-AZ VPC architecture.
#
# Infrastructure provisioning is fully automated using Terraform,
# enabling Infrastructure as Code (IaC) for repeatable deployments.
#
# GitHub Actions automates the CI/CD pipeline by building Docker
# images, tagging them with the Git commit SHA, pushing them to ECR,
# and deploying them directly to ECS Fargate.
#
# ECS Fargate was chosen over EC2 to remove server management and
# allow AWS to handle scaling, provisioning, and infrastructure.


# ===================================================================
# 🌍 LIVE APPLICATION
# ===================================================================

https://tm.<your-domain>

# HTTPS health check endpoint

https://tm.<your-domain>/health


# ===================================================================
# 📸 LIVE APPLICATION SCREENSHOTS
# ===================================================================

# [ ADD LIVE WEBSITE SCREENSHOT HERE ]

# [ ADD HEALTH ENDPOINT SCREENSHOT HERE ]

# [ ADD ECS SERVICE RUNNING SCREENSHOT HERE ]


# ===================================================================
# 🏗️ ARCHITECTURE
# ===================================================================

# User
#   │
# Cloudflare DNS
#   │
# Route53
#   │
# Application Load Balancer (Public Subnets)
#   │
# ECS Fargate Tasks (Private Subnets)
#   │
# CloudWatch Logs
#
# GitHub
#   │
# GitHub Actions CI/CD
#   │
# Amazon ECR
#   │
# ECS Deployment


# ===================================================================
# 🖼️ ARCHITECTURE DIAGRAM
# ===================================================================

# [ ADD FINAL ARCHITECTURE DIAGRAM HERE ]

# [ OPTIONAL: ADD DRAW.IO / LUCIDCHART IMAGE ]


# ===================================================================
# ⚙️ FEATURES
# ===================================================================

# ✅ Multi-stage Docker containerisation
# ✅ ECS Fargate deployment
# ✅ Application Load Balancer
# ✅ Public/private subnet architecture
# ✅ Terraform Infrastructure as Code
# ✅ GitHub Actions CI/CD
# ✅ Cloudflare DNS integration
# ✅ HTTPS using AWS ACM
# ✅ CloudWatch logging and monitoring
# ✅ Remote Terraform state using S3 + DynamoDB
# ✅ Multi-AZ deployment architecture
# ✅ Git SHA image versioning
# ✅ OIDC GitHub authentication


# ===================================================================
# 🔄 CI/CD PIPELINES
# ===================================================================


# -------------------------------------------------------------------
# 🚀 BUILD & PUSH PIPELINE
# -------------------------------------------------------------------

# Responsibilities:
#
# • Build Docker image
# • Tag image using Git SHA
# • Push image to Amazon ECR

docker build -t threat-composer .

docker tag threat-composer:latest \
<ecr-repository>:<git-sha>

docker push <ecr-repository>:<git-sha>


# 📸 Pipeline Screenshot

# [ ADD BUILD PIPELINE SUCCESS SCREENSHOT HERE ]


# -------------------------------------------------------------------
# 🚀 DEPLOY PIPELINE
# -------------------------------------------------------------------

# Responsibilities:
#
# • Terraform init
# • Terraform plan
# • Terraform apply
# • ECS service update
# • Health check validation

curl https://tm.<your-domain>/health


# 📸 Pipeline Screenshot

# [ ADD DEPLOY PIPELINE SUCCESS SCREENSHOT HERE ]


# -------------------------------------------------------------------
# 💥 DESTROY PIPELINE
# -------------------------------------------------------------------

# Responsibilities:
#
# • Scale ECS services down safely
# • Destroy infrastructure
# • Clean AWS resources

terraform destroy


# 📸 Pipeline Screenshot

# [ ADD DESTROY PIPELINE SCREENSHOT HERE ]


# ===================================================================
# 📁 REPOSITORY STRUCTURE
# ===================================================================

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


# ===================================================================
# 🔄 HOW THE DEPLOYMENT WORKS
# ===================================================================

# 1. Developer pushes code to GitHub
# 2. GitHub Actions pipeline starts
# 3. Docker image is built
# 4. Image is tagged using Git SHA
# 5. Image is pushed to Amazon ECR
# 6. Terraform deploys infrastructure
# 7. ECS Fargate pulls latest image
# 8. ECS tasks run behind ALB
# 9. HTTPS traffic is routed securely
# 10. CloudWatch collects application logs


# ===================================================================
# 🐳 DOCKER CONTAINERISATION
# ===================================================================

# Build Docker image

docker build -t threat-composer-app .

# Run container locally

docker run -p 3000:3000 threat-composer-app

# Verify health endpoint

curl http://localhost:3000/health


# 📸 Docker Screenshots

# [ ADD DOCKER BUILD SCREENSHOT HERE ]

# [ ADD CONTAINER RUNNING SCREENSHOT HERE ]


# ===================================================================
# 💻 RUN APPLICATION LOCALLY
# ===================================================================


# Step 1 — Clone repository

git clone <your-repository-url>


# Step 2 — Navigate into application directory

cd app


# Step 3 — Install dependencies

npm install


# Step 4 — Start application

npm start


# Step 5 — Open application

http://localhost:3000


# ===================================================================
# ☁️ TERRAFORM INFRASTRUCTURE
# ===================================================================

# Resources provisioned:
#
# • VPC
# • Public Subnets
# • Private Subnets
# • Internet Gateway
# • NAT Gateways
# • Route Tables
# • Security Groups
# • ECS Cluster
# • ECS Services
# • ECS Task Definitions
# • Application Load Balancer
# • Target Groups
# • Route53 Records
# • ACM Certificates
# • CloudWatch Log Groups
# • IAM Roles & Policies
# • Amazon ECR Repository


# ===================================================================
# 📸 TERRAFORM SCREENSHOTS
# ===================================================================

# [ ADD TERRAFORM APPLY SCREENSHOT HERE ]

# [ ADD ECS CLUSTER SCREENSHOT HERE ]

# [ ADD ALB TARGET GROUP HEALTH SCREENSHOT HERE ]


# ===================================================================
# 🚢 ECS FARGATE
# ===================================================================

# ECS Fargate removes the need to manage EC2 instances.
#
# AWS automatically handles:
#
# • Scaling
# • Provisioning
# • Availability
# • Infrastructure maintenance
# • Server patching
#
# This allows the deployment to focus entirely on containers
# and application delivery.


# ===================================================================
# 🌐 NETWORKING ARCHITECTURE
# ===================================================================

# Public Subnets:
#
# • Application Load Balancer
# • NAT Gateways
#
# Private Subnets:
#
# • ECS Fargate Tasks
#
# ECS tasks are not publicly accessible directly.
# Traffic only enters through the Application Load Balancer.


# ===================================================================
# 🔐 SECURITY
# ===================================================================

# HTTPS:
#
# • AWS ACM certificates
# • HTTPS ALB listener
# • HTTP → HTTPS redirect
#
# IAM:
#
# • Least privilege access
# • GitHub OIDC authentication
# • No long-lived AWS credentials


# ===================================================================
# 📊 CLOUDWATCH LOGGING
# ===================================================================

# Application logs are sent to CloudWatch Logs for:
#
# • Monitoring
# • Debugging
# • Observability
# • ECS task visibility


# 📸 CloudWatch Screenshots

# [ ADD CLOUDWATCH LOGS SCREENSHOT HERE ]


# ===================================================================
# 🗃️ REMOTE TERRAFORM STATE
# ===================================================================

# Terraform state is stored using:
#
# • Amazon S3
# • DynamoDB state locking
#
# Benefits:
#
# • Shared team state
# • Prevents concurrent applies
# • Safer infrastructure management


# ===================================================================
# 🧰 REQUIREMENTS
# ===================================================================

# Local Tools:
#
# • Docker
# • Terraform
# • AWS CLI
# • Node.js
# • Git
#
# AWS Services:
#
# • ECS Fargate
# • ECR
# • ALB
# • Route53
# • ACM
# • CloudWatch
# • IAM
# • VPC


# ===================================================================
# 🚀 FUTURE IMPROVEMENTS
# ===================================================================

# • Blue/Green Deployments
# • ECS Auto Scaling
# • WAF Integration
# • Secrets Manager
# • Terragrunt
# • Canary Deployments
# • Slack Notifications
# • Trivy Vulnerability Scanning


# ===================================================================
# 🛠️ USEFUL COMMANDS
# ===================================================================


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


# ===================================================================
# 🔗 USEFUL LINKS
# ===================================================================

# Terraform AWS Provider
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs

# Amazon ECS Docs
# https://docs.aws.amazon.com/ecs/

# Docker Docs
# https://docs.docker.com/

# GitHub Actions Docs
# https://docs.github.com/en/actions


# ===================================================================
# 👨‍💻 AUTHOR
# ===================================================================

# Hassan Ibrahim
# Cloud / DevOps Engineer Journey ☁️🚀
