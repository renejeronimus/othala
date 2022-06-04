import 'package:bip39/bip39.dart' as bip39;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../themes/theme_data.dart';
import '../widgets/flat_rounded_button.dart';

class WalletImportScreen extends StatefulWidget {
  const WalletImportScreen({Key? key}) : super(key: key);

  @override
  _WalletImportScreenState createState() => _WalletImportScreenState();
}

class _WalletImportScreenState extends State<WalletImportScreen> {
  bool _validated = false;
  String _mnemonic = '';

  final _storage = const FlutterSecureStorage();
  final _myTextController = TextEditingController();

  _encryptToKeyStore() async {
    const String key = 'Mnemonic phrase';
    final String value = _mnemonic;

    await _storage.write(
      key: key,
      value: value,
    );
    Navigator.pushReplacementNamed(context, '/home_screen');
  }

  void _getClipboard() async {
    ClipboardData? data = await Clipboard.getData('text/plain');
    _mnemonic = data!.text!;
    _myTextController.text = _mnemonic;
  }

  void _validateMnemonic() {
    if (_myTextController.text.isNotEmpty) {
      _mnemonic = _myTextController.text;
      if (bip39.validateMnemonic(_mnemonic) == true) {
        setState(() {
          _validated = true;
        });
      }
      if (bip39.validateMnemonic(_mnemonic) == false) {
        setState(() {
          _validated = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Start listening to changes.
    _myTextController.addListener(_validateMnemonic);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _myTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restore'),
        backgroundColor: kBlackColor,
        bottomOpacity: 0.0,
        elevation: 0.0,
        leading: IconButton(
            icon: const Icon(CupertinoIcons.chevron_back),
            onPressed: () => Navigator.pop(context)),
      ),
      body: Container(
        color: kBlackColor,
        child: SafeArea(
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Column(
              children: <Widget>[
                const Text(
                  'Enter your 12-word recovery phrase to import your wallets.',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
                        controller: _myTextController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                            hintText: '12 words separated by a single space.'),
                      ),
                      const SizedBox(height: 8.0),
                      GestureDetector(
                        onTap: () {
                          _getClipboard();
                        },
                        child: const Text(
                          'Paste from clipboard',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: kWhiteColor,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                const SizedBox(height: 16.0),
                GestureDetector(
                  onTap: () => _validated == true ? _encryptToKeyStore() : null,
                  child: _validated == true
                      ? const FlatRoundedButton(
                          buttonColor: kWhiteColor,
                          textLabel: 'import',
                        )
                      : const FlatRoundedButton(
                          buttonColor: kWhiteColor,
                          textLabel: 'import',
                          enabled: false,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
