import { useState } from 'react';
import { Task, CreateTaskData, UpdateTaskData, TaskStatus, TaskPriority } from '../types';

interface TaskFormProps {
    task?: Task;
    onSubmit: (data: CreateTaskData | UpdateTaskData) => void;
    onCancel: () => void;
}

export function TaskForm({ task, onSubmit, onCancel }: TaskFormProps) {
    const [title, setTitle] = useState(task?.title || '');
    const [description, setDescription] = useState(task?.description || '');
    const [status, setStatus] = useState<TaskStatus>(task?.status || TaskStatus.TODO);
    const [priority, setPriority] = useState<TaskPriority>(task?.priority || TaskPriority.MEDIUM);

    const handleSubmit = (e: React.FormEvent) => {
        e.preventDefault();

        if (!title.trim()) {
            alert('Title is required');
            return;
        }

        onSubmit({
            title: title.trim(),
            description: description.trim(),
            status,
            priority,
        });
    };

    return (
        <div className="task-form-overlay" onClick={onCancel}>
            <div className="task-form-container" onClick={(e) => e.stopPropagation()}>
                <h2>{task ? 'Edit Task' : 'Create New Task'}</h2>

                <form onSubmit={handleSubmit}>
                    <div className="form-group">
                        <label htmlFor="title">Title *</label>
                        <input
                            id="title"
                            type="text"
                            value={title}
                            onChange={(e) => setTitle(e.target.value)}
                            placeholder="Enter task title"
                            required
                            autoFocus
                        />
                    </div>

                    <div className="form-group">
                        <label htmlFor="description">Description</label>
                        <textarea
                            id="description"
                            value={description}
                            onChange={(e) => setDescription(e.target.value)}
                            placeholder="Enter task description"
                            rows={4}
                        />
                    </div>

                    <div className="form-row">
                        <div className="form-group">
                            <label htmlFor="status">Status</label>
                            <select
                                id="status"
                                value={status}
                                onChange={(e) => setStatus(e.target.value as TaskStatus)}
                            >
                                <option value={TaskStatus.TODO}>To Do</option>
                                <option value={TaskStatus.IN_PROGRESS}>In Progress</option>
                                <option value={TaskStatus.DONE}>Done</option>
                            </select>
                        </div>

                        <div className="form-group">
                            <label htmlFor="priority">Priority</label>
                            <select
                                id="priority"
                                value={priority}
                                onChange={(e) => setPriority(e.target.value as TaskPriority)}
                            >
                                <option value={TaskPriority.LOW}>Low</option>
                                <option value={TaskPriority.MEDIUM}>Medium</option>
                                <option value={TaskPriority.HIGH}>High</option>
                            </select>
                        </div>
                    </div>

                    <div className="form-actions">
                        <button type="button" onClick={onCancel} className="btn btn-secondary">
                            Cancel
                        </button>
                        <button type="submit" className="btn btn-primary">
                            {task ? 'Update Task' : 'Create Task'}
                        </button>
                    </div>
                </form>
            </div>
        </div>
    );
}
