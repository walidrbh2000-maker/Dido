import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voyageur/core/constants/app_colors.dart';
import 'package:voyageur/core/constants/app_spacing.dart';
import 'package:voyageur/core/router/app_routes.dart';
import 'package:voyageur/providers/reservation/reservation_provider.dart';
import 'package:voyageur/screens/reservations/widgets/reservation_status_badge.dart';
import 'package:voyageur/screens/reservations/widgets/reservation_timeline.dart';
import 'package:voyageur/screens/reservations/widgets/ticket_widget.dart';
import 'package:voyageur/shared_widgets/buttons/primary_button.dart';
import 'package:voyageur/shared_widgets/buttons/secondary_button.dart';
import 'package:voyageur/shared_widgets/loaders/app_loading_indicator.dart';

class ReservationDetailScreen extends ConsumerStatefulWidget {
  final int reservationId;

  const ReservationDetailScreen({super.key, required this.reservationId});

  @override
  ConsumerState<ReservationDetailScreen> createState() => _ReservationDetailScreenState();
}

class _ReservationDetailScreenState extends ConsumerState<ReservationDetailScreen> {
  bool _isCancelling = false;

  @override
  Widget build(BuildContext context) {
    final reservationsAsync = ref.watch(reservationsProvider);

    return reservationsAsync.when(
      loading: () => const Scaffold(body: Center(child: AppLoadingIndicator())),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Erreur: $e')),
      ),
      data: (reservations) {
        final reservation = reservations.where((r) => r.id == widget.reservationId).firstOrNull;
        if (reservation == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('R\u00e9servation introuvable')),
          );
        }

        return Scaffold(
          appBar: AppBar(title: Text(reservation.reference)),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: ReservationStatusBadge(statut: reservation.statut),
                ),
                const SizedBox(height: AppSpacing.lg),
                TicketWidget(reservation: reservation),
                const SizedBox(height: AppSpacing.lg),
                ReservationTimeline(statut: reservation.statut),
                const SizedBox(height: AppSpacing.xl),
                if (reservation.isActive && !reservation.isPaid) ...[
                  PrimaryButton(
                    label: 'Proc\u00e9der au paiement',
                    icon: Icons.payment,
                    onPressed: () => context.go(AppRoutes.payment),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SecondaryButton(
                    label: 'Annuler la r\u00e9servation',
                    icon: Icons.cancel_outlined,
                    onPressed: _isCancelling ? null : _cancelReservation,
                    isLoading: _isCancelling,
                  ),
                ],
                if (reservation.isPaid) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMd),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle, color: AppColors.success),
                        SizedBox(width: AppSpacing.sm),
                        Text(
                          'R\u00e9servation pay\u00e9e',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _cancelReservation() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Annuler la r\u00e9servation ?'),
        content: const Text('Cette action est irr\u00e9versible.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Non')),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Oui', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _isCancelling = true);
    final success = await ref.read(reservationsProvider.notifier).cancel(widget.reservationId);
    if (!mounted) return;
    setState(() => _isCancelling = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('R\u00e9servation annul\u00e9e'), backgroundColor: AppColors.success),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de l\'annulation'), backgroundColor: AppColors.error),
      );
    }
  }
}
