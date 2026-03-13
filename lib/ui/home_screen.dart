import 'package:flutter/material.dart';
import '../styles/app_colors.dart';
import 'login_screen.dart';
import '../models/menu_item.dart';
import '../ui/widgets/banner_widgets.dart';
import 'order_screen.dart';
import '../ui/widgets/menu_card_widget.dart';

class HomeScreen extends StatelessWidget {
  final String username;

  const HomeScreen({super.key, required this.username});

  static final List<MenuItem> menuList = [
    MenuItem(
      nama: 'Nasi Goreng',
      harga: 15000,
      imagePath: 'assets/images/menu/nasi_goreng.png',
      deskripsi: 'Nasi goreng spesial',
    ),
    MenuItem(
      nama: 'Mie Ayam',
      harga: 12000,
      imagePath: 'assets/images/menu/mie_ayam.png',
      deskripsi: 'Mie ayam bakso',
    ),
    MenuItem(
      nama: 'Sate Ayam',
      harga: 20000,
      imagePath: 'assets/images/menu/sate_ayam.png',
      deskripsi: 'Sate 10 tusuk',
    ),
    MenuItem(
      nama: 'Bakso',
      harga: 10000,
      imagePath: 'assets/images/menu/bakso.png',
      deskripsi: 'Bakso urat kenyal',
    ),
    MenuItem(
      nama: 'Soto Ayam',
      harga: 13000,
      imagePath: 'assets/images/menu/soto_ayam.png',
      deskripsi: 'Soto kuah bening',
    ),
    MenuItem(
      nama: 'Gado-Gado',
      harga: 11000,
      imagePath: 'assets/images/menu/gado_gado.png',
      deskripsi: 'Sayur + bumbu kacang',
    ),
  ];

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Logout',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        content: const Text('Yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Batal',
              style: TextStyle(color: AppColors.textGrey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Keluar', style: TextStyle(color: Colors.white)),
          ),
        ],
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
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.restaurant_menu,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'MBG Merchant',
              style: TextStyle(
                color: AppColors.textDark,
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => _showLogoutDialog(context),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.logout, color: Colors.red.shade400, size: 18),
            ),
            tooltip: 'Logout',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Banner
          SliverToBoxAdapter(child: BannerWidget(username: username)),

          // Section title
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
              child: Row(
                children: [
                  Text(
                    'Daftar Menu',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text('🍽️', style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
          ),

          // Grid menu
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final menu = menuList[index];
                return MenuCardWidget(
                  menu: menu,
                  onPesan: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrderScreen(menu: menu),
                      ),
                    );
                  },
                );
              }, childCount: menuList.length),
            ),
          ),
        ],
      ),
    );
  }
}
