import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:othala/screens/wallet_settings_screen.dart';

import '../models/unsplash_image.dart';
import '../models/wallet.dart';
import '../themes/theme_data.dart';
import '../widgets/flat_button.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen(this.wallet, this.walletIndex, {Key? key})
      : super(key: key);

  final Wallet wallet;
  final int walletIndex;

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  /// Stores the current page index for the api requests.
  int page = 0, totalPages = -1;

  /// Stores the currently loaded loaded images.
  List<UnsplashImage> images = [];

  /// States whether there is currently a task running loading images.
  bool loadingImages = false;

  /// Stored the currently searched keyword.
  late String keyword;

  num _balance = 0;

  showImage() {
    if (FileSystemEntity.typeSync(widget.wallet.imagePath) ==
        FileSystemEntityType.notFound) {
      return Image.asset(
        'assets/images/andreas-gucklhorn-mawU2PoJWfU-unsplash.jpeg',
        fit: BoxFit.cover,
        color: Colors.white.withOpacity(0.8),
        colorBlendMode: BlendMode.modulate,
        height: 160,
        width: MediaQuery.of(context).size.width,
      );
    } else {
      return Image.file(
        File(widget.wallet.imagePath),
        fit: BoxFit.cover,
        color: Colors.white.withOpacity(0.8),
        colorBlendMode: BlendMode.modulate,
        height: 160,
        width: MediaQuery.of(context).size.width,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.wallet.balance.isNotEmpty) {
      _balance = widget.wallet.balance.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: kBlackColor,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Hero(
                      tag: 'imageHero',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: showImage(),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  WalletSettingsScreen(
                                      widget.wallet, widget.walletIndex),
                            ),
                          );
                        },
                        icon: const Icon(Icons.more_vert),
                      ),
                    ),
                    Positioned(
                      top: 40.0,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            _balance.toString(),
                            style: const TextStyle(
                              color: kWhiteColor,
                              fontSize: 32.0,
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
                  ],
                ),
                const SizedBox(height: 24.0),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
