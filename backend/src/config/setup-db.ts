import pool from './database';

const setupDatabase = async () => {
    try {
        console.log('🔧 Setting up database...');

        // Create tasks table
        await pool.query(`
      CREATE TABLE IF NOT EXISTS tasks (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
        title VARCHAR(255) NOT NULL,
        description TEXT,
        status VARCHAR(50) DEFAULT 'TODO',
        priority VARCHAR(50) DEFAULT 'MEDIUM',
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
    `);

        console.log('✅ Tasks table created successfully');

        // Create updated_at trigger function
        await pool.query(`
      CREATE OR REPLACE FUNCTION update_updated_at_column()
      RETURNS TRIGGER AS $$
      BEGIN
        NEW.updated_at = CURRENT_TIMESTAMP;
        RETURN NEW;
      END;
      $$ language 'plpgsql';
    `);

        // Create trigger for tasks table
        await pool.query(`
      DROP TRIGGER IF EXISTS update_tasks_updated_at ON tasks;
      CREATE TRIGGER update_tasks_updated_at
        BEFORE UPDATE ON tasks
        FOR EACH ROW
        EXECUTE FUNCTION update_updated_at_column();
    `);

        console.log('✅ Database triggers created successfully');

        // Insert sample data
        await pool.query(`
      INSERT INTO tasks (title, description, status, priority)
      VALUES 
        ('Setup DevOps Pipeline', 'Configure GitHub Actions, Terraform, and Ansible', 'IN_PROGRESS', 'HIGH'),
        ('Implement Backend API', 'Create Express REST API with TypeScript', 'DONE', 'HIGH'),
        ('Create Frontend UI', 'Build React frontend with Vite', 'TODO', 'MEDIUM')
      ON CONFLICT DO NOTHING;
    `);

        console.log('✅ Sample data inserted successfully');
        console.log('✅ Database setup complete!');

        process.exit(0);
    } catch (error) {
        console.error('❌ Database setup failed:', error);
        process.exit(1);
    }
};

setupDatabase();
