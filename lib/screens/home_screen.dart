import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:othala/widgets/wallet_card_new.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

import '../models/wallet.dart';
import '../themes/theme_data.dart';
import '../widgets/wallet_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    getWallets();
  }

  final PageController _controller = PageController(initialPage: 0);
  final _currentPageNotifier = ValueNotifier<int>(0);
  final Color _selectedDotColor = kYellowColor;
  final Color _dotColor = kWhiteColor;

  final List _pages = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SvgPicture.asset(
              'assets/icons/logo.svg',
              color: kYellowColor,
              height: 40.0,
            ),
            Expanded(
              child: _buildPageView(),
            ),
            const SizedBox(height: 16.0),
            _buildCircleIndicator(),
          ],
        ),
      ),
    );
  }

  _buildPageView() {
    return PageView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _pages.length,
        controller: _controller,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: _pages[index],
          );
        },
        onPageChanged: (int index) {
          _currentPageNotifier.value = index;
        });
  }

  _buildCircleIndicator() {
    // Ignore CirclePageIndicator when fewer than 2 screens.
    if (_pages.length > 1) {
      return Center(
        child: CirclePageIndicator(
          size: 8.0,
          selectedSize: 12.0,
          dotColor: _dotColor,
          selectedDotColor: _selectedDotColor,
          itemCount: _pages.length,
          currentPageNotifier: _currentPageNotifier,
        ),
      );
    } else {
      return Container();
    }
  }

  getWallets() async {
    Box _walletBox = Hive.box('walletBox');
    for (var index = 0; index < _walletBox.length; index++) {
      // print('wallet index: $index');
      Wallet _wallet = _walletBox.getAt(index);
      // print('walletKey: ${_wallet.key}');
      // print('walletAddress: ${_wallet.address}');
      _pages.insert(0, WalletCard(_wallet, index));
    }
    _pages.add(const WalletCardNew());
    setState(() {});
  }
}
