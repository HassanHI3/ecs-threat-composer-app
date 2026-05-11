cat > README.md << 'EOF'
# ECS Threat Composer App

This project is a cloud-native web application with a fully automated CI/CD pipeline on AWS, built to demonstrate production-grade deployment practices.

The application is containerised using a multi-stage Docker build and runs on AWS ECS Fargate behind an Application Load Balancer, within a dual-stack (IPv4/IPv6) multi-AZ VPC architecture with segregated public and private subnets across `eu-west-2a` and `eu-west-2b`. Fargate was chosen over EC2 to remove the operational overhead of managing servers, with AWS handling provisioning, scaling, and patching of the underlying infrastructure.

Infrastructure is provisioned entirely through Terraform using a modular structure, with remote state stored in S3 using native S3 state locking. TLS certificates are issued and validated automatically via AWS Certificate Manager, with DNS managed through Cloudflare. CI/CD is implemented in GitHub Actions using OIDC for AWS authentication, eliminating the need for long-lived access credentials.

## Architecture

- Custom VPC with public and private subnets across two AZs (`eu-west-2a`, `eu-west-2b`)
- Dual-stack networking (IPv4 + IPv6)
- Internet Gateway for public subnet egress
- Egress-only Internet Gateway for IPv6 private subnet egress
- NAT Gateways (one per AZ) for IPv4 private subnet egress
- Application Load Balancer in public subnets handling HTTP → HTTPS redirect
- ECS Fargate tasks running in private subnets for security
- ACM certificate managed via Terraform for HTTPS
- Cloudflare DNS records for the app hostname and ACM validation
- ECR repository with vulnerability scanning enabled
- CloudWatch Logs for ECS task logging (30-day retention)
- Auto-scaling based on CPU utilisation (2–4 tasks, 70% target)

## Features

- Multi-stage Docker containerisation with non-root user
- ECS Fargate deployment with rolling updates and deployment circuit breaker (auto-rollback)
- Application Load Balancer with HTTP → HTTPS redirect
- TLS 1.3 enforced via `ELBSecurityPolicy-TLS13-1-2-2021-06`
- Public and private subnet architecture (multi-AZ, dual-stack)
- Terraform Infrastructure as Code with modular structure
- Remote state in S3 with native state locking (`use_lockfile = true`)
- CI/CD with GitHub Actions using OIDC (no static AWS keys)
- ACM certificate created and DNS-validated automatically via Cloudflare
- CloudWatch logging with 30-day retention
- Container Insights enabled on the ECS cluster
- Auto-scaling on CPU target tracking (70% threshold, 2–4 tasks)
- ECR image scanning on push
- Security groups follow least-privilege (ALB → ECS tasks only on app port 3003)

## CI/CD Pipelines

### Build & Push Pipeline (`ci.yaml`)
- Triggered on push to `main` or manually via `workflow_dispatch`
- Builds Docker image
- Tags image with Git SHA and `latest`
- Authenticates to AWS via OIDC
- Pushes image to Amazon ECR

### Terraform Deploy Pipeline (`terraform.yaml`)
- Triggered on changes to `infra/**` or manually
- Runs `terraform fmt`, `validate`, `plan`, then `apply`
- Provisions/updates all AWS infrastructure
- Uses GitHub Secrets for sensitive variables (role ARNs, registry, Cloudflare zone ID)

### ECS Deployment Pipeline (`cd.yaml`)
- Triggered after CI workflow completes successfully
- Renders new ECS task definition with the SHA-tagged image
- Deploys to ECS service with `wait-for-service-stability`
- Runs post-deploy health check against `https://tm.threatmodapp.com/health`

### Terraform Destroy Pipeline (`terraform-destroy.yaml`)
- Manual trigger only via `workflow_dispatch`
- Requires explicit confirmation input
- Safely tears down all infrastructure

## Repository Structure

\`\`\`
ecs-threat-composer-app/
│
├── app/                            # Application source code
│   ├── Dockerfile
│   ├── .dockerignore
│   └── ...
│
├── infra/                          # Terraform configuration
│   ├── main.tf                     # Root module calls
│   ├── variables.tf                # Root variables
│   ├── outputs.tf                  # Root outputs
│   ├── provider.tf                 # AWS + Cloudflare providers, S3 backend
│   ├── dev.tfvars                  # Non-sensitive environment config
│   ├── .aws/
│   │   └── task-definition.json    # ECS task definition template
│   └── modules/
│       ├── vpc/                    # VPC, subnets, IGW, NAT, route tables
│       ├── alb/                    # Load balancer, listeners, target group
│       ├── ecr/                    # Container registry
│       ├── ecs/                    # Cluster, service, task def, autoscaling
│       └── acm/                    # SSL certificate + Cloudflare DNS validation
│
├── .github/
│   └── workflows/
│       ├── ci.yaml                 # Build & push Docker image
│       ├── cd.yaml                 # Deploy to ECS
│       ├── terraform.yaml          # Terraform apply
│       └── terraform-destroy.yaml  # Terraform destroy (manual)
│
├── .gitignore
└── README.md
\`\`\`

## How It Works

1. Developer pushes code to the GitHub `main` branch
2. CI workflow runs: builds Docker image, tags with Git SHA, pushes to ECR
3. ECS deployment workflow triggers on CI success: renders task definition with the new image and deploys to ECS
4. ECS performs a rolling update with deployment circuit breaker (auto-rollback on failure)
5. Health check against `https://tm.threatmodapp.com/health` validates the deployment
6. Terraform workflow runs separately when `infra/**` changes: applies infrastructure updates

