import { Request, Response } from 'express';
import { TaskModel } from '../models/task.model';
import { CreateTaskDTO, UpdateTaskDTO, ApiResponse, Task } from '../types';

export class TaskController {
    // GET /api/tasks - Get all tasks
    static async getAllTasks(_req: Request, res: Response): Promise<void> {
        try {
            const tasks = await TaskModel.findAll();
            const response: ApiResponse<Task[]> = {
                success: true,
                data: tasks,
                message: `Retrieved ${tasks.length} tasks`
            };
            res.json(response);
        } catch (error) {
            console.error('Error getting tasks:', error);
            const response: ApiResponse<never> = {
                success: false,
                error: 'Failed to retrieve tasks'
            };
            res.status(500).json(response);
        }
    }

    // GET /api/tasks/:id - Get a single task
    static async getTaskById(req: Request, res: Response): Promise<void> {
        try {
            const { id } = req.params;
            const task = await TaskModel.findById(id);

            if (!task) {
                const response: ApiResponse<never> = {
                    success: false,
                    error: 'Task not found'
                };
                res.status(404).json(response);
                return;
            }

            const response: ApiResponse<Task> = {
                success: true,
                data: task
            };
            res.json(response);
        } catch (error) {
            console.error('Error getting task:', error);
            const response: ApiResponse<never> = {
                success: false,
                error: 'Failed to retrieve task'
            };
            res.status(500).json(response);
        }
    }

    // POST /api/tasks - Create a new task
    static async createTask(req: Request, res: Response): Promise<void> {
        try {
            const taskData: CreateTaskDTO = req.body;

            // Validation
            if (!taskData.title || taskData.title.trim() === '') {
                const response: ApiResponse<never> = {
                    success: false,
                    error: 'Title is required'
                };
                res.status(400).json(response);
                return;
            }

            const task = await TaskModel.create(taskData);
            const response: ApiResponse<Task> = {
                success: true,
                data: task,
                message: 'Task created successfully'
            };
            res.status(201).json(response);
        } catch (error) {
            console.error('Error creating task:', error);
            const response: ApiResponse<never> = {
                success: false,
                error: 'Failed to create task'
            };
            res.status(500).json(response);
        }
    }

    // PUT /api/tasks/:id - Update a task
    static async updateTask(req: Request, res: Response): Promise<void> {
        try {
            const { id } = req.params;
            const taskData: UpdateTaskDTO = req.body;

            const task = await TaskModel.update(id, taskData);

            if (!task) {
                const response: ApiResponse<never> = {
                    success: false,
                    error: 'Task not found'
                };
                res.status(404).json(response);
                return;
            }

            const response: ApiResponse<Task> = {
                success: true,
                data: task,
                message: 'Task updated successfully'
            };
            res.json(response);
        } catch (error) {
            console.error('Error updating task:', error);
            const response: ApiResponse<never> = {
                success: false,
                error: 'Failed to update task'
            };
            res.status(500).json(response);
        }
    }

    // DELETE /api/tasks/:id - Delete a task
    static async deleteTask(req: Request, res: Response): Promise<void> {
        try {
            const { id } = req.params;
            const deleted = await TaskModel.delete(id);

            if (!deleted) {
                const response: ApiResponse<never> = {
                    success: false,
                    error: 'Task not found'
                };
                res.status(404).json(response);
                return;
            }

            const response: ApiResponse<never> = {
                success: true,
                message: 'Task deleted successfully'
            };
            res.json(response);
        } catch (error) {
            console.error('Error deleting task:', error);
            const response: ApiResponse<never> = {
                success: false,
                error: 'Failed to delete task'
            };
            res.status(500).json(response);
        }
    }
}
