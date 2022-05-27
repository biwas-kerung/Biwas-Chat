// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:fapp/constants.dart';
import 'package:fapp/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../components/rounded_button.dart';
import '../services/authentication.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const String id = 'login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  late String email;
  late String password;

  bool isBioExist = false;

  Future<bool> get hasBio async {
    List<BiometricType> availableBiometrics =
        await localAuth.getAvailableBiometrics();
    return availableBiometrics.isNotEmpty;
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    onPressed: (() async {
                      //Write  finger print code here,
                      bool isAuthenticated = await localAuth.authenticate(
                        localizedReason: 'Login',
                        options: const AuthenticationOptions(
                          useErrorDialogs: true,
                          stickyAuth: true,
                        ),
                      );
                      if (isAuthenticated) {
                        Navigator.pushNamed(context, ChatScreen.id);
                      }
                    }),
                    child: const Icon(Icons.fingerprint),
                  ),
                  const SizedBox(
                    height: 20.0,
                    width: 20.0,
                  ),
                  const Text(
                    "Tap to login with fingerprint",
                    style: TextStyle(
                      color: Colors.indigo,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
