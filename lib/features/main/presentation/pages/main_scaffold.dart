import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../community/presentation/pages/community_page.dart';
import '../../../shop/presentation/pages/shop_page.dart';
import '../../../account/presentation/pages/account_page.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const CommunityPage(),
    const ShopPage(),
    const AccountPage(),
  ];

  // Check if we should show center add button
  bool get _showCenterButton => _currentIndex == 1 || _currentIndex == 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _showCenterButton
                  ? _buildNavWithCenterButton()
                  : _buildNavWithoutCenterButton(),
            ),
          ),
        ),
      ),
    );
  }

  // 4 nav items only (for Beranda & Akun Saya pages)
  List<Widget> _buildNavWithoutCenterButton() {
    return [
      _buildNavItem(
        icon: Icons.home_outlined,
        activeIcon: Icons.home,
        label: 'Beranda',
        index: 0,
      ),
      _buildNavItem(
        icon: Icons.people_outline,
        activeIcon: Icons.people,
        label: 'Komunitas',
        index: 1,
      ),
      _buildNavItem(
        icon: Icons.shopping_bag_outlined,
        activeIcon: Icons.shopping_bag,
        label: 'Belanja',
        index: 2,
      ),
      _buildNavItem(
        icon: Icons.person_outline,
        activeIcon: Icons.person,
        label: 'Akun Saya',
        index: 3,
      ),
    ];
  }

  // 4 nav items + center button (for Komunitas & Belanja pages)
  List<Widget> _buildNavWithCenterButton() {
    return [
      _buildNavItem(
        icon: Icons.home_outlined,
        activeIcon: Icons.home,
        label: 'Beranda',
        index: 0,
      ),
      _buildNavItem(
        icon: Icons.people_outline,
        activeIcon: Icons.people,
        label: 'Komunitas',
        index: 1,
      ),
      _buildCenterAddButton(),
      _buildNavItem(
        icon: Icons.shopping_bag_outlined,
        activeIcon: Icons.shopping_bag,
        label: 'Belanja',
        index: 2,
      ),
      _buildNavItem(
        icon: Icons.person_outline,
        activeIcon: Icons.person,
        label: 'Akun Saya',
        index: 3,
      ),
    ];
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isActive = _currentIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? const Color(0xFFFA6978) : Colors.grey[600],
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                color: isActive ? const Color(0xFFFA6978) : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterAddButton() {
    final String route = _currentIndex == 1 ? '/community/create' : '/shop/add';
    final String label = _currentIndex == 1 ? 'Post' : 'Jual';

    return GestureDetector(
      onTap: () => context.push(route),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFA6978), Color(0xFFFF8A95)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFA6978).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFFFA6978),
            ),
          ),
        ],
      ),
    );
  }
}
