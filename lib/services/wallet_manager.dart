import 'package:hive/hive.dart';
import 'package:xchain_dart/xchaindart.dart';

import '../models/wallet.dart';

class WalletManager {
  Future<void> updateBalances() async {
    Box _walletBox = Hive.box('walletBox');
    for (var index = 0; index < _walletBox.length; index++) {
      Wallet _wallet = _walletBox.getAt(index);
      XChainClient _client = BitcoinClient.readonly(_wallet.address[0]);
      List _balances = await _client.getBalance(_client.address, 'BTC.BTC');
      _wallet.balance = [_balances[0]['amount']];
      _walletBox.putAt(index, _wallet);
    }
  }
}