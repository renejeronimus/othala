import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../themes/theme_data.dart';
import '../widgets/list_item.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
                Navigator.pushNamed(context, '/wallet_import_screen');
              },
              child: ListItem(
                'Restore wallet',
              ),
            ),
            GestureDetector(
              onTap: () {
                const _storage = FlutterSecureStorage();
                _storage.delete(key: 'Mnemonic phrase');
                Navigator.pop(context);
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
