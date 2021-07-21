import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';

import '../common/assets.dart';
import '../common/hive_boxes.dart';
import '../common/styles.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'tutorial_screen.dart';

class SplashScreen extends StatefulWidget {
  static const route = '/';
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _destination = '';

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(_resolveDestination);
  }

  Future<void> _resolveDestination() async {
    debugPrint('Firebase init complete');

    // Allows the splash screen to remain for a bit longer
    await Future.delayed(const Duration(seconds: 2));

    final isFirstLaunch = Hive.box(ConfigBox.key)
        .get(ConfigBox.isFirstLaunch, defaultValue: true) as bool;

    if (isFirstLaunch) {
      _destination = TutorialScreen.route;
    } else if (FirebaseAuth.instance.currentUser != null) {
      _destination = HomeScreen.route;
      _updateCachedData();
    } else {
      _destination = LoginScreen.route;
    }

    Navigator.of(context).pushReplacementNamed(_destination);
  }

  Future<void> _updateCachedData() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((value) {
      final configBox = Hive.box(ConfigBox.key);
      configBox.put(
        ConfigBox.bloodType,
        value.data()['bloodType'] as String,
      );
      configBox.put(
        ConfigBox.isAdmin,
        value.data()['isAdmin'] as bool ?? false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(IconAssets.logo),
              const SizedBox(height: 28),
              Flexible(
                child: Text(
                  'Blood Donation',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline4.copyWith(
                        fontFamily: Fonts.logo,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
