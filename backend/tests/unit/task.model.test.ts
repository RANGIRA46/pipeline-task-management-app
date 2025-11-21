import { TaskModel } from '../../src/models/task.model';
import { CreateTaskDTO, UpdateTaskDTO, TaskStatus, TaskPriority } from '../../src/types';
import { query } from '../../src/config/database';

// Mock the database module
jest.mock('../../src/config/database');

const mockQuery = query as jest.MockedFunction<typeof query>;

describe('TaskModel', () => {
    beforeEach(() => {
        jest.clearAllMocks();
    });

    describe('findAll', () => {
        it('should return all tasks', async () => {
            const mockTasks = [
                {
                    id: '1',
                    title: 'Test Task 1',
                    description: 'Description 1',
                    status: TaskStatus.TODO,
                    priority: TaskPriority.HIGH,
                    created_at: new Date(),
                    updated_at: new Date()
                },
                {
                    id: '2',
                    title: 'Test Task 2',
                    description: 'Description 2',
                    status: TaskStatus.IN_PROGRESS,
                    priority: TaskPriority.MEDIUM,
                    created_at: new Date(),
                    updated_at: new Date()
                }
            ];

            mockQuery.mockResolvedValueOnce({ rows: mockTasks } as never);

            const result = await TaskModel.findAll();

            expect(result).toEqual(mockTasks);
            expect(mockQuery).toHaveBeenCalledWith('SELECT * FROM tasks ORDER BY created_at DESC');
        });
    });

    describe('findById', () => {
        it('should return a task by id', async () => {
            const mockTask = {
                id: '1',
                title: 'Test Task',
                description: 'Test Description',
                status: TaskStatus.TODO,
                priority: TaskPriority.HIGH,
                created_at: new Date(),
                updated_at: new Date()
            };

            mockQuery.mockResolvedValueOnce({ rows: [mockTask] } as never);

            const result = await TaskModel.findById('1');

            expect(result).toEqual(mockTask);
            expect(mockQuery).toHaveBeenCalledWith('SELECT * FROM tasks WHERE id = $1', ['1']);
        });

        it('should return null if task not found', async () => {
            mockQuery.mockResolvedValueOnce({ rows: [] } as never);

            const result = await TaskModel.findById('nonexistent');

            expect(result).toBeNull();
        });
    });

    describe('create', () => {
        it('should create a new task with default values', async () => {
            const createData: CreateTaskDTO = {
                title: 'New Task',
                description: 'New Description'
            };

            const mockCreatedTask = {
                id: 'new-id',
                title: 'New Task',
                description: 'New Description',
                status: TaskStatus.TODO,
                priority: TaskPriority.MEDIUM,
                created_at: new Date(),
                updated_at: new Date()
            };

            mockQuery.mockResolvedValueOnce({ rows: [mockCreatedTask] } as never);

            const result = await TaskModel.create(createData);

            expect(result).toEqual(mockCreatedTask);
            expect(mockQuery).toHaveBeenCalledWith(
                expect.stringContaining('INSERT INTO tasks'),
                expect.arrayContaining([expect.any(String), 'New Task', 'New Description', 'TODO', 'MEDIUM'])
            );
        });

        it('should create a task with custom status and priority', async () => {
            const createData: CreateTaskDTO = {
                title: 'Custom Task',
                description: 'Custom Description',
                status: TaskStatus.IN_PROGRESS,
                priority: TaskPriority.HIGH
            };

            const mockCreatedTask = {
                id: 'custom-id',
                ...createData,
                created_at: new Date(),
                updated_at: new Date()
            };

            mockQuery.mockResolvedValueOnce({ rows: [mockCreatedTask] } as never);

            const result = await TaskModel.create(createData);

            expect(result.status).toBe(TaskStatus.IN_PROGRESS);
            expect(result.priority).toBe(TaskPriority.HIGH);
        });
    });

    describe('update', () => {
        it('should update a task successfully', async () => {
            const existingTask = {
                id: '1',
                title: 'Old Title',
                description: 'Old Description',
                status: TaskStatus.TODO,
                priority: TaskPriority.LOW,
                created_at: new Date(),
                updated_at: new Date()
            };

            const updateData: UpdateTaskDTO = {
                title: 'Updated Title',
                status: TaskStatus.DONE
            };

            const updatedTask = { ...existingTask, ...updateData };

            mockQuery
                .mockResolvedValueOnce({ rows: [existingTask] } as never) // findById
                .mockResolvedValueOnce({ rows: [updatedTask] } as never); // update

            const result = await TaskModel.update('1', updateData);

            expect(result).toEqual(updatedTask);
        });

        it('should return null if task not found', async () => {
            mockQuery.mockResolvedValueOnce({ rows: [] } as never); // findById returns nothing

            const result = await TaskModel.update('nonexistent', { title: 'New Title' });

            expect(result).toBeNull();
        });
    });

    describe('delete', () => {
        it('should delete a task successfully', async () => {
            mockQuery.mockResolvedValueOnce({ rowCount: 1 } as never);

            const result = await TaskModel.delete('1');

            expect(result).toBe(true);
            expect(mockQuery).toHaveBeenCalledWith('DELETE FROM tasks WHERE id = $1', ['1']);
        });

        it('should return false if task not found', async () => {
            mockQuery.mockResolvedValueOnce({ rowCount: 0 } as never);

            const result = await TaskModel.delete('nonexistent');

            expect(result).toBe(false);
        });
    });

    describe('count', () => {
        it('should return the count of tasks', async () => {
            mockQuery.mockResolvedValueOnce({ rows: [{ count: '5' }] } as never);

            const result = await TaskModel.count();

            expect(result).toBe(5);
            expect(mockQuery).toHaveBeenCalledWith('SELECT COUNT(*) FROM tasks');
        });
    });
});
