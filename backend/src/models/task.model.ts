import { query } from '../config/database';
import { Task, CreateTaskDTO, UpdateTaskDTO, TaskStatus, TaskPriority } from '../types';
import { v4 as uuidv4 } from 'uuid';

export class TaskModel {
    static async findAll(): Promise<Task[]> {
        const result = await query(
            'SELECT * FROM tasks ORDER BY created_at DESC'
        );
        return result.rows;
    }

    static async findById(id: string): Promise<Task | null> {
        const result = await query(
            'SELECT * FROM tasks WHERE id = $1',
            [id]
        );
        return result.rows[0] || null;
    }

    static async create(taskData: CreateTaskDTO): Promise<Task> {
        const id = uuidv4();
        const { title, description, status = TaskStatus.TODO, priority = TaskPriority.MEDIUM } = taskData;

        const result = await query(
            `INSERT INTO tasks (id, title, description, status, priority)
       VALUES ($1, $2, $3, $4, $5)
       RETURNING *`,
            [id, title, description, status, priority]
        );

        return result.rows[0];
    }

    static async update(id: string, taskData: UpdateTaskDTO): Promise<Task | null> {
        const existingTask = await this.findById(id);
        if (!existingTask) {
            return null;
        }

        const { title, description, status, priority } = taskData;

        const updates: string[] = [];
        const values: unknown[] = [];
        let paramIndex = 1;

        if (title !== undefined) {
            updates.push(`title = $${paramIndex++}`);
            values.push(title);
        }
        if (description !== undefined) {
            updates.push(`description = $${paramIndex++}`);
            values.push(description);
        }
        if (status !== undefined) {
            updates.push(`status = $${paramIndex++}`);
            values.push(status);
        }
        if (priority !== undefined) {
            updates.push(`priority = $${paramIndex++}`);
            values.push(priority);
        }

        if (updates.length === 0) {
            return existingTask;
        }

        values.push(id);
        const result = await query(
            `UPDATE tasks SET ${updates.join(', ')} WHERE id = $${paramIndex} RETURNING *`,
            values
        );

        return result.rows[0];
    }

    static async delete(id: string): Promise<boolean> {
        const result = await query(
            'DELETE FROM tasks WHERE id = $1',
            [id]
        );
        return (result.rowCount ?? 0) > 0;
    }

    static async count(): Promise<number> {
        const result = await query('SELECT COUNT(*) FROM tasks');
        return parseInt(result.rows[0].count);
    }
}
