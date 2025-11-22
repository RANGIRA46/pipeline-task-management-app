# 🚀 **IMMEDIATE ACTION PLAN** - CD Pipeline Deployment

**Created:** 2025-11-22  
**Estimated Time:** 30-45 minutes  
**Status:** All fixes complete, ready to deploy

---

## 📌 What Was Done

### ✅ Issues Fixed (Just Now)

1. **Port Configuration** - Backend and frontend now use port 3000 consistently
2. **Ansible Setup** - Complete automation playbooks created
3. **Documentation** - Comprehensive guides for debugging and secrets
4. **Verification** - Test workflow for secrets validation

### 📁 Files Created/Modified

**New Files (9):**
- `ansible/ansible.cfg`
- `ansible/inventory/.gitkeep`
- `ansible/playbooks/setup-server.yml`
- `ansible/playbooks/update-app.yml`
- `ansible/README.md`
- `.github/workflows/test-secrets.yml`
- `CD_DEBUG_GUIDE.md`
- `SECRETS_SETUP.md`
- `CD_FIXES_SUMMARY.md`
- `check-cd-ready.bat`

**Modified Files (2):**
- `infra/docker/backend.Dockerfile` (port 4000 → 3000)
- `infra/docker/frontend.Dockerfile` (API URL port fix)

---

## ⚡ **DO THIS NOW** - Step by Step

### **STEP 1: Commit All Changes** (2 minutes)

```bash
# Add all new/modified files
git add .

# Commit with descriptive message
git commit -m "fix: configure CD pipeline with Ansible automation and port fixes

- Fix port configuration (backend now uses 3000 consistently)
- Add complete Ansible playbooks for deployment
- Add comprehensive debugging and secrets documentation
- Add test-secrets workflow for validation
- Ready for production deployment"

# Push to GitHub
git push origin main
```

---

### **STEP 2: Configure GitHub Secrets** (10-15 minutes)

Go to: **GitHub → Settings → Secrets and variables → Actions → New repository secret**

Add these **12 secrets**:

#### Azure Container Registry (4 secrets)

1. **ACR_LOGIN_SERVER**
   ```
   Value: yourregistry.azurecr.io
   ```

2. **ACR_NAME**
   ```
   Value: yourregistryname
   ```

3. **ACR_USERNAME**
   ```
   Value: (from Azure Portal → ACR → Access keys → Username)
   ```

4. **ACR_PASSWORD**
   ```
   Value: (from Azure Portal → ACR → Access keys → Password)
   ```

#### Azure Service Principal (3 secrets)

5. **ARM_CLIENT_ID**
   ```
   Value: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
   ```

6. **ARM_CLIENT_SECRET**
   ```
   Value: your-service-principal-secret
   ```

7. **ARM_TENANT_ID**
   ```
   Value: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
   ```

#### Azure VM (2 secrets)

8. **VM_PUBLIC_IP**
   ```
   Value: XX.XX.XX.XX
   ```

9. **SSH_PRIVATE_KEY**
   ```
   Value: (entire private key including -----BEGIN and -----END lines)
   ```

#### Database (3 secrets)

10. **DB_USER**
    ```
    Value: devops
    ```

11. **DB_PASSWORD**
    ```
    Value: YourSecurePassword123!
    ```

12. **DB_NAME**
    ```
    Value: devops_app
    ```

**📘 Need help?** See: `SECRETS_SETUP.md` for detailed instructions

---

### **STEP 3: Verify Secrets** (2 minutes)

1. Go to: **GitHub → Actions**
2. Click: **Test Secrets Configuration** workflow
3. Click: **Run workflow** → Select `main` → **Run workflow**
4. Wait ~30 seconds
5. Check results:
   - All 12 secrets should show ✅
   - If any show ❌, go back to Step 2

---

### **STEP 4: Run CD Pipeline** (10-15 minutes)

#### Option A: Automatic (Recommended)

If you pushed in Step 1, the CD pipeline should already be running!

1. Go to: **GitHub → Actions**
2. Look for: **CD Pipeline** workflow with your commit message
3. Click on it to watch progress

#### Option B: Manual Trigger

1. Go to: **GitHub → Actions**
2. Click: **CD Pipeline** workflow (left sidebar)
3. Click: **Run workflow** button
4. Select branch: `main`
5. Click: **Run workflow**

---

### **STEP 5: Monitor Pipeline** (10-15 minutes)

Watch the workflow run through 3 jobs:

**Job 1: Build and Push** (~5-8 min)
```
✓ Build backend Docker image
✓ Push to ACR
✓ Build frontend Docker image  
✓ Push to ACR
✓ Security scan
```

**Job 2: Deploy** (~3-5 min)
```
✓ Setup Ansible
✓ SSH to VM
✓ Run setup-server.yml playbook
  - Install Docker
  - Pull images from ACR
  - Start containers
  - Configure firewall
✓ Verify health
```

**Job 3: Post-Deployment** (~1-2 min)
```
✓ Test frontend
✓ Test backend health
✓ Test API
```

**📌 Expected:** All jobs complete with ✅ green checkmarks

---

### **STEP 6: Verify Deployment** (5 minutes)

#### A. Check Workflow Succeeded

- [ ] All 3 jobs show green ✅
- [ ] No errors in logs
- [ ] Deployment successful message

#### B. Test from Browser

Replace `YOUR_VM_IP` with your actual VM IP:

1. **Frontend:** `http://YOUR_VM_IP`
   - [ ] Page loads
   - [ ] No errors in browser console (F12)

2. **Backend Health:** `http://YOUR_VM_IP:3000/health`
   - [ ] Returns JSON: `{"status":"ok",...}`

