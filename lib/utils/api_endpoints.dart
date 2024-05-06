class ApiEndPoints {
  static final String baseUrl = "http://localhost:8000/api/";
  static _AuthEndPoints authEndpoints = _AuthEndPoints();
  static _PostEndPoints postEndpoints = _PostEndPoints();
}

class _AuthEndPoints {
  final String register = 'register';
  final String login = 'login';
  final String me = 'me';
}

class _PostEndPoints {
  final String posts = 'posts';
}
