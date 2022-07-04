import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:othala/models/transaction.dart';
import 'package:othala/screens/wallet_settings_screen.dart';
import 'package:othala/widgets/list_divider.dart';

import '../models/unsplash_image.dart';
import '../models/wallet.dart';
import '../themes/theme_data.dart';
import '../widgets/flat_button.dart';
import '../widgets/list_item_transaction.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen(this.wallet, this.walletIndex, {Key? key})
      : super(key: key);

  final Wallet wallet;
  final int walletIndex;

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  /// Stores the current page index for the api requests.
  int page = 0, totalPages = -1;

  /// Stores the currently loaded loaded images.
  List<UnsplashImage> images = [];

  /// States whether there is currently a task running loading images.
  bool loadingImages = false;

  /// Stored the currently searched keyword.
  late String keyword;

  num _balance = 0;
  List<Transaction> _transactions = [];

  @override
  void initState() {
    super.initState();
    if (widget.wallet.balance.isNotEmpty) {
      _balance = widget.wallet.balance.first;
    }
    _transactions = widget.wallet.transactions;
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
              children: <Widget>[
                Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Hero(
                      tag: 'imageHero',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: showImage(),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  WalletSettingsScreen(
                                      widget.wallet, widget.walletIndex),
                            ),
                          );
                        },
                        icon: const Icon(Icons.more_vert),
                      ),
                    ),
                    Positioned(
                      top: 40.0,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            _balance.toString(),
                            style: const TextStyle(
                              color: kWhiteColor,
                              fontSize: 32.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          const Text(
                            'btc',
                            style: TextStyle(
                              color: kWhiteColor,
                              fontSize: 24.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24.0),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (BuildContext context, int index) =>
                        const ListDivider(),
                    itemCount: _transactions.length,
                    itemBuilder: (BuildContext context, int index) {
                      String _formattedDateTime = DateFormat('yyyy-MM-dd kk:mm')
                          .format(_transactions[index].transactionBroadcast);
                      double _amount = 0.0;
                      String _address = '';
                      List _ioAmount = _checkInputOutput(_transactions[index]);
                      _address = _ioAmount.elementAt(0);
                      _amount = _ioAmount.elementAt(1);
                      return ListItemTransaction(
                        _address,
                        subtitle: _formattedDateTime,
                        value: _amount,
                      );
                    },
                  ),
                ),
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
    // return Scaffold(
    //   body: Container(
    //     color: kBlackColor,
    //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
    //     child: SafeArea(
    //       child: ValueListenableBuilder(
    //           valueListenable: Hive.box('walletBox').listenable(),
    //           builder: (context, Box box, widget) {
    //             updateTransactions();
    //             return Stack(
    //               children: [
    //                 CustomScrollView(
    //                   slivers: <Widget>[
    //                     SliverList(
    //                       delegate: SliverChildBuilderDelegate(
    //                         (BuildContext context, int index) {
    //                           print(_transactions[index]);
    //                           // print(_transactions[index].transactionBroadcast);
    //                           // double _amount = _transactions[index].inbound -
    //                           //     _transactions[index].outbound;
    //                           // String _formattedDate = DateFormat('yyyy-MM-dd')
    //                           //     .format(_transactions[index]
    //                           //         .transactionBroadcast);
    //                           // String _formattedTime = DateFormat('kk:mm')
    //                           //     .format(_transactions[index]
    //                           //         .transactionBroadcast);
    //                           double _amount = 2.0;
    //                           String _formattedDate = '2022-10-11';
    //                           String _formattedTime = '11:12';
    //                           // String _priceSnapshot =
    //                           //     _currencyConverter.showCurrency(
    //                           //         _transactions[index].priceSnapshot,
    //                           //         _defaultCurrency);
    //                           return Column(
    //                             children: <Widget>[
    //                               Stack(
    //                                 alignment: AlignmentDirectional.center,
    //                                 children: [
    //                                   Hero(
    //                                     tag: 'imageHero',
    //                                     child: ClipRRect(
    //                                       borderRadius:
    //                                           BorderRadius.circular(16.0),
    //                                       child: showImage(),
    //                                     ),
    //                                   ),
    //                                   Positioned(
    //                                     top: 8,
    //                                     right: 8,
    //                                     child: IconButton(
    //                                       onPressed: () {
    //                                         // Navigator.push(
    //                                         //   context,
    //                                         //   MaterialPageRoute<void>(
    //                                         //     builder:
    //                                         //         (BuildContext context) =>
    //                                         //             WalletSettingsScreen(
    //                                         //                 widget.wallet,
    //                                         //                 widget.walletIndex),
    //                                         //   ),
    //                                         // );
    //                                       },
    //                                       icon: const Icon(Icons.more_vert),
    //                                     ),
    //                                   ),
    //                                   Positioned(
    //                                     top: 40.0,
    //                                     child: Row(
    //                                       mainAxisSize: MainAxisSize.min,
    //                                       crossAxisAlignment:
    //                                           CrossAxisAlignment.baseline,
    //                                       textBaseline: TextBaseline.alphabetic,
    //                                       children: [
    //                                         Text(
    //                                           _balance.toString(),
    //                                           style: const TextStyle(
    //                                             color: kWhiteColor,
    //                                             fontSize: 32.0,
    //                                             fontWeight: FontWeight.w600,
    //                                           ),
    //                                         ),
    //                                         const SizedBox(width: 8.0),
    //                                         const Text(
    //                                           'btc',
    //                                           style: TextStyle(
    //                                             color: kWhiteColor,
    //                                             fontSize: 24.0,
    //                                             fontWeight: FontWeight.w600,
    //                                           ),
    //                                         ),
    //                                       ],
    //                                     ),
    //                                   ),
    //                                 ],
    //                               ),
    //                               GestureDetector(
    //                                 onTap: () {},
    //                                 child: Container(
    //                                   // color: Theme.of(context)
    //                                   //     .scaffoldBackgroundColor,
    //                                   padding: const EdgeInsets.all(8.0),
    //                                   margin: const EdgeInsets.symmetric(
    //                                       vertical: 4.0),
    //                                   child: Row(
    //                                     children: [
    //                                       _amount.isNegative
    //                                           ? const Icon(
    //                                               Icons.file_upload_outlined,
    //                                               size: 24,
    //                                               color: kRedColor,
    //                                             )
    //                                           : const Icon(
    //                                               Icons.file_download_outlined,
    //                                               size: 24,
    //                                               color: kYellowColor,
    //                                             ),
    //                                       SizedBox(width: 16.0),
    //                                       Expanded(
    //                                         child: Column(
    //                                           children: [
    //                                             Row(
    //                                               children: [
    //                                                 Text(
    //                                                   '${_amount.toString()} ' +
    //                                                       'BTC',
    //                                                   style: const TextStyle(
    //                                                     fontSize: 16,
    //                                                     fontWeight:
    //                                                         FontWeight.w600,
    //                                                   ),
    //                                                 ),
    //                                                 const Spacer(),
    //                                                 // Text(
    //                                                 //   _currencyConverter
    //                                                 //       .showCurrency(
    //                                                 //           _amount *
    //                                                 //               _transactions[
    //                                                 //                       index]
    //                                                 //                   .priceSnapshot,
    //                                                 //           _defaultCurrency),
    //                                                 //   style: TextStyle(
    //                                                 //     fontSize: 16,
    //                                                 //     fontWeight:
    //                                                 //         FontWeight.w500,
    //                                                 //   ),
    //                                                 // ),
    //                                               ],
    //                                             ),
    //                                             Row(
    //                                               children: [
    //                                                 Text(
    //                                                   '$_formattedDate  $_formattedTime',
    //                                                   style: const TextStyle(
    //                                                     fontSize: 16,
    //                                                     fontWeight:
    //                                                         FontWeight.w600,
    //                                                     color:
    //                                                         kDarkNeutral7Color,
    //                                                   ),
    //                                                 ),
    //                                                 Spacer(),
    //                                               ],
    //                                             ),
    //                                           ],
    //                                         ),
    //                                       ),
    //                                     ],
    //                                   ),
    //                                 ),
    //                               ),
    //                               const ListDivider(),
    //                             ],
    //                           );
    //                         },
    //                         childCount: _transactions.length,
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //                 Positioned(
    //                   // 2*16 equals top level padding (main).
    //                   width: MediaQuery.of(context).size.width - 32,
    //                   bottom: 36.0,
    //                   child: GestureDetector(
    //                     onTap: () {
    //                       Navigator.pop(context);
    //                     },
    //                     child: const CustomFlatButton(
    //                       textLabel: 'Cancel',
    //                       buttonColor: kDarkBackgroundColor,
    //                       fontColor: kWhiteColor,
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             );
    //           }),
    //     ),
    //   ),
    // );
  }

  List _checkInputOutput(Transaction transaction) {
    double _amount = 0.0;
    String _io = '';
    String _address = widget.wallet.address.first;
    for (Map vin in transaction.from) {
      if (vin.values.first == _address) {
        // Filter out transactions to self
        for (Map vout in transaction.to) {
          if (vout.values.first != _address) {
            _amount = _amount - vout.values.elementAt(1);
            _io = vout.values.elementAt(0);
          }
          break;
        }
        break;
      } else {
        // 100% new deposit to address
        for (Map vout in transaction.to) {
          String _address = widget.wallet.address.first;
          if (vout.values.first == _address) {
            _amount = _amount + vout.values.elementAt(1);
            _io = vout.values.elementAt(0);
          }
        }
        break;
      }
    }
    List _ioAmount = [_io, _amount];
    return _ioAmount;
  }

  showImage() {
    if (FileSystemEntity.typeSync(widget.wallet.imagePath) ==
        FileSystemEntityType.notFound) {
      return Image.asset(
        'assets/images/andreas-gucklhorn-mawU2PoJWfU-unsplash.jpeg',
        fit: BoxFit.cover,
        color: Colors.white.withOpacity(0.8),
        colorBlendMode: BlendMode.modulate,
        height: 160,
        width: MediaQuery.of(context).size.width,
      );
    } else {
      return Image.file(
        File(widget.wallet.imagePath),
        fit: BoxFit.cover,
        color: Colors.white.withOpacity(0.8),
        colorBlendMode: BlendMode.modulate,
        height: 160,
        width: MediaQuery.of(context).size.width,
      );
    }
  }
}
