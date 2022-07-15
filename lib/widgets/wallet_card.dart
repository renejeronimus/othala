import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/wallet.dart';
import '../screens/receive_payment_screen.dart';
import '../screens/wallet_screen.dart';
import '../themes/theme_data.dart';
import '../widgets/flat_button.dart';

class WalletCard extends StatefulWidget {
  const WalletCard(this.walletIndex, {Key? key}) : super(key: key);

  final int walletIndex;

  @override
  State<WalletCard> createState() => _WalletCardState();
}

class _WalletCardState extends State<WalletCard> {
  late Wallet _wallet;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ValueListenableBuilder(
          valueListenable: Hive.box('walletBox').listenable(),
          builder: (context, Box box, widget2) {
            if (widget.walletIndex < box.length) {
              _wallet = box.getAt(widget.walletIndex);
            }
            return Scaffold(
              body: Column(
                children: [
                  Expanded(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    WalletScreen(widget.walletIndex),
                              ),
                            );
                          },
                          child: Hero(
                            tag: 'imageHero',
                            child: _showImage(),
                          ),
                        ),
                        Positioned(
                          top: 48,
                          child: Container(
                            decoration: BoxDecoration(
                              color: kBlackColor.withOpacity(0.5),
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(40.0),
                                bottomRight: Radius.circular(40.0),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8.0,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  _wallet.balance.isNotEmpty
                                      ? _wallet.balance.first.toString()
                                      : '',
                                  style: const TextStyle(
                                    color: kWhiteColor,
                                    fontSize: 40.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                const Text(
                                  'btc',
                                  style: TextStyle(
                                    color: kWhiteColor,
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Visibility(
                        visible: _wallet.type == 'address' ? false : true,
                        child: Expanded(
                            child: GestureDetector(
                                onTap: () {},
                                child:
                                    const CustomFlatButton(textLabel: 'Send'))),
                      ),
                      Expanded(
                          child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  ReceivePaymentScreen(_wallet),
                            ),
                          );
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
            );
          }),
    );
  }

  _showImage() {
    if (FileSystemEntity.typeSync(_wallet.imagePath) ==
        FileSystemEntityType.notFound) {
      return Image.asset(
        'assets/images/andreas-gucklhorn-mawU2PoJWfU-unsplash.jpeg',
        fit: BoxFit.cover,
      );
    } else {
      return Image.file(
        File(_wallet.imagePath),
        fit: BoxFit.cover,
      );
    }
  }
}
