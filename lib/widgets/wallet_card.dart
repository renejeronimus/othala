import 'dart:io';

import 'package:flutter/material.dart';
import 'package:othala/screens/wallet_screen.dart';

import '../models/wallet.dart';
import '../themes/theme_data.dart';
import 'flat_button.dart';

class WalletCard extends StatefulWidget {
  final Wallet wallet;

  const WalletCard(this.wallet, {Key? key}) : super(key: key);

  @override
  State<WalletCard> createState() => _WalletCardState();
}

class _WalletCardState extends State<WalletCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlackColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) =>
                          WalletScreen(widget.wallet),
                    ),
                  );
                },
                child: Hero(
                  tag: 'imageHero',
                  child: Image.file(
                    File(widget.wallet.imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                    child: GestureDetector(
                        onTap: () {
                          print(widget.wallet.address);
                        },
                        child: const CustomFlatButton(textLabel: 'Send'))),
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    print(widget.wallet.address);
                  },
                  child: const CustomFlatButton(
                    textLabel: 'Receive',
                    buttonColor: kDarkBackgroundColor,
                    fontColor: kWhiteColor,
                  ),
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
