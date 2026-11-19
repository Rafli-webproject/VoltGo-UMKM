import multer from 'multer';
import { v2 as cloudinary } from 'cloudinary';
import { CloudinaryStorage } from 'multer-storage-cloudinary';
import dotenv from 'dotenv';

dotenv.config();

// 1. Konfigurasi Cloudinary dari file .env
cloudinary.config({
  cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
  api_key: process.env.CLOUDINARY_API_KEY,
  api_secret: process.env.CLOUDINARY_API_SECRET,
});

// 2. Konfigurasi Penyimpanan Cloudinary untuk Multer
const storage = new CloudinaryStorage({
  cloudinary: cloudinary,
  params: {
    folder: 'voltgo_orders', // Nama folder di Cloudinary
    allowed_formats: ['jpg', 'jpeg', 'png'], // Format yang diizinkan
  } as any, 
});

// 3. Filter Tipe File (Lapisan Keamanan Ekstra)
const fileFilter = (req: any, file: any, cb: any) => {
  const allowedTypes = /jpeg|jpg|png/;
  const mimetype = allowedTypes.test(file.mimetype);

  if (mimetype) {
    cb(null, true);
  } else {
    cb(new Error('Hanya file gambar (JPG, JPEG, PNG) yang diperbolehkan!'));
  }
};

// 4. Ekspor Middleware Multer
export const upload = multer({
  storage,
  limits: { fileSize: 2 * 1024 * 1024 }, // Maksimal 2MB
  fileFilter
});