import 'package:flutter/material.dart';
import '../styles/app_colors.dart';
import '../models/menu_item.dart';
import '../services/order_services.dart';

class OrderScreen extends StatefulWidget {
  final MenuItem menu;

  const OrderScreen({super.key, required this.menu});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final _jumlahController = TextEditingController();

  // Dependency Injection: UI menggunakan OrderService untuk semua logika
  late final OrderService _orderService;

  @override
  void initState() {
    super.initState();
    _orderService = OrderService(menu: widget.menu);
  }

  @override
  void dispose() {
    _jumlahController.dispose();
    super.dispose();
  }

  // ── Handler: hanya update state & delegasi ke service ──

  void _onIncrement() {
    setState(() {
      _orderService.increment();
      _jumlahController.text = _orderService.jumlah.toString();
    });
  }

  void _onDecrement() {
    setState(() {
      _orderService.decrement();
      _jumlahController.text = _orderService.jumlah > 0
          ? _orderService.jumlah.toString()
          : '';
    });
  }

  void _onInputChanged(String val) {
    setState(() => _orderService.hitungTotal(val));
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('✅', style: TextStyle(fontSize: 52)),
            const SizedBox(height: 12),
            const Text(
              'Pesanan Berhasil!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            // Data dari service, bukan dari state UI
            Text(
              _orderService.ringkasanPesanan,
              style: const TextStyle(color: AppColors.textGrey),
            ),
            const SizedBox(height: 4),
            Text(
              'Total: Rp ${_orderService.totalHargaFormatted}',
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Kembali ke Menu',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.textDark,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail Order',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _MenuInfoCard(service: _orderService),
            const SizedBox(height: 20),
            _JumlahInputCard(
              controller: _jumlahController,
              service: _orderService,
              onIncrement: _onIncrement,
              onDecrement: _onDecrement,
              onInputChanged: _onInputChanged,
              onSubmit: _showSuccessDialog,
            ),
            const SizedBox(height: 20),
            _TotalHargaCard(service: _orderService),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
// WIDGET: Info menu (nama, emoji, deskripsi, harga)
// ══════════════════════════════════════════════════════
class _MenuInfoCard extends StatelessWidget {
  final OrderService service;

  const _MenuInfoCard({required this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                service.menu.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: AppColors.textGrey,
                      size: 32,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            service.menu.nama,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            service.menu.deskripsi,
            style: const TextStyle(color: AppColors.textGrey, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              // Format harga dari service, bukan hitung di UI
              'Rp ${service.hargaPerPorsiFormatted} / porsi',
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
// WIDGET: Input jumlah dengan stepper +/-
// ══════════════════════════════════════════════════════
class _JumlahInputCard extends StatelessWidget {
  final TextEditingController controller;
  final OrderService service;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final ValueChanged<String> onInputChanged;
  final VoidCallback onSubmit;

  const _JumlahInputCard({
    required this.controller,
    required this.service,
    required this.onIncrement,
    required this.onDecrement,
    required this.onInputChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Jumlah Pesanan',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              // Tombol −
              GestureDetector(
                onTap: onDecrement,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: const Icon(Icons.remove, color: AppColors.textDark),
                ),
              ),
              const SizedBox(width: 12),

              // TextField
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: AppColors.textDark,
                  ),
                  decoration: InputDecoration(
                    hintText: '0',
                    hintStyle: const TextStyle(color: AppColors.textLight),
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 1.5,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                  ),
                  onChanged: onInputChanged,
                ),
              ),
              const SizedBox(width: 12),

              // Tombol +
              GestureDetector(
                onTap: onIncrement,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Tombol Submit
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: service.isValid ? onSubmit : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.divider,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Submit Pesanan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: service.isValid
                          ? Colors.white
                          : AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
// WIDGET: Card total harga
// ══════════════════════════════════════════════════════
class _TotalHargaCard extends StatelessWidget {
  final OrderService service;

  const _TotalHargaCard({required this.service});

  @override
  Widget build(BuildContext context) {
    final aktif = service.isSubmitted && service.isValid;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: aktif
            ? const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: aktif ? null : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (aktif ? AppColors.primary : Colors.black).withOpacity(0.15),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total Harga:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: aktif ? Colors.white70 : AppColors.textGrey,
            ),
          ),
          Text(
            'Rp ${service.totalHargaFormatted}',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: aktif ? Colors.white : AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
