const Todo = require('../models/Todo');

// GET /api/todos
const getTodos = async (req, res) => {
  try {
    const { completed, priority } = req.query;
    const filter = { user: req.user._id };

    if (completed !== undefined) {
      filter.isCompleted = completed === 'true';
    }
    if (priority) {
      filter.priority = priority;
    }

    const todos = await Todo.find(filter).sort({ createdAt: -1 });
    res.json({ todos });
  } catch (error) {
    res.status(500).json({ message: 'Failed to fetch todos' });
  }
};

// POST /api/todos
const createTodo = async (req, res) => {
  try {
    const { title, description, priority } = req.body;

    if (!title || title.trim() === '') {
      return res.status(400).json({ message: 'Title is required' });
    }

    const todo = await Todo.create({
      user: req.user._id,
      title: title.trim(),
      description: description?.trim() || '',
      priority: priority || 'medium'
    });

    res.status(201).json({ message: 'Todo created', todo });
  } catch (error) {
    if (error.name === 'ValidationError') {
      const messages = Object.values(error.errors).map(e => e.message);
      return res.status(400).json({ message: messages[0] });
    }
    res.status(500).json({ message: 'Failed to create todo' });
  }
};

// PUT /api/todos/:id
const updateTodo = async (req, res) => {
  try {
    const { title, description, isCompleted, priority } = req.body;

    const todo = await Todo.findOne({ _id: req.params.id, user: req.user._id });
    if (!todo) {
      return res.status(404).json({ message: 'Todo not found' });
    }

    if (title !== undefined) todo.title = title.trim();
    if (description !== undefined) todo.description = description.trim();
    if (isCompleted !== undefined) todo.isCompleted = isCompleted;
    if (priority !== undefined) todo.priority = priority;

    await todo.save();
    res.json({ message: 'Todo updated', todo });
  } catch (error) {
    res.status(500).json({ message: 'Failed to update todo' });
  }
};

// DELETE /api/todos/:id
const deleteTodo = async (req, res) => {
  try {
    const todo = await Todo.findOneAndDelete({
      _id: req.params.id,
      user: req.user._id
    });

    if (!todo) {
      return res.status(404).json({ message: 'Todo not found' });
    }

    res.json({ message: 'Todo deleted' });
  } catch (error) {
    res.status(500).json({ message: 'Failed to delete todo' });
  }
};

// PATCH /api/todos/:id/toggle
const toggleTodo = async (req, res) => {
  try {
    const todo = await Todo.findOne({ _id: req.params.id, user: req.user._id });
    if (!todo) {
      return res.status(404).json({ message: 'Todo not found' });
    }

    todo.isCompleted = !todo.isCompleted;
    await todo.save();

    res.json({ message: 'Todo toggled', todo });
  } catch (error) {
    res.status(500).json({ message: 'Failed to toggle todo' });
  }
};

module.exports = { getTodos, createTodo, updateTodo, deleteTodo, toggleTodo };
