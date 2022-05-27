// ignore_for_file: use_build_context_synchronously

import 'dart:ffi';
import 'dart:math';

import 'package:fapp/constants.dart';
import 'package:fapp/screens/chat_screen.dart';
import 'package:fapp/screens/sign_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../components/rounded_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const String id = 'login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;

  final LocalAuthentication auth = LocalAuthentication();
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  late String email;
  late String password;
  bool userHasTouchId = false;
  bool _useTouchId = false;

  @override
  void initState() {
    super.initState();
    getSecureStorage();
  }

  void getSecureStorage() async {
    final isUsingBio = await storage.read(key: 'usingBiometric');
    setState(() {
      userHasTouchId = isUsingBio == 'true';
    });
  }

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
          final userStoredEmail = await storage.read(key: 'email');
          final userStoredPassword = await storage.read(key: 'password');
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
          final userStoredEmail = await storage.read(key: 'email');
          final userStoredPassword = await storage.read(key: 'password');

          _signIn(em: userStoredEmail, pw: userStoredPassword);
        }
      }
    } else {
      print('Cant check');
    }
  }

  void _signIn({String em, String pw}) {
    _auth
        .signInWithEmailAndPassword(email: em, password: pw)
        .then((authResult) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return SignInPage(
          user: authResult._delegate.user == null ? null : User._(authResult._auth, authResult._delegate.user!),
          wantsTouchId: _useTouchId,
          password: password,
        );
      }));
    }).catchError((err) {
      print(err.code);
      if (err.code == 'ERROR_WRONG_PASSWORD') {
        showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text('The password was incorrect, please try again'),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Hero(
                tag: 'logo',
                child: SizedBox(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              const SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  //Do something tothe user Input
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: "Enter Your Email."),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                onChanged: (value) {
                  //Do something with the user input.
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter Your Password.'),
              ),
              const SizedBox(
                height: 24.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    activeColor: Colors.orange,
                    value: _useTouchId,
                    onChanged: (newValue) {
                      setState(() {
                        _useTouchId = newValue!;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Text(
                    "Use Touch Id",
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  //   InkWell(
                  //     onTap: (() {
                  //       // _signIn(em: email, pw: password);

                  //     },
                  //     child: Container(
                  //       width: double.infinity,
                  //       padding: EdgeInsets.symmetric(
                  //         vertical: 16.0,
                  //         horizontal: 34.0,
                  //       ),
                  //     ),
                  //     ),
                  //   )
                ],
              ),
              //FOR Login
              RoundedButton(
                colour: Colors.blueAccent,
                title: 'Login',
                onPressed: () async {
                  //Go to login Screen
                  setState(() {
                    showSpinner = true;
                  });
                  final user = await _auth.signInWithEmailAndPassword(
                      email: email, password: password);
                  // ignore: unnecessary_null_comparison
                  try {
                    // ignore: unnecessary_null_comparison
                    if (user != null) {
                      Navigator.pushNamed(context, ChatScreen.id);
                    }
                    setState(() {
                      showSpinner = false;
                    });
                  } catch (e) {
                    print(e);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
