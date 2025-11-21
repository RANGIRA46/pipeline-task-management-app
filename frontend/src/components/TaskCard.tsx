import { Task, TaskStatus, TaskPriority } from '../types';

interface TaskCardProps {
    task: Task;
    onEdit: (task: Task) => void;
    onDelete: (id: string) => void;
    onStatusChange: (id: string, status: TaskStatus) => void;
}

export function TaskCard({ task, onEdit, onDelete, onStatusChange }: TaskCardProps) {
    const getStatusColor = (status: TaskStatus) => {
        switch (status) {
            case TaskStatus.TODO:
                return '#6366f1'; // Indigo
            case TaskStatus.IN_PROGRESS:
                return '#f59e0b'; // Amber
            case TaskStatus.DONE:
                return '#10b981'; // Green
            default:
                return '#6b7280'; // Gray
        }
    };

    const getPriorityColor = (priority: TaskPriority) => {
        switch (priority) {
            case TaskPriority.HIGH:
                return '#ef4444'; // Red
            case TaskPriority.MEDIUM:
                return '#f59e0b'; // Amber
            case TaskPriority.LOW:
                return '#10b981'; // Green
            default:
                return '#6b7280'; // Gray
        }
    };

    const formatDate = (dateString: string) => {
        const date = new Date(dateString);
        return date.toLocaleDateString() + ' ' + date.toLocaleTimeString();
    };

    return (
        <div className="task-card">
            <div className="task-header">
                <h3 className="task-title">{task.title}</h3>
                <div className="task-badges">
                    <span
                        className="badge priority-badge"
                        style={{ backgroundColor: getPriorityColor(task.priority) }}
                    >
                        {task.priority}
                    </span>
                    <span
                        className="badge status-badge"
                        style={{ backgroundColor: getStatusColor(task.status) }}
                    >
                        {task.status.replace('_', ' ')}
                    </span>
                </div>
            </div>

            <p className="task-description">{task.description}</p>

            <div className="task-meta">
                <small>Created: {formatDate(task.created_at)}</small>
                {task.updated_at !== task.created_at && (
                    <small>Updated: {formatDate(task.updated_at)}</small>
                )}
            </div>

            <div className="task-actions">
                <select
                    value={task.status}
                    onChange={(e) => onStatusChange(task.id, e.target.value as TaskStatus)}
                    className="status-select"
                >
                    <option value={TaskStatus.TODO}>To Do</option>
                    <option value={TaskStatus.IN_PROGRESS}>In Progress</option>
                    <option value={TaskStatus.DONE}>Done</option>
                </select>

                <div className="button-group">
                    <button onClick={() => onEdit(task)} className="btn btn-secondary">
                        Edit
                    </button>
                    <button onClick={() => onDelete(task.id)} className="btn btn-danger">
                        Delete
                    </button>
                </div>
            </div>
        </div>
    );
}
