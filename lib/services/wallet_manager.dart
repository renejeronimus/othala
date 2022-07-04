import 'package:bitcoin_dart/bitcoin_flutter.dart' as bitcoinClient;
import 'package:hive/hive.dart';
import 'package:othala/models/transaction.dart';
import 'package:xchain_dart/xchaindart.dart';

import '../models/wallet.dart';

class WalletManager {
  final Box _walletBox = Hive.box('walletBox');

  /// Update all wallet balances.
  Future<void> updateAllBalances() async {
    for (var index = 0; index < _walletBox.length; index++) {
      Wallet _wallet = _walletBox.getAt(index);
      XChainClient _client = BitcoinClient.readonly(_wallet.address[0]);
      if (_wallet.network == 'testnet') {
        _client.setNetwork(bitcoinClient.testnet);
      }
      List _balances = await _client.getBalance(_client.address, 'BTC.BTC');
      _wallet.balance = [_balances[0]['amount']];
      _walletBox.putAt(index, _wallet);
    }
  }

  /// Update a single wallet balance.
  Future<void> updateBalance(index) async {
    Wallet _wallet = _walletBox.getAt(index);
    XChainClient _client = BitcoinClient.readonly(_wallet.address[0]);
    if (_wallet.network == 'testnet') {
      _client.setNetwork(bitcoinClient.testnet);
    }
    List _balances = await _client.getBalance(_client.address, 'BTC.BTC');
    _wallet.balance = [_balances[0]['amount']];
    _walletBox.putAt(index, _wallet);
  }

  Future<void> updateTransactions(index) async {
    Wallet _wallet = _walletBox.getAt(index);
    XChainClient _client = BitcoinClient.readonly(_wallet.address[0]);
    if (_wallet.network == 'testnet') {
      _client.setNetwork(bitcoinClient.testnet);
    }
    List<Transaction> _transactions = [];
    List _rawTxs = await _client.getTransactions(_wallet.address[0]);
    for (var _rawTx in _rawTxs) {
      String _transactionId = _rawTx['txid'];
      DateTime _transactionBroadcast = _rawTx['date'];
      var _confirmation = _rawTx['confirmed'];
      List<Map> _from = _rawTx['from'];
      List<Map> _to = _rawTx['to'];
      Transaction _tx = Transaction(
          _transactionId, _transactionBroadcast, _confirmation, _from, _to);
      _transactions.add(_tx);
    }

    _wallet.transactions = _transactions;
    _walletBox.putAt(index, _wallet);
  }
}
