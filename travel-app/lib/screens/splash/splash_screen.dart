import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voyageur/core/constants/app_colors.dart';
import 'package:voyageur/core/constants/app_constants.dart';
import 'package:voyageur/core/router/app_routes.dart';
import 'package:voyageur/core/storage/secure_storage.dart';
import 'package:voyageur/providers/auth/auth_provider.dart';
import 'package:voyageur/screens/splash/widgets/animated_logo.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    await Future.delayed(
      Duration(seconds: AppConstants.splashDurationSeconds),
    );

    if (!mounted) return;

    final secureStorage = SecureStorage();
    final hasToken = await secureStorage.hasToken();
    final hasSeenOnboarding = await secureStorage.hasSeenOnboarding();

    if (!mounted) return;

    if (hasToken) {
      ref.read(authProvider.notifier).checkAuth();
      context.go(AppRoutes.home);
    } else if (hasSeenOnboarding) {
      context.go(AppRoutes.login);
    } else {
      context.go(AppRoutes.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primary, AppColors.primaryLight],
          ),
        ),
        child: const Center(
          child: AnimatedLogo(),
        ),
      ),
    );
  }
}
