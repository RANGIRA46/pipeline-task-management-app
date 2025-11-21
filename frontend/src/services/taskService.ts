import axios from 'axios';
import { Task, CreateTaskData, UpdateTaskData, ApiResponse } from '../types';

const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:3000';

const api = axios.create({
    baseURL: API_URL,
    headers: {
        'Content-Type': 'application/json',
    },
});

export const taskService = {
    async getAllTasks(): Promise<Task[]> {
        const response = await api.get<ApiResponse<Task[]>>('/api/tasks');
        return response.data.data || [];
    },

    async getTaskById(id: string): Promise<Task> {
        const response = await api.get<ApiResponse<Task>>(`/api/tasks/${id}`);
        if (!response.data.data) {
            throw new Error('Task not found');
        }
        return response.data.data;
    },

    async createTask(taskData: CreateTaskData): Promise<Task> {
        const response = await api.post<ApiResponse<Task>>('/api/tasks', taskData);
        if (!response.data.data) {
            throw new Error('Failed to create task');
        }
        return response.data.data;
    },

    async updateTask(id: string, taskData: UpdateTaskData): Promise<Task> {
        const response = await api.put<ApiResponse<Task>>(`/api/tasks/${id}`, taskData);
        if (!response.data.data) {
            throw new Error('Failed to update task');
        }
        return response.data.data;
    },

    async deleteTask(id: string): Promise<void> {
        await api.delete(`/api/tasks/${id}`);
    },

    async healthCheck(): Promise<boolean> {
        try {
            const response = await api.get('/health');
            return response.data.status === 'healthy';
        } catch {
            return false;
        }
    },
};
