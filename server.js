const express = require('express');
const bodyParser = require('body-parser');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const { User, DiaryEntry } = require('./models');
require('dotenv').config();

const app = express();
app.use(bodyParser.json());

// Endpoint for user registration
app.post('/register', async (req, res) => {
  try {
    const { username, email, password } = req.body;
    if (username === '' || email === '' || password === '' || !username || !email || !password) {
        return res.status(400).json({ message: 'username, email and password are required' });
    }
    const existingUserWithEmail = await User.findOne({ where: { email } });
    if (existingUserWithEmail) {
      return res.status(400).json({ message: 'User with this email already exists' });
    }
    const existingUserWithUsername = await User.findOne({ where: { username } });
    if (existingUserWithUsername) {
      return res.status(400).json({ message: 'User with this username already exists' });
    }
    const newUser = await User.create({ username, email, password });
    res.status(201).json({ user_id: newUser.id });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Internal server error' });
  }
});

// Endpoint for user login
app.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;
    if (email === '' || password === '' || !email || !password) {
        return res.status(400).json({ message: 'email and password are required' });
    }
    const user = await User.findOne({ where: { email } });
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }
    const isPasswordValid = await bcrypt.compare(password, user.password);
    if (!isPasswordValid) {
      return res.status(401).json({ message: 'Invalid credentials' });
    }
    const token = jwt.sign({ userId: user.id }, process.env.SECRET_KEY, { expiresIn: '24h' });
    res.json({ token });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Internal server error' });
  }
});

// Middleware for authentication
const authenticateUser = async (req, res, next) => {
  try {
    const token = req.headers.authorization.split(' ')[1];
    const decodedToken = jwt.verify(token, process.env.SECRET_KEY);
    req.userData = { userId: decodedToken.userId };
    next();
  } catch (error) {
    console.error(error);
    res.status(401).json({ message: 'Authentication failed' });
  }
};

// Endpoint to create a new diary entry
app.post('/diary', authenticateUser, async (req, res) => {
  try {
    const { title, description, date, location } = req.body;
    // response for title not provided
    if (!title || title === '') {
      return res.status(400).json({ message: 'title is required' });
    }
    // response for description not provided
    if (!description || description === '') {
      return res.status(400).json({ message: 'description is required' });
    }
    // response for date not provided
    if (!date || date === '') {
      return res.status(400).json({ message: 'date is required' });
    }
    // response for location not provided
    if (!location || location === '') {
      return res.status(400).json({ message: 'location is required' });
    }
    const newDiaryEntry = await DiaryEntry.create({
      title,
      description,
      date,
      location,
      userId: req.userData.userId // Set the user ID from decoded token
    });
    res.status(201).json({ diary_entry_id: newDiaryEntry.id });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Internal server error' });
  }
});

// Endpoint to get all diary entries for a user
app.get('/diary', authenticateUser, async (req, res) => {
  try {
    const diaryEntries = await DiaryEntry.findAll({ where: { userId: req.userData.userId } });
    if (diaryEntries.length === 0) {
        return res.status(404).json({ message: 'No diary entries found for this User' });
    } else {
      const response = diaryEntries.map(diaryEntry => {
        return {
          id: diaryEntry.id,
          title: diaryEntry.title,
          description: diaryEntry.description,
          date: diaryEntry.date,
          location: diaryEntry.location
        };
      });
      res.json(response);
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Internal server error' });
  }
});

// Endpoint to get only one diary entry for a user
app.get('/diary/:id', authenticateUser, async (req, res) => {
  try {
    const { id } = req.params;
    const diaryEntry = await DiaryEntry.findByPk(id);
    if (!diaryEntry) {
      return res.status(404).json({ message: 'Diary entry not found' });
    }
    if (diaryEntry.userId !== req.userData.userId) {
      return res.status(403).json({ message: 'You are not authorized to view this diary entry' });
    }
    const response = {
      id: diaryEntry.id,
      title: diaryEntry.title,
      description: diaryEntry.description,
      date: diaryEntry.date,
      location: diaryEntry.location
    };
    res.json(response);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Internal server error' });
  }
});

// Endpoint to update a diary entry
app.put('/diary/:id', authenticateUser, async (req, res) => {
  try {
    const { id } = req.params;
    const { title, description, date, location } = req.body;
    const diaryEntry = await DiaryEntry.findByPk(id);
    if (!diaryEntry) {
      return res.status(404).json({ message: 'Diary entry not found' });
    }
    if (diaryEntry.userId !== req.userData.userId) {
      return res.status(403).json({ message: 'You are not authorized to update this diary entry' });
    }
    await diaryEntry.update({ title, description, date, location });
    const response = {
      id: diaryEntry.id,
      title: diaryEntry.title,
      description: diaryEntry.description,
      date: diaryEntry.date,
      location: diaryEntry.location
    };
    res.json(response);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Internal server error' });
  }
});

// Endpoint to delete a diary entry
app.delete('/diary/:id', authenticateUser, async (req, res) => {
  try {
    const { id } = req.params;
    const diaryEntry = await DiaryEntry.findByPk(id);
    if (!diaryEntry) {
      return res.status(404).json({ message: 'Diary entry not found' });
    }
    if (diaryEntry.userId !== req.userData.userId) {
      return res.status(403).json({ message: 'You are not authorized to delete this diary entry' });
    }
    await diaryEntry.destroy();
    res.json({ message: 'Diary entry deleted successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Internal server error' });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
