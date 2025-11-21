# 🐳 Docker Testing Guide

## Quick Start - Test Docker Setup Locally

This guide will help you test the complete Dockerized application stack (Backend API + Frontend UI + PostgreSQL Database).

---

## ✅ Prerequisites

1. **Docker Desktop** must be installed and running
   - Download: https://www.docker.com/products/docker-desktop
   - Verify installation: Open PowerShell and run:
     ```powershell
     docker --version
     docker compose version
     ```

2. **Ports must be available**:
   - Port `80` - Frontend (Nginx)
   - Port `4000` - Backend API
   - Port `5432` - PostgreSQL Database

---

## 🚀 Step-by-Step Testing Instructions

### **Step 1: Create Environment File**

Create a file named `.env` in `infra/docker/` directory with the following content:

```env
# Database Configuration
POSTGRES_USER=tm_user
POSTGRES_PASSWORD=tm_password
POSTGRES_DB=tm_db

# Backend Configuration
DATABASE_URL=postgresql://tm_user:tm_password@db:5432/tm_db
BACKEND_PORT=4000
NODE_ENV=production

# Frontend Configuration
VITE_API_URL=http://localhost:4000
```

**Or use the example file**:
```powershell
cd infra\docker
copy .env.example .env
```

---

### **Step 2: Start Docker Desktop**

Make sure Docker Desktop is running. You should see the Docker icon in your system tray.

---

### **Step 3: Build and Start All Services**

Open PowerShell or CMD in the project root directory and run:

```powershell
cd infra\docker
docker compose up --build
```

**What happens**:
- ✅ Downloads base images (postgres:15-alpine, node:20-alpine, nginx:stable-alpine)
- ✅ Builds backend Docker image (compiles TypeScript)
- ✅ Builds frontend Docker image (Vite production build)
- ✅ Starts PostgreSQL database
- ✅ Initializes database with schema and sample data
- ✅ Starts backend API (waits for DB to be healthy)
- ✅ Starts frontend UI (waits for backend to be healthy)

**Expected Output**:
```
[+] Building...
[+] Running 4/4
 ✔ Network infra_app-network  Created
 ✔ Container tm-db            Started
 ✔ Container tm-backend       Started
 ✔ Container tm-frontend      Started
```

---

### **Step 4: Verify Services Are Running**

#### Check Container Status
```powershell
docker compose ps
```

Expected output:
```
NAME          STATUS          PORTS
tm-db         Up (healthy)    5432->5432
tm-backend    Up (healthy)    4000->4000
tm-frontend   Up              80->80
```

#### Check Logs
```powershell
# All services
docker compose logs -f

# Specific service
docker compose logs -f backend
docker compose logs -f frontend
docker compose logs -f db
```

---

### **Step 5: Test the Application**

#### **Frontend (Browser)**
Open your browser and navigate to:
```
http://localhost
```

You should see the Task Manager UI with:
- ✅ Task list displaying sample tasks
- ✅ Ability to create, update, delete tasks
- ✅ Filter tasks by status/priority

#### **Backend API (Direct Testing)**

**Health Check**:
```powershell
curl http://localhost:4000/health
```

Expected response:
```json
{
  "status": "healthy",
  "timestamp": "2025-11-21T...",
  "uptime": 123.45,
  "database": "connected"
}
```

**Get All Tasks**:
```powershell
curl http://localhost:4000/api/tasks
```

**Create a New Task** (PowerShell):
```powershell
$body = @{
    title = "Test Task from PowerShell"
    description = "Testing Docker setup"
    status = "TODO"
    priority = "HIGH"
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:4000/api/tasks" -Method Post -Body $body -ContentType "application/json"
```

#### **Database (Direct Access)**

Connect to PostgreSQL using any DB client (DBeaver, pgAdmin, etc.):
- **Host**: `localhost`
- **Port**: `5432`
- **Database**: `tm_db`
- **Username**: `tm_user`
- **Password**: `tm_password`

Or use Docker exec:
```powershell
docker compose exec db psql -U tm_user -d tm_db
```

Then run SQL:
```sql
SELECT * FROM tasks;
```

---

## 🛑 Stop the Stack

### **Stop (preserves data)**
```powershell
docker compose down
```

### **Stop and remove volumes (deletes database data)**
```powershell
docker compose down -v
```

---

## 🔧 Common Issues & Solutions

### **Issue 1: Port Already in Use**

**Error**:
```
Error: bind: address already in use
```

**Solution**:
```powershell
# Find what's using the port
netstat -ano | findstr :80
netstat -ano | findstr :4000

# Kill the process (replace PID with actual)
taskkill /PID <PID> /F
```

