import 'package:flutter/material.dart';

import '../themes/theme_data.dart';
import 'flat_button.dart';

class WalletCardNew extends StatefulWidget {
  const WalletCardNew({Key? key}) : super(key: key);

  @override
  State<WalletCardNew> createState() => _WalletCardNewState();
}

class _WalletCardNewState extends State<WalletCardNew> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlackColor,
      body: SafeArea(
        child: Column(
          children: [
            Image.asset(
              'assets/images/andreas-gucklhorn-mawU2PoJWfU-unsplash.jpeg',
              fit: BoxFit.cover,
              height: 600.0,
              width: MediaQuery.of(context).size.width,
            ),
            Row(
              children: [
                Expanded(
                    child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, '/wallet_creation_screen');
                        },
                        child: const CustomFlatButton(textLabel: 'Create'))),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/wallet_creation_screen');
                    },
                    child: const CustomFlatButton(
                      textLabel: 'Import',
                      buttonColor: kDarkBackgroundColor,
                      fontColor: kWhiteColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
