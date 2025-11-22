# 🐳 Docker Hub Deployment Guide

## Overview

This deployment uses **Docker Hub** instead of Azure Container Registry for simpler, cloud-agnostic deployment.

---

## 🔐 Required GitHub Secrets (Simplified!)

**Only 5 secrets needed** (instead of 12 with ACR):

### **1. Docker Hub (2 secrets)**

- **DOCKER_USERNAME**
  - Your Docker Hub username
  - Example: `johndoe`
  - Get it from: https://hub.docker.com (your username)

- **DOCKER_PASSWORD**
  - Your Docker Hub password or access token
  - **Recommended:** Use access token instead of password
  - How to create token:
    1. Login to Docker Hub
    2. Go to Account Settings → Security → New Access Token
    3. Name it "GitHub Actions"
    4. Copy the token

### **2. VM Access (2 secrets)**

- **VM_PUBLIC_IP**
  - Your server's public IP address
  - Example: `20.121.45.67`

- **SSH_PRIVATE_KEY**
  - Full SSH private key for VM access
  - Generate with: `ssh-keygen -t rsa -b 4096`

### **3. Database (3 secrets - optional, has defaults)**

- **DB_USER** (default: `devops`)
- **DB_PASSWORD** (choose a strong password)
- **DB_NAME** (default: `devops_app`)

---

## 📦 Docker Hub Repositories

Your images will be pushed to:

- `YOUR_USERNAME/taskmanager-backend:latest`
- `YOUR_USERNAME/taskmanager-backend:sha-xxxxxxx`
- `YOUR_USERNAME/taskmanager-frontend:latest`
- `YOUR_USERNAME/taskmanager-frontend:sha-xxxxxxx`

**Note:** Docker Hub public repositories are free!

---

## 🚀 Quick Setup Steps

### Step 1: Create Docker Hub Account (if needed)

```bash
# Visit https://hub.docker.com
# Sign up for free account
# Verify your email
```

### Step 2: Create Access Token

```bash
# Login to Docker Hub
# Go to: Account Settings → Security
# Click: New Access Token
# Name: "GitHub Actions"  
# Permissions: Read, Write, Delete
# Copy the token (you won't see it again!)
```

### Step 3: Configure GitHub Secrets

Go to: **GitHub → Settings → Secrets and variables → Actions**

Add these secrets:

```
DOCKER_USERNAME = your-dockerhub-username
DOCKER_PASSWORD = dckr_pat_xxxxxxxxxxxxx (your token)
VM_PUBLIC_IP = XX.XX.XX.XX
SSH_PRIVATE_KEY = -----BEGIN OPENSSH PRIVATE KEY-----...
DB_USER = devops
DB_PASSWORD = YourSecurePassword123!
DB_NAME = devops_app
```

### Step 4: Run Deployment

```bash
# Commit and push
git add .
git commit -m "feat: configure Docker Hub deployment"
git push origin main

# CD pipeline auto-runs!
# Check: https://github.com/RANGIRA46/pipeline-task-management-app/actions
```

---

## 🔍 How It Works

### Build & Push (GitHub Actions)

```yaml
1. Login to Docker Hub
2. Build backend image
3. Tag: username/taskmanager-backend:sha-abc1234
4. Tag: username/taskmanager-backend:latest
5. Push to Docker Hub
6. Repeat for frontend
```

### Deploy (Ansible on VM)

```yaml
1. SSH to VM
2. Install Docker
3. Login to Docker Hub
4. Pull images: username/taskmanager-backend:latest
5. Start containers with docker-compose
6. Verify health checks
```

---

## ✅ Advantages of Docker Hub

- ✅ **Simpler:** No Azure subscription needed
- ✅ **Free:** Public repositories are free
- ✅ **Faster:** No ACR authentication complexity
- ✅ **Cloud-Agnostic:** Works with any cloud provider
- ✅ **Easy Testing:** Can pull images locally for testing

