const { Pool } = require('pg');

const pool = new Pool({
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  host: process.env.DB_HOST,
  port: parseInt(process.env.DB_PORT),
  database: process.env.DB_DATABASE,
});

// Test koneksi dan buat tabel users jika belum ada
const initDatabase = async () => {
  try {
    const client = await pool.connect();
    console.log('[+] Berhasil terhubung ke PostgreSQL');

    await client.query(`
      CREATE TABLE IF NOT EXISTS users (
        id SERIAL PRIMARY KEY,
        name VARCHAR(100) NOT NULL,
        email VARCHAR(100) UNIQUE NOT NULL,
        password VARCHAR(255) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
    `);
    console.log('[v] Tabel users siap');
    client.release();
  } catch (err) {
    console.error('[x] Gagal koneksi ke database:', err.message);
    process.exit(1);
  }
};

module.exports = { pool, initDatabase };
