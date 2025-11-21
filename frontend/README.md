# Frontend Application

Task Management Application - Frontend

## Tech Stack
- React 18
- TypeScript
- Vite
- React Router
- Axios for API calls

## Getting Started

```bash
# Install dependencies
npm install

# Run development server
npm run dev

# Run tests
npm test

# Build for production
npm run build

# Preview production build
npm run preview
```

## Project Structure

```
frontend/
├── src/
│   ├── components/     # Reusable components
│   ├── pages/         # Page components
│   ├── services/      # API services
│   ├── hooks/         # Custom hooks
│   ├── types/         # TypeScript types
│   ├── utils/         # Utility functions
│   ├── App.tsx        # Main app component
│   └── main.tsx       # Entry point
├── public/            # Static assets
├── Dockerfile         # Docker configuration
├── nginx.conf         # Nginx configuration
└── package.json
```

## Available Scripts

- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm run preview` - Preview production build
- `npm test` - Run tests
- `npm run lint` - Run ESLint
- `npm run lint:fix` - Fix linting issues

## Environment Variables

Create a `.env` file:

```
VITE_API_URL=http://localhost:3000
```

## Docker

```bash
# Build image
docker build -t task-manager-frontend .

# Run container
docker run -p 80:80 task-manager-frontend
```
