import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:othala/screens/wallet_creation_screen.dart';

import '../screens/home_screen.dart';
import '../screens/loading_screen.dart';

void main() {
  runApp(const MyApp());
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
      },
    );
  }
}