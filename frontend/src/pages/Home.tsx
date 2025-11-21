import { useState, useEffect } from 'react';
import { taskService } from '../services/taskService';
import { Task, CreateTaskData, UpdateTaskData, TaskStatus } from '../types';
import { TaskCard } from '../components/TaskCard';
import { TaskForm } from '../components/TaskForm';
import { Header } from '../components/Header';

export function Home() {
    const [tasks, setTasks] = useState<Task[]>([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState<string | null>(null);
    const [showForm, setShowForm] = useState(false);
    const [editingTask, setEditingTask] = useState<Task | undefined>(undefined);
    const [filter, setFilter] = useState<TaskStatus | 'ALL'>('ALL');

    useEffect(() => {
        loadTasks();
    }, []);

    const loadTasks = async () => {
        try {
            setLoading(true);
            setError(null);
            const data = await taskService.getAllTasks();
            setTasks(data);
        } catch (err) {
            setError('Failed to load tasks. Please try again.');
            console.error('Error loading tasks:', err);
        } finally {
            setLoading(false);
        }
    };

    const handleCreateTask = async (taskData: CreateTaskData) => {
        try {
            await taskService.createTask(taskData);
            await loadTasks();
            setShowForm(false);
        } catch (err) {
            alert('Failed to create task');
            console.error('Error creating task:', err);
        }
    };

    const handleUpdateTask = async (taskData: UpdateTaskData) => {
        if (!editingTask) return;

        try {
            await taskService.updateTask(editingTask.id, taskData);
            await loadTasks();
            setEditingTask(undefined);
            setShowForm(false);
        } catch (err) {
            alert('Failed to update task');
            console.error('Error updating task:', err);
        }
    };

    const handleDeleteTask = async (id: string) => {
        if (!confirm('Are you sure you want to delete this task?')) return;

        try {
            await taskService.deleteTask(id);
            await loadTasks();
        } catch (err) {
            alert('Failed to delete task');
            console.error('Error deleting task:', err);
        }
    };

    const handleStatusChange = async (id: string, status: TaskStatus) => {
        try {
            await taskService.updateTask(id, { status });
            await loadTasks();
        } catch (err) {
            alert('Failed to update task status');
            console.error('Error updating status:', err);
        }
    };

    const handleEdit = (task: Task) => {
        setEditingTask(task);
        setShowForm(true);
    };

    const handleCloseForm = () => {
        setShowForm(false);
        setEditingTask(undefined);
    };

    const filteredTasks = filter === 'ALL'
        ? tasks
        : tasks.filter(task => task.status === filter);

    const taskStats = {
        total: tasks.length,
        todo: tasks.filter(t => t.status === TaskStatus.TODO).length,
        inProgress: tasks.filter(t => t.status === TaskStatus.IN_PROGRESS).length,
        done: tasks.filter(t => t.status === TaskStatus.DONE).length,
    };

    return (
        <div className="app">
            <Header />

            <main className="main-content">
                <div className="container">
                    {/* Stats */}
                    <div className="stats-container">
                        <div className="stat-card">
                            <h3>Total Tasks</h3>
                            <p className="stat-number">{taskStats.total}</p>
                        </div>
                        <div className="stat-card">
                            <h3>To Do</h3>
                            <p className="stat-number" style={{ color: '#6366f1' }}>{taskStats.todo}</p>
                        </div>
                        <div className="stat-card">
                            <h3>In Progress</h3>
                            <p className="stat-number" style={{ color: '#f59e0b' }}>{taskStats.inProgress}</p>
                        </div>
                        <div className="stat-card">
                            <h3>Done</h3>
                            <p className="stat-number" style={{ color: '#10b981' }}>{taskStats.done}</p>
                        </div>
                    </div>

                    {/* Controls */}
                    <div className="controls">
                        <div className="filter-buttons">
                            <button
                                className={`filter-btn ${filter === 'ALL' ? 'active' : ''}`}
                                onClick={() => setFilter('ALL')}
                            >
                                All Tasks
                            </button>
                            <button
                                className={`filter-btn ${filter === TaskStatus.TODO ? 'active' : ''}`}
                                onClick={() => setFilter(TaskStatus.TODO)}
                            >
                                To Do
                            </button>
                            <button
                                className={`filter-btn ${filter === TaskStatus.IN_PROGRESS ? 'active' : ''}`}
                                onClick={() => setFilter(TaskStatus.IN_PROGRESS)}
                            >
                                In Progress
                            </button>
                            <button
                                className={`filter-btn ${filter === TaskStatus.DONE ? 'active' : ''}`}
                                onClick={() => setFilter(TaskStatus.DONE)}
                            >
                                Done
                            </button>
                        </div>

                        <button onClick={() => setShowForm(true)} className="btn btn-primary">
                            + New Task
                        </button>
                    </div>

                    {/* Task List */}
                    {loading && (
                        <div className="loading">
                            <div className="spinner"></div>
                            <p>Loading tasks...</p>
                        </div>
                    )}

                    {error && (
                        <div className="error-message">
                            <p>{error}</p>
                            <button onClick={loadTasks} className="btn btn-secondary">
                                Retry
                            </button>
                        </div>
                    )}

                    {!loading && !error && filteredTasks.length === 0 && (
                        <div className="empty-state">
                            <h2>No tasks found</h2>
                            <p>Create your first task to get started!</p>
                            <button onClick={() => setShowForm(true)} className="btn btn-primary">
                                Create Task
                            </button>
                        </div>
                    )}

                    {!loading && !error && filteredTasks.length > 0 && (
                        <div className="tasks-grid">
                            {filteredTasks.map((task) => (
                                <TaskCard
                                    key={task.id}
                                    task={task}
                                    onEdit={handleEdit}
                                    onDelete={handleDeleteTask}
                                    onStatusChange={handleStatusChange}
                                />
                            ))}
                        </div>
                    )}
                </div>
            </main>

            {/* Task Form Modal */}
            {showForm && (
                <TaskForm
                    task={editingTask}
                    onSubmit={editingTask ? handleUpdateTask : handleCreateTask}
                    onCancel={handleCloseForm}
                />
            )}
        </div>
    );
}
