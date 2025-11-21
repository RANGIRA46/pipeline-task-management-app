# Guided Learning Activity: End-to-End DevOps Pipeline Implementation

## Overview

This comprehensive lab activity guides your group through implementing a complete DevOps pipeline for a fullstack application. You will apply DevOps best practices, implement CI/CD, manage infrastructure as code, automate configuration management, and integrate security throughout the development lifecycle.

## Group Configuration

- Group Size: 4 students
- Recommended Role Distribution:
  - DevOps Engineer (GitHub/CI/CD Lead)
  - Infrastructure Engineer (Terraform/Azure Lead)
  - Configuration Manager (Ansible Lead)
  - Security Engineer (DevSecOps Lead)

Note: All team members should participate in all aspects but can specialize in their assigned areas.

## Learning Objectives

By completing this activity, you will be able to:

1. Configure and enforce DevOps best practices using GitHub features
2. Design and implement automated CI/CD pipelines with GitHub Actions
3. Provision cloud infrastructure using Terraform and Azure
4. Automate server configuration using Ansible
5. Containerize applications using Docker
6. Integrate security scanning and testing throughout the pipeline
7. Deploy applications to cloud infrastructure through automated pipelines
8. Collaborate effectively using project management tools

## Prerequisites

### Technical Requirements
- GitHub account (all team members)
- Azure account with subscription (free student account acceptable)
- Terraform Cloud account (free tier)
- Local development environment with:
  - Git
  - Docker Desktop
  - Terraform CLI
  - Ansible
  - Your chosen tech stack tools

### Knowledge Prerequisites
- Basic Git and GitHub usage
- Understanding of web application architecture
- Familiarity with YAML syntax
- Basic command-line proficiency
- Understanding of containerization concepts

## Project Selection Guidelines

Choose a simple fullstack application with the following characteristics:

### Acceptable Project Types
- Task management application
- Blog or content management system
- E-commerce product catalog
- Social media feed
- Inventory management system
- Recipe or cookbook application

