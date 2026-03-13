import '../models/menu_item.dart';

/// Service untuk mengelola logika bisnis pemesanan
/// Memisahkan business logic dari UI (Separation of Concerns)
class OrderService {
  final MenuItem menu;

  int _jumlah = 0;
  int _totalHarga = 0;
  bool _isSubmitted = false;

  OrderService({required this.menu});

  // ── Getters (Encapsulation) ──────────────────
  int get jumlah => _jumlah;
  int get totalHarga => _totalHarga;
  bool get isSubmitted => _isSubmitted;
  bool get isValid => _jumlah > 0;
  // ─────────────────────────────────────────────

  /// Hitung total dari input manual
  void hitungTotal(String input) {
    final parsed = int.tryParse(input) ?? 0;
    _jumlah = parsed;
    _totalHarga = parsed * menu.harga;
    _isSubmitted = parsed > 0;
  }

  /// Tambah jumlah pesanan sebanyak 1
  void increment() {
    _jumlah++;
    _totalHarga = _jumlah * menu.harga;
    _isSubmitted = true;
  }

  /// Kurangi jumlah pesanan sebanyak 1 (minimum 0)
  void decrement() {
    if (_jumlah <= 0) return;
    _jumlah--;
    _totalHarga = _jumlah * menu.harga;
    _isSubmitted = _jumlah > 0;
  }

  /// Reset semua state ke awal
  void reset() {
    _jumlah = 0;
    _totalHarga = 0;
    _isSubmitted = false;
  }

  /// Format angka ke format Rupiah: 15000 → "15.000"
  String formatHarga(int harga) {
    return harga.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
  }

  /// Format total harga yang sudah dihitung
  String get totalHargaFormatted => formatHarga(_totalHarga);

  /// Format harga per porsi menu
  String get hargaPerPorsiFormatted => formatHarga(menu.harga);

  /// Ringkasan pesanan untuk ditampilkan di dialog
  String get ringkasanPesanan => '${menu.nama} x$_jumlah';
}