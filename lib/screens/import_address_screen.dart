import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xchain_dart/xchaindart.dart';

import '../services/wallet_manager.dart';
import '../themes/theme_data.dart';
import '../widgets/flat_button.dart';

class ImportAddressScreen extends StatefulWidget {
  const ImportAddressScreen({Key? key}) : super(key: key);

  @override
  _ImportAddressScreenState createState() => _ImportAddressScreenState();
}

class _ImportAddressScreenState extends State<ImportAddressScreen> {
  late String _address;
  bool _confirmed = false;
  final _myTextController = TextEditingController();
  final _walletManager = WalletManager();

  @override
  void initState() {
    super.initState();
    _myTextController.addListener(_validateAddress);
  }

  @override
  void dispose() {
    _myTextController.dispose();
    super.dispose();
  }

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
                  'Enter your bitcoin address to import your wallets.',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 24.0),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    color: kBlackColor,
                  ),
                  child: Column(
                    children: [
                      TextField(
                        style: const TextStyle(fontSize: 20),
                        controller: _myTextController,
                        decoration: const InputDecoration(
                          hintText: 'address starting with a 1, 3 or bc1',
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      GestureDetector(
                        onTap: () => _getClipboard(),
                        child: const Text(
                          'Paste from clipboard',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: kYellowColor,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Visibility(
                      visible: _confirmed == true,
                      child: Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              _confirmed == true ? _importWallet() : null,
                          child: const CustomFlatButton(
                            textLabel: 'Import',
                          ),
                        ),
                      ),
                    ),
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

  void _importWallet() {
    _walletManager.encryptToKeyStore(address: _address);
    Navigator.pushReplacementNamed(context, '/home_screen');
  }

  void _getClipboard() async {
    ClipboardData? data = await Clipboard.getData('text/plain');
    _myTextController.text = data!.text!;
  }

  void _validateAddress() {
    _address = _stripMeta(_myTextController.text);
    if (_myTextController.text.isNotEmpty) {
      _confirmed = _walletManager.validateAddress(_address);
      setState(() {});
    }
  }

  String _stripMeta(source) {
    // strip meta-data (e.g. bitcoin:bc1...).
    List<AssetAddress> _addresses = substractAddress(source);
    return _addresses.first.address;
  }
}
