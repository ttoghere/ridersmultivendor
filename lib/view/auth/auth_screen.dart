import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ridersmultivendor/view/auth/widgets/login.dart';
import 'package:ridersmultivendor/view/auth/widgets/sign_up.dart';
import '../shared/app_gradient.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text("SellersApp"),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: appGradient(),
            ),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
                text: "Login",
              ),
              Tab(
                icon: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                text: "SignUp",
              ),
            ],
            indicatorColor: Colors.orange,
            indicatorWeight: 6,
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: appGradient(),
          ),
          child: const TabBarView(children: [
            Login(),
            SignUp(),
          ]),
        ),
      ),
    );
  }
}