**Traffic flow:**
\`\`\`
User → Cloudflare DNS → HTTPS:443 → ALB (TLS termination)
        ↓ HTTP forward to ECS task on port 3003
        ↓ Private subnet → NAT Gateway → Internet (if needed)
\`\`\`

## Running Locally

### Prerequisites
- Docker installed
- Git

### Steps

1. Clone the repository:
   \`\`\`bash
   git clone https://github.com/HassanHI3/ecs-threat-composer-app.git
   cd ecs-threat-composer-app
   \`\`\`

2. Build the Docker image:
   \`\`\`bash
   docker build -t threatmod ./app
   \`\`\`

3. Run the container locally:
   \`\`\`bash
   docker run -p 3003:3003 threatmod
   \`\`\`

4. Test the health endpoint:
   \`\`\`bash
   curl http://localhost:3003/health
   # {"status":"ok"}
   \`\`\`

5. Open in browser: `http://localhost:3003`

## Reproducing the Infrastructure

### Prerequisites
- AWS account with appropriate permissions
- Terraform installed (>= 1.5)
- A domain with DNS managed via Cloudflare
- Cloudflare API token with DNS edit permissions for the zone

### Steps

1. **Configure backend bucket:** Create an S3 bucket for Terraform state (or reuse one) and update `infra/provider.tf`.

2. **Set up GitHub Secrets:**
   - `CICD_ECS_ROLE` — ARN of the IAM role for OIDC
   - `ECR_REGISTRY` — `<account-id>.dkr.ecr.<region>.amazonaws.com`
   - `TASK_ROLE_ARN` — ECS task role ARN
   - `EXECUTION_ROLE_ARN` — ECS execution role ARN
   - `CLOUDFLARE_API_TOKEN` — Cloudflare API token
   - `CLOUDFLARE_ZONE_ID` — Cloudflare zone ID for the domain

3. **Initialise and apply Terraform:**
   \`\`\`bash
   cd infra
   terraform init
   terraform plan -var-file="dev.tfvars"
   terraform apply -var-file="dev.tfvars"
   \`\`\`

4. **Verify deployment:**
   \`\`\`bash
   curl https://tm.threatmodapp.com/health
   \`\`\`

## Tearing Down

To destroy all infrastructure via GitHub Actions:
1. Go to **GitHub Actions → Terraform Destroy**
2. Click **Run workflow**
3. Type `destroy-dev` in the confirmation field
4. Click **Run workflow**

Or locally:
\`\`\`bash
cd infra
terraform destroy -var-file="dev.tfvars"
\`\`\`

## Tech Stack

| Layer            | Technology                                          |
|------------------|-----------------------------------------------------|
| Container        | Docker (multi-stage build)                          |
| Compute          | AWS ECS Fargate                                     |
| Load Balancing   | AWS Application Load Balancer                       |
| Networking       | AWS VPC (multi-AZ, dual-stack, public + private)    |
| DNS              | Cloudflare                                          |
| SSL/TLS          | AWS Certificate Manager (DNS validation)            |
| Registry         | AWS Elastic Container Registry                      |
| Logging          | AWS CloudWatch Logs                                 |
| IaC              | Terraform (modular, S3 backend, native locking)     |
| CI/CD            | GitHub Actions (OIDC auth)                          |
| Region           | `eu-west-2` (London)                                |

## Security Highlights

- ECS tasks run in private subnets — not directly internet-accessible
- HTTP traffic forcibly redirected to HTTPS via 301
- TLS 1.3 enforced via `ELBSecurityPolicy-TLS13-1-2-2021-06`
- No static AWS credentials anywhere — OIDC used for CI/CD authentication
- IAM permissions scoped to required actions only
- Secrets managed via GitHub Secrets, never committed to the repo
- ECR image scanning on push to detect vulnerabilities
- Container runs as a non-root user
- Security groups follow least-privilege (ALB → ECS tasks only on app port 3003)

## Author

Hassan Ibrahim
EOF
