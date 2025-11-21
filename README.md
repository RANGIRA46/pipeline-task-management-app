# DevOps Pipeline - Task Management Application

[![CI Pipeline](https://github.com/YOUR_USERNAME/pipeline-task-management-app/workflows/CI%20Pipeline/badge.svg)](https://github.com/YOUR_USERNAME/pipeline-task-management-app/actions)
[![CD Pipeline](https://github.com/YOUR_USERNAME/pipeline-task-management-app/workflows/CD%20Pipeline/badge.svg)](https://github.com/YOUR_USERNAME/pipeline-task-management-app/actions)
[![Security Scan](https://github.com/YOUR_USERNAME/pipeline-task-management-app/workflows/Security%20Scanning/badge.svg)](https://github.com/YOUR_USERNAME/pipeline-task-management-app/actions)

## 📋 Project Overview

A comprehensive DevOps implementation for a Task Management application, demonstrating end-to-end CI/CD pipeline, Infrastructure as Code, Configuration Management, and DevSecOps best practices.

**Application**: Simple task management system with CRUD operations for tasks
**Purpose**: Educational project for learning and implementing DevOps best practices

## 👥 Team Members

> **Note**: Replace with your actual team member information

- **[Name 1]** - DevOps Engineer (GitHub/CI/CD Lead) - [@github-username1]
- **[Name 2]** - Infrastructure Engineer (Terraform/Azure Lead) - [@github-username2]
- **[Name 3]** - Configuration Manager (Ansible Lead) - [@github-username3]
- **[Name 4]** - Security Engineer (DevSecOps Lead) - [@github-username4]

## 🏗️ Architecture

### Application Stack
- **Frontend**: React with Vite (TypeScript)
- **Backend**: Node.js/Express (TypeScript)
- **Database**: PostgreSQL 15
- **Container Runtime**: Docker & Docker Compose

### Infrastructure
- **Cloud Provider**: Microsoft Azure
- **IaC Tool**: Terraform with Terraform Cloud backend
- **Configuration Management**: Ansible
- **Container Registry**: Azure Container Registry (ACR)
- **Compute**: Azure Virtual Machine (Ubuntu 22.04 LTS)
- **Networking**: Azure Virtual Network, Network Security Groups

### CI/CD Pipeline
- **Source Control**: GitHub
- **CI/CD Platform**: GitHub Actions
- **Containerization**: Docker (multi-stage builds)
- **Orchestration**: Docker Compose

### DevSecOps Tools
- **SAST**: GitHub CodeQL
- **Dependency Scanning**: npm audit
- **Container Scanning**: Trivy
- **IaC Security**: tfsec, Checkov
- **Secret Scanning**: TruffleHog
- **DAST**: OWASP ZAP

## 📁 Repository Structure

```
pipeline-task-management-app/
├── .github/
│   ├── workflows/              # CI/CD pipeline definitions
│   │   ├── ci-pipeline.yml     # Continuous integration
│   │   ├── cd-pipeline.yml     # Continuous deployment
│   │   ├── terraform.yml       # Infrastructure pipeline
│   │   ├── security.yml        # Security scanning
│   │   └── dast.yml           # OWASP ZAP scanning
│   ├── ISSUE_TEMPLATE/         # Issue templates
│   ├── CODEOWNERS             # Code ownership definitions
│   └── pull_request_template.md
├── frontend/                   # React frontend application
│   ├── src/
│   ├── Dockerfile
│   ├── nginx.conf
│   └── package.json
├── backend/                    # Express backend API
│   ├── src/
│   ├── tests/
│   ├── Dockerfile
│   └── package.json
├── terraform/                  # Infrastructure as Code
│   ├── main.tf                # Main infrastructure resources
│   ├── variables.tf           # Variable definitions
│   ├── outputs.tf             # Output values
│   ├── backend.tf             # Terraform Cloud backend config
│   └── terraform.tfvars.example
├── ansible/                    # Configuration management
│   ├── playbooks/             # Ansible playbooks
│   ├── roles/                 # Reusable roles
│   │   ├── docker/           # Docker installation
│   │   ├── security/         # Security hardening
│   │   ├── monitoring/       # Monitoring setup
│   │   └── app-deploy/       # Application deployment
│   ├── inventory/             # Inventory files
│   └── ansible.cfg
├── security/                   # Security configurations
│   ├── security-policies.md   # Security policies
│   └── .trivyignore          # Trivy exceptions
├── docs/                       # Additional documentation
│   ├── ARCHITECTURE.md        # Architecture details
│   ├── DEPLOYMENT.md          # Deployment guide
│   └── SECURITY.md           # Security documentation
├── docker-compose.yml          # Local development environment
├── .dockerignore
├── .gitignore
└── README.md
```

## 🚀 Getting Started

### Prerequisites

Ensure you have the following installed:

- **Git**: Version control
- **Docker Desktop**: For containerization (version 20.10+)
- **Node.js**: For local development (version 18+)
- **Azure CLI**: For Azure operations
- **Terraform CLI**: For infrastructure management (version 1.5+)
- **Ansible**: For configuration management (version 2.14+)

### Azure & Terraform Cloud Setup

1. **Azure Account**: Create a free Azure student account
2. **Terraform Cloud**: Sign up at [app.terraform.io](https://app.terraform.io)
3. **Azure Service Principal**: Create credentials for Terraform

```bash
# Login to Azure
az login

# Create service principal
az ad sp create-for-rbac --name "devops-pipeline-sp" \
  --role="Contributor" \
  --scopes="/subscriptions/YOUR_SUBSCRIPTION_ID"
```

### Local Development Setup

1. **Clone the repository**:
```bash
git clone https://github.com/YOUR_USERNAME/pipeline-task-management-app.git
cd pipeline-task-management-app
```

2. **Start local development environment**:
```bash
# Start all services
docker-compose up --build

# Run in detached mode
docker-compose up -d
```

3. **Access the application**:
- **Frontend**: http://localhost
- **Backend API**: http://localhost:3000
- **API Health Check**: http://localhost:3000/health
- **API Documentation**: http://localhost:3000/api-docs

4. **View logs**:
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f backend
```

5. **Stop services**:
```bash
docker-compose down

# Stop and remove volumes
docker-compose down -v
```

## 🔧 Development Workflow

### Branching Strategy

We follow **Git Flow** branching model:

- **`main`**: Production-ready code (protected)
- **`develop`**: Integration branch for features (protected)
- **`feature/*`**: New features (branch from develop)
- **`bugfix/*`**: Bug fixes (branch from develop)
- **`hotfix/*`**: Emergency production fixes (branch from main)
- **`release/*`**: Release preparation (branch from develop)

### Creating a Feature

```bash
# Create feature branch
git checkout develop
git pull origin develop
git checkout -b feature/task-filtering

# Make changes, commit regularly
git add .
git commit -m "feat: add task filtering functionality"

# Push and create PR
git push origin feature/task-filtering
```

### Pull Request Process

1. **Create PR** from your feature branch to `develop`
2. **Fill out PR template** with all required information
3. **Ensure CI checks pass**:
   - ✅ Linting
   - ✅ Unit tests
   - ✅ Integration tests
   - ✅ Security scans
   - ✅ Docker build
4. **Request reviews** from at least 2 team members
5. **Address feedback** and resolve conversations
6. **Merge** after approval

## 🏭 CI/CD Pipelines

### CI Pipeline (Triggered on PR to develop/main)

1. **Linting**: ESLint for code quality
2. **Testing**: Unit and integration tests with coverage
3. **Security Scanning**: 
   - Trivy for filesystem vulnerabilities
   - npm audit for dependency vulnerabilities
   - CodeQL for code security issues
4. **Build Verification**: Docker image builds

### CD Pipeline (Triggered on push to main)

1. **Build & Push**: Docker images to Azure Container Registry
2. **Infrastructure**: Terraform provisions/updates Azure resources
3. **Configuration**: Ansible configures servers
4. **Deployment**: Application deployed to Azure VM
5. **Verification**: Smoke tests and health checks

### Infrastructure Pipeline (Triggered on terraform/ changes)

1. **Validation**: Terraform format and validation
2. **Security Scan**: tfsec and Checkov
3. **Plan**: Terraform plan review
4. **Apply**: Automated infrastructure provisioning (on main)

### Security Pipeline (Runs on schedule and PR)

1. **Dependency Scan**: Weekly npm audit
2. **SAST**: CodeQL analysis
3. **Secret Scan**: TruffleHog detection
4. **Container Scan**: Trivy vulnerability scanning
5. **IaC Security**: Terraform security checks
6. **DAST**: Weekly OWASP ZAP scans

## 📊 Monitoring & Operations

### Health Checks

- **Backend Health**: `GET /health`
- **Database Connection**: Verified in health endpoint
- **Container Status**: `docker ps`

### System Monitoring

```bash
# SSH into VM
ssh -i ~/.ssh/devops-pipeline azureuser@<VM_IP>

# Check system status
/usr/local/bin/system-status.sh

# Check Docker containers
docker ps
docker stats

# Check application logs
cd /opt/devops-app
docker-compose logs -f
```

### Common Operations

```bash
# View deployment logs
docker-compose -f /opt/devops-app/docker-compose.yml logs -f

# Restart application
docker-compose -f /opt/devops-app/docker-compose.yml restart

# Pull latest images
docker-compose -f /opt/devops-app/docker-compose.yml pull
docker-compose -f /opt/devops-app/docker-compose.yml up -d
```

## 🛡️ Security

### Security Policies

See [security/security-policies.md](security/security-policies.md) for comprehensive security policies.

### Key Security Features

- ✅ Branch protection with required reviews
- ✅ Automated security scanning in CI/CD
- ✅ Secret management with GitHub Secrets
- ✅ Container vulnerability scanning
- ✅ Infrastructure security validation
- ✅ UFW firewall configuration
- ✅ Fail2ban intrusion prevention
- ✅ Non-root container execution
- ✅ Automated security updates

### Reporting Security Issues

Please report security vulnerabilities to: **[security-email@example.com]**

## 🧪 Testing

### Backend Tests

```bash
cd backend
npm install
npm test              # Run all tests
npm run test:watch    # Watch mode
npm run test:coverage # With coverage report
```

### Frontend Tests

```bash
cd frontend
npm install
npm test              # Run all tests
npm run test:watch    # Watch mode
npm run test:coverage # With coverage report
```

### Integration Tests

Integration tests run automatically in the CI pipeline with a PostgreSQL service.

## 📦 Deployment

### Prerequisites for Deployment

- Azure subscription active
- Terraform Cloud workspace configured
- GitHub Secrets configured:
  - `TF_API_TOKEN`
  - `ARM_CLIENT_ID`
  - `ARM_CLIENT_SECRET`
  - `ARM_SUBSCRIPTION_ID`
  - `ARM_TENANT_ID`
  - `ACR_NAME`
  - `ACR_LOGIN_SERVER`
  - `ACR_USERNAME`
  - `ACR_PASSWORD`
  - `SSH_PRIVATE_KEY`
  - `VM_PUBLIC_IP`
  - `DB_USER`
  - `DB_PASSWORD`
  - `DB_NAME`

### Manual Deployment

```bash
# 1. Provision infrastructure
cd terraform
terraform init
terraform plan
terraform apply

# 2. Configure servers
cd ../ansible
ansible-playbook playbooks/setup-server.yml -i inventory/azure_rm.yml

# 3. Verify deployment
curl http://<VM_IP>/health
```

### Automated Deployment

Simply push to `main` branch:

```bash
git checkout main
git merge develop
git push origin main
```

The CD pipeline will automatically:
1. Build and push Docker images
2. Provision/update infrastructure
3. Configure servers
4. Deploy application
5. Run verification tests

## 🐛 Troubleshooting

### Local Development Issues

**Port already in use**:
```bash
# Find process using port 3000
lsof -i :3000
# Or on Windows
netstat -ano | findstr :3000

# Kill the process or change port in docker-compose.yml
```

**Database connection issues**:
```bash
# Ensure database container is healthy
docker-compose ps

# Check database logs
docker-compose logs database

# Restart database
docker-compose restart database
```

### Deployment Issues

**Terraform apply fails**:
- Check Azure credentials in Terraform Cloud
- Verify resource name uniqueness
- Check subscription quotas

**Ansible deployment fails**:
- Verify SSH key in GitHub Secrets
- Check VM firewall rules (NSG)
- Ensure ACR credentials are correct

**Application not accessible**:
- Verify containers are running: `docker ps`
- Check application logs: `docker-compose logs`
- Verify firewall rules allow traffic on ports 80, 443, 3000

## 📚 Documentation

- **[Architecture Documentation](docs/ARCHITECTURE.md)**: Detailed architecture diagrams and explanations
- **[Deployment Guide](docs/DEPLOYMENT.md)**: Step-by-step deployment instructions
- **[Security Documentation](docs/SECURITY.md)**: Security practices and policies
- **[API Documentation](docs/API.md)**: API endpoints and usage

## 🤝 Contributing

We welcome contributions! Please follow these guidelines:

1. **Fork the repository** and create a feature branch
2. **Follow code style** and linting rules
3. **Write tests** for new features
4. **Update documentation** as needed
5. **Create a pull request** with clear description
6. **Ensure all CI checks pass**
7. **Obtain required reviews**

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- ALU DevOps Course instructors and teaching assistants
- Open source communities for amazing tools
- Team members for collaboration and dedication

## 📞 Contact

- **Project Repository**: https://github.com/YOUR_USERNAME/pipeline-task-management-app
- **Issues**: Use GitHub Issues for bug reports and feature requests
- **Discussions**: Use GitHub Discussions for questions

---

**Last Updated**: November 2025
**Project Status**: 🚧 In Development
