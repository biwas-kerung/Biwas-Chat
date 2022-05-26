import 'package:fapp/screens/chat_screen.dart';
import 'package:fapp/screens/login_screen.dart';
import 'package:fapp/screens/registration_screen.dart';
import 'package:fapp/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: ThemeData.dark().copyWith(
      //   textTheme: const TextTheme(
      //     bodyText1: TextStyle(
      //       color: Colors.black54,
      //     ),
      //   ),
      // ),
      home: const WelcomeScreen(),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ChatScreen.id: (context) => ChatScreen(),
        // 'login_screen': (context) => LoginScreen(),
        // 'registration_screen': (context) => RegistrationScreen(),
        // 'chat_screen': (context) => ChatScreen(),
      },
    );
  }
}
