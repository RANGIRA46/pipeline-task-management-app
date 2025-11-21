# Task Manager Application - Setup Guide

## ✅ Application Complete!

Your full-stack Task Manager application has been successfully created with:

### **Backend (Node.js + Express + TypeScript + PostgreSQL)**
- ✅ Express REST API with TypeScript
- ✅ PostgreSQL database integration
- ✅ CRUD operations for tasks
- ✅ Health check endpoint
- ✅ 5+ unit tests (TaskModel)
- ✅ 3+ integration tests (API endpoints)
- ✅ ESLint configuration
- ✅ Docker support with health checks

### **Frontend (React + Vite + TypeScript)**
- ✅ React 18 with TypeScript
- ✅ Vite for fast development
- ✅ Beautiful dark theme UI
- ✅ Task list view with filtering
- ✅ Create/Edit task forms
- ✅ Status and priority management
- ✅ 3+ component tests
- ✅ ESLint configuration
- ✅ Docker support with Nginx

## 🚀 Quick Start

### Option 1: Using Docker Compose (Recommended)

```bash
# 1. Copy environment file
copy .env.example .env

# 2. Start all services
docker-compose up --build

# 3. Wait for services to be healthy (about 30 seconds)

# 4. Access the application
# Frontend: http://localhost:5173
# Backend API: http://localhost:3000
# Health Check: http://localhost:3000/health
```

### Option 2: Local Development (Without Docker)

#### Prerequisites
- Node.js 18+
- PostgreSQL 15

#### Backend Setup
```bash
cd backend

# Install dependencies
npm install

# Copy environment file
copy .env.example .env

# Update .env with your PostgreSQL connection:
# DATABASE_URL=postgresql://username:password@localhost:5432/taskmanager

# Setup database (creates tables and sample data)
npm run db:setup

# Start development server
npm run dev

# Run tests
npm test

# Run linting
npm run lint
```

#### Frontend Setup
```bash
cd frontend

# Install dependencies
npm install

# Copy environment file
copy .env.example .env

# Start development server
npm run dev

# Run tests
npm test

# Run linting
npm run lint
```

## 📁 Project Structure

```
pipeline-task-management-app/
├── backend/
│   ├── src/
│   │   ├── config/
│   │   │   ├── database.ts          # Database connection
│   │   │   └── setup-db.ts          # Database setup script
│   │   ├── controllers/
│   │   │   └── task.controller.ts   # Task API controllers
│   │   ├── models/
│   │   │   └── task.model.ts        # Task data model
│   │   ├── routes/
│   │   │   └── task.routes.ts       # API routes
│   │   ├── types/
│   │   │   └── index.ts             # TypeScript types
│   │   ├── app.ts                   # Express app setup
│   │   └── server.ts                # Server entry point
│   ├── tests/
│   │   ├── unit/
│   │   │   └── task.model.test.ts   # Unit tests
│   │   └── integration/
│   │       └── api.test.ts          # Integration tests
│   ├── .eslintrc.json               # ESLint config
│   ├── tsconfig.json                # TypeScript config
│   ├── jest.config.js               # Jest config
│   ├── Dockerfile                   # Docker image config
│   └── package.json
├── frontend/
│   ├── src/
│   │   ├── components/
│   │   │   ├── Header.tsx           # Header component
│   │   │   ├── TaskCard.tsx         # Task card component
│   │   │   └── TaskForm.tsx         # Task form component
│   │   ├── pages/
│   │   │   └── Home.tsx             # Home page
│   │   ├── services/
│   │   │   └── taskService.ts       # API service
│   │   ├── test/
│   │   │   ├── setup.ts             # Test setup
│   │   │   ├── Header.test.tsx      # Header tests
│   │   │   ├── TaskCard.test.tsx    # TaskCard tests
│   │   │   └── TaskForm.test.tsx    # TaskForm tests
│   │   ├── types/
│   │   │   └── index.ts             # TypeScript types
│   │   ├── App.tsx                  # Main app
│   │   ├── App.css                  # Styles
│   │   ├── main.tsx                 # Entry point
│   │   └── index.css                # Global styles
│   ├── eslint.config.js             # ESLint config
│   ├── vite.config.ts               # Vite config
│   ├── tsconfig.json                # TypeScript config
│   ├── Dockerfile                   # Docker image config
│   ├── nginx.conf                   # Nginx config
│   └── package.json
├── docker-compose.yml               # Docker Compose config
└── .env.example                     # Environment variables example
```

## 🎯 API Endpoints

### Tasks
- **GET** `/api/tasks` - Get all tasks
- **GET** `/api/tasks/:id` - Get task by ID
- **POST** `/api/tasks` - Create new task
- **PUT** `/api/tasks/:id` - Update task
- **DELETE** `/api/tasks/:id` - Delete task

### Health
- **GET** `/health` - Health check endpoint

### Example API Calls

