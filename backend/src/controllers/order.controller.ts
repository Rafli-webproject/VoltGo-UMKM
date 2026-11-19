import { Response } from 'express';
import db from '../config/db';
import { AuthRequest } from '../middlewares/auth.middleware';

// 1. Create (Buat Pesanan Baru)
export const createOrder = async (req: AuthRequest, res: Response) => {
  try {
    const { customer_name, phone, device_type, problem_description, service_id, technician_id } = req.body;
    
    // Ambil path file dari multer (jika ada yang diupload)
    const photo_path = req.file ? req.file.path : null;

    if (!customer_name || !phone || !device_type || !problem_description) {
      return res.status(400).json({ message: 'Data pesanan belum lengkap' });
    }

    const [result]: any = await db.query(
      'INSERT INTO orders (customer_name, phone, device_type, problem_description, service_id, technician_id, photo_path) VALUES (?, ?, ?, ?, ?, ?, ?)',
      [customer_name, phone, device_type, problem_description, service_id, technician_id, photo_path]
    );

    res.status(201).json({ 
      message: 'Pesanan berhasil dibuat',
      data: { id: result.insertId, customer_name, device_type, status: 'pending', photo_path }
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Terjadi kesalahan pada server' });
  }
};

// 2. Read (Lihat Semua Pesanan)
export const getAllOrders = async (req: AuthRequest, res: Response) => {
  try {
    // Query dengan JOIN untuk mengambil nama layanan dan nama teknisi
    const query = `
      SELECT o.*, s.name as service_name, u.name as technician_name 
      FROM orders o
      LEFT JOIN services s ON o.service_id = s.id
      LEFT JOIN users u ON o.technician_id = u.id
      ORDER BY o.created_at DESC
    `;
    const [rows]: any = await db.query(query);
    res.status(200).json({ message: 'Berhasil mengambil data pesanan', data: rows });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Terjadi kesalahan pada server' });
  }
};

// 3. Update Status (Khusus Teknisi/Admin)
export const updateOrderStatus = async (req: AuthRequest, res: Response) => {
  try {
    const { id } = req.params;
    const { status } = req.body;

    const validStatus = ['pending', 'diagnosa', 'perbaikan', 'selesai', 'diambil'];
    if (!validStatus.includes(status)) {
      return res.status(400).json({ message: 'Status tidak valid' });
    }

    const [result]: any = await db.query('UPDATE orders SET status = ? WHERE id = ?', [status, id]);

    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Pesanan tidak ditemukan' });
    }

    res.status(200).json({ message: 'Status pesanan berhasil diperbarui' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Terjadi kesalahan pada server' });
  }
};