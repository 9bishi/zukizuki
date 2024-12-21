import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  final _authService = AuthService();
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _authService.login(email, password);
      if (response['code'] == 200) {
        _user = User(
          uid: response['data']['uid'] ?? 0,
          name: response['data']['name'] ?? '',
          email: email,
          avatar: response['data']['avatar'] ?? '',
          token: response['data']['token'],
          refreshToken: response['data']['refreshToken'],
        );
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(String email, String password, String code) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _authService.register(email, password, code);
      if (response['code'] == 200) {
        // After registration, perform login
        await login(email, password);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}