Or change ports in `docker-compose.yml`:
```yaml
ports:
  - "8080:80"     # Frontend (instead of 80:80)
  - "4001:4000"   # Backend (instead of 4000:4000)
```

---

### **Issue 2: Build Fails**

**Error**:
```
ERROR [build XX/XX] ...
```

**Solution**:
```powershell
# Clean Docker cache
docker builder prune -a

# Rebuild without cache
docker compose build --no-cache
docker compose up
```

---

### **Issue 3: Database Connection Refused**

**Error (in backend logs)**:
```
❌ Database connection failed
```

**Solution**:
```powershell
# Check if DB is healthy
docker compose ps

# View DB logs
docker compose logs db

# Restart DB
docker compose restart db

# Wait for health check (10-15 seconds)
docker compose ps
```

---

### **Issue 4: Frontend Shows "Cannot Connect to Backend"**

**Solution**:

1. Check backend is running:
   ```powershell
   curl http://localhost:4000/health
   ```

2. Check browser console (F12) for CORS errors

3. Verify `VITE_API_URL` in `.env`:
   ```env
   VITE_API_URL=http://localhost:4000
   ```

4. Rebuild frontend:
   ```powershell
   docker compose up --build frontend
   ```

---

### **Issue 5: Docker Desktop Not Running**

**Error**:
```
error during connect: This error may indicate that the docker daemon is not running
```

**Solution**:
1. Start Docker Desktop from Start Menu
2. Wait for Docker icon in system tray to show "Docker Desktop is running"
3. Try again

---

## 🧪 Testing Checklist

After starting the stack, verify:

- [ ] All 3 containers are running (`docker compose ps`)
- [ ] Database shows "healthy" status
- [ ] Backend shows "healthy" status
- [ ] Frontend accessible at `http://localhost`
- [ ] Backend  health endpoint returns 200: `http://localhost:4000/health`
- [ ] API returns tasks: `http://localhost:4000/api/tasks`
- [ ] Can create a new task via UI
- [ ] Can update a task via UI
- [ ] Can delete a task via UI
- [ ] Database persists data (check with `docker compose restart`)

---

## 📊 Viewing Container Metrics

### **Resource Usage**
```powershell
docker stats
```

Shows:
- CPU usage
- Memory usage
- Network I/O
- Container IDs

### **Inspect Specific Container**
```powershell
docker inspect tm-backend
docker inspect tm-frontend
docker inspect tm-db
```

---

## 🔍 Advanced Debugging

### **Enter a Running Container**
```powershell
# Backend
docker compose exec backend sh

# Frontend
docker compose exec frontend sh

# Database
docker compose exec db sh
```

### **View Container Logs (Last 100 Lines)**
```powershell
docker compose logs --tail=100 backend
```

### **Follow Real-Time Logs**
```powershell
docker compose logs -f --tail=50
```

---

## 🎯 What to Test

### **Functional Testing**

1. **CRUD Operations**:
   - ✅ Create a task
   - ✅ Read all tasks
   - ✅ Read specific task by ID
   - ✅ Update a task
   - ✅ Delete a task

2. **Data Persistence**:
   ```powershell
   # Create a task, then restart
   docker compose restart backend
   
   # Verify task still exists
   curl http://localhost:4000/api/tasks
   ```

3. **Health Checks**:
   - Backend: `http://localhost:4000/health`
   - Database connection test (via backend health endpoint)

### **Performance Testing**

```powershell
# Stress test (requires Apache Bench or similar)
ab -n 1000 -c 10 http://localhost:4000/api/tasks
```

---

## 📝 Next Steps After Successful Docker Test

Once Docker works locally:

1. ✅ **Proceed with Azure Service Principal setup**
2. ✅ **Fill in `terraform/terraform.tfvars`**
3. ✅ **Run Terraform to provision Azure infrastructure**
4. ✅ **Push Docker images to Azure Container Registry**
5. ✅ **Deploy containers to Azure VM** (via Ansible)

---

## 🚀 Quick Commands Reference

```powershell
# Start services
docker compose up -d

# View logs
docker compose logs -f

# Check status
docker compose ps

# Restart specific service
docker compose restart backend

# Stop all
docker compose down

# Stop and remove volumes
docker compose down -v

# Rebuild and restart
docker compose up --build -d

# View resource usage
docker stats

# Execute command in container
docker compose exec backend npm test
```

---

## ✅ Success Criteria

**Docker setup is successful when**:
- ✅ All 3 containers start without errors
- ✅ Health checks pass for backend and database
- ✅ Frontend loads in browser at `http://localhost`
- ✅ API endpoints respond correctly
- ✅ Can create, read, update, delete tasks via UI
- ✅ Data persists across container restarts

---

**Created**: 2025-11-21  
**For questions, check**: `infra/docker/README.md`
