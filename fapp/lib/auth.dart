import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  LocalAuthentication localAuthentication = LocalAuthentication();

  bool canAuth = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            onPressed: () async {
              canAuth = await localAuthentication.canCheckBiometrics;

              print(canAuth.toString());
            },
            child: const Center(child: Text('Check')),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: ElevatedButton(
              onPressed: () async {
                List<BiometricType> list = [];
                try {
                  if (canAuth) {
                    list = await localAuthentication.getAvailableBiometrics();

                    if (list.length > 0) {
                      bool result = await localAuthentication.authenticate(
                          localizedReason:
                              'Please enter your fingerprint to unlock');

                      print('resultis $result');

                      if (list.contains(BiometricType.fingerprint)) {
                        print('fingerprint');
                      }
                    }
                  }
                } catch (e) {
                  print(e);
                }
              },
              child: Center(child: Text('Verify')),
            ),
          ),
        ],
      ),
    );
  }
}
