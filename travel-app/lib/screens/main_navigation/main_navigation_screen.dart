import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voyageur/core/constants/app_colors.dart';
import 'package:voyageur/core/constants/app_spacing.dart';
import 'package:voyageur/core/router/app_routes.dart';
import 'package:voyageur/shared_widgets/navigation/main_navigation_bar.dart';

class MainNavigationScreen extends StatefulWidget {
  final Widget child;

  const MainNavigationScreen({super.key, required this.child});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateCurrentIndex();
  }

  void _updateCurrentIndex() {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith(AppRoutes.vols)) {
      _currentIndex = 1;
    } else if (location.startsWith(AppRoutes.hotels)) {
      _currentIndex = 2;
    } else if (location.startsWith(AppRoutes.reservations)) {
      _currentIndex = 3;
    } else if (location.startsWith(AppRoutes.profile)) {
      _currentIndex = 4;
    } else {
      _currentIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: widget.child,
      bottomNavigationBar: MainNavigationBar(currentIndex: _currentIndex),
    );
  }
}
