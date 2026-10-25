
const express = require('express');
require('dotenv').config();
const { Pool } = require('pg');

const app = express();
const PORT = process.env.PORT || 3000;

const db = new Pool({
    host: process.env.DB_HOST,
    port: process.env.DB_PORT,
    database: process.env.DB_NAME,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
});

app.use(express.json());

// GET semua etalase
app.get('/api/etalase', async (req, res) => {
    try {
        const result = await db.query(`
            SELECT e.id, e.nama, e.deskripsi, e.status,
                   p.nama AS nama_pemilik
            FROM etalase e
            JOIN pemilik p ON e.pemilik_id = p.id
            ORDER BY e.id
        `);

        res.json(result.rows);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

// GET etalase berdasarkan ID
app.get('/api/etalase/:id', async (req, res) => {
    try {
        const result = await db.query(
            `SELECT * FROM etalase WHERE id = $1`,
            [req.params.id]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({
                message: 'Etalase tidak ditemukan'
            });
        }

        res.json(result.rows[0]);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

// POST tambah etalase
app.post('/api/etalase', async (req, res) => {
    try {
        const { pemilik_id, nama, deskripsi, status } = req.body;

        if (!pemilik_id || !nama) {
            return res.status(400).json({
                message: 'pemilik_id dan nama wajib diisi'
            });
        }

        const result = await db.query(
            `INSERT INTO etalase
             (pemilik_id, nama, deskripsi, status)
             VALUES ($1, $2, $3, $4)
             RETURNING *`,
            [
                pemilik_id,
                nama,
                deskripsi || null,
                status || 'data_simulasi'
            ]
        );

        res.status(201).json(result.rows[0]);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

// PUT ubah etalase
app.put('/api/etalase/:id', async (req, res) => {
    try {
        const { pemilik_id, nama, deskripsi, status } = req.body;

        if (!pemilik_id || !nama || !status) {
            return res.status(400).json({
                message: 'pemilik_id, nama, dan status wajib diisi'
            });
        }

        const result = await db.query(
            `UPDATE etalase
             SET pemilik_id = $1,
                 nama = $2,
                 deskripsi = $3,
                 status = $4
             WHERE id = $5
             RETURNING *`,
            [pemilik_id, nama, deskripsi || null, status, req.params.id]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({
                message: 'Etalase tidak ditemukan'
            });
        }

        res.json(result.rows[0]);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

// DELETE hapus etalase
app.delete('/api/etalase/:id', async (req, res) => {
    try {
        const result = await db.query(
            `DELETE FROM etalase WHERE id = $1 RETURNING *`,
            [req.params.id]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({
                message: 'Etalase tidak ditemukan'
            });
        }

        res.json({
            message: 'Etalase berhasil dihapus',
            data: result.rows[0]
        });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

app.get('/', (req, res) => {
    res.json({ message: 'API EtalasePelemwatu berhasil berjalan!' });
});

app.listen(PORT, () => {
    console.log(`Server berjalan di http://localhost:${PORT}`);
});