---

## 🧪 Test Locally

Pull and run your images locally:

```bash
# Pull images from Docker Hub
docker pull YOUR_USERNAME/taskmanager-backend:latest
docker pull YOUR_USERNAME/taskmanager-frontend:latest

# Run locally
docker-compose up
```

---

## 📊 Expected Deployment Flow

```
1. Push to GitHub main branch
   ↓
2. GitHub Actions triggered
   ↓
3. Build Docker images (5-8 min)
   - Backend image built
   - Frontend image built
   ↓
4. Push to Docker Hub
   - username/taskmanager-backend:latest
   - username/taskmanager-frontend:latest
   ↓
5. Deploy to VM via Ansible (3-5 min)
   - Install Docker
   - Login to Docker Hub  
   - Pull latest images
   - Start containers
   ↓
6. Verify deployment (1-2 min)
   - Health checks pass
   - Frontend accessible
   ↓
7. ✅ App live at http://YOUR_VM_IP
```

**Total Time:** ~10-15 minutes

---

## 🐛 Troubleshooting

### "unauthorized: authentication required"

**Cause:** Wrong Docker Hub credentials

**Solution:**
```bash
# Test Docker Hub login locally
docker login
# Username: your-username
# Password: paste your access token

# If successful, update GitHub secrets:
# DOCKER_USERNAME = your-username (from login)
# DOCKER_PASSWORD = your-access-token (from Docker Hub)
```

### "denied: requested access to the resource is denied"

**Cause:** Repository doesn't exist or private

**Solution:**
```bash
# Docker Hub auto-creates public repos on first push
# Make sure DOCKER_USERNAME is correct
# Or manually create repos at hub.docker.com
```

### Images not pulling on VM

**Cause:** Docker not logged in or network issues

**Solution:**
```bash
# SSH to VM
ssh azureuser@YOUR_VM_IP

# Test Docker Hub access
docker login
docker pull YOUR_USERNAME/taskmanager-backend:latest

# Check logs
docker logs taskmanager-backend
```

---

## 🔐 Security Best Practices

### Use Access Tokens, Not Passwords

```
✅ DO: Use Docker Hub Access Token
   - More secure
   - Can be revoked
   - Scoped permissions

❌ DON'T: Use your Docker Hub password
   - Less secure
   - Full account access
   - Can't be revoked individually
```

### Keep Repositories Public or Use Private

```
Public (Free):
  - Anyone can pull
  - Great for open source
  - No pull authentication needed

Private (Free tier: 1 private repo):
  - Requires authentication to pull
  - Better for proprietary code
  - VM needs Docker login
```

---

## 📝 Verification Checklist

Before deploying:

- [ ] Docker Hub account created
- [ ] Access token generated
- [ ] DOCKER_USERNAME secret configured
- [ ] DOCKER_PASSWORD secret configured (use token!)
- [ ] VM_PUBLIC_IP secret configured
- [ ] SSH_PRIVATE_KEY secret configured
- [ ] DB secrets configured (or using defaults)

After first deployment:

- [ ] Check Docker Hub for images
- [ ] Images have `latest` and `sha-xxx` tags
- [ ] Containers running on VM
- [ ] App accessible at VM IP
- [ ] All CRUD operations work

---

## 🔄 Future Updates

Just push to main - that's it!

```bash
# Make changes
git add .
git commit -m "feat: add new feature"
git push origin main

# Wait 10-15 minutes
# New version deployed automatically!
# Check: http://YOUR_VM_IP
```

---

## 📚 Additional Resources

- [Docker Hub](https://hub.docker.com)
- [Docker Hub Access Tokens](https://docs.docker.com/docker-hub/access-tokens/)
- [GitHub Actions Docker Login](https://github.com/docker/login-action)
- [Docker Compose Reference](https://docs.docker.com/compose/)

---

**Ready to deploy with Docker Hub!** 🐳

Last Updated: 2025-11-22
