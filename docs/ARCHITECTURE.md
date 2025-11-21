# 🏗️ Architecture Documentation

## Table of Contents
1. [System Overview](#system-overview)
2. [Application Architecture](#application-architecture)
3. [Infrastructure Architecture](#infrastructure-architecture)
4. [CI/CD Pipeline Architecture](#cicd-pipeline-architecture)
5. [Security Architecture](#security-architecture)
6. [Data Flow](#data-flow)
7. [Technology Stack](#technology-stack)

---

## System Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                         USER/DEVELOPER                          │
└──────────────────┬──────────────────────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────────────────────┐
│                         GITHUB REPOSITORY                        │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  Source Code │ Workflows │ Infrastructure Code │ Configs │  │
│  └──────────────────────────────────────────────────────────┘  │
└───────────┬──────────────────────────────────────────┬──────────┘
            │                                          │
            ▼                                          ▼
┌───────────────────────────┐          ┌──────────────────────────┐
│   GITHUB ACTIONS (CI/CD)  │          │   TERRAFORM CLOUD        │
│  ┌─────────────────────┐  │          │  ┌────────────────────┐  │
│  │ • Lint & Test       │  │          │  │ • State Management │  │
│  │ • Security Scans    │  │          │  │ • Plan & Apply     │  │
│  │ • Docker Build      │  │          │  │ • Workspace Config │  │
│  │ • ACR Push          │  │          │  └────────────────────┘  │
│  │ • Ansible Deploy    │  │          └──────────────────────────┘
│  └─────────────────────┘  │                       │
└───────────┬───────────────┘                       │
            │                                       ▼
            │                          ┌─────────────────────────┐
            │                          │     AZURE CLOUD         │
            │                          │  ┌──────────────────┐   │
            │                          │  │ Resource Group   │   │
            │                          │  └──────────────────┘   │
            │                          │           │             │
            ▼                          │           ▼             │
┌─────────────────────────┐            │  ┌──────────────────┐   │
│ AZURE CONTAINER REGISTRY│◄───────────┼──┤  ACR (Images)    │   │
│  • Backend Image        │            │  └──────────────────┘   │
│  • Frontend Image       │            │           │             │
└─────────────────────────┘            │           ▼             │
                                      │  ┌──────────────────┐   │
                                      │  │  Virtual Machine │   │
                                      │  │  Ubuntu 22.04    │   │
                                      │  │  ┌────────────┐  │   │
                                      │  │  │  Docker    │  │   │
                                      │  │  │  Compose   │  │   │
                                      │  │  └────────────┘  │   │
                                      │  └──────────────────┘   │
                                      └─────────────────────────┘
                                                   │
                                                   ▼
                                      ┌─────────────────────────┐
                                      │     END USERS           │
                                      │  (HTTP/HTTPS Access)    │
                                      └─────────────────────────┘
```

[Full content as before - continuing with the complete architecture documentation...]

