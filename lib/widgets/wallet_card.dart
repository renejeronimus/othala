import 'package:flutter/material.dart';
import 'package:othala/models/secure_item.dart';
import 'package:othala/screens/wallet_screen.dart';

import '../services/secure_storage.dart';
import '../themes/theme_data.dart';
import 'flat_button.dart';

class WalletCard extends StatefulWidget {
  WalletCard(this.secureItem, {Key? key}) : super(key: key);

  final SecureItem secureItem;

  @override
  State<WalletCard> createState() => _WalletCardState();
}

class _WalletCardState extends State<WalletCard> {
  final StorageService _storageService = StorageService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlackColor,
      body: SafeArea(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        WalletScreen(secureItem: widget.secureItem),
                  ),
                );
              },
              child: Hero(
                tag: 'imageHero',
                child: Image.asset(
                  'assets/images/david-marcu-78A265wPiO4-unsplash.jpeg',
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height - 300,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                    child: GestureDetector(
                        onTap: () {
                          print(widget.secureItem.key);
                        },
                        child: const CustomFlatButton(textLabel: 'Send'))),
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    _storageService.deleteSecureData(widget.secureItem);
                    setState(() {
                      print('deleting: ${widget.secureItem.key}');
                    });
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
