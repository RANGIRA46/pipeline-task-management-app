# 🚀 Simple Setup & Run Instructions

## Prerequisites
- ✅ Node.js 18+ installed
- ✅ PostgreSQL 15 installed (or Docker)

## Quick Start (3 Easy Steps)

### Step 1: Install Dependencies
Double-click: **`install-dependencies.bat`**

This will install all npm packages for backend and frontend.
⏱️ Takes: 2-5 minutes

---

### Step 2: Setup Database
Double-click: **`setup-database.bat`**

**Important**: Make sure PostgreSQL is running first!

If you don't have PostgreSQL:
- **Download**: https://www.postgresql.org/download/windows/
- **Or use Docker**: 
  ```bash
  docker run --name taskmanager-db -e POSTGRES_USER=devops -e POSTGRES_PASSWORD=devops123 -e POSTGRES_DB=devops_app -p 5432:5432 -d postgres:15-alpine
  ```

⏱️ Takes: 30 seconds

---

### Step 3: Run the Application
Double-click: **`run-app.bat`**

This will:
1. Start the backend server (http://localhost:3000)
2. Start the frontend server (http://localhost:5173)
3. Open your browser automatically

⏱️ Takes: 10 seconds

---

## Alternative: Manual Commands

If you prefer running commands manually:

### Terminal 1: Backend
```bash
cd backend
npm install
npm run db:setup
npm run dev
```

### Terminal 2: Frontend
```bash
cd frontend
npm install
npm run dev
```

### Browser
Open: http://localhost:5173

---

## Configuration

### Backend (.env file in backend/)
```env
PORT=3000
NODE_ENV=development
DATABASE_URL=postgresql://devops:devops123@localhost:5432/devops_app
CORS_ORIGIN=http://localhost:5173
```

### Frontend (.env file in frontend/)
```env
VITE_API_URL=http://localhost:3000
```

---

## Troubleshooting

### "Cannot connect to database"
1. Make sure PostgreSQL is running
2. Check credentials in `backend/.env`
3. Try: `psql -U postgres` to test connection

### "Port already in use"
Change ports in `.env` files:
- Backend: `PORT=3001`
- Frontend: Update `vite.config.ts`

### "npm not found"
Install Node.js from: https://nodejs.org/

---

## What You'll See

### Backend Terminal
```
╔═══════════════════════════════════════════╗
║   🚀 Task Manager API Server Started     ║
╚═══════════════════════════════════════════╝

📍 Server running on: http://localhost:3000
🏥 Health check: http://localhost:3000/health
```

### Frontend Terminal
```
VITE v5.0.11  ready in 523 ms

➜  Local:   http://localhost:5173/
➜  Network: use --host to expose
```

### Browser (http://localhost:5173)
🎨 Beautiful Task Manager UI with:
- Statistics dashboard
- Task list
- Create/Edit forms
- Filtering options

---

## Testing

```bash
# Backend tests
cd backend
npm test

# Frontend tests
cd frontend
npm test
```

---

## Stop the Application

1. Close the backend terminal window
2. Close the frontend terminal window

Or press `Ctrl+C` in each terminal.

---

## Need Help?

Check:
- **RUN_GUIDE.md** - Detailed instructions
- **APPLICATION_GUIDE.md** - Complete documentation
- **VISUAL_GUIDE.md** - Visual overview

---

**Enjoy your Task Manager! 🎉**
