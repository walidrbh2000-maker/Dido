import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voyageur/core/constants/app_colors.dart';
import 'package:voyageur/core/constants/app_spacing.dart';
import 'package:voyageur/core/router/app_routes.dart';
import 'package:voyageur/providers/auth/auth_provider.dart';
import 'package:voyageur/providers/user/user_profile_provider.dart';
import 'package:voyageur/screens/profile/widgets/language_selector.dart';
import 'package:voyageur/screens/profile/widgets/profile_header.dart';
import 'package:voyageur/screens/profile/widgets/settings_tile.dart';
import 'package:voyageur/shared_widgets/loaders/app_loading_indicator.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: userAsync.when(
        loading: () => const Center(child: AppLoadingIndicator()),
        error: (e, _) => const Center(child: Text('Erreur de chargement')),
        data: (user) {
          if (user == null) {
            return const Center(child: Text('Non connect\u00e9'));
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                ProfileHeader(
                  name: user.name,
                  email: user.email,
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    children: [
                      SettingsTile(
                        icon: Icons.person_outline,
                        title: 'Modifier le profil',
                        subtitle: 'Nom, email, t\u00e9l\u00e9phone',
                        onTap: () => context.go(AppRoutes.editProfile),
                      ),
                      SettingsTile(
                        icon: Icons.bookmark_outline,
                        title: 'Mes r\u00e9servations',
                        subtitle: 'Historique et suivi',
                        onTap: () => context.go(AppRoutes.reservations),
                      ),
                      SettingsTile(
                        icon: Icons.payment_outlined,
                        title: 'Moyens de paiement',
                        subtitle: 'Cartes et portefeuilles',
                      ),
                      SettingsTile(
                        icon: Icons.notifications_outlined,
                        title: 'Notifications',
                        subtitle: 'Alertes et rappels',
                      ),
                      SettingsTile(
                        icon: Icons.shield_outlined,
                        title: 'Confidentialit\u00e9',
                        subtitle: 'Donn\u00e9es et s\u00e9curit\u00e9',
                      ),
                      SettingsTile(
                        icon: Icons.help_outline,
                        title: 'Aide et support',
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      const LanguageSelector(),
                      const SizedBox(height: AppSpacing.lg),
                      SettingsTile(
                        icon: Icons.logout,
                        title: 'D\u00e9connexion',
                        iconColor: AppColors.error,
                        onTap: () async {
                          await ref.read(authProvider.notifier).logout();
                          if (context.mounted) {
                            context.go(AppRoutes.login);
                          }
                        },
                        trailing: const SizedBox.shrink(),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
