import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../themes/theme_data.dart';
import 'home_screen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  initState() {
    super.initState();

    // placeholder for verifying data.
    Timer(const Duration(seconds: 2), () {
      // Navigator.pushReplacementNamed(context, '/home_screen');
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => const HomeScreen(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: kBlackColor,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Center(
                child: SvgPicture.asset(
                  'assets/icons/logo-text.svg',
                  height: 40.0,
                ),
              ),
              const Spacer(),
              const Text(
                'Your wallet, your bitcoins.\n100% open-source & open-design',
                style: TextStyle(
                    color: kDarkNeutral7Color,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}
