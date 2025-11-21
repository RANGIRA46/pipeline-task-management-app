# Architecture Documentation

## Overview

This document describes the architecture of the Task Management DevOps Pipeline project.

## Table of Contents
1. [System Architecture](#system-architecture)
2. [Application Architecture](#application-architecture)
3. [Infrastructure Architecture](#infrastructure-architecture)
4. [CI/CD Architecture](#cicd-architecture)
5. [Security Architecture](#security-architecture)

## System Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         Developer Workstation                    │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐       │
│  │   Git    │  │  Docker  │  │Terraform │  │ Ansible  │       │
│  └────┬─────┘  └──────────┘  └──────────┘  └──────────┘       │
└───────┼──────────────────────────────────────────────────────────┘
        │
        ├─ Push Code
        ▼
┌─────────────────────────────────────────────────────────────────┐
│                         GitHub                                   │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                    Source Repository                      │  │
│  │  - Branch Protection  - CODEOWNERS  - Issue Templates    │  │
│  └──────────────────────────────────────────────────────────┘  │
└───────┬─────────────────────────────────────────────────────────┘
        │
        ├─ Trigger Workflows
        ▼
┌─────────────────────────────────────────────────────────────────┐
│                    GitHub Actions (CI/CD)                        │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐       │
│  │    CI    │  │    CD    │  │Terraform │  │ Security │       │
│  │ Pipeline │  │ Pipeline │  │ Pipeline │  │   Scan   │       │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘       │
└───────┬─────────────────────────┬───────────────────────────────┘
        │                         │
        │ Build Images            │ Provision Infrastructure
        ▼                         ▼
┌──────────────────┐    ┌────────────────────────────────────────┐
│  Azure Container │    │        Terraform Cloud                 │
│    Registry      │    │  - State Management                    │
│  - Backend Image │    │  - Workspace Configuration             │
│  - Frontend Image│    └────────┬───────────────────────────────┘
└──────────────────┘             │
                                 │ Provision Resources
                                 ▼
                    ┌────────────────────────────────────────────┐
                    │         Microsoft Azure                    │
                    │  ┌──────────────────────────────────────┐ │
                    │  │      Resource Group                  │ │
                    │  │  ┌────────────┐  ┌────────────────┐ │ │
                    │  │  │   VNet     │  │      NSG       │ │ │
                    │  │  └────────────┘  └────────────────┘ │ │
                    │  │  ┌────────────────────────────────┐ │ │
                    │  │  │    Linux VM (Ubuntu 22.04)     │ │ │
                    │  │  │  - Docker                      │ │ │
                    │  │  │  - UFW Firewall                │ │ │
                    │  │  │  - Fail2ban                    │ │ │
                    │  │  │  - Application Containers      │ │ │
                    │  │  └────────────────────────────────┘ │ │
                    │  └──────────────────────────────────────┘ │
                    └────────────────────────────────────────────┘
```

## Application Architecture

### Three-Tier Architecture

```
┌────────────────────────────────────────────────────────────────┐
│                      Presentation Layer                         │
│  ┌──────────────────────────────────────────────────────────┐ │
│  │             React Frontend (Port 80)                      │ │
│  │  - React 18  - TypeScript  - Vite  - React Router        │ │
│  │  - Served by Nginx                                        │ │
│  └──────────────────────────────────────────────────────────┘ │
└──────────────────┬─────────────────────────────────────────────┘
                   │ HTTP/REST API
                   ▼
┌────────────────────────────────────────────────────────────────┐
│                      Application Layer                          │
│  ┌──────────────────────────────────────────────────────────┐ │
│  │           Express Backend (Port 3000)                     │ │
│  │  - Node.js  - Express  - TypeScript                      │ │
│  │  - REST API  - Business Logic  - Validation              │ │
│  └──────────────────────────────────────────────────────────┘ │
└──────────────────┬─────────────────────────────────────────────┘
                   │ Database Queries
                   ▼
┌────────────────────────────────────────────────────────────────┐
│                         Data Layer                              │
│  ┌──────────────────────────────────────────────────────────┐ │
│  │              PostgreSQL Database                          │ │
│  │  - PostgreSQL 15  - Persistent Volume  - Health Checks   │ │
│  └──────────────────────────────────────────────────────────┘ │
└────────────────────────────────────────────────────────────────┘
```

### Container Architecture

```
Docker Host (Azure VM)
├── app-network (Bridge Network)
│   ├── frontend-container
│   │   └── Nginx → React Static Files
│   ├── backend-container
│   │   └── Node.js → Express API
│   └── database-container
│       └── PostgreSQL → Data Storage
└── postgres_data (Volume)
```

## Infrastructure Architecture

### Azure Resources

```
Azure Subscription
└── Resource Group: devopspipeline-dev-rg
    ├── Virtual Network: devopspipeline-dev-vnet (10.0.0.0/16)
    │   └── Subnet: vm-subnet (10.0.1.0/24)
    ├── Network Security Group: devopspipeline-dev-nsg
    │   ├── Allow SSH (22)
    │   ├── Allow HTTP (80)
    │   ├── Allow HTTPS (443)
    │   └── Allow App (3000)
    ├── Public IP: devopspipeline-dev-pip
    ├── Network Interface: devopspipeline-dev-nic
    ├── SSH Key: devopspipeline-dev-sshkey
    ├── Linux VM: devopspipeline-dev-vm
    │   ├── Size: Standard_B2s
    │   ├── OS: Ubuntu 22.04 LTS
    │   └── Managed Identity: System Assigned
    └── Container Registry: devopspipelinedevacr
        ├── SKU: Basic
        └── Admin Enabled: true
```

### Network Flow

```
Internet
   │
   ├─ Port 80 (HTTP) ──────┐
   ├─ Port 443 (HTTPS) ────┤
   ├─ Port 3000 (API) ─────┤
   └─ Port 22 (SSH) ───────┤
                           │
                           ▼
                    ┌─────────────┐
                    │   NSG Rules │
                    └──────┬──────┘
                           │
                           ▼
                    ┌─────────────┐
                    │  Public IP  │
                    └──────┬──────┘
                           │
                           ▼
                    ┌─────────────┐
                    │  UFW (VM)   │
                    └──────┬──────┘
                           │
                           ▼
                  ┌────────────────┐
                  │   Application  │
                  │   Containers   │
                  └────────────────┘
```

## CI/CD Architecture

### CI Pipeline Flow

```
Developer Push/PR
        │
        ▼
┌─────────────────┐
│  Checkout Code  │
└────────┬────────┘
         │
         ├─────────────┬─────────────┬──────────────┐
         ▼             ▼             ▼              ▼
┌────────────┐  ┌────────────┐  ┌─────────┐  ┌──────────┐
│   Lint     │  │    Test    │  │Security │  │  Build   │
│  Backend   │  │  Backend   │  │  Scan   │  │  Docker  │
└────────────┘  └────────────┘  └─────────┘  └──────────┘
         │             │             │              │
         ├─────────────┴─────────────┴──────────────┤
         │                                           │
         ├─────────────┬─────────────┬──────────────┘
         ▼             ▼             ▼
┌────────────┐  ┌────────────┐  ┌─────────────┐
│   Lint     │  │    Test    │  │Upload Scans │
│  Frontend  │  │  Frontend  │  │  to GitHub  │
└────────────┘  └────────────┘  └─────────────┘
         │             │
         └─────────────┤
                       ▼
              ┌──────────────────┐
              │  All Checks Pass │
              │  Ready to Merge  │
              └──────────────────┘
```

### CD Pipeline Flow

```
Merge to Main
      │
      ▼
┌───────────────────┐
│  Trigger CD       │
└─────────┬─────────┘
          │
          ├──────────────────┬──────────────────┐
          ▼                  ▼                  ▼
┌──────────────────┐  ┌──────────────┐  ┌──────────────┐
│  Build Backend   │  │Build Frontend│  │   Scan       │
│  Docker Image    │  │ Docker Image │  │  Images      │
└────────┬─────────┘  └──────┬───────┘  └──────┬───────┘
         │                   │                  │
         ├───────────────────┴──────────────────┤
         │                                      │
         ▼                                      ▼
┌──────────────────┐                  ┌────────────────┐
│  Push to ACR     │                  │ Security Check │
└────────┬─────────┘                  └────────┬───────┘
         │                                      │
         │◄─────────────────────────────────────┘
         │
         ▼
┌──────────────────┐
│  Terraform       │
│  Infrastructure  │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│  Ansible         │
│  Configuration   │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│  Deploy App      │
│  to VM           │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│  Verification    │
│  & Health Checks │
└──────────────────┘
```

## Security Architecture

### Security Layers

```
┌─────────────────────────────────────────────────────────────┐
│                    Code Security Layer                       │
│  - CodeQL SAST  - ESLint  - Code Reviews  - Branch Protection│
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                 Dependency Security Layer                     │
│  - npm audit  - Trivy  - TruffleHog  - Dependabot           │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                Container Security Layer                       │
│  - Trivy Scanning  - Non-root Users  - Minimal Images       │
│  - Multi-stage Builds  - Image Signing                      │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│              Infrastructure Security Layer                    │
│  - tfsec  - Checkov  - NSG Rules  - UFW Firewall            │
│  - Fail2ban  - SSH Keys Only                                │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                Application Security Layer                     │
│  - OWASP ZAP DAST  - Health Checks  - Monitoring            │
│  - Logging  - Automated Updates                             │
└─────────────────────────────────────────────────────────────┘
```

### Secrets Management

```
Developer
   │
   └─► GitHub Secrets (Encrypted)
         │
         ├─► GitHub Actions (Runtime Injection)
         │     │
         │     ├─► Terraform Cloud Variables
         │     │
         │     └─► Ansible Environment Variables
         │           │
         │           └─► Application Containers (.env)
         │
         └─► Never in Code / Logs / Images
```

## Technology Stack Summary

### Frontend
- React 18
- TypeScript
- Vite
- React Router
- Nginx

### Backend
- Node.js 18
- Express
- TypeScript
- Prisma ORM

### Database
- PostgreSQL 15

### Infrastructure
- Azure Virtual Machines
- Azure Virtual Network
- Azure Container Registry
- Terraform
- Ansible

### CI/CD & DevOps
- GitHub Actions
- Docker & Docker Compose
- Terraform Cloud
- Git Flow

### Security Tools
- Trivy
- CodeQL
- npm audit
- tfsec
- Checkov
- TruffleHog
- OWASP ZAP
- Fail2ban
- UFW

## Design Decisions

### Why Docker Compose instead of Kubernetes?
- Simpler for learning DevOps fundamentals
- Adequate for small-scale application
- Easier to debug and manage
- Lower resource requirements

### Why Azure over AWS/GCP?
- Student credits available
- Good integration with Terraform
- Comprehensive free tier
- Similar to enterprise environments

### Why Terraform Cloud?
- Secure state management
- Team collaboration features
- No need to manage backend storage
- Free tier sufficient for project

### Why Ansible over other CM tools?
- Agentless architecture
- Easy to learn and use
- Good Azure integration
- Industry standard

## Scaling Considerations

### Current Architecture Limitations
- Single VM (single point of failure)
- No load balancing
- No auto-scaling
- Limited disaster recovery

### Future Improvements
- Multiple VMs with load balancer
- Azure Kubernetes Service (AKS)
- Azure Database for PostgreSQL
- Azure Application Gateway
- Redis for caching
- Azure Monitor for observability
- Backup and disaster recovery

## Monitoring & Observability

### Current Implementation
- Docker health checks
- Application /health endpoint
- System monitoring script
- Container logs
- UFW firewall logs

### Recommended Additions
- Prometheus + Grafana
- ELK Stack (Elasticsearch, Logstash, Kibana)
- Azure Monitor
- Application Insights
- Alerting system

---

**Document Version**: 1.0
**Last Updated**: November 2025
**Maintained By**: Infrastructure Team
