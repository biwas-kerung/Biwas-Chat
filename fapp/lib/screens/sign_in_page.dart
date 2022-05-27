import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class SignInPage extends StatefulWidget {
  // ignore: use_key_in_widget_constructors, prefer_const_constructors_in_immutables
  SignInPage(
      {required this.user, required this.wantsTouchId, required this.password});

  final User user;
  final bool wantsTouchId;
  final String password;

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final LocalAuthentication auth = LocalAuthentication();
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    if (widget.wantsTouchId) {
      authenticate();
    }
  }

  //AUTHENTICATING

  void authenticate() async {
    final canCheck = await auth.canCheckBiometrics;
    if (canCheck) {
      List<BiometricType> availableBiometrics =
          await auth.getAvailableBiometrics();

      if (availableBiometrics.contains(BiometricType.face)) {
        // Face ID.
        final authenticated = await auth.authenticate(
          localizedReason: 'Enable Face ID to sign in more easily',
          options: const AuthenticationOptions(
            useErrorDialogs: true,
            stickyAuth: true,
          ),
        );
        if (authenticated) {
          storage.write(key: 'email', value: widget.user.email);
          storage.write(key: 'password', value: widget.password);
          storage.write(key: 'usingBiometric', value: 'true');
        }
      } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
        // Touch ID.
        final authenticated = await auth.authenticate(
          localizedReason: 'Enable fingerprint to sign in more easily',
          options: const AuthenticationOptions(
            useErrorDialogs: true,
            stickyAuth: true,
          ),
        );
        if (authenticated) {
          storage.write(key: 'email', value: widget.user.email);
          storage.write(key: 'password', value: widget.password);
          storage.write(key: 'usingBiometric', value: 'true');
        }
      }
    } else {
      print('Cant check');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        // ignore: avoid_unnecessary_containers
        child: Container(
          child: Center(
            child: Column(
              children: <Widget>[
                Text(
                  'Welcome ${widget.user.email}',
                  style: const TextStyle(fontSize: 24.0),
                ),
                TextButton(
                  child: const Text('Click to authenticate'),
                  onPressed: () {
                    authenticate();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
