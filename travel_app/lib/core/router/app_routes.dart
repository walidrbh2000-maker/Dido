class AppRoutes {
  const AppRoutes._();

  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String home = '/home';
  static const String vols = '/vols';
  static const String volSearch = '/vols/search';
  static const String volList = '/vols/list';
  static const String volDetail = '/vols/:id';
  static const String hotels = '/hotels';
  static const String hotelSearch = '/hotels/search';
  static const String hotelList = '/hotels/list';
  static const String hotelDetail = '/hotels/:id';
  static const String reservations = '/reservations';
  static const String createReservation = '/reservations/create';
  static const String reservationDetail = '/reservations/:id';
  static const String payment = '/payment';
  static const String paymentSuccess = '/payment/success';
  static const String destinations = '/destinations';
  static const String destinationDetail = '/destinations/:id';
  static const String guides = '/guides';
  static const String guideDetail = '/guides/:id';
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';

  static String volDetailPath(int id) => '/vols/$id';
  static String hotelDetailPath(int id) => '/hotels/$id';
  static String reservationDetailPath(int id) => '/reservations/$id';
  static String destinationDetailPath(int id) => '/destinations/$id';
  static String guideDetailPath(int id) => '/guides/$id';
}
