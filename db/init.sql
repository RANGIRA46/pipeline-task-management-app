-- =================================================
-- Task Management Application - Database Initialization
-- =================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Create tasks table
CREATE TABLE IF NOT EXISTS tasks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title VARCHAR(255) NOT NULL,
  description TEXT,
  status VARCHAR(50) DEFAULT 'TODO',
  priority VARCHAR(50) DEFAULT 'MEDIUM',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create index for faster queries
CREATE INDEX IF NOT EXISTS idx_tasks_status ON tasks(status);
CREATE INDEX IF NOT EXISTS idx_tasks_priority ON tasks(priority);
CREATE INDEX IF NOT EXISTS idx_tasks_created_at ON tasks(created_at DESC);

-- Insert sample data
INSERT INTO tasks (title, description, status, priority)
VALUES 
  ('Setup DevOps Pipeline', 'Configure GitHub Actions, Terraform, and Ansible', 'IN_PROGRESS', 'HIGH'),
  ('Implement Backend API', 'Create Express REST API with TypeScript', 'DONE', 'HIGH'),
  ('Create Frontend UI', 'Build React frontend with Vite', 'TODO', 'MEDIUM'),
  ('Configure Docker', 'Create Docker and Docker Compose configurations', 'IN_PROGRESS', 'HIGH'),
  ('Deploy to Azure', 'Provision infrastructure and deploy application', 'TODO', 'MEDIUM')
ON CONFLICT DO NOTHING;

-- Log success
DO $$
BEGIN
  RAISE NOTICE 'Database initialized successfully!';
END $$;
