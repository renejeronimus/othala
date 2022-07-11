import 'package:flutter/material.dart';

import '../themes/theme_data.dart';

class ReceiveScreen extends StatefulWidget {
  const ReceiveScreen({Key? key}) : super(key: key);

  @override
  State<ReceiveScreen> createState() => _ReceiveScreenState();
}

class _ReceiveScreenState extends State<ReceiveScreen> {
  String _address = 'bc1qa2vzx9vz7argn5z3264l6s0xj7w7xytglergvf';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlackColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 48.0),
              const Text(
                'Receive',
                style: TextStyle(fontSize: 24.0),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 36.0),
              GestureDetector(
                onTap: () {},
                child: Text(
                  _address,
                  style: const TextStyle(fontSize: 24.0),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 36.0),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(fontSize: 16.0),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