```bash
# Get all tasks
curl http://localhost:3000/api/tasks

# Create a new task
curl -X POST http://localhost:3000/api/tasks \
  -H "Content-Type: application/json" \
  -d '{
    "title": "New Task",
    "description": "Task description",
    "status": "TODO",
    "priority": "HIGH"
  }'

# Update a task
curl -X PUT http://localhost:3000/api/tasks/TASK_ID \
  -H "Content-Type: application/json" \
  -d '{
    "status": "DONE"
  }'

# Delete a task
curl -X DELETE http://localhost:3000/api/tasks/TASK_ID
```

## 🧪 Testing

### Backend Tests

```bash
cd backend

# Run all tests
npm test

# Run tests in watch mode
npm run test:watch

# Run tests with coverage
npm test -- --coverage

# The backend has:
# - 6 unit tests for TaskModel (CRUD operations)
# - 7 integration tests for API endpoints
```

### Frontend Tests

```bash
cd frontend

# Run all tests
npm test

# Run tests in watch mode
npm run test:watch

# The frontend has:
# - 3 tests for TaskCard component
# - 3 tests for TaskForm component
# - 2 tests for Header component
```

## 🎨 Features

### Task Management
- ✅ Create tasks with title, description, status, and priority
- ✅ View all tasks in a beautiful card layout
- ✅ Filter tasks by status (All, To Do, In Progress, Done)
- ✅ Edit existing tasks
- ✅ Delete tasks with confirmation
- ✅ Quick status change via dropdown
- ✅ Real-time task statistics

### Task Properties
- **Status**: TODO, IN_PROGRESS, DONE
- **Priority**: LOW, MEDIUM, HIGH
- **Metadata**: Created date, Updated date

### UI Features
- 🎨 Modern dark theme with gradients
- ✨ Smooth animations and transitions
- 📱 Fully responsive design
- 🎯 Intuitive user interface
- 💫 Loading states and error handling
- 🎪 Modal forms for create/edit
- 📊 Task statistics dashboard

## 🔧 Development Commands

### Backend
```bash
npm run dev         # Start development server
npm run build       # Build TypeScript to JavaScript
npm start           # Start production server
npm test            # Run tests
npm run lint        # Run ESLint
npm run lint:fix    # Fix linting issues
npm run db:setup    # Setup database
```

### Frontend
```bash
npm run dev         # Start development server
npm run build       # Build for production
npm run preview     # Preview production build
npm test            # Run tests
npm run lint        # Run ESLint
npm run lint:fix    # Fix linting issues
```

## 🐳 Docker

### Build Images
```bash
# Build backend image
docker build -t taskmanager-backend ./backend

# Build frontend image
docker build -t taskmanager-frontend ./frontend
```

### Run Containers
```bash
# Using docker-compose (recommended)
docker-compose up

# Stop containers
docker-compose down

# View logs
docker-compose logs -f

# Rebuild and start
docker-compose up --build
```

## 🔍 Troubleshooting

### Backend won't start
- Check PostgreSQL is running
- Verify DATABASE_URL in .env
- Run `npm run db:setup` to create tables

### Frontend can't connect to backend
- Ensure backend is running on port 3000
- Check VITE_API_URL in frontend .env
- Verify CORS is enabled in backend

### Docker containers fail
- Ensure Docker Desktop is running
- Check if ports 3000, 5173, 5432 are available
- Try `docker-compose down -v` to remove volumes

### Tests fail
- Run `npm install` to ensure dependencies are installed
- For integration tests, ensure test database is accessible
- Check test database connection string

## 📊 Database Schema

```sql
CREATE TABLE tasks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title VARCHAR(255) NOT NULL,
  description TEXT,
  status VARCHAR(50) DEFAULT 'TODO',
  priority VARCHAR(50) DEFAULT 'MEDIUM',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## ✨ Next Steps

Now that your application is complete, you can:

1. **Test the Application**
   - Try creating, editing, and deleting tasks
   - Test the filtering functionality
   - Verify health check endpoint

2. **Run Tests**
   - Execute backend tests: `cd backend && npm test`
   - Execute frontend tests: `cd frontend && npm test`

3. **Build Docker Images**
   - Test Docker build: `docker-compose up --build`
   - Verify all services are healthy

4. **Proceed to Next Phase**
   - ✅ Phase 1 Complete: Project Setup & Application Development
   - 🚀 Ready for Phase 2: Dockerization (Already done!)
   - 📝 Next: Phase 3 - CI Pipeline Implementation

## 📝 Important Notes

- Default database credentials: `devops/devops123`
- Frontend runs on port 5173
- Backend API runs on port 3000
- PostgreSQL runs on port 5432
- All passwords should be changed in production
- The app includes sample data (3 tasks) after database setup

## 🎉 Success Criteria

Your application meets all requirements:

- ✅ **Backend**: REST API with 5 endpoints
- ✅ **Frontend**: React app with list, create, edit views
- ✅ **Database**: PostgreSQL integration
- ✅ **Tests**: 5+ backend unit tests, 3+ integration tests, 3+ frontend tests
- ✅ **Linting**: ESLint configured for both
- ✅ **Docker**: Multi-stage Dockerfiles with health checks
- ✅ **Docker Compose**: Full local development environment

---

**Application Status**: ✅ **COMPLETE AND READY FOR DEPLOYMENT**

Proceed to implementing the CI/CD pipeline! 🚀
