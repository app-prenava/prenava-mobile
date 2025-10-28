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

  final List<Widget> _pages = const [
    HomePage(),
    CommunityPage(),
    ShopPage(),
    AccountPage(),
  ];

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
          border: Border(
            top: BorderSide(
              color: Colors.grey[300]!,
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 70,
                  child: _currentIndex == 2
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
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
                            // Center Add Button - only on Shop page
                            _buildAddButton(context),
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
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
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
                          ],
                        ),
          ),
        ),
      ),
    );
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

  Widget _buildAddButton(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/shop/add'),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            const Text(
              'Jual',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFFFA6978),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

