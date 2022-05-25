import 'package:flutter/material.dart';

import '../../controllers/global.dart';
import '../auth/auth_screen.dart';
import '../shared/app_gradient.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: appGradient(),
          ),
        ),
        title: Text(sharedPreferences!.getString("name")!),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () {
            firebaseAuth.signOut().then((value) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const AuthScreen(),
                ),
              );
            });
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.red[900],
          ),
          icon: const Icon(Icons.logout),
          label: const Text("Log Out"),
        ),
      ),
    );
  }
}
