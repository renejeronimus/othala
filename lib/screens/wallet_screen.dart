import 'dart:io';

import 'package:flutter/material.dart';
import 'package:othala/screens/wallet_settings_screen.dart';

import '../models/unsplash_image.dart';
import '../models/wallet.dart';
import '../themes/theme_data.dart';
import '../widgets/flat_button.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen(this.wallet, {Key? key}) : super(key: key);

  final Wallet wallet;

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
                        child: Image.file(
                          File(widget.wallet.imagePath),
                          fit: BoxFit.cover,
                          color: Colors.white.withOpacity(0.8),
                          colorBlendMode: BlendMode.modulate,
                          height: 160,
                          width: MediaQuery.of(context).size.width,
                        ),
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
                                  WalletSettingsScreen(widget.wallet),
                            ),
                          );
                        },
                        icon: const Icon(Icons.more_vert),
                      ),
                    ),
                    Positioned(
                      top: 20.0,
                      child: Column(
                        children: const [
                          Text(
                            'Wallet name',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            '1.23456 BTC',
                            style: TextStyle(
                                fontSize: 32.0, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            '€23.032,12',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
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
