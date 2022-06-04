import 'package:flutter/material.dart';

import '../models/secure_item.dart';
import '../services/secure_storage.dart';
import '../themes/theme_data.dart';
import '../widgets/list_item.dart';
import 'home_screen.dart';

class WalletSettingsScreen extends StatefulWidget {
  const WalletSettingsScreen({Key? key, required this.secureItem})
      : super(key: key);

  final SecureItem secureItem;

  @override
  _WalletSettingsScreenState createState() => _WalletSettingsScreenState();
}

class _WalletSettingsScreenState extends State<WalletSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: kBlackColor,
      ),
      body: Container(
        color: kBlackColor,
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                final StorageService _storageService = StorageService();
                _storageService.deleteSecureData(widget.secureItem);
                setState(() {
                  print('deleting: ${widget.secureItem.key}');
                });
                // const _storage = FlutterSecureStorage();
                // _storage.delete(key: 'Mnemonic phrase');

                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        const HomeScreen(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
                setState(() {});
              },
              child: ListItem(
                'Delete wallet',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
