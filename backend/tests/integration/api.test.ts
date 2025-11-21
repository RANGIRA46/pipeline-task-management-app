import request from 'supertest';
import app from '../../src/app';
import pool from '../../src/config/database';

describe('Integration Tests', () => {
    let testTaskId: string;

    beforeAll(async () => {
        // Setup test database
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
    });

    afterAll(async () => {
        // Clean up
        await pool.query('DROP TABLE IF EXISTS tasks CASCADE');
        await pool.end();
    });

    beforeEach(async () => {
        // Clear tasks before each test
        await pool.query('DELETE FROM tasks');
    });

    describe('POST /api/tasks', () => {
        it('should create a new task', async () => {
            const newTask = {
                title: 'Integration Test Task',
                description: 'Testing task creation',
                status: 'TODO',
                priority: 'HIGH'
            };

            const response = await request(app)
                .post('/api/tasks')
                .send(newTask)
                .expect(201);

            expect(response.body.success).toBe(true);
            expect(response.body.data).toHaveProperty('id');
            expect(response.body.data.title).toBe(newTask.title);
            expect(response.body.data.description).toBe(newTask.description);

            testTaskId = response.body.data.id;
        });

        it('should return 400 if title is missing', async () => {
            const invalidTask = {
                description: 'No title provided'
            };

            const response = await request(app)
                .post('/api/tasks')
                .send(invalidTask)
                .expect(400);

            expect(response.body.success).toBe(false);
            expect(response.body.error).toBe('Title is required');
        });
    });

    describe('GET /api/tasks', () => {
        beforeEach(async () => {
            // Create some test tasks
            await request(app).post('/api/tasks').send({
                title: 'Task 1',
                description: 'First task',
                status: 'TODO',
                priority: 'HIGH'
            });

            await request(app).post('/api/tasks').send({
                title: 'Task 2',
                description: 'Second task',
                status: 'IN_PROGRESS',
                priority: 'MEDIUM'
            });
        });

        it('should get all tasks', async () => {
            const response = await request(app)
                .get('/api/tasks')
                .expect(200);

            expect(response.body.success).toBe(true);
            expect(response.body.data).toBeInstanceOf(Array);
            expect(response.body.data.length).toBe(2);
        });
    });

    describe('GET /api/tasks/:id', () => {
        beforeEach(async () => {
            const response = await request(app).post('/api/tasks').send({
                title: 'Specific Task',
                description: 'Task for GET by ID test'
            });
            testTaskId = response.body.data.id;
        });

        it('should get a task by id', async () => {
            const response = await request(app)
                .get(`/api/tasks/${testTaskId}`)
                .expect(200);

            expect(response.body.success).toBe(true);
            expect(response.body.data.id).toBe(testTaskId);
            expect(response.body.data.title).toBe('Specific Task');
        });

        it('should return 404 for non-existent task', async () => {
            const response = await request(app)
                .get('/api/tasks/00000000-0000-0000-0000-000000000000')
                .expect(404);

            expect(response.body.success).toBe(false);
            expect(response.body.error).toBe('Task not found');
        });
    });

    describe('PUT /api/tasks/:id', () => {
        beforeEach(async () => {
            const response = await request(app).post('/api/tasks').send({
                title: 'Original Task',
                description: 'Original description',
                status: 'TODO',
                priority: 'LOW'
            });
            testTaskId = response.body.data.id;
        });

        it('should update a task', async () => {
            const updates = {
                title: 'Updated Task',
                status: 'DONE',
                priority: 'HIGH'
            };

            const response = await request(app)
                .put(`/api/tasks/${testTaskId}`)
                .send(updates)
                .expect(200);

            expect(response.body.success).toBe(true);
            expect(response.body.data.title).toBe('Updated Task');
            expect(response.body.data.status).toBe('DONE');
            expect(response.body.data.priority).toBe('HIGH');
        });

        it('should return 404 for non-existent task', async () => {
            const response = await request(app)
                .put('/api/tasks/00000000-0000-0000-0000-000000000000')
                .send({ title: 'Updated' })
                .expect(404);

            expect(response.body.success).toBe(false);
        });
    });

    describe('DELETE /api/tasks/:id', () => {
        beforeEach(async () => {
            const response = await request(app).post('/api/tasks').send({
                title: 'Task to Delete',
                description: 'This will be deleted'
            });
            testTaskId = response.body.data.id;
        });

        it('should delete a task', async () => {
            const response = await request(app)
                .delete(`/api/tasks/${testTaskId}`)
                .expect(200);

            expect(response.body.success).toBe(true);
            expect(response.body.message).toBe('Task deleted successfully');

            // Verify task is deleted
            await request(app)
                .get(`/api/tasks/${testTaskId}`)
                .expect(404);
        });

        it('should return 404 for non-existent task', async () => {
            const response = await request(app)
                .delete('/api/tasks/00000000-0000-0000-0000-000000000000')
                .expect(404);

            expect(response.body.success).toBe(false);
        });
    });

    describe('GET /health', () => {
        it('should return healthy status', async () => {
            const response = await request(app)
                .get('/health')
                .expect(200);

            expect(response.body.status).toBe('healthy');
            expect(response.body.database).toBe('connected');
        });
    });
});
