import 'package:go_router/go_router.dart';

import '../../features/admin/presentation/admin_dashboard_page.dart';
import '../../features/admin/presentation/admin_login_page.dart';
import '../../features/authentication/presentation/login_page.dart';
import '../../features/authentication/presentation/sign_up_page.dart';
import '../../features/home/presentation/home_page.dart';

abstract final class AppRoutes {
  static const home = '/';
  static const login = '/login';
  static const signUp = '/signup';
  static const adminLogin = '/admin/login';
  static const adminDashboard = '/admin/dashboard';
}

/// Customer and admin routes have separate namespaces.
final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.signUp,
      builder: (context, state) => const SignUpPage(),
    ),
    GoRoute(
      path: AppRoutes.adminLogin,
      builder: (context, state) => const AdminLoginPage(),
    ),
    GoRoute(
      path: AppRoutes.adminDashboard,
      builder: (context, state) => const AdminDashboardPage(),
    ),
  ],
);
