import 'dart:io';

import 'package:flutter/material.dart';

import '../models/wallet.dart';
import '../screens/receive_payment_screen.dart';
import '../screens/wallet_screen.dart';
import '../services/wallet_manager.dart';
import '../themes/theme_data.dart';
import '../widgets/flat_button.dart';

class WalletCard extends StatefulWidget {
  const WalletCard(this.wallet, this.walletIndex, {Key? key}) : super(key: key);

  final Wallet wallet;
  final int walletIndex;

  @override
  State<WalletCard> createState() => _WalletCardState();
}

class _WalletCardState extends State<WalletCard> {
  num _balance = 0.0;

  showImage() {
    if (FileSystemEntity.typeSync(widget.wallet.imagePath) ==
        FileSystemEntityType.notFound) {
      return Image.asset(
        'assets/images/andreas-gucklhorn-mawU2PoJWfU-unsplash.jpeg',
        fit: BoxFit.cover,
      );
    } else {
      return Image.file(
        File(widget.wallet.imagePath),
        fit: BoxFit.cover,
      );
    }
  }

  Future<void> _refresh(int index) async {
    final WalletManager _walletManager = WalletManager();
    await _walletManager.updateTransactions(index);
    await _walletManager.updateBalance(index);
    for (num sats in widget.wallet.balance) {
      _balance = _balance + sats;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _refresh(widget.walletIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlackColor,
      body: SafeArea(
        child: Column(
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
                              WalletScreen(widget.wallet, widget.walletIndex),
                        ),
                      );
                    },
                    child: Hero(
                      tag: 'imageHero',
                      child: showImage(),
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
                            _balance.toString(),
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
                  visible: widget.wallet.type == 'address' ? false : true,
                  child: Expanded(
                      child: GestureDetector(
                          onTap: () {},
                          child: const CustomFlatButton(textLabel: 'Send'))),
                ),
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            ReceivePaymentScreen(widget.wallet),
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
      ),
    );
  }
}
