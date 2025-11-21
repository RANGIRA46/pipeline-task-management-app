# Backend API

Task Management Application - Backend API

## Tech Stack
- Node.js
- Express
- TypeScript
- PostgreSQL
- Prisma ORM
- Jest for testing

## Getting Started

```bash
# Install dependencies
npm install

# Setup database
npm run db:setup

# Run development server
npm run dev

# Run tests
npm test

# Build for production
npm run build

# Start production server
npm start
```

## Project Structure

```
backend/
├── src/
│   ├── controllers/   # Route controllers
│   ├── models/        # Data models
│   ├── routes/        # API routes
│   ├── middleware/    # Express middleware
│   ├── services/      # Business logic
│   ├── utils/         # Utility functions
│   ├── config/        # Configuration
│   └── server.ts      # Server entry point
├── tests/             # Test files
│   ├── unit/
│   └── integration/
├── Dockerfile
└── package.json
```

## API Endpoints

### Tasks
- `GET /api/tasks` - Get all tasks
- `GET /api/tasks/:id` - Get a task by ID
- `POST /api/tasks` - Create a new task
- `PUT /api/tasks/:id` - Update a task
- `DELETE /api/tasks/:id` - Delete a task

### Health
- `GET /health` - Health check endpoint

## Environment Variables

Create a `.env` file:

```
DATABASE_URL=postgresql://user:password@localhost:5432/taskmanager
PORT=3000
NODE_ENV=development
```

## Docker

```bash
# Build image
docker build -t task-manager-backend .

# Run container
docker run -p 3000:3000 \
  -e DATABASE_URL=postgresql://... \
  task-manager-backend
```

## Testing

```bash
# Run all tests
npm test

# Run with coverage
npm run test:coverage

# Run specific test file
npm test -- tasks.test.ts
```
