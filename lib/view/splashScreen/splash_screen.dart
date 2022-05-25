import 'dart:async';
import 'package:flutter/material.dart';
import '../../controllers/global.dart';
import '../auth/auth_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTimer() {
    Timer(const Duration(seconds: 3), () async {
      Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const AuthScreen(),
          ),
        );
      if (firebaseAuth.currentUser != null) {
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => const HomeScreen(),
        //   ),
        // );
      } else {
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => const AuthScreen(),
        //   ),
        // );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("images/logo.png"),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.all(18.0),
                child: Text(
                  "Food Delivery Online",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 40,
                    fontFamily: "Signatra",
                    letterSpacing: 3,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
