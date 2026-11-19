import { Router } from 'express';
import { createService, getAllServices, updateService, deleteService } from '../controllers/service.controller';
import { verifyToken, checkRole } from '../middlewares/auth.middleware';

const router = Router();

// Semua user yang login bisa melihat data (GET)
router.get('/', verifyToken, getAllServices);

// Hanya Admin (role_id = 1) yang bisa menambah, mengubah, dan menghapus
router.post('/', verifyToken, checkRole([1]), createService);
router.put('/:id', verifyToken, checkRole([1]), updateService);
router.delete('/:id', verifyToken, checkRole([1]), deleteService);

export default router;