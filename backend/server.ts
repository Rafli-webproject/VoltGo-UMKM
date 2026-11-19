import express, { Request, Response } from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import db from './src/config/db';
import authRoute from './src/routes/auth.route';
import serviceRoute from './src/routes/service.route';
import orderRoute from './src/routes/order.route'; // <-- Tambahan baru

dotenv.config();

const app = express();

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Folder statis untuk akses gambar

app.use('/api/auth', authRoute);
app.use('/api/services', serviceRoute);
app.use('/api/orders', orderRoute); // <-- Tambahan baru

app.get('/', (req: Request, res: Response) => {
  res.status(200).json({ message: 'Server VoltGo Backend Berjalan dengan TypeScript!', status: 'success' });
});

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Server berjalan di port ${PORT}`);
});