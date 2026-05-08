import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voyageur/core/constants/app_spacing.dart';
import 'package:voyageur/core/router/app_routes.dart';
import 'package:voyageur/providers/hotel/hotel_provider.dart';
import 'package:voyageur/shared_widgets/cards/hotel_card.dart';
import 'package:voyageur/shared_widgets/errors/empty_state_widget.dart';
import 'package:voyageur/shared_widgets/errors/error_widget.dart';
import 'package:voyageur/shared_widgets/shimmer/list_shimmer.dart';

class HotelsListScreen extends ConsumerWidget {
  const HotelsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hotelsAsync = ref.watch(hotelsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('R\u00e9sultats h\u00f4tels'),
      ),
      body: hotelsAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: ListShimmer(itemCount: 5),
        ),
        error: (e, _) => AppErrorWidget(
          message: 'Erreur lors du chargement des h\u00f4tels',
          onRetry: () => ref.invalidate(hotelsProvider),
        ),
        data: (hotels) {
          if (hotels.isEmpty) {
            return const EmptyStateWidget(
              message: 'Aucun h\u00f4tel trouv\u00e9',
              icon: Icons.hotel,
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: hotels.length,
            itemBuilder: (context, index) {
              return HotelCard(
                hotel: hotels[index],
                onTap: () => context.go(AppRoutes.hotelDetailPath(hotels[index].id)),
              );
            },
          );
        },
      ),
    );
  }
}
