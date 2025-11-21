import { describe, it, expect } from 'vitest';
import { render, screen } from '@testing-library/react';
import { Header } from '../components/Header';

describe('Header', () => {
    it('renders header with correct text', () => {
        render(<Header />);

        expect(screen.getByText('Task Manager')).toBeInTheDocument();
        expect(screen.getByText('Manage your tasks efficiently')).toBeInTheDocument();
    });

    it('renders logo icon', () => {
        render(<Header />);

        const logoIcon = screen.getByText('📋');
        expect(logoIcon).toBeInTheDocument();
    });
});
