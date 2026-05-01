class ApiEndpoints {
  const ApiEndpoints._();

  static const String baseUrl = 'http://localhost/api/v1';

  static const String register = '/register';
  static const String login = '/login';
  static const String logout = '/logout';
  static const String me = '/me';

  static const String destinations = '/destinations';
  static String destinationDetail(int id) => '/destinations/$id';

  static const String vols = '/vols';
  static String volDetail(int id) => '/vols/$id';

  static const String hotels = '/hotels';
  static String hotelDetail(int id) => '/hotels/$id';

  static const String reservations = '/reservations';
  static String reservationDetail(int id) => '/reservations/$id';
  static String reservationTicket(int id) => '/reservations/$id/ticket';

  static const String payments = '/payments/process';
  static String paymentDetail(int id) => '/payments/$id';

  static const String guides = '/guides';
  static String guideDetail(int id) => '/guides/$id';
}
