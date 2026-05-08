import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voyageur/core/constants/app_spacing.dart';
import 'package:voyageur/core/router/app_routes.dart';
import 'package:voyageur/providers/reservation/reservation_provider.dart';
import 'package:voyageur/screens/reservations/widgets/reservation_card.dart';
import 'package:voyageur/shared_widgets/errors/empty_state_widget.dart';
import 'package:voyageur/shared_widgets/errors/error_widget.dart';
import 'package:voyageur/shared_widgets/shimmer/list_shimmer.dart';

class ReservationsScreen extends ConsumerWidget {
  const ReservationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reservationsAsync = ref.watch(reservationsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mes r\u00e9servations')),
      body: reservationsAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: ListShimmer(itemCount: 4),
        ),
        error: (e, _) => AppErrorWidget(
          message: 'Erreur de chargement',
          onRetry: () => ref.invalidate(reservationsProvider),
        ),
        data: (reservations) {
          if (reservations.isEmpty) {
            return EmptyStateWidget(
              message: 'Aucune r\u00e9servation',
              icon: Icons.bookmark_border,
              actionLabel: 'R\u00e9server un vol',
              onAction: () => context.go(AppRoutes.vols),
            );
          }
          return RefreshIndicator(
            onRefresh: () => ref.read(reservationsProvider.notifier).refresh(),
            child: ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: reservations.length,
              itemBuilder: (context, index) {
                final r = reservations[index];
                return ReservationCard(
                  reservation: r,
                  onTap: () => context.go(AppRoutes.reservationDetailPath(r.id)),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
