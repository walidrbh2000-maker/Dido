import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voyageur/core/constants/app_colors.dart';
import 'package:voyageur/core/constants/app_spacing.dart';
import 'package:voyageur/core/router/app_routes.dart';
import 'package:voyageur/core/utils/helpers/currency_helper.dart';
import 'package:voyageur/providers/vol/vol_provider.dart';
import 'package:voyageur/shared_widgets/buttons/primary_button.dart';
import 'package:voyageur/shared_widgets/loaders/app_loading_indicator.dart';

class VolDetailScreen extends ConsumerWidget {
  final int volId;

  const VolDetailScreen({super.key, required this.volId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final volAsync = ref.watch(volDetailProvider(volId));

    return volAsync.when(
      loading: () => const Scaffold(body: Center(child: AppLoadingIndicator())),
      error: (e, _) => Scaffold(appBar: AppBar(), body: Center(child: Text('Erreur: $e'))),
      data: (vol) => Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [AppColors.primary, AppColors.primaryLight]),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(vol.dateDepart.toLocal().toString().substring(11, 16), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: Colors.white)),
                          const Icon(Icons.flight, color: Colors.white70, size: 32),
                          Text(vol.dateArrivee.toLocal().toString().substring(11, 16), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: Colors.white)),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(vol.destinationName ?? 'Départ', style: TextStyle(color: Colors.white70, fontSize: 14)),
                          Text(vol.destinationCountry ?? 'Arrivée', style: TextStyle(color: Colors.white70, fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DetailRow(icon: Icons.airlines, label: 'Compagnie', value: vol.compagnie),
                    _DetailRow(icon: Icons.confirmation_number, label: 'N° de vol', value: vol.numeroVol),
                    _DetailRow(icon: Icons.calendar_today, label: 'Date', value: '${vol.dateDepart.day}/${vol.dateDepart.month}/${vol.dateDepart.year}'),
                    _DetailRow(icon: Icons.airline_seat_recline_normal, label: 'Classe', value: vol.classeLabel),
                    _DetailRow(icon: Icons.people, label: 'Places disponibles', value: '${vol.placesDisponibles}'),
                    const SizedBox(height: AppSpacing.xl),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Prix par personne', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                          Text(CurrencyHelper.format(vol.prix), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.primary)),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    PrimaryButton(
                      label: 'Réserver maintenant',
                      icon: Icons.bookmark_add,
                      onPressed: () => context.go(AppRoutes.createReservation),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: AppSpacing.md),
          Text(label, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
