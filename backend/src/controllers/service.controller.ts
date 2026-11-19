import { Request, Response } from 'express';
import db from '../config/db';

// 1. Create (Tambah Layanan)
export const createService = async (req: Request, res: Response) => {
  try {
    const { name, description, price, estimated_days } = req.body;

    if (!name || !price || !estimated_days) {
      return res.status(400).json({ message: 'Nama, harga, dan estimasi hari wajib diisi' });
    }

    const [result]: any = await db.query(
      'INSERT INTO services (name, description, price, estimated_days) VALUES (?, ?, ?, ?)',
      [name, description, price, estimated_days]
    );

    res.status(201).json({ 
      message: 'Layanan servis berhasil ditambahkan',
      data: { id: result.insertId, name, description, price, estimated_days }
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Terjadi kesalahan pada server' });
  }
};

// 2. Read (Lihat Semua Layanan)
export const getAllServices = async (req: Request, res: Response) => {
  try {
    const [rows]: any = await db.query('SELECT * FROM services ORDER BY created_at DESC');
    res.status(200).json({ message: 'Berhasil mengambil data layanan', data: rows });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Terjadi kesalahan pada server' });
  }
};

// 3. Update (Ubah Layanan)
export const updateService = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const { name, description, price, estimated_days } = req.body;

    const [result]: any = await db.query(
      'UPDATE services SET name = ?, description = ?, price = ?, estimated_days = ? WHERE id = ?',
      [name, description, price, estimated_days, id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Layanan servis tidak ditemukan' });
    }

    res.status(200).json({ message: 'Layanan servis berhasil diubah' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Terjadi kesalahan pada server' });
  }
};

// 4. Delete (Hapus Layanan)
export const deleteService = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;

    const [result]: any = await db.query('DELETE FROM services WHERE id = ?', [id]);

    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Layanan servis tidak ditemukan' });
    }

    res.status(200).json({ message: 'Layanan servis berhasil dihapus' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Terjadi kesalahan pada server' });
  }
};