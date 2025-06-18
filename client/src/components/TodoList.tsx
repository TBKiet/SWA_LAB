import React, { useState, useEffect } from 'react';
import {
  Box,
  List,
  ListItem,
  ListItemText,
  ListItemSecondaryAction,
  IconButton,
  TextField,
  Button,
  Paper,
  Typography,
  Checkbox,
} from '@mui/material';
import {
  Delete as DeleteIcon,
  Edit as EditIcon,
  Add as AddIcon,
} from '@mui/icons-material';
import axios from 'axios';

interface Todo {
  id: string;
  title: string;
  description: string;
  completed: boolean;
}

const TodoList: React.FC = () => {
  const [todos, setTodos] = useState<Todo[]>([]);
  const [newTodo, setNewTodo] = useState({ title: '', description: '' });
  const [editingTodo, setEditingTodo] = useState<Todo | null>(null);

  const fetchTodos = async () => {
    try {
      const token = localStorage.getItem('token');
      const response = await axios.get('http://localhost:8080/api/tasks', {
        headers: { Authorization: `Bearer ${token}` },
      });
      setTodos(response.data);
    } catch (error) {
      console.error('Error fetching todos:', error);
    }
  };

  useEffect(() => {
    fetchTodos();
  }, []);

  const handleAddTodo = async () => {
    try {
      const token = localStorage.getItem('token');
      await axios.post(
        'http://localhost:8080/api/tasks',
        newTodo,
        {
          headers: { Authorization: `Bearer ${token}` },
        }
      );
      setNewTodo({ title: '', description: '' });
      fetchTodos();
    } catch (error) {
      console.error('Error adding todo:', error);
    }
  };

  const handleDeleteTodo = async (id: string) => {
    try {
      const token = localStorage.getItem('token');
      await axios.delete(`http://localhost:8080/api/tasks/${id}`, {
        headers: { Authorization: `Bearer ${token}` },
      });
      fetchTodos();
    } catch (error) {
      console.error('Error deleting todo:', error);
    }
  };

  const handleToggleComplete = async (todo: Todo) => {
    try {
      const token = localStorage.getItem('token');
      await axios.patch(
        `http://localhost:8080/api/tasks/${todo.id}`,
        { completed: !todo.completed },
        {
          headers: { Authorization: `Bearer ${token}` },
        }
      );
      fetchTodos();
    } catch (error) {
      console.error('Error updating todo:', error);
    }
  };

  const handleUpdateTodo = async () => {
    if (!editingTodo) return;
    try {
      const token = localStorage.getItem('token');
      await axios.put(
        `http://localhost:8080/api/tasks/${editingTodo.id}`,
        editingTodo,
        {
          headers: { Authorization: `Bearer ${token}` },
        }
      );
      setEditingTodo(null);
      fetchTodos();
    } catch (error) {
      console.error('Error updating todo:', error);
    }
  };

  return (
    <Box>
      <Paper sx={{ p: 2, mb: 2 }}>
        <Typography variant="h6" gutterBottom>
          Add New Task
        </Typography>
        <Box sx={{ display: 'flex', gap: 2, mb: 2 }}>
          <TextField
            label="Title"
            value={newTodo.title}
            onChange={(e) =>
              setNewTodo({ ...newTodo, title: e.target.value })
            }
            fullWidth
          />
          <TextField
            label="Description"
            value={newTodo.description}
            onChange={(e) =>
              setNewTodo({ ...newTodo, description: e.target.value })
            }
            fullWidth
          />
          <Button
            variant="contained"
            startIcon={<AddIcon />}
            onClick={handleAddTodo}
            disabled={!newTodo.title}
          >
            Add
          </Button>
        </Box>
      </Paper>

      <List>
        {todos.map((todo) => (
          <ListItem
            key={todo.id}
            sx={{
              mb: 1,
              bgcolor: 'background.paper',
              borderRadius: 1,
            }}
          >
            <Checkbox
              checked={todo.completed}
              onChange={() => handleToggleComplete(todo)}
            />
            <ListItemText
              primary={todo.title}
              secondary={todo.description}
              sx={{
                textDecoration: todo.completed ? 'line-through' : 'none',
              }}
            />
            <ListItemSecondaryAction>
              <IconButton
                edge="end"
                aria-label="edit"
                onClick={() => setEditingTodo(todo)}
                sx={{ mr: 1 }}
              >
                <EditIcon />
              </IconButton>
              <IconButton
                edge="end"
                aria-label="delete"
                onClick={() => handleDeleteTodo(todo.id)}
              >
                <DeleteIcon />
              </IconButton>
            </ListItemSecondaryAction>
          </ListItem>
        ))}
      </List>

      {editingTodo && (
        <Paper sx={{ p: 2, mt: 2 }}>
          <Typography variant="h6" gutterBottom>
            Edit Task
          </Typography>
          <Box sx={{ display: 'flex', gap: 2 }}>
            <TextField
              label="Title"
              value={editingTodo.title}
              onChange={(e) =>
                setEditingTodo({ ...editingTodo, title: e.target.value })
              }
              fullWidth
            />
            <TextField
              label="Description"
              value={editingTodo.description}
              onChange={(e) =>
                setEditingTodo({ ...editingTodo, description: e.target.value })
              }
              fullWidth
            />
            <Button
              variant="contained"
              onClick={handleUpdateTodo}
              sx={{ mr: 1 }}
            >
              Save
            </Button>
            <Button
              variant="outlined"
              onClick={() => setEditingTodo(null)}
            >
              Cancel
            </Button>
          </Box>
        </Paper>
      )}
    </Box>
  );
};

export default TodoList; 