### Technical Requirements
- Frontend: Any modern framework (React, Vue, Angular, vanilla JS)
- Backend: REST API (Node.js/Express, Python/Flask, C#/ASP.NET Core, etc.)
- Database: PostgreSQL, MySQL, or MongoDB
- Must be containerizable
- Should have testable endpoints

### Scope Limitations
- Keep functionality simple (3-5 core features)
- You may use AI code generation tools for application code
- Focus is on DevOps implementation, not complex application logic
- Authentication can be basic or simulated

## Lab Structure

### Phase 1: Project Setup and DevOps Foundation

#### Part A: Repository and Project Configuration

**Step 1: Create GitHub Repository**

1. Designate one team member to create the main repository
2. Repository name format: `devops-pipeline-[project-name]`
3. Initialize with:
   - README.md with project description
   - .gitignore for your tech stack
   - MIT or Apache 2.0 license

**Step 2: Configure Branch Protection Rules**

Navigate to Settings > Branches > Add rule and configure:

1. Branch name pattern: `main`
2. Required settings:
   - Require a pull request before merging
   - Require approvals: 1
   - Dismiss stale pull request approvals when new commits are pushed
   - Require review from Code Owners
   - Require status checks to pass before merging
   - Require branches to be up to date before merging
   - Require conversation resolution before merging
   - Do not allow bypassing the above settings

3. Additional branch patterns to protect:
   - `develop` (same rules as main)
   - `release/*` (same rules as main)

**Step 3: Create CODEOWNERS File**

Create `.github/CODEOWNERS`:

```
# Default owners for everything in the repo
* @team-member1 @team-member2

# Infrastructure code
/terraform/ @infrastructure-engineer
/ansible/ @configuration-manager

# CI/CD pipelines
/.github/workflows/ @devops-engineer

# Security configurations
/security/ @security-engineer
```

**Step 4: Configure Issue Templates**

Create `.github/ISSUE_TEMPLATE/bug_report.md`:

```markdown
---
name: Bug Report
about: Report a bug in the application or pipeline
title: '[BUG] '
labels: bug
assignees: ''
---

## Description
A clear description of the bug.

## Steps to Reproduce
1. Step one
2. Step two
3. Step three

## Expected Behavior
What should happen.

## Actual Behavior
What actually happens.

## Environment
- Branch:
- Commit SHA:
- Environment: (development/staging/production)

## Screenshots
If applicable, add screenshots.

## Additional Context
Any other relevant information.
```

Create `.github/ISSUE_TEMPLATE/feature_request.md`:

```markdown
---
name: Feature Request
about: Suggest a new feature or improvement
title: '[FEATURE] '
labels: enhancement
assignees: ''
---

## Feature Description
Clear description of the proposed feature.

## Problem It Solves
What problem does this address?

## Proposed Solution
How should this be implemented?

## Alternatives Considered
Other approaches you've considered.

## DevOps Impact
How will this affect the pipeline or infrastructure?
```

Create `.github/ISSUE_TEMPLATE/devops_task.md`:

```markdown
---
name: DevOps Task
about: Track infrastructure, pipeline, or configuration tasks
title: '[DEVOPS] '
labels: devops
assignees: ''
---

## Task Description
What needs to be done?

## Component
- [ ] CI/CD Pipeline
- [ ] Infrastructure
- [ ] Configuration Management
- [ ] Security
- [ ] Documentation

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Dependencies
List any dependencies or blockers.

## Estimated Effort
Small / Medium / Large
```

**Step 5: Set Up GitHub Projects**

1. Create a new Project (Projects tab > New project)
2. Choose "Board" view
3. Name it: `DevOps Pipeline Implementation`
4. Create columns:
   - Backlog
   - Ready
   - In Progress
   - In Review
   - Done

5. Configure automation:
   - Auto-add new issues to Backlog
   - Move to "In Progress" when assigned
   - Move to "In Review" when PR is opened
   - Move to "Done" when PR is merged

6. Create initial issues for all lab phases using templates

**Step 6: Establish Branching Strategy**

Document your Git workflow in README.md:

```markdown
## Branching Strategy

- `main`: Production-ready code, protected
- `develop`: Integration branch for features
- `feature/*`: New features (branch from develop)
- `bugfix/*`: Bug fixes (branch from develop)
- `hotfix/*`: Emergency fixes (branch from main)
- `release/*`: Release preparation (branch from develop)

## Workflow
1. Create feature branch from develop
2. Develop and commit changes
3. Push branch and create Pull Request to develop
4. Pass all CI checks
5. Obtain 2 peer reviews
6. Merge to develop
7. Periodically merge develop to main through release branch
```

#### Part B: Application Development Setup

**Step 7: Project Structure**

Create the following directory structure:

```
project-root/
├── .github/
│   ├── workflows/
│   ├── ISSUE_TEMPLATE/
│   └── CODEOWNERS
├── frontend/
│   ├── src/
│   ├── Dockerfile
│   ├── .eslintrc.json
│   └── package.json
├── backend/
│   ├── src/
│   ├── tests/
│   ├── Dockerfile
│   └── requirements.txt (or equivalent)
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── terraform.tfvars.example
├── ansible/
│   ├── playbooks/
│   ├── roles/
│   └── inventory/
├── security/
│   ├── .trivyignore
│   └── security-policies.md
├── docker-compose.yml
├── .dockerignore
├── .gitignore
└── README.md
```

**Step 8: Develop Basic Application**

Implement a minimal viable version of your chosen application:

1. Create frontend with at least:
   - Home page
   - List view
   - Create/Edit form
   - Basic styling

2. Create backend with at least:
   - GET endpoint (list all)
   - GET endpoint (single item)
   - POST endpoint (create)
   - PUT endpoint (update)
   - DELETE endpoint (delete)
   - Health check endpoint

3. Set up database connection
4. Create at least 5 unit tests for backend
5. Create at least 3 integration tests

Note: You may use AI tools to generate boilerplate code, but ensure you understand what the code does.

### Phase 2: Containerization and Local Development

#### Part A: Docker Configuration

**Step 9: Create Backend Dockerfile**

Example for Node.js/Express (adapt for your stack):

```dockerfile
# backend/Dockerfile
FROM node:18-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

COPY . .

FROM node:18-alpine

WORKDIR /app

RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

COPY --from=builder --chown=nodejs:nodejs /app/node_modules ./node_modules
COPY --chown=nodejs:nodejs . .

USER nodejs

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node healthcheck.js

CMD ["node", "src/server.js"]
```

**Step 10: Create Frontend Dockerfile**

Example for React (adapt for your stack):

```dockerfile
# frontend/Dockerfile
FROM node:18-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

FROM nginx:alpine

COPY --from=builder /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=3s \
  CMD wget --quiet --tries=1 --spider http://localhost:80 || exit 1

CMD ["nginx", "-g", "daemon off;"]
```

**Step 11: Create docker-compose.yml**

```yaml
version: '3.8'

services:
  database:
    image: postgres:15-alpine
    environment:
      POSTGRES_USER: ${DB_USER:-devops}
      POSTGRES_PASSWORD: ${DB_PASSWORD:-devops123}
      POSTGRES_DB: ${DB_NAME:-devops_app}
    volumes:
      - postgres_data:/var/lib/postgresql/data
    networks:
      - app-network
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U devops"]
      interval: 10s
      timeout: 5s
      retries: 5

  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    environment:
      DATABASE_URL: postgresql://${DB_USER:-devops}:${DB_PASSWORD:-devops123}@database:5432/${DB_NAME:-devops_app}
      NODE_ENV: development
    ports:
      - "3000:3000"
    depends_on:
      database:
        condition: service_healthy
    networks:
      - app-network
    volumes:
      - ./backend:/app
      - /app/node_modules

  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    ports:
      - "80:80"
    depends_on:
      - backend
    networks:
      - app-network

volumes:
  postgres_data:

networks:
  app-network:
    driver: bridge
```

**Step 12: Create .dockerignore**

```
# .dockerignore
node_modules
npm-debug.log
.git
.gitignore
README.md
.env
.DS_Store
coverage
.vscode
.idea
*.md
```

**Step 13: Test Local Development Environment**

```bash
# Build and start services
docker-compose up --build

# Verify all services are healthy
docker-compose ps

# Test backend health endpoint
curl http://localhost:3000/health

# Access frontend
# Open browser to http://localhost

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

### Phase 3: CI/CD Pipeline - Part 1

#### Part A: Linting Configuration

**Step 14: Configure Backend Linting**

For Node.js, create `backend/.eslintrc.json`:

```json
{
  "env": {
    "node": true,
    "es2021": true,
    "jest": true
  },
  "extends": [
    "eslint:recommended"
  ],
  "parserOptions": {
    "ecmaVersion": 12
  },
  "rules": {
    "indent": ["error", 2],
    "linebreak-style": ["error", "unix"],
    "quotes": ["error", "single"],
    "semi": ["error", "always"],
    "no-unused-vars": ["error", { "argsIgnorePattern": "^_" }],
    "no-console": "warn"
  }
}
```

Add to `backend/package.json`:

```json
{
  "scripts": {
    "lint": "eslint .",
    "lint:fix": "eslint . --fix"
  }
}
```

For frontend, create similar ESLint configuration appropriate to your framework.

**Step 15: Configure Security Scanning**

Create `security/.trivyignore`:

```
# Add CVEs to ignore with justification
# CVE-YYYY-XXXXX: Justification for ignoring
```

#### Part B: Initial CI Pipeline

**Step 16: Create Lint and Test Workflow**

Create `.github/workflows/ci-pipeline.yml`:

```yaml
name: CI Pipeline

on:
  pull_request:
    branches: [develop, main]
  push:
    branches: [develop, main]

env:
  NODE_VERSION: '18'

jobs:
  lint-backend:
    name: Lint Backend Code
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'
          cache-dependency-path: backend/package-lock.json

      - name: Install dependencies
        working-directory: ./backend
        run: npm ci

      - name: Run ESLint
        working-directory: ./backend
        run: npm run lint

  lint-frontend:
    name: Lint Frontend Code
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'
          cache-dependency-path: frontend/package-lock.json

      - name: Install dependencies
        working-directory: ./frontend
        run: npm ci

      - name: Run ESLint
        working-directory: ./frontend
        run: npm run lint

  test-backend:
    name: Test Backend
    runs-on: ubuntu-latest
    needs: lint-backend
    
    services:
      postgres:
        image: postgres:15-alpine
        env:
          POSTGRES_USER: test
          POSTGRES_PASSWORD: test
          POSTGRES_DB: test_db
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 5432:5432

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'
          cache-dependency-path: backend/package-lock.json

      - name: Install dependencies
        working-directory: ./backend
        run: npm ci

      - name: Run tests
        working-directory: ./backend
        env:
          DATABASE_URL: postgresql://test:test@localhost:5432/test_db
          NODE_ENV: test
        run: npm test

      - name: Upload coverage reports
        uses: codecov/codecov-action@v3
        with:
          files: ./backend/coverage/lcov.info
          flags: backend
          name: backend-coverage

  test-frontend:
    name: Test Frontend
    runs-on: ubuntu-latest
    needs: lint-frontend
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'
          cache-dependency-path: frontend/package-lock.json

      - name: Install dependencies
        working-directory: ./frontend
        run: npm ci

      - name: Run tests
        working-directory: ./frontend
        run: npm test -- --coverage

      - name: Upload coverage reports
        uses: codecov/codecov-action@v3
        with:
          files: ./frontend/coverage/lcov.info
          flags: frontend
          name: frontend-coverage

  security-scan:
    name: Security Scanning
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Run Trivy vulnerability scanner
        uses: aquasecurity/trivy-action@master
        with:
          scan-type: 'fs'
          scan-ref: '.'
          format: 'sarif'
          output: 'trivy-results.sarif'
          severity: 'CRITICAL,HIGH'

      - name: Upload Trivy results to GitHub Security
        uses: github/codeql-action/upload-sarif@v2
        if: always()
        with:
          sarif_file: 'trivy-results.sarif'

      - name: Dependency Check
        working-directory: ./backend
        run: |
          npm audit --audit-level=moderate

  build-test:
    name: Test Docker Build
    runs-on: ubuntu-latest
    needs: [test-backend, test-frontend]
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Build backend image
        uses: docker/build-push-action@v5
        with:
          context: ./backend
          push: false
          tags: devops-backend:test
          cache-from: type=gha
          cache-to: type=gha,mode=max

      - name: Build frontend image
        uses: docker/build-push-action@v5
        with:
          context: ./frontend
          push: false
          tags: devops-frontend:test
          cache-from: type=gha
          cache-to: type=gha,mode=max
```

**Step 17: Test CI Pipeline**

1. Create a feature branch
2. Make a small change
3. Push and create pull request
4. Verify all CI checks pass
5. Request reviews from 2 team members
6. Merge after approval

### Phase 4: Infrastructure as Code with Terraform

#### Part A: Terraform Configuration for Azure

**Step 18: Set Up Terraform Cloud**

1. Create account at app.terraform.io
2. Create new organization
3. Create workspace: `devops-pipeline-infrastructure`
4. Choose "CLI-driven workflow"
5. Configure workspace variables (mark sensitive as needed):
   - `ARM_CLIENT_ID`: Azure service principal client ID
   - `ARM_CLIENT_SECRET`: Azure service principal secret (sensitive)
   - `ARM_SUBSCRIPTION_ID`: Azure subscription ID
   - `ARM_TENANT_ID`: Azure tenant ID

**Step 19: Create Azure Service Principal**

```bash
# Login to Azure
az login

# Create service principal
az ad sp create-for-rbac --name "devops-pipeline-sp" --role="Contributor" --scopes="/subscriptions/YOUR_SUBSCRIPTION_ID"

# Save the output:
# {
#   "appId": "YOUR_CLIENT_ID",
#   "displayName": "devops-pipeline-sp",
#   "password": "YOUR_CLIENT_SECRET",
#   "tenant": "YOUR_TENANT_ID"
# }
```

**Step 20: Create Terraform Backend Configuration**

Create `terraform/backend.tf`:

```hcl
terraform {
  required_version = ">= 1.5.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }

  cloud {
    organization = "your-org-name"
    
    workspaces {
      name = "devops-pipeline-infrastructure"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}
```

**Step 21: Create Main Infrastructure Configuration**

Create `terraform/main.tf`:

```hcl
# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "${var.project_name}-${var.environment}-rg"
  location = var.location

  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}

# Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = "${var.project_name}-${var.environment}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = azurerm_resource_group.main.tags
}

# Subnet for VMs
resource "azurerm_subnet" "vm_subnet" {
  name                 = "vm-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Network Security Group
resource "azurerm_network_security_group" "main" {
  name                = "${var.project_name}-${var.environment}-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-HTTPS"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-App"
    priority                   = 130
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3000"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = azurerm_resource_group.main.tags
}

# Associate NSG with Subnet
resource "azurerm_subnet_network_security_group_association" "main" {
  subnet_id                 = azurerm_subnet.vm_subnet.id
  network_security_group_id = azurerm_network_security_group.main.id
}

# Public IP for VM
resource "azurerm_public_ip" "main" {
  name                = "${var.project_name}-${var.environment}-pip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = azurerm_resource_group.main.tags
}

# Network Interface
resource "azurerm_network_interface" "main" {
  name                = "${var.project_name}-${var.environment}-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vm_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }

  tags = azurerm_resource_group.main.tags
}

# SSH Key
resource "azurerm_ssh_public_key" "main" {
  name                = "${var.project_name}-${var.environment}-sshkey"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  public_key          = var.ssh_public_key
}

# Virtual Machine
resource "azurerm_linux_virtual_machine" "main" {
  name                = "${var.project_name}-${var.environment}-vm"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  size                = var.vm_size
  admin_username      = var.admin_username

  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = azurerm_ssh_public_key.main.public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 30
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = azurerm_resource_group.main.tags
}

# Container Registry
resource "azurerm_container_registry" "main" {
  name                = "${var.project_name}${var.environment}acr"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Basic"
  admin_enabled       = true

  tags = azurerm_resource_group.main.tags
}

# Role assignment for VM to pull from ACR
resource "azurerm_role_assignment" "acr_pull" {
  scope                = azurerm_container_registry.main.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_linux_virtual_machine.main.identity[0].principal_id
}
```

**Step 22: Create Variables Configuration**

Create `terraform/variables.tf`:

```hcl
variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "devopspipeline"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "East US"
}

variable "vm_size" {
  description = "Size of the virtual machine"
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key" {
  description = "SSH public key for VM access"
  type        = string
  sensitive   = true
}
```

Create `terraform/outputs.tf`:

```hcl
output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "vm_public_ip" {
  description = "Public IP address of the VM"
  value       = azurerm_public_ip.main.ip_address
}

output "vm_name" {
  description = "Name of the virtual machine"
  value       = azurerm_linux_virtual_machine.main.name
}

output "acr_login_server" {
  description = "Login server for the container registry"
  value       = azurerm_container_registry.main.login_server
}

output "acr_name" {
  description = "Name of the container registry"
  value       = azurerm_container_registry.main.name
}

output "acr_admin_username" {
  description = "Admin username for ACR"
  value       = azurerm_container_registry.main.admin_username
  sensitive   = true
}

output "acr_admin_password" {
  description = "Admin password for ACR"
  value       = azurerm_container_registry.main.admin_password
  sensitive   = true
}
```

**Step 23: Initialize and Apply Terraform**

```bash
# Navigate to terraform directory
cd terraform

# Generate SSH key pair
ssh-keygen -t rsa -b 4096 -f ~/.ssh/devops-pipeline -N ""

# Login to Terraform Cloud
terraform login

# Initialize Terraform
terraform init

# Set variables in Terraform Cloud workspace or create terraform.tfvars
# In Terraform Cloud, set ssh_public_key variable with content of:
cat ~/.ssh/devops-pipeline.pub

# Validate configuration
terraform validate

# Plan infrastructure
terraform plan

# Apply infrastructure
terraform apply

# Save outputs
terraform output -json > ../terraform-outputs.json
```

### Phase 5: Ansible Configuration Management

#### Part A: Ansible Setup

**Step 24: Create Ansible Directory Structure**

```bash
mkdir -p ansible/{playbooks,roles,inventory}
```

**Step 25: Create Ansible Configuration**

Create `ansible/ansible.cfg`:

```ini
[defaults]
inventory = inventory/hosts
host_key_checking = False
retry_files_enabled = False
roles_path = roles
gathering = smart
fact_caching = jsonfile
fact_caching_connection = /tmp/ansible_facts
fact_caching_timeout = 3600

[privilege_escalation]
become = True
become_method = sudo
become_user = root
become_ask_pass = False

[ssh_connection]
pipelining = True
ssh_args = -o ControlMaster=auto -o ControlPersist=60s
```

**Step 26: Create Dynamic Inventory**

Create `ansible/inventory/azure_rm.yml`:

```yaml
plugin: azure.azcollection.azure_rm
include_vm_resource_groups:
  - devopspipeline-dev-rg
auth_source: auto
keyed_groups:
  - key: tags.Environment
    prefix: env
  - key: tags.Project
    prefix: project
```

**Step 27: Create Ansible Roles**

Create base server role structure:

```bash
cd ansible/roles
ansible-galaxy init docker
ansible-galaxy init security
ansible-galaxy init monitoring
```

**Step 28: Create Docker Installation Role**

Create `ansible/roles/docker/tasks/main.yml`:

```yaml
---
- name: Update apt cache
  apt:
    update_cache: yes
    cache_valid_time: 3600

- name: Install required packages
  apt:
    name:
      - apt-transport-https
      - ca-certificates
      - curl
      - gnupg
      - lsb-release
    state: present

- name: Add Docker GPG key
  apt_key:
    url: https://download.docker.com/linux/ubuntu/gpg
    state: present

- name: Add Docker repository
  apt_repository:
    repo: "deb [arch=amd64] https://download.docker.com/linux/ubuntu {{ ansible_distribution_release }} stable"
    state: present

- name: Install Docker
  apt:
    name:
      - docker-ce
      - docker-ce-cli
      - containerd.io
      - docker-compose-plugin
    state: present
    update_cache: yes

- name: Ensure Docker service is started and enabled
  systemd:
    name: docker
    state: started
    enabled: yes

- name: Add user to docker group
  user:
    name: "{{ ansible_user }}"
    groups: docker
    append: yes

- name: Install Docker Compose
  get_url:
    url: "https://github.com/docker/compose/releases/download/v2.23.0/docker-compose-linux-x86_64"
    dest: /usr/local/bin/docker-compose
    mode: '0755'

- name: Create Docker daemon configuration
  copy:
    content: |
      {
        "log-driver": "json-file",
        "log-opts": {
          "max-size": "10m",
          "max-file": "3"
        }
      }
    dest: /etc/docker/daemon.json
    mode: '0644'
  notify: Restart Docker

- name: Install Azure CLI
  shell: |
    curl -sL https://aka.ms/InstallAzureCLIDeb | bash
  args:
    creates: /usr/bin/az
```

Create `ansible/roles/docker/handlers/main.yml`:

```yaml
---
- name: Restart Docker
  systemd:
    name: docker
    state: restarted
```

**Step 29: Create Security Hardening Role**

Create `ansible/roles/security/tasks/main.yml`:

```yaml
---
- name: Update all packages
  apt:
    upgrade: dist
    update_cache: yes

- name: Install security packages
  apt:
    name:
      - ufw
      - fail2ban
      - unattended-upgrades
      - aide
    state: present

- name: Configure UFW defaults
  ufw:
    direction: "{{ item.direction }}"
    policy: "{{ item.policy }}"
  loop:
    - { direction: 'incoming', policy: 'deny' }
    - { direction: 'outgoing', policy: 'allow' }

- name: Configure UFW rules
  ufw:
    rule: "{{ item.rule }}"
    port: "{{ item.port }}"
    proto: "{{ item.proto }}"
  loop:
    - { rule: 'allow', port: '22', proto: 'tcp' }
    - { rule: 'allow', port: '80', proto: 'tcp' }
    - { rule: 'allow', port: '443', proto: 'tcp' }
    - { rule: 'allow', port: '3000', proto: 'tcp' }

- name: Enable UFW
  ufw:
    state: enabled

- name: Configure fail2ban
  copy:
    content: |
      [DEFAULT]
      bantime = 3600
      findtime = 600
      maxretry = 5

      [sshd]
      enabled = true
      port = 22
      logpath = %(sshd_log)s
    dest: /etc/fail2ban/jail.local
    mode: '0644'
  notify: Restart fail2ban

- name: Enable fail2ban
  systemd:
    name: fail2ban
    state: started
    enabled: yes

- name: Configure automatic security updates
  copy:
    content: |
      APT::Periodic::Update-Package-Lists "1";
      APT::Periodic::Download-Upgradeable-Packages "1";
      APT::Periodic::AutocleanInterval "7";
      APT::Periodic::Unattended-Upgrade "1";
    dest: /etc/apt/apt.conf.d/20auto-upgrades
    mode: '0644'

- name: Set system limits
  pam_limits:
    domain: '*'
    limit_type: "{{ item.type }}"
    limit_item: "{{ item.item }}"
    value: "{{ item.value }}"
  loop:
    - { type: 'soft', item: 'nofile', value: '65536' }
    - { type: 'hard', item: 'nofile', value: '65536' }
    - { type: 'soft', item: 'nproc', value: '4096' }
    - { type: 'hard', item: 'nproc', value: '4096' }
```

Create `ansible/roles/security/handlers/main.yml`:

```yaml
---
- name: Restart fail2ban
  systemd:
    name: fail2ban
    state: restarted
```

**Step 30: Create Application Deployment Role**

Create `ansible/roles/app-deploy/tasks/main.yml`:

```yaml
---
- name: Create application directory
  file:
    path: /opt/devops-app
    state: directory
    owner: "{{ ansible_user }}"
    group: docker
    mode: '0755'

- name: Login to Azure Container Registry
  shell: |
    az acr login --name {{ acr_name }}
  environment:
    AZURE_CLIENT_ID: "{{ lookup('env', 'ARM_CLIENT_ID') }}"
    AZURE_CLIENT_SECRET: "{{ lookup('env', 'ARM_CLIENT_SECRET') }}"
    AZURE_TENANT_ID: "{{ lookup('env', 'ARM_TENANT_ID') }}"

- name: Create docker-compose file
  template:
    src: docker-compose.yml.j2
    dest: /opt/devops-app/docker-compose.yml
    owner: "{{ ansible_user }}"
    mode: '0644'

- name: Create environment file
  template:
    src: .env.j2
    dest: /opt/devops-app/.env
    owner: "{{ ansible_user }}"
    mode: '0600'

- name: Pull latest images
  community.docker.docker_compose:
    project_src: /opt/devops-app
    pull: yes

- name: Start application containers
  community.docker.docker_compose:
    project_src: /opt/devops-app
    state: present
    restarted: yes

- name: Wait for application to be ready
  uri:
    url: "http://localhost:3000/health"
    status_code: 200
  register: result
  until: result.status == 200
  retries: 30
  delay: 2
```

Create `ansible/roles/app-deploy/templates/docker-compose.yml.j2`:

```yaml
version: '3.8'

services:
  database:
    image: postgres:15-alpine
    environment:
      POSTGRES_USER: {{ db_user }}
      POSTGRES_PASSWORD: {{ db_password }}
      POSTGRES_DB: {{ db_name }}
    volumes:
      - postgres_data:/var/lib/postgresql/data
    networks:
      - app-network
    restart: unless-stopped

  backend:
    image: {{ acr_login_server }}/{{ backend_image_name }}:{{ image_tag }}
    environment:
      DATABASE_URL: postgresql://{{ db_user }}:{{ db_password }}@database:5432/{{ db_name }}
      NODE_ENV: production
    ports:
      - "3000:3000"
    depends_on:
      - database
    networks:
      - app-network
    restart: unless-stopped

  frontend:
    image: {{ acr_login_server }}/{{ frontend_image_name }}:{{ image_tag }}
    ports:
      - "80:80"
    depends_on:
      - backend
    networks:
      - app-network
    restart: unless-stopped

volumes:
  postgres_data:

networks:
  app-network:
    driver: bridge
```

Create `ansible/roles/app-deploy/templates/.env.j2`:

```
DB_USER={{ db_user }}
DB_PASSWORD={{ db_password }}
DB_NAME={{ db_name }}
ACR_LOGIN_SERVER={{ acr_login_server }}
IMAGE_TAG={{ image_tag }}
```

**Step 31: Create Main Playbook**

Create `ansible/playbooks/setup-server.yml`:

```yaml
---
- name: Configure DevOps Application Server
  hosts: all
  become: yes
  gather_facts: yes

  vars:
    acr_name: "{{ lookup('env', 'ACR_NAME') }}"
    acr_login_server: "{{ lookup('env', 'ACR_LOGIN_SERVER') }}"
    backend_image_name: "devops-backend"
    frontend_image_name: "devops-frontend"
    image_tag: "{{ lookup('env', 'IMAGE_TAG') | default('latest', true) }}"
    db_user: "{{ lookup('env', 'DB_USER') }}"
    db_password: "{{ lookup('env', 'DB_PASSWORD') }}"
    db_name: "{{ lookup('env', 'DB_NAME') }}"

  tasks:
    - name: Display target host information
      debug:
        msg: "Configuring {{ inventory_hostname }} ({{ ansible_host }})"

  roles:
    - security
    - docker
    - app-deploy

  post_tasks:
    - name: Verify application is running
      uri:
        url: "http://localhost:3000/health"
        status_code: 200
      register: health_check
      until: health_check.status == 200
      retries: 5
      delay: 3

    - name: Display deployment summary
      debug:
        msg:
          - "Deployment completed successfully"
          - "Application URL: http://{{ ansible_host }}"
          - "Backend Health: http://{{ ansible_host }}:3000/health"
```

**Step 32: Test Ansible Locally**

```bash
# Install required collections
ansible-galaxy collection install azure.azcollection
ansible-galaxy collection install community.docker

# Test connection
ansible all -m ping -i inventory/azure_rm.yml

# Run playbook in check mode
ansible-playbook playbooks/setup-server.yml -i inventory/azure_rm.yml --check

# Run playbook
ansible-playbook playbooks/setup-server.yml -i inventory/azure_rm.yml
```

### Phase 6: Complete CI/CD Integration

#### Part A: Infrastructure Pipeline

**Step 33: Create Terraform CI/CD Workflow**

Create `.github/workflows/terraform.yml`:

```yaml
name: Terraform Infrastructure

on:
  push:
    branches: [main]
    paths:
      - 'terraform/**'
  pull_request:
    branches: [main]
    paths:
      - 'terraform/**'
  workflow_dispatch:

env:
  TF_CLOUD_ORGANIZATION: "your-org-name"
  TF_WORKSPACE: "devops-pipeline-infrastructure"
  TF_TOKEN_app_terraform_io: ${{ secrets.TF_API_TOKEN }}

jobs:
  terraform-plan:
    name: Terraform Plan
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v3
        with:
          cli_config_credentials_token: ${{ secrets.TF_API_TOKEN }}

      - name: Terraform Format Check
        working-directory: ./terraform
        run: terraform fmt -check -recursive

      - name: Terraform Init
        working-directory: ./terraform
        run: terraform init

      - name: Terraform Validate
        working-directory: ./terraform
        run: terraform validate

      - name: Terraform Plan
        working-directory: ./terraform
        run: terraform plan -no-color
        continue-on-error: true

  terraform-security:
    name: Terraform Security Scan
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Run tfsec
        uses: aquasecurity/tfsec-action@v1.0.0
        with:
          working_directory: terraform
          soft_fail: true

      - name: Run Checkov
        uses: bridgecrewio/checkov-action@master
        with:
          directory: terraform
          framework: terraform
          soft_fail: true

  terraform-apply:
    name: Terraform Apply
    runs-on: ubuntu-latest
    needs: [terraform-plan, terraform-security]
    if: github.ref == 'refs/heads/main' && github.event_name == 'push'
    environment:
      name: production
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v3
        with:
          cli_config_credentials_token: ${{ secrets.TF_API_TOKEN }}
          terraform_wrapper: false

      - name: Terraform Init
        working-directory: ./terraform
        run: terraform init

      - name: Terraform Apply
        working-directory: ./terraform
        run: terraform apply -auto-approve

      - name: Extract Terraform Outputs
        working-directory: ./terraform
        id: tf-outputs
        run: |
          echo "vm_ip=$(terraform output -raw vm_public_ip)" >> $GITHUB_OUTPUT
          echo "acr_name=$(terraform output -raw acr_name)" >> $GITHUB_OUTPUT
          echo "acr_server=$(terraform output -raw acr_login_server)" >> $GITHUB_OUTPUT

      - name: Save outputs as artifacts
        uses: actions/upload-artifact@v3
        with:
          name: terraform-outputs
          path: terraform/terraform-outputs.json
```

#### Part B: Complete CD Pipeline

**Step 34: Create Full Deployment Workflow**

Create `.github/workflows/cd-pipeline.yml`:

```yaml
name: CD Pipeline

on:
  push:
    branches: [main]
  workflow_dispatch:

env:
  NODE_VERSION: '18'
  ACR_NAME: ${{ secrets.ACR_NAME }}

jobs:
  build-and-push:
    name: Build and Push Docker Images
    runs-on: ubuntu-latest
    
    outputs:
      image_tag: ${{ steps.meta.outputs.version }}
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Log in to Azure Container Registry
        uses: azure/docker-login@v1
        with:
          login-server: ${{ secrets.ACR_LOGIN_SERVER }}
          username: ${{ secrets.ACR_USERNAME }}
          password: ${{ secrets.ACR_PASSWORD }}

      - name: Extract metadata
        id: meta
        run: |
          echo "version=sha-${GITHUB_SHA::7}" >> $GITHUB_OUTPUT
          echo "date=$(date +'%Y%m%d')" >> $GITHUB_OUTPUT

      - name: Build and push backend image
        uses: docker/build-push-action@v5
        with:
          context: ./backend
          push: true
          tags: |
            ${{ secrets.ACR_LOGIN_SERVER }}/devops-backend:${{ steps.meta.outputs.version }}
            ${{ secrets.ACR_LOGIN_SERVER }}/devops-backend:latest
          cache-from: type=gha
          cache-to: type=gha,mode=max
          build-args: |
            BUILD_DATE=${{ steps.meta.outputs.date }}
            VCS_REF=${{ github.sha }}

      - name: Build and push frontend image
        uses: docker/build-push-action@v5
        with:
          context: ./frontend
          push: true
          tags: |
            ${{ secrets.ACR_LOGIN_SERVER }}/devops-frontend:${{ steps.meta.outputs.version }}
            ${{ secrets.ACR_LOGIN_SERVER }}/devops-frontend:latest
          cache-from: type=gha
          cache-to: type=gha,mode=max
          build-args: |
            BUILD_DATE=${{ steps.meta.outputs.date }}
            VCS_REF=${{ github.sha }}

      - name: Scan backend image
        uses: aquasecurity/trivy-action@master
        with:
          image-ref: ${{ secrets.ACR_LOGIN_SERVER }}/devops-backend:${{ steps.meta.outputs.version }}
          format: 'sarif'
          output: 'trivy-backend-results.sarif'

      - name: Scan frontend image
        uses: aquasecurity/trivy-action@master
        with:
          image-ref: ${{ secrets.ACR_LOGIN_SERVER }}/devops-frontend:${{ steps.meta.outputs.version }}
          format: 'sarif'
          output: 'trivy-frontend-results.sarif'

      - name: Upload Trivy results
        uses: github/codeql-action/upload-sarif@v2
        if: always()
        with:
          sarif_file: '.'

  deploy:
    name: Deploy to Azure VM
    runs-on: ubuntu-latest
    needs: build-and-push
    environment:
      name: production
      url: http://${{ steps.get-ip.outputs.vm_ip }}
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.10'

      - name: Install Ansible
        run: |
          pip install ansible
          ansible-galaxy collection install azure.azcollection
          ansible-galaxy collection install community.docker
          pip install -r https://raw.githubusercontent.com/ansible-collections/azure/dev/requirements-azure.txt

      - name: Setup SSH key
        run: |
          mkdir -p ~/.ssh
          echo "${{ secrets.SSH_PRIVATE_KEY }}" > ~/.ssh/id_rsa
          chmod 600 ~/.ssh/id_rsa
          ssh-keyscan -H ${{ secrets.VM_PUBLIC_IP }} >> ~/.ssh/known_hosts

      - name: Create Ansible inventory
        run: |
          cat > ansible/inventory/hosts << EOF
          [app_servers]
          azure-vm ansible_host=${{ secrets.VM_PUBLIC_IP }} ansible_user=azureuser
          EOF

      - name: Run Ansible deployment
        working-directory: ./ansible
        env:
          ANSIBLE_HOST_KEY_CHECKING: False
          ACR_NAME: ${{ secrets.ACR_NAME }}
          ACR_LOGIN_SERVER: ${{ secrets.ACR_LOGIN_SERVER }}
          ARM_CLIENT_ID: ${{ secrets.ARM_CLIENT_ID }}
          ARM_CLIENT_SECRET: ${{ secrets.ARM_CLIENT_SECRET }}
          ARM_TENANT_ID: ${{ secrets.ARM_TENANT_ID }}
          IMAGE_TAG: ${{ needs.build-and-push.outputs.image_tag }}
          DB_USER: ${{ secrets.DB_USER }}
          DB_PASSWORD: ${{ secrets.DB_PASSWORD }}
          DB_NAME: ${{ secrets.DB_NAME }}
        run: |
          ansible-playbook playbooks/setup-server.yml -i inventory/hosts -v

      - name: Verify deployment
        run: |
          sleep 30
          curl -f http://${{ secrets.VM_PUBLIC_IP }}/health || exit 1
          curl -f http://${{ secrets.VM_PUBLIC_IP }} || exit 1

      - name: Get VM IP
        id: get-ip
        run: echo "vm_ip=${{ secrets.VM_PUBLIC_IP }}" >> $GITHUB_OUTPUT

  post-deployment:
    name: Post-Deployment Tests
    runs-on: ubuntu-latest
    needs: deploy
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Run smoke tests
        run: |
          echo "Running smoke tests against http://${{ secrets.VM_PUBLIC_IP }}"
          
          # Test frontend
          curl -f http://${{ secrets.VM_PUBLIC_IP }} || exit 1
          
          # Test backend health
          curl -f http://${{ secrets.VM_PUBLIC_IP }}:3000/health || exit 1
          
          # Test API endpoints
          curl -f http://${{ secrets.VM_PUBLIC_IP }}:3000/api || exit 1

      - name: Notify deployment success
        if: success()
        run: |
          echo "Deployment successful to http://${{ secrets.VM_PUBLIC_IP }}"
```

### Phase 7: DevSecOps Integration

#### Part A: Security Scanning

**Step 35: Create Security Workflow**

Create `.github/workflows/security.yml`:

```yaml
name: Security Scanning

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]
  schedule:
    - cron: '0 2 * * 1'  # Weekly on Monday at 2 AM

jobs:
  dependency-scan:
    name: Dependency Vulnerability Scan
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Run npm audit on backend
        working-directory: ./backend
        run: |
          npm audit --audit-level=moderate --json > backend-audit.json || true

      - name: Run npm audit on frontend
        working-directory: ./frontend
        run: |
          npm audit --audit-level=moderate --json > frontend-audit.json || true

      - name: Upload audit results
        uses: actions/upload-artifact@v3
        with:
          name: npm-audit-results
          path: |
            backend/backend-audit.json
            frontend/frontend-audit.json

  sast-scan:
    name: Static Application Security Testing
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Initialize CodeQL
        uses: github/codeql-action/init@v2
        with:
          languages: javascript

      - name: Perform CodeQL Analysis
        uses: github/codeql-action/analyze@v2

  secret-scan:
    name: Secret Scanning
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: TruffleHog OSS
        uses: trufflesecurity/trufflehog@main
        with:
          path: ./
          base: ${{ github.event.repository.default_branch }}
          head: HEAD
          extra_args: --debug --only-verified

  container-scan:
    name: Container Security Scan
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Build backend image
        run: docker build -t devops-backend:scan ./backend

      - name: Build frontend image
        run: docker build -t devops-frontend:scan ./frontend

      - name: Run Trivy on backend
        uses: aquasecurity/trivy-action@master
        with:
          image-ref: 'devops-backend:scan'
          format: 'table'
          exit-code: '1'
          ignore-unfixed: true
          vuln-type: 'os,library'
          severity: 'CRITICAL,HIGH'

      - name: Run Trivy on frontend
        uses: aquasecurity/trivy-action@master
        with:
          image-ref: 'devops-frontend:scan'
          format: 'table'
          exit-code: '1'
          ignore-unfixed: true
          vuln-type: 'os,library'
          severity: 'CRITICAL,HIGH'

  iac-security:
    name: Infrastructure as Code Security
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Run tfsec
        uses: aquasecurity/tfsec-action@v1.0.0
        with:
          working_directory: terraform
          format: sarif
          soft_fail: false

      - name: Upload tfsec results
        uses: github/codeql-action/upload-sarif@v2
        if: always()
        with:
          sarif_file: tfsec.sarif

      - name: Scan Ansible playbooks
        uses: ansible/ansible-lint-action@main
        with:
          targets: "ansible/playbooks/"
```

#### Part B: OWASP ZAP Security Testing

**Step 36: Create OWASP ZAP Workflow**

Create `.github/workflows/dast.yml`:

```yaml
name: DAST with OWASP ZAP

on:
  workflow_dispatch:
  schedule:
    - cron: '0 3 * * 0'  # Weekly on Sunday at 3 AM

jobs:
  zap-scan:
    name: OWASP ZAP Security Scan
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: ZAP Baseline Scan
        uses: zaproxy/action-baseline@v0.10.0
        with:
          target: 'http://${{ secrets.VM_PUBLIC_IP }}'
          rules_file_name: 'zap-rules.tsv'
          cmd_options: '-a'

      - name: Upload ZAP results
        uses: actions/upload-artifact@v3
        if: always()
        with:
          name: zap-report
          path: |
            report_html.html
            report_json.json
```

### Phase 8: Monitoring and Documentation

#### Part C: Monitoring Setup

**Step 37: Add Monitoring to Ansible**

Create `ansible/roles/monitoring/tasks/main.yml`:

```yaml
---
- name: Install monitoring tools
  apt:
    name:
      - prometheus-node-exporter
      - sysstat
    state: present

- name: Enable node exporter
  systemd:
    name: prometheus-node-exporter
    state: started
    enabled: yes

- name: Create monitoring script
  copy:
    content: |
      #!/bin/bash
      echo "=== System Status ==="
      echo "CPU Usage:"
      top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}'
      echo "Memory Usage:"
      free -m | awk 'NR==2{printf "%.2f%%\n", $3*100/$2 }'
      echo "Disk Usage:"
      df -h | awk '$NF=="/"{printf "%s\n", $5}'
      echo "Docker Containers:"
      docker ps --format "table {{.Names}}\t{{.Status}}"
    dest: /usr/local/bin/system-status.sh
    mode: '0755'
```

#### Part D: Documentation

**Step 38: Create Comprehensive Documentation**

Create `README.md`:

```markdown
# DevOps Pipeline Project

Comprehensive DevOps implementation with CI/CD, IaC, and configuration management.

## Team Members

- [Name 1] - DevOps Engineer (GitHub/CI/CD Lead)
- [Name 2] - Infrastructure Engineer (Terraform/Azure Lead)
- [Name 3] - Configuration Manager (Ansible Lead)
- [Name 4] - Security Engineer (DevSecOps Lead)

## Project Overview

[Brief description of your application]

## Architecture

### Application Stack
- Frontend: [Technology]
- Backend: [Technology]
- Database: PostgreSQL

### Infrastructure
- Cloud Provider: Microsoft Azure
- IaC Tool: Terraform with Terraform Cloud
- Configuration Management: Ansible
- Container Registry: Azure Container Registry
- Compute: Azure Virtual Machine (Ubuntu 22.04)

### CI/CD Pipeline
- Source Control: GitHub
- CI/CD Platform: GitHub Actions
- Containerization: Docker
- Orchestration: Docker Compose

## Repository Structure

```
├── .github/
│   ├── workflows/          # CI/CD pipelines
│   ├── ISSUE_TEMPLATE/     # Issue templates
│   └── CODEOWNERS          # Code ownership
├── frontend/               # Frontend application
├── backend/                # Backend API
├── terraform/              # Infrastructure as Code
├── ansible/                # Configuration management
├── security/               # Security configurations
└── docs/                   # Additional documentation
```

## Getting Started

### Prerequisites
- Git
- Docker Desktop
- Azure CLI
- Terraform CLI
- Ansible
- Node.js 18+

### Local Development

1. Clone the repository:
```bash
git clone [repository-url]
cd devops-pipeline-project
```

2. Start local environment:
```bash
docker-compose up --build
```

3. Access the application:
- Frontend: http://localhost
- Backend API: http://localhost:3000
- API Documentation: http://localhost:3000/api-docs

## Deployment

### Infrastructure Provisioning

1. Configure Terraform Cloud workspace
2. Set required variables in Terraform Cloud
3. Push changes to main branch
4. Infrastructure pipeline runs automatically

### Application Deployment

1. Merge changes to main branch
2. CI pipeline runs tests and builds images
3. Images pushed to Azure Container Registry
4. Ansible configures and deploys to VM
5. Application accessible at production URL

## CI/CD Pipelines

### CI Pipeline
- Linting (ESLint)
- Unit testing
- Integration testing
- Security scanning (Trivy, npm audit)
- Docker build verification

### CD Pipeline
- Build and push Docker images
- Infrastructure provisioning (Terraform)
- Server configuration (Ansible)
- Application deployment
- Post-deployment verification

### Security Pipeline
- Dependency vulnerability scanning
- Static application security testing (SAST)
- Container security scanning
- Infrastructure security (tfsec, Checkov)
- Secret scanning (TruffleHog)
- Dynamic application security testing (DAST with OWASP ZAP)

## DevOps Practices Implemented

### Version Control
- Branch protection rules
- Required pull request reviews
- Status checks before merging
- CODEOWNERS for specialized reviews

### Project Management
- GitHub Projects for task tracking
- Issue templates for consistency
- Automated project board workflows

### Security
- Automated security scanning in CI/CD
- Container vulnerability scanning
- Infrastructure security scanning
- Secret management with GitHub Secrets
- UFW firewall configuration
- Fail2ban for intrusion prevention
- Regular security updates

### Infrastructure Management
- Infrastructure as Code with Terraform
- State management with Terraform Cloud
- Automated provisioning
- Version-controlled infrastructure

### Configuration Management
- Ansible roles for modularity
- Automated server configuration
- Idempotent playbooks
- Dynamic inventory

### Monitoring
- Application health checks
- System resource monitoring
- Docker container status
- Automated alerts

## Security Considerations

- All secrets stored in GitHub Secrets
- Branch protection prevents unauthorized changes
- Security scanning on every PR
- Container images scanned for vulnerabilities
- Infrastructure security validated
- Regular security updates applied automatically
- Firewall configured to allow only necessary traffic

## Troubleshooting

### Common Issues

#### Terraform Apply Fails
- Verify Azure credentials in Terraform Cloud
- Check resource name uniqueness
- Ensure subscription has sufficient quota

#### Ansible Deployment Fails
- Verify SSH key configuration
- Check VM firewall rules
- Ensure ACR credentials are correct

#### Application Not Accessible
- Verify all containers are running: `docker ps`
- Check application logs: `docker-compose logs`
- Verify firewall rules allow traffic

## Contributing

1. Create feature branch from develop
2. Make changes and commit
3. Push branch and create pull request
4. Ensure all CI checks pass
5. Obtain required reviews
6. Merge to develop

## License

[Your chosen license]

## Acknowledgments

- ALU DevOps Course
- Open source tools and communities
```

Create `docs/DEPLOYMENT.md` with detailed deployment instructions.

Create `docs/ARCHITECTURE.md` with architecture diagrams.

Create `docs/SECURITY.md` with security practices documentation.

## Deliverables

### Required Submissions

1. **GitHub Repository** with:
   - Complete source code
   - All configuration files
   - Documentation
   - Working CI/CD pipelines

2. **Documentation Package**:
   - README.md with comprehensive project overview
   - Architecture diagrams
   - Deployment guide
   - Security practices documentation
   - Troubleshooting guide

3. **Demonstration Video** (15-20 minutes):
   - Repository walkthrough
   - CI/CD pipeline demonstration
   - Infrastructure provisioning demo
   - Live application demonstration
   - Security features showcase

4. **Team Presentation**:
   - Project overview
   - Architecture explanation
   - DevOps practices implementation
   - Challenges and solutions
   - Lessons learned
   - Q&A session

5. **Individual Reflection** (2-3 pages per student):
   - Your specific contributions
   - Technical challenges overcome
   - Skills developed
   - Team collaboration experience
   - DevOps best practices learned

## Assessment Rubric

### Technical Implementation (40%)
- Repository configuration and branch protection (5%)
- CI pipeline implementation (10%)
- CD pipeline implementation (10%)
- Infrastructure as Code (7%)
- Configuration management (5%)
- DevSecOps practices (3%)

### Code Quality and Standards (20%)
- Code organization and structure (5%)
- Linting and code standards (5%)
- Testing coverage (5%)
- Security implementation (5%)

### Documentation (20%)
- README and project documentation (8%)
- Code comments and clarity (4%)
- Architecture documentation (4%)
- Deployment procedures (4%)

### Collaboration and Project Management (10%)
- GitHub Projects usage (3%)
- Issue tracking (2%)
- Pull request process (3%)
- Team communication (2%)

### Presentation and Demonstration (10%)
- Video demonstration quality (5%)
- Team presentation (3%)
- Individual reflection (2%)

## Resources

### Official Documentation
- GitHub Actions: https://docs.github.com/actions
- Terraform: https://www.terraform.io/docs
- Ansible: https://docs.ansible.com
- Docker: https://docs.docker.com
- Azure: https://docs.microsoft.com/azure

### Additional Learning Resources
- DevOps best practices guides
- Security scanning tools documentation
- CI/CD pipeline patterns
- Infrastructure as Code patterns

## Support and Questions

- Use GitHub Issues for technical questions
- Tag instructors for urgent matters
- Schedule office hours for in-depth discussions
- Collaborate with team members on Slack/Teams

Good luck with your DevOps pipeline implementation!
