require('dotenv').config();
const express = require('express');
const cors = require('cors');
const { pool } = require('./config/db');
const authRoutes = require('./routes/auth');

const app = express();

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Routes
app.use('/api/auth', authRoutes);

// Route utama
app.get('/', (req, res) => {
  res.json({
    success: true,
    message: 'Backend berjalan dengan baik',
    endpoints: {
      register: 'POST /api/auth/register',
      login: 'POST /api/auth/login',
      profile: 'GET /api/auth/profile (Bearer Token)',
    },
  });
});

// Health check untuk Vercel
app.get('/api/health', async (req, res) => {
  try {
    const result = await pool.query('SELECT NOW()');
    res.json({
      success: true,
      message: 'Database terkoneksi',
      time: result.rows[0].now,
    });
  } catch (err) {
    res.status(503).json({
      success: false,
      message: 'Database tidak tersedia',
      error: err.message,
    });
  }
});

// Handle 404
app.use((req, res) => {
  res.status(404).json({
    success: false,
    message: 'Endpoint tidak ditemukan',
  });
});

// Handle error global
app.use((err, req, res, next) => {
  console.error('Server Error:', err);
  res.status(500).json({
    success: false,
    message: 'Internal Server Error',
  });
});

module.exports = app;
