import app from './app';
import dotenv from 'dotenv';

dotenv.config();

const PORT = process.env.PORT || 3000;

const server = app.listen(PORT, () => {
    console.log(`
╔═══════════════════════════════════════════╗
║   🚀 Task Manager API Server Started     ║
╚═══════════════════════════════════════════╝

📍 Server running on: http://localhost:${PORT}
🏥 Health check: http://localhost:${PORT}/health
📚 API endpoints: http://localhost:${PORT}/api/tasks
🌍 Environment: ${process.env.NODE_ENV || 'development'}

Press Ctrl+C to stop the server
  `);
});

// Graceful shutdown
process.on('SIGTERM', () => {
    console.log('SIGTERM signal received: closing HTTP server');
    server.close(() => {
        console.log('HTTP server closed');
        process.exit(0);
    });
});

process.on('SIGINT', () => {
    console.log('\nSIGINT signal received: closing HTTP server');
    server.close(() => {
        console.log('HTTP server closed');
        process.exit(0);
    });
});

export default server;
