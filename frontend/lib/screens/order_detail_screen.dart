import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/order_model.dart';
import '../providers/order_provider.dart';
import '../utils/theme.dart';

class OrderDetailScreen extends StatelessWidget {
  final OrderModel order;

  const OrderDetailScreen({super.key, required this.order});

  // Fungsi untuk menampilkan BottomSheet pilihan status
  void _showStatusPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Ubah Status Pesanan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              _buildStatusItem(context, 'pending', 'Pending (Menunggu)'),
              _buildStatusItem(context, 'diagnosa', 'Diagnosa (Pengecekan)'),
              _buildStatusItem(context, 'perbaikan', 'Perbaikan (Dikerjakan)'),
              _buildStatusItem(context, 'selesai', 'Selesai (Siap Diambil)'),
              _buildStatusItem(context, 'diambil', 'Diambil (Tuntas)'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusItem(BuildContext context, String status, String label) {
    return ListTile(
      title: Text(label),
      trailing: order.status == status ? const Icon(Icons.check, color: Colors.green) : null,
      onTap: () async {
        Navigator.pop(context); // Tutup BottomSheet
        final error = await Provider.of<OrderProvider>(context, listen: false)
            .updateStatus(order.id, status);
        
        if (!context.mounted) return;
        
        if (error == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Status berhasil diubah'), backgroundColor: AppColors.success),
          );
          Navigator.pop(context); // Kembali ke list pesanan (agar data ter-refresh)
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error), backgroundColor: AppColors.error),
          );
        }
      },
    );
  }

  // Fungsi pewarnaan timeline
  Color _getTimelineColor(String status, String step) {
    List<String> steps = ['pending', 'diagnosa', 'perbaikan', 'selesai', 'diambil'];
    int currentIdx = steps.indexOf(status);
    int stepIdx = steps.indexOf(step);

    if (currentIdx >= stepIdx) return AppColors.primary; // Sudah dilewati
    return Colors.grey[300]!; // Belum dilewati
  }

  @override
  Widget build(BuildContext context) {
    // Format tanggal
    final date = DateTime.parse(order.createdAt).toLocal();
    final formattedDate = DateFormat('dd MMM yyyy, HH:mm').format(date);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Detail Pesanan', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kartu Info Pelanggan
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Order #${order.id}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('Dibuat: $formattedDate', style: const TextStyle(color: Colors.grey)),
                    const Divider(height: 24),
                    _buildInfoRow('Pelanggan', order.customerName),
                    _buildInfoRow('No HP', order.phone),
                    _buildInfoRow('Perangkat', order.deviceType),
                    _buildInfoRow('Keluhan', order.problemDescription),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Foto Perangkat (Jika ada)
            if (order.photoPath != null) ...[
              const Text('Foto Perangkat', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  order.photoPath!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Center(child: Text('Gagal memuat gambar')),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Visual Timeline Status
            const Text('Timeline Servis', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildTimelineStep('pending', 'Pesanan Diterima', 'Barang masuk ke toko'),
            _buildTimelineStep('diagnosa', 'Diagnosa', 'Teknisi mengecek kerusakan'),
            _buildTimelineStep('perbaikan', 'Perbaikan', 'Proses penggantian sparepart'),
            _buildTimelineStep('selesai', 'Selesai', 'Siap diambil pelanggan'),
            _buildTimelineStep('diambil', 'Diambil', 'Transaksi selesai', isLast: true),
            
            const SizedBox(height: 32),
            // Tombol Ubah Status
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showStatusPicker(context),
                child: const Text('Ubah Status Sekarang', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 100, child: Text(label, style: const TextStyle(color: Colors.grey))),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  Widget _buildTimelineStep(String step, String title, String subtitle, {bool isLast = false}) {
    final isActive = _getTimelineColor(order.status, step) == AppColors.primary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : Colors.white,
                border: Border.all(color: isActive ? AppColors.primary : Colors.grey[400]!, width: 2),
                shape: BoxShape.circle,
              ),
              child: isActive ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isActive ? AppColors.primary : Colors.grey[300],
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: isActive ? FontWeight.bold : FontWeight.normal, fontSize: 16)),
              Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}