import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../themes/theme_data.dart';
import '../widgets/flat_button.dart';
import '../widgets/list_divider.dart';
import '../widgets/list_item.dart';

class WalletImportScreen extends StatefulWidget {
  const WalletImportScreen({Key? key}) : super(key: key);

  @override
  _WalletImportScreenState createState() => _WalletImportScreenState();
}

class _WalletImportScreenState extends State<WalletImportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: kBlackColor,
        child: SafeArea(
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: SvgPicture.asset(
                    'assets/icons/logo.svg',
                    color: kYellowColor,
                    height: 40.0,
                  ),
                ),
                const Text(
                  'How do you want to import your wallet?',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 24.0),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/camera_screen');
                  },
                  child: ListItem(
                    'Scan QR code',
                    subtitle: 'Use the camera to scan a QR code.',
                    chevron: true,
                  ),
                ),
                const ListDivider(),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/import_phrase_screen');
                  },
                  child: ListItem(
                    'Enter recovery phrase',
                    subtitle: 'A combination of 12 to 24 words.',
                    chevron: true,
                  ),
                ),
                const ListDivider(),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/import_address_screen');
                  },
                  child: ListItem(
                    'Enter wallet address',
                    subtitle: 'For importing a watch-only wallet',
                    chevron: true,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const CustomFlatButton(
                          textLabel: 'Cancel',
                          buttonColor: kDarkBackgroundColor,
                          fontColor: kWhiteColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
