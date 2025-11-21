import { describe, it, expect, vi } from 'vitest';
import { render, screen, fireEvent } from '@testing-library/react';
import { TaskForm } from '../components/TaskForm';
import { TaskStatus, TaskPriority } from '../types';

describe('TaskForm', () => {
    const mockOnSubmit = vi.fn();
    const mockOnCancel = vi.fn();

    it('renders create form correctly', () => {
        render(<TaskForm onSubmit={mockOnSubmit} onCancel={mockOnCancel} />);

        expect(screen.getByText('Create New Task')).toBeInTheDocument();
        expect(screen.getByLabelText(/title/i)).toBeInTheDocument();
        expect(screen.getByLabelText(/description/i)).toBeInTheDocument();
    });

    it('submits form with correct data', () => {
        render(<TaskForm onSubmit={mockOnSubmit} onCancel={mockOnCancel} />);

        const titleInput = screen.getByLabelText(/title/i);
        const descriptionInput = screen.getByLabelText(/description/i);
        const submitButton = screen.getByText('Create Task');

        fireEvent.change(titleInput, { target: { value: 'New Task' } });
        fireEvent.change(descriptionInput, { target: { value: 'New Description' } });
        fireEvent.click(submitButton);

        expect(mockOnSubmit).toHaveBeenCalledWith({
            title: 'New Task',
            description: 'New Description',
            status: TaskStatus.TODO,
            priority: TaskPriority.MEDIUM,
        });
    });

    it('calls onCancel when cancel button is clicked', () => {
        render(<TaskForm onSubmit={mockOnSubmit} onCancel={mockOnCancel} />);

        const cancelButton = screen.getByText('Cancel');
        fireEvent.click(cancelButton);

        expect(mockOnCancel).toHaveBeenCalled();
    });
});
