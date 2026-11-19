import { Router } from 'express';
import { createOrder, getAllOrders, updateOrderStatus } from '../controllers/order.controller';
import { verifyToken, checkRole } from '../middlewares/auth.middleware';
import { upload } from '../middlewares/upload.middleware';

const router = Router();

// Semua user yang login bisa melihat pesanan
router.get('/', verifyToken, getAllOrders);

// Admin (1) dan Teknisi (2) bisa membuat pesanan
// Gunakan upload.single('photo') untuk menangani file
router.post('/', verifyToken, checkRole([1, 2]), upload.single('photo'), createOrder);

// Admin (1) dan Teknisi (2) bisa mengubah status
router.put('/:id/status', verifyToken, checkRole([1, 2]), updateOrderStatus);

export default router;