import { describe, it, expect, vi } from 'vitest';
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import { TaskCard } from '../components/TaskCard';
import { Task, TaskStatus, TaskPriority } from '../types';

describe('TaskCard', () => {
    const mockTask: Task = {
        id: '1',
        title: 'Test Task',
        description: 'Test Description',
        status: TaskStatus.TODO,
        priority: TaskPriority.HIGH,
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString(),
    };

    const mockOnEdit = vi.fn();
    const mockOnDelete = vi.fn();
    const mockOnStatusChange = vi.fn();

    it('renders task information correctly', () => {
        render(
            <TaskCard
                task={mockTask}
                onEdit={mockOnEdit}
                onDelete={mockOnDelete}
                onStatusChange={mockOnStatusChange}
            />
        );

        expect(screen.getByText('Test Task')).toBeInTheDocument();
        expect(screen.getByText('Test Description')).toBeInTheDocument();
        expect(screen.getByText('HIGH')).toBeInTheDocument();
    });

    it('calls onEdit when edit button is clicked', () => {
        render(
            <TaskCard
                task={mockTask}
                onEdit={mockOnEdit}
                onDelete={mockOnDelete}
                onStatusChange={mockOnStatusChange}
            />
        );

        const editButton = screen.getByText('Edit');
        fireEvent.click(editButton);

        expect(mockOnEdit).toHaveBeenCalledWith(mockTask);
    });

    it('calls onDelete when delete button is clicked', () => {
        render(
            <TaskCard
                task={mockTask}
                onEdit={mockOnEdit}
                onDelete={mockOnDelete}
                onStatusChange={mockOnStatusChange}
            />
        );

        const deleteButton = screen.getByText('Delete');
        fireEvent.click(deleteButton);

        expect(mockOnDelete).toHaveBeenCalledWith('1');
    });

    it('calls onStatusChange when status is changed', async () => {
        render(
            <TaskCard
                task={mockTask}
                onEdit={mockOnEdit}
                onDelete={mockOnDelete}
                onStatusChange={mockOnStatusChange}
            />
        );

        const statusSelect = screen.getByRole('combobox');
        fireEvent.change(statusSelect, { target: { value: TaskStatus.DONE } });

        await waitFor(() => {
            expect(mockOnStatusChange).toHaveBeenCalledWith('1', TaskStatus.DONE);
        });
    });
});
