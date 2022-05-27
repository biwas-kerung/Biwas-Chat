import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class AuthenticationService {
  static final localAuth = LocalAuthentication();
  // final _storage = const FlutterSecureStorage();
  final StreamController<bool> _isEnabledController =
      StreamController<bool>.broadcast();
  final StreamController<bool> _isNewUserController =
      StreamController<bool>.broadcast();
  // Todo: skipped case
  // final StreamController<bool> _skipped

  StreamController<bool> get isEnabledController => _isEnabledController;
  StreamController<bool> get isNewUserController => _isNewUserController;

  Stream<bool> get isEnabledStream => _isEnabledController.stream;
  Stream<bool> get isNewUserStream => _isNewUserController.stream;
}

final AuthenticationService authService = AuthenticationService();
final localAuth = AuthenticationService.localAuth;
