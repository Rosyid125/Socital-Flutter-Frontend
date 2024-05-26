class ApiEndPoints {
  static const String baseUrl = "http://localhost:8000/api/";
  static _AuthEndPoints authEndpoints = _AuthEndPoints();
}

class _AuthEndPoints {
  final String register = 'auth/register';
  final String login = 'auth/login';
  final String me = 'auth/me';
}
