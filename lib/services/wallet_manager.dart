import 'dart:io';

import 'package:bitcoin_dart/bitcoin_flutter.dart' as bitcoinClient;
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:xchain_dart/xchaindart.dart';

import '../models/secure_item.dart';
import '../models/transaction.dart';
import '../models/unsplash_image.dart';
import '../models/wallet.dart';
import '../services/secure_storage.dart';
import '../services/unsplash_image_provider.dart';

class WalletManager extends ChangeNotifier {
  final Box _walletBox = Hive.box('walletBox');
  final StorageService _storageService = StorageService();

  // Wallet client can be either read-only or full.
  late XChainClient _client;

  Future<void> deleteWallet(int walletIndex) async {
    Wallet _wallet = _walletBox.getAt(walletIndex);

    // Delete wallet from Secure storage.
    StorageService _storageService = StorageService();
    _storageService.deleteSecureData(_wallet.key);

    // Delete wallet from Hive box.
    _walletBox.deleteAt(walletIndex);
  }

  /// Secure store wallet
  void encryptToKeyStore({String? mnemonic, String? address}) async {
    String _key = UniqueKey().toString();
    String _secureData;

    String _type;
    if (mnemonic != null && mnemonic.isNotEmpty) {
      _secureData = mnemonic;
      _type = 'mnemonic';
      _client = BitcoinClient(mnemonic);
      address = _client.address;
    } else if (address != null && address.isNotEmpty) {
      _secureData = address;
      _type = 'address';
      _client = BitcoinClient.readonly(address);
    } else {
      throw ArgumentError('Missing input');
    }

    // Discover if address is testnet.
    String _network = getNetworkType(address);

    // Secure storage
    _storageService.writeSecureData(SecureItem(_key, _secureData));

    num _balance = await getBalance(_client.address, _network);
    List<Transaction> _transactions =
        await getTransactions(_client.address, _network);

    var _walletBox = Hive.box('walletBox');

    String _localPath = await _loadRandomImage(keyword: 'nature');

    _walletBox.add(Wallet(_key, '', _type, _network, [address], [_balance],
        _localPath, _transactions));
  }

  /// Retrieve wallet balance.
  Future<double> getBalance(address, network) async {
    _client = BitcoinClient.readonly(address);
    String _asset = 'BTC';
    if (network == 'testnet') {
      _client.setNetwork(bitcoinClient.testnet);
      _asset = 'tBTC';
    }
    List _balances = await _client.getBalance(_client.address, 'BTC.$_asset');
    double _balance = _balances[0]['amount'];
    return _balance;
  }

  Future<List<Transaction>> getTransactions(address, network) async {
    XChainClient _client = BitcoinClient.readonly(address[0]);
    if (network == 'testnet') {
      _client.setNetwork(bitcoinClient.testnet);
    }
    List<Transaction> _transactions = [];
    List _rawTxs = await _client.getTransactions(address[0]);
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

    return _transactions;
  }

  String? getInputType(String input) {
    // check if input is an address format.
    List<AssetAddress> _addresses = substractAddress(input);
    if (_addresses.isNotEmpty) {
      String _address = _addresses.first.address;
      bool _isValid = validateAddress(_address);
      if (_isValid == true) {
        return 'address';
      }
    }
    return null;
  }

  String getNetworkType(String address) {
    XChainClient _client = BitcoinClient.readonly(address);
    _client.setNetwork(bitcoinClient.testnet);
    if (_client.validateAddress(address) == true) {
      return 'testnet';
    } else {
      return 'bitcoin';
    }
  }

  Future<void> setNetwork(int walletIndex, String network) async {
    Wallet _wallet = _walletBox.getAt(walletIndex);

    // Get the seed to update the address on the new network
    String? _seed = await _storageService.readSecureData(_wallet.key);
    XChainClient _client = BitcoinClient(_seed!);

    if (network == 'bitcoin') {
      _wallet.network = 'bitcoin';
      _client.setNetwork(bitcoinClient.bitcoin);
    } else if (network == 'testnet') {
      _wallet.network = 'testnet';
      _client.setNetwork(bitcoinClient.testnet);
    }
    _wallet.address = [_client.getAddress(0)];

    // update box entry with new network & address.
    _walletBox.putAt(walletIndex, _wallet);
  }

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

  bool validateInput({required String input, String? inputType}) {
    bool _valid = false;

    if (inputType == 'address') {
      _valid = validateAddress(input);
    } else if (inputType == 'mnemonic') {
      _valid = validatePhrase(input);
    } else if (input.isNotEmpty) {
      inputType = getInputType(input);
      if (inputType == 'address') {
        _valid = true;
      }
    }
    return _valid;
  }

  bool validateAddress(String address) {
    XChainClient _client = BitcoinClient.readonly(address);
    if (_client.validateAddress(address) == true) {
      return true;
    } else {
      // try validating on testnet.
      _client.setNetwork(bitcoinClient.testnet);
      if (_client.validateAddress(address) == true) {
        return true;
      } else {
        return false;
      }
    }
  }

  bool validatePhrase(String input) {
    return validateMnemonic(input);
  }

  /// Requests a [UnsplashImage] for a given [keyword] query.
  /// If the given [keyword] is null, any random image is loaded.
  Future<String> _loadRandomImage({String? keyword}) async {
    UnsplashImage res =
        await UnsplashImageProvider.loadRandomImage(keyword: keyword);
    Future<String> _localPath = _download(res.getRegularUrl());
    return _localPath;
  }

  Future<String> _download(String url) async {
    // Default background image
    String _localPath =
        'assets/images/andreas-gucklhorn-mawU2PoJWfU-unsplash.jpeg';

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
    return _localPath;
  }
}
