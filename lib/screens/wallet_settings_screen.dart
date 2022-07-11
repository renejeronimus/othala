import 'package:bitcoin_dart/bitcoin_flutter.dart' as bitcoinClient;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:xchain_dart/xchaindart.dart';

import '../models/wallet.dart';
import '../screens/home_screen.dart';
import '../services/secure_storage.dart';
import '../themes/theme_data.dart';
import '../widgets/flat_button.dart';
import '../widgets/list_item.dart';

class WalletSettingsScreen extends StatefulWidget {
  const WalletSettingsScreen(this.wallet, this.walletIndex, {Key? key})
      : super(key: key);

  final Wallet wallet;
  final int walletIndex;

  @override
  _WalletSettingsScreenState createState() => _WalletSettingsScreenState();
}

class _WalletSettingsScreenState extends State<WalletSettingsScreen> {
  final Box _walletBox = Hive.box('walletBox');

  void _showDialog() {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: kDarkNeutral1Color, // your color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SizedBox(
            height: 200,
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: const Center(
                          child: Text(
                            "Delete wallet?",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 22.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(16.0),
                        child: const Center(
                          child: Text(
                            "Warning: Deleting this wallet without a backup, may result in permanent loss of your assets.",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(16),
                              ),
                              color: kYellowColor,
                            ),
                            child: const Center(
                              child: Text(
                                "Delete",
                                style: TextStyle(
                                    color: kDarkBackgroundColor,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          onTap: () => _deleteWallet(),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(16),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                    color: kDarkForegroundColor,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          onTap: () => Navigator.pop(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _deleteWallet() async {
    // Delete wallet from Secure storage.
    StorageService _storageService = StorageService();
    _storageService.deleteSecureData(widget.wallet.key);

    // Delete wallet from Hive box.
    _walletBox.deleteAt(widget.walletIndex);

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => const HomeScreen(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
    setState(() {});
  }

  Future<void> _changeNetwork() async {
    String networkType = widget.wallet.network;
    StorageService _storageService = StorageService();
    String? _seed = await _storageService.readSecureData(widget.wallet.key);
    XChainClient _client = BitcoinClient(_seed!);
    if (networkType == 'bitcoin') {
      widget.wallet.network = 'testnet';
      _client.setNetwork(bitcoinClient.testnet);
    } else {
      widget.wallet.network = 'bitcoin';
      _client.setNetwork(bitcoinClient.bitcoin);
    }
    widget.wallet.address = [_client.getAddress(0)];
    _walletBox.putAt(widget.walletIndex, widget.wallet);

    setState(() {
      _client.purgeClient();
    });
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
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: SvgPicture.asset(
                    'assets/icons/logo.svg',
                    color: kYellowColor,
                    height: 40.0,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _showDialog();
                  },
                  child: ListItem(
                    'Delete wallet',
                    subtitle: 'Warning: may cause loss of funds',
                    subtitleColor: kRedColor,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _changeNetwork();
                  },
                  child: Visibility(
                    visible: widget.wallet.type == 'phrase' ? true : false,
                    child: ListItem(
                      'Toggle nework',
                      subtitle: 'Selected network: ${widget.wallet.network}',
                    ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
