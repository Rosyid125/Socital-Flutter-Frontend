// lib/routesprotection/AuthMiddleware.dart
import 'package:get/get.dart';
import 'package:socital/routesprotection/ProtectedRoute.dart';

class AuthMiddleware extends GetMiddleware {
  final AuthService _authService = AuthService();

  @override
  Future<GetNavConfig?> redirectDelegate(GetNavConfig route) async {
    bool isAuthenticated = await _authService.isAuthenticated();
    if (isAuthenticated) {
      return super.redirectDelegate(
          route); // User is authenticated, proceed to the intended route
    } else {
      return GetNavConfig.fromRoute(
          '/login'); // User is not authenticated, redirect to login screen
    }
  }
}
