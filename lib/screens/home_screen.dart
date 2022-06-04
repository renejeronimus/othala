import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:othala/widgets/wallet_card_new.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

import '../models/secure_item.dart';
import '../services/secure_storage.dart';
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
    print('initState');
    getWallets();
  }

  final PageController _controller = PageController(initialPage: 0);
  final _currentPageNotifier = ValueNotifier<int>(0);
  final Color _selectedDotColor = kYellowColor;
  final Color _dotColor = kWhiteColor;
  final StorageService _storageService = StorageService();

  final List _pages = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
            Expanded(
              child: _buildPageView(),
            ),
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
        // left: 0.0,
        // right: 0.0,
        // bottom: 24.0,
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
    // Read all values
    List<SecureItem> _allValues = await _storageService.readAllSecureData();
    print(_allValues.length);

    for (SecureItem _secureItem in _allValues) {
      print(_secureItem.key);
      _pages.insert(0, WalletCard(_secureItem));
    }
    _pages.add(const WalletCardNew());

    setState(() {});

    // await _storageService.deleteAllSecureData();
  }
}
