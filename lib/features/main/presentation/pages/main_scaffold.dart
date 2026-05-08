import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/providers/guide_provider.dart';
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
    return ValueListenableBuilder<bool>(
      valueListenable: guideVisibleNotifier,
      builder: (context, isGuideVisible, _) {
        return Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: _pages,
          ),
          floatingActionButton: _showCenterButton
              ? FloatingActionButton(
                  onPressed: () {
                    final String route = _currentIndex == 1 ? '/community/create' : '/shop/add';
                    context.push(route);
                  },
                  backgroundColor: const Color(0xFFFA6978),
                  elevation: 4,
                  shape: const CircleBorder(),
                  child: const Icon(Icons.add, color: Colors.white, size: 30),
                )
              : null,
          bottomNavigationBar: (isGuideVisible && (_currentIndex == 1 || _currentIndex == 2))
              ? null
              : Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                  child: Container(
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: _buildNavWithoutCenterButton(),
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }

  // 4 nav items only (for all pages)
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

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isActive = _currentIndex == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: EdgeInsets.symmetric(
        horizontal: isActive ? 16 : 8,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFFA6978) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? Colors.white : Colors.grey[600],
              size: 24,
            ),
            if (isActive) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
