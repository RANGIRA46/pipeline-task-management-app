# 🚀 Quick Run Guide

## Running the Task Manager Application

I've started installing the dependencies for you. Here's what's happening:

### Current Status:
- ✅ Environment files copied (`.env` created)
- 🔄 Backend dependencies installing... (`npm install` in backend/)
- 🔄 Frontend dependencies installing... (`npm install` in frontend/)

---

## Option 1: Using Docker Compose (Easiest - If you have Docker)

If you have Docker Desktop installed and running:

```bash
# From the project root
docker-compose up --build
```

This will start:
- 🗄️ PostgreSQL database (port 5432)
- 🚂 Backend API (port 3000)
- ⚛️ Frontend (port 5173)

**Access**: http://localhost:5173

---

## Option 2: Run Locally (Without Docker)

### Prerequisites:
- ✅ Node.js 18+ installed
- ✅ PostgreSQL 15 installed and running

### Step 1: Install Dependencies (In Progress)

```bash
# Backend (RUNNING NOW)
cd backend
npm install

# Frontend (RUNNING NOW)
cd frontend
npm install
```

### Step 2: Setup PostgreSQL Database

Make sure PostgreSQL is running, then:

```bash
cd backend

# Update .env file with your PostgreSQL credentials
# DATABASE_URL=postgresql://username:password@localhost:5432/taskmanager

# Create database and tables
npm run db:setup
```

### Step 3: Start Backend

```bash
# In backend directory
npm run dev

# You should see:
# 🚀 Task Manager API Server Started
# Server running on: http://localhost:3000
```

### Step 4: Start Frontend (New Terminal)

```bash
# In frontend directory
npm run dev

# You should see:
# VITE ready in Xms
# Local: http://localhost:5173/
```

### Step 5: Access the Application

Open your browser: **http://localhost:5173**

---

## What to Expect

### Backend (http://localhost:3000)
- ✅ Health check: http://localhost:3000/health
- ✅ API endpoints: http://localhost:3000/api/tasks

### Frontend (http://localhost:5173)
- 🎨 Beautiful dark theme UI
- 📋 Task list with create/edit/delete
- 📊 Statistics dashboard
- 🔍 Filter by status

---

## Troubleshooting

### If PostgreSQL is not installed:

**Windows:**
1. Download PostgreSQL 15: https://www.postgresql.org/download/windows/
2. Install with default settings
3. Remember the password you set for the `postgres` user
4. Update `backend/.env`:
   ```
   DATABASE_URL=postgresql://postgres:YOUR_PASSWORD@localhost:5432/taskmanager
   ```

**Or use Docker for PostgreSQL only:**
```bash
docker run --name taskmanager-db -e POSTGRES_USER=devops -e POSTGRES_PASSWORD=devops123 -e POSTGRES_DB=devops_app -p 5432:5432 -d postgres:15-alpine
```

### If npm install fails:

Try clearing npm cache:
```bash
npm cache clean --force
npm install
```

### If ports are in use:

Change ports in `.env` files:
- Backend: `.env` → `PORT=3001`
- Frontend: `vite.config.ts` → change port to `5174`

---

## Next Steps After Installation

1. **Wait for npm install to complete** (both backend and frontend)
2. **Setup PostgreSQL** (if not using Docker)
3. **Run the database setup**: `cd backend && npm run db:setup`
4. **Start backend**: `cd backend && npm run dev`
5. **Start frontend**: `cd frontend && npm run dev` (in new terminal)
6. **Access**: http://localhost:5173

---

## Commands Summary

```bash
# Check if installations are complete
cd backend && npm list --depth=0
cd frontend && npm list --depth=0

# Run backend
cd backend && npm run dev

# Run frontend (new terminal)
cd frontend && npm run dev

# Run tests
cd backend && npm test
cd frontend && npm test
```

---

## Estimated Time
- Dependencies installation: 2-5 minutes
- Database setup: 30 seconds
- Starting services: 10 seconds

**Total: ~5-10 minutes for first run**

---

## Current Command Status

The following commands are currently running:

1. ✅ `.env` files created
2. 🔄 `npm install` in backend/ (installing dependencies)
3. 🔄 `npm install` in frontend/ (installing dependencies)

Check the terminal output to see when they complete!

---

**Once npm install completes, follow Step 2-5 above to run the application!**
