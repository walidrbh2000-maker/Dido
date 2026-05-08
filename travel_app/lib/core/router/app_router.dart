import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voyageur/core/router/app_routes.dart';
import 'package:voyageur/core/router/route_guards.dart';
import 'package:voyageur/screens/splash/splash_screen.dart';
import 'package:voyageur/screens/onboarding/onboarding_screen.dart';
import 'package:voyageur/screens/auth/login_screen.dart';
import 'package:voyageur/screens/auth/register_screen.dart';
import 'package:voyageur/screens/main_navigation/main_navigation_screen.dart';
import 'package:voyageur/screens/home/home_screen.dart';
import 'package:voyageur/screens/vols/vols_search_screen.dart';
import 'package:voyageur/screens/vols/vols_list_screen.dart';
import 'package:voyageur/screens/vols/vol_detail_screen.dart';
import 'package:voyageur/screens/hotels/hotels_search_screen.dart';
import 'package:voyageur/screens/hotels/hotels_list_screen.dart';
import 'package:voyageur/screens/hotels/hotel_detail_screen.dart';
import 'package:voyageur/screens/reservations/reservations_screen.dart';
import 'package:voyageur/screens/reservations/reservation_detail_screen.dart';
import 'package:voyageur/screens/reservations/create_reservation_screen.dart';
import 'package:voyageur/screens/payment/payment_screen.dart';
import 'package:voyageur/screens/payment/payment_success_screen.dart';
import 'package:voyageur/screens/destinations/destinations_screen.dart';
import 'package:voyageur/screens/destinations/destination_detail_screen.dart';
import 'package:voyageur/screens/guides/guides_screen.dart';
import 'package:voyageur/screens/guides/guide_detail_screen.dart';
import 'package:voyageur/screens/profile/profile_screen.dart';
import 'package:voyageur/screens/profile/edit_profile_screen.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorKey = GlobalKey<NavigatorState>();

// NOTE: Signature changed from `GoRouter appRouter(Ref ref)` to
// `GoRouter appRouter(Ref<GoRouter> ref)` — `Ref` alone is not exported
// by Riverpod; the typed form `Ref<T>` (or `ProviderRef<T>`) is correct.
// The function is only called from inside routerProvider so this is fine.
GoRouter _buildRouter(Ref<GoRouter> ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isAuthenticated = ref.read(authGuardProvider);
      final isAuthRoute = state.matchedLocation.startsWith('/auth');
      final isPublicRoute = state.matchedLocation == AppRoutes.splash ||
          state.matchedLocation == AppRoutes.onboarding ||
          isAuthRoute;

      if (!isAuthenticated && !isPublicRoute) {
        return AppRoutes.login;
      }

      if (isAuthenticated && isAuthRoute) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) => MainNavigationScreen(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.vols,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: VolsSearchScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.hotels,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HotelsSearchScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.reservations,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ReservationsScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.profile,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfileScreen(),
            ),
          ),
        ],
      ),
      // FIX: /destinations was missing — caused runtime exception from
      // context.go(AppRoutes.destinations) in featured_destinations.dart
      GoRoute(
        path: AppRoutes.destinations,
        builder: (context, state) => const DestinationsScreen(),
      ),
      GoRoute(
        path: AppRoutes.volList,
        builder: (context, state) => const VolsListScreen(),
      ),
      GoRoute(
        path: AppRoutes.volDetail,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return VolDetailScreen(volId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.hotelList,
        builder: (context, state) => const HotelsListScreen(),
      ),
      GoRoute(
        path: AppRoutes.hotelDetail,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return HotelDetailScreen(hotelId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.createReservation,
        builder: (context, state) => const CreateReservationScreen(),
      ),
      GoRoute(
        path: AppRoutes.reservationDetail,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return ReservationDetailScreen(reservationId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.payment,
        builder: (context, state) => const PaymentScreen(),
      ),
      GoRoute(
        path: AppRoutes.paymentSuccess,
        builder: (context, state) => const PaymentSuccessScreen(),
      ),
      GoRoute(
        path: AppRoutes.destinationDetail,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return DestinationDetailScreen(destinationId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.guides,
        builder: (context, state) => const GuidesScreen(),
      ),
      GoRoute(
        path: AppRoutes.guideDetail,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return GuideDetailScreen(guideId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        builder: (context, state) => const EditProfileScreen(),
      ),
    ],
  );
}

final routerProvider = Provider<GoRouter>(_buildRouter);
