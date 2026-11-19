import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';
import '../utils/theme.dart';
import 'create_order_screen.dart'; // Import halaman tambah pesanan

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  void initState() {
    super.initState();
    // Memanggil data pesanan saat halaman pertama kali dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrderProvider>(context, listen: false).fetchOrders();
    });
  }

  // Fungsi untuk memberi warna pada Badge Status
  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending': return Colors.orange;
      case 'diagnosa': return Colors.blue;
      case 'perbaikan': return Colors.purple;
      case 'selesai': return Colors.green;
      case 'diambil': return Colors.grey;
      default: return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Daftar Pesanan', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      // Tombol Tambah Pesanan (Floating Action Button)
            floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateOrderScreen()),
          );
          // Pengecekan context.mounted untuk menghindari warning async gap
          if (context.mounted) {
            Provider.of<OrderProvider>(context, listen: false).fetchOrders();
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: orderProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : orderProvider.errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(orderProvider.errorMessage!, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => orderProvider.fetchOrders(),
                        child: const Text('Coba Lagi'),
                      )
                    ],
                  ),
                )
              : orderProvider.orders.isEmpty
                  ? const Center(child: Text('Belum ada pesanan'))
                  : RefreshIndicator(
                      onRefresh: () => orderProvider.fetchOrders(),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: orderProvider.orders.length,
                        itemBuilder: (context, index) {
                          final order = orderProvider.orders[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Order #${order.id}',
                                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          // Perbaikan withOpacity menjadi withValues
                                          color: _getStatusColor(order.status).withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          order.status.toUpperCase(),
                                          style: TextStyle(
                                            color: _getStatusColor(order.status), 
                                            fontWeight: FontWeight.bold, 
                                            fontSize: 12
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(order.deviceType, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text('Pelanggan: ${order.customerName}'),
                                  Text('Keluhan: ${order.problemDescription}'),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}