import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';

// Mendefinisikan tipe data untuk request yang sudah dimodifikasi
export interface AuthRequest extends Request {
  user?: { id: number; role_id: number };
}

// 1. Middleware untuk mengecek apakah user sudah login (punya token valid)
export const verifyToken = (req: AuthRequest, res: Response, next: NextFunction) => {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ message: 'Akses ditolak. Token tidak disediakan.' });
  }

  const token = authHeader.split(' ')[1];

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET as string) as { id: number; role_id: number };
    req.user = decoded; // Menyimpan data user ke dalam request
    next(); // Lanjut ke controller berikutnya
  } catch (error) {
    return res.status(403).json({ message: 'Token tidak valid atau sudah kedaluwarsa.' });
  }
};

// 2. Middleware untuk mengecek Role (Otorisasi)
export const checkRole = (allowedRoles: number[]) => {
  return (req: AuthRequest, res: Response, next: NextFunction) => {
    if (!req.user) {
      return res.status(401).json({ message: 'Akses ditolak. User tidak teridentifikasi.' });
    }

    // Cek apakah role_id user ada di dalam daftar role yang diizinkan
    if (!allowedRoles.includes(req.user.role_id)) {
      return res.status(403).json({ message: 'Akses ditolak. Anda tidak memiliki izin (role).' });
    }

    next();
  };
};