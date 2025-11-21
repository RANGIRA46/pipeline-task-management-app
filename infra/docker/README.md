# Docker Configuration

This directory contains Docker and Docker Compose configurations for local development and containerized deployments.

## 📦 Services

### 1. Backend API
- **Image**: Custom Node.js 20 Alpine
- **Port**: 4000
- **Dependencies**: PostgreSQL database

### 2. Frontend UI
- **Image**: Nginx Alpine (serves static React build)
- **Port**: 80
- **Dependencies**: Backend API

### 3. Database
- **Image**: PostgreSQL 15 Alpine
- **Port**: 5432
- **Data**: Persisted in Docker volume `db-data`

## 🚀 Usage

### Start All Services
```bash
docker compose up --build
```

### Start in Detached Mode
```bash
docker compose up -d --build
```

### View Logs
```bash
docker compose logs -f
docker compose logs -f backend   # specific service
```

### Stop Services
```bash
docker compose down
```

### Stop and Remove Volumes
```bash
docker compose down -v
```

## 🔧 Development

### Rebuild After Code Changes
```bash
docker compose up --build backend   # rebuild only backend
docker compose up --build frontend  # rebuild only frontend
```

### Access Running Containers
```bash
docker compose exec backend sh
docker compose exec db psql -U tm_user -d tm_db
```

### Environment Variables

Create `.env` file in this directory:
```env
# Database
POSTGRES_USER=tm_user
POSTGRES_PASSWORD=tm_password
POSTGRES_DB=tm_db

# Backend
DATABASE_URL=postgresql://tm_user:tm_password@db:5432/tm_db
PORT=4000
NODE_ENV=production

# Frontend
VITE_API_URL=http://localhost:4000
```

## 🏷️ Image Tagging for Azure

### Build for Production
```bash
# Replace <acr_name> with your Azure Container Registry name
docker build -f ../backend/Dockerfile -t <acr_name>.azurecr.io/tm-backend:latest ../..
docker build -f ../frontend/Dockerfile -t <acr_name>.azurecr.io/tm-frontend:latest ../..
```

### Push to ACR
```bash
az acr login --name <acr_name>
docker push <acr_name>.azurecr.io/tm-backend:latest
docker push <acr_name>.azurecr.io/tm-frontend:latest
```

## 🧪 Testing

### Run Backend Tests
```bash
docker compose run --rm backend npm test
```

### Health Checks
- Backend: http://localhost:4000/health
- Frontend: http://localhost

## 📊 Monitoring

### View Resource Usage
```bash
docker stats
```

### Inspect Volumes
```bash
docker volume inspect infra_db-data
```

## 🐛 Troubleshooting

| Issue | Solution |
|-------|----------|
| Port already in use | Stop conflicting services or change ports in `docker-compose.yml` |
| Database connection refused | Ensure `db` service is running: `docker compose ps` |
| Frontend can't reach backend | Check `VITE_API_URL` environment variable |
| Build fails | Clear Docker cache: `docker builder prune` |
