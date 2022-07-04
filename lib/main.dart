import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:othala/screens/import_address_screen.dart';
import 'package:othala/screens/import_phrase_screen.dart';
import 'package:othala/screens/wallet_creation_screen.dart';
import 'package:othala/screens/wallet_import_screen.dart';

import '../screens/home_screen.dart';
import '../screens/loading_screen.dart';
import 'models/transaction.dart';
import 'models/wallet.dart';

Future<void> main() async {
  Hive.registerAdapter(WalletAdapter());
  Hive.registerAdapter(TransactionAdapter());
  await Hive.initFlutter();
  await Hive.openBox('walletBox');
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Othala',
      theme: ThemeData(
        brightness: Brightness.light,
        textTheme: GoogleFonts.rajdhaniTextTheme(
          Theme.of(context).primaryTextTheme,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        textTheme: GoogleFonts.rajdhaniTextTheme(
          Theme.of(context).primaryTextTheme,
        ),
      ),
      /* dark theme settings */
      themeMode: ThemeMode.dark,
      /* ThemeMode.system to follow system theme,
         ThemeMode.light for light theme,
         ThemeMode.dark for dark theme
      */
      debugShowCheckedModeBanner: false,
      initialRoute: '/loading_screen',
      routes: {
        '/home_screen': (context) => const HomeScreen(),
        '/loading_screen': (context) => const LoadingScreen(),
        '/wallet_creation_screen': (context) => const WalletCreationScreen(),
        '/wallet_import_screen': (context) => const WalletImportScreen(),
        '/import_phrase_screen': (context) => const ImportPhraseScreen(),
        '/import_address_screen': (context) => const ImportAddressScreen(),
      },
    );
  }
}