3. **API:** `http://YOUR_VM_IP:3000/api/tasks`
   - [ ] Returns task list (might be empty)

#### C. Test Functionality

On the frontend (`http://YOUR_VM_IP`):

1. [ ] Create a new task
2. [ ] Edit the task
3. [ ] Mark as complete
4. [ ] Delete the task
5. [ ] All operations work correctly

#### D. Check Containers (SSH)

```bash
# SSH into VM
ssh azureuser@YOUR_VM_IP

# Check containers running
docker ps

# Should see 3 containers:
# - taskmanager-db
# - taskmanager-backend
# - taskmanager-frontend

# Check logs (should see no errors)
docker logs taskmanager-backend --tail 50
docker logs taskmanager-frontend --tail 50
```

---

## ✅ Success Criteria

Your deployment is successful when:

- ✅ CD Pipeline completed all 3 jobs
- ✅ Frontend loads at `http://YOUR_VM_IP`
- ✅ Backend health check returns 200 OK
- ✅ Can create/edit/delete tasks
- ✅ 3 containers running on VM
- ✅ No errors in logs

---

## 🐛 If Something Goes Wrong

### Pipeline Fails?

1. Click on the failed job
2. Expand the failed step
3. Read the error message
4. Check: `CD_DEBUG_GUIDE.md` for solutions

### Common Quick Fixes:

**"ACR authentication failed"**
→ Check `ACR_USERNAME` and `ACR_PASSWORD` secrets

**"SSH connection refused"**
→ Check `VM_PUBLIC_IP` and `SSH_PRIVATE_KEY` secrets
→ Test: `ssh azureuser@YOUR_VM_IP`

**"Ansible playbook failed"**
→ SSH to VM and check: `sudo systemctl status docker`

**"Health check timeout"**
→ SSH to VM and check: `docker logs taskmanager-backend`

**Full Troubleshooting:**
- See: `CD_DEBUG_GUIDE.md` (comprehensive guide)
- See: `SECRETS_SETUP.md` (secrets configuration)

---

## 🎯 Timeline

| Step | Action | Time | Status |
|------|--------|------|--------|
| 1 | Commit & push changes | 2 min | ⏭️ |
| 2 | Configure GitHub secrets | 10-15 min | ⏭️ |
| 3 | Verify secrets | 2 min | ⏭️ |
| 4 | Run CD pipeline | - | ⏭️ |
| 5 | Monitor deployment | 10-15 min | ⏭️ |
| 6 | Verify & test | 5 min | ⏭️ |
| **Total** | | **~30-45 min** | |

---

## 📊 What Happens During Deployment

```
┌─────────────────────────────────────────────────┐
│ 1. GitHub Actions Triggered                    │
│    - On push to main                            │
│    - Or manual workflow dispatch                │
└─────────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────────┐
│ 2. Build Docker Images                          │
│    - Backend: Node.js app                       │
│    - Frontend: React app with Nginx             │
│    - Both pushed to Azure Container Registry    │
└─────────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────────┐
│ 3. Ansible Connects to VM                       │
│    - SSH authentication                         │
│    - Runs setup-server.yml playbook             │
└─────────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────────┐
│ 4. Server Configuration                         │
│    - Install Docker & Docker Compose            │
│    - Login to Azure Container Registry          │
│    - Pull latest images                         │
│    - Create docker-compose.yml                  │
└─────────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────────┐
│ 5. Deploy Application                           │
│    - Start PostgreSQL database                  │
│    - Start backend API (port 3000)              │
│    - Start frontend (port 80)                   │
│    - Configure firewall                         │
└─────────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────────┐
│ 6. Verify Health Checks                         │
│    - Backend: /health endpoint                  │
│    - Frontend: HTTP 200                         │
│    - API: /api/tasks endpoint                   │
└─────────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────────┐
│ 7. ✅ Deployment Complete!                      │
│    - App live at http://YOUR_VM_IP              │
│    - API at http://YOUR_VM_IP:3000              │
└─────────────────────────────────────────────────┘
```

---

## 📚 Documentation Quick Links

- **Debugging:** [CD_DEBUG_GUIDE.md](./CD_DEBUG_GUIDE.md)
- **Secrets Setup:** [SECRETS_SETUP.md](./SECRETS_SETUP.md)
- **Summary:** [CD_FIXES_SUMMARY.md](./CD_FIXES_SUMMARY.md)
- **Ansible:** [ansible/README.md](./ansible/README.md)

---

## 🎉 After Successful Deployment

Once everything works:

1. **Document your VM IP** for future reference
2. **Bookmark your app:** `http://YOUR_VM_IP`
3. **Share with team** (if applicable)
4. **Test thoroughly** - create multiple tasks, test all features

### Future Updates Are Automatic!

```bash
# Just commit and push - that's it!
git add .
git commit -m "feat: add new feature"
git push origin main

# Pipeline auto-deploys in 10-15 minutes
# Check: http://YOUR_VM_IP
```

---

## 🔒 Security Reminder

**Your app is now PUBLIC on the internet!**

Consider:
- [ ] Set strong database password (not default)
- [ ] Add HTTPS/SSL certificate (Let's Encrypt)
- [ ] Configure authentication for production use
- [ ] Review firewall rules
- [ ] Enable Azure security features
- [ ] Regular security updates

---

## 🚀 **START HERE:**

**Step 1:** Commit and push changes ↑
**Step 2:** Configure secrets ↑
**Step 3:** Run pipeline ↑

**You got this! 🎯**

---

**Last Updated:** 2025-11-22  
**Version:** 1.0  
**Status:** Ready to Deploy ✅
