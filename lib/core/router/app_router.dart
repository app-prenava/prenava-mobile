import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/presentation/pages/splash_screen.dart';
import '../../features/splash/presentation/pages/onboarding_screen.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/change_password_page.dart';
import '../../features/main/presentation/pages/main_scaffold.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/shop/presentation/pages/add_edit_shop_page.dart';
import '../../features/shop/presentation/pages/shop_detail_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const MainScaffold(),
      ),
      GoRoute(
        path: '/edit-profile',
        builder: (context, state) => const EditProfilePage(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: '/change-password',
        builder: (context, state) => const ChangePasswordPage(),
      ),
      GoRoute(
        path: '/shop/add',
        builder: (context, state) => const AddEditShopPage(),
      ),
      GoRoute(
        path: '/shop/edit/:id',
        builder: (context, state) {
          // TODO: Get product from state and pass to edit page
          return const AddEditShopPage();
        },
      ),
      GoRoute(
        path: '/shop/detail/:id',
        builder: (context, state) {
          final productId = state.pathParameters['id']!;
          return ShopDetailPage(productId: productId);
        },
      ),
    ],
  );
});

