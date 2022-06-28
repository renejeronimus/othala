import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:xchain_dart/xchaindart.dart' as xchain;
import 'package:xchain_dart/xchaindart.dart';

import '../models/secure_item.dart';
import '../models/unsplash_image.dart';
import '../models/wallet.dart';
import '../services/secure_storage.dart';
import '../services/unsplash_image_provider.dart';
import '../themes/theme_data.dart';
import '../widgets/flat_button.dart';

class ImportPhraseScreen extends StatefulWidget {
  const ImportPhraseScreen({Key? key}) : super(key: key);

  @override
  _ImportPhraseScreenState createState() => _ImportPhraseScreenState();
}

class _ImportPhraseScreenState extends State<ImportPhraseScreen> {
  bool _confirmed = false;
  String _mnemonic = '';

  final _myTextController = TextEditingController();

  // Default background image
  String _localPath =
      'assets/images/andreas-gucklhorn-mawU2PoJWfU-unsplash.jpeg';

  _encryptToKeyStore() async {
    String _key = UniqueKey().toString();

    final StorageService _storageService = StorageService();
    _storageService.writeSecureData(SecureItem(_key, _mnemonic));

    XChainClient _client = BitcoinClient(_mnemonic);
    var _walletBox = Hive.box('walletBox');
    _walletBox.add(Wallet(
        _key, '', 'phrase', 'bitcoin', [_client.address], [], _localPath));

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
      if (xchain.validateMnemonic(_mnemonic) == true) {
        setState(() {
          _confirmed = true;
        });
      }
      if (xchain.validateMnemonic(_mnemonic) == false) {
        setState(() {
          _confirmed = false;
        });
      }
    }
  }

  /// Requests a [UnsplashImage] for a given [keyword] query.
  /// If the given [keyword] is null, any random image is loaded.
  _loadRandomImage({String? keyword}) async {
    UnsplashImage res =
        await UnsplashImageProvider.loadRandomImage(keyword: keyword);
    _download(res.getRegularUrl());
  }

  Future<void> _download(String url) async {
    final response = await http.get(Uri.parse(url));

    // Get the image name
    final imageName = path.basename(url);

    // Get the document directory path
    final appDir = await pathProvider.getApplicationDocumentsDirectory();
    // This is the saved image path
    _localPath = path.join(appDir.path, imageName);

    // Downloading
    final imageFile = File(_localPath);
    await imageFile.writeAsBytes(response.bodyBytes);
  }

  @override
  void initState() {
    super.initState();
    // Start listening to changes.
    _myTextController.addListener(_validateMnemonic);
    _loadRandomImage(keyword: 'nature');
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
                  'Enter your 12-word recovery phrase to import your wallets.',
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
                    Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            _confirmed == true ? _encryptToKeyStore() : null,
                        child: _confirmed == true
                            ? const CustomFlatButton(
                                textLabel: 'Import',
                              )
                            : const CustomFlatButton(
                                textLabel: 'Import',
                                enabled: false,
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
                const SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
