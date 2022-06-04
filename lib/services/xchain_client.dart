// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:xchaindart/xchaindart.dart';
//
// import '../models/secure_item.dart';
//
// class BitcoinNodeClient {
//   late XChainClient client;
//
//   BitcoinNodeClient(phrase, {network = 'mainnet'}) {
//     client = BitcoinClient(phrase, network: 'testnet');
//   }
//
//   getTransactions(address) async {
//     // temporarily only bitcoin client
//     XChainClient xChainClient = BitcoinClient.readonly(address);
//     List transactions = await xChainClient.getTransactions(address);
//     return transactions;
//   }
//
//   Future<void> getAddress() async {
//     const _storage = FlutterSecureStorage();
//     List<SecureItem> _items = [];
//     final all = await _storage.readAll();
//     _items = all.entries
//         .map((entry) => SecureItem(entry.key, entry.value))
//         .toList(growable: false);
//     print('${_items[0].key} = ${_items[0].value}');
//     var phrase = _items[0].value;
//
//     XChainClient client = BitcoinClient(phrase, network: 'testnet');
//
//     String network = client.network;
//     print('network: $network');
//
//     String address = client.address;
//     print('address: $address');
//
//     List balances = await client.getBalance(address, 'BTC.BTC');
//     print('balances: $balances');
//
//     List transactions = await client.getTransactions(address);
//     print('transactions: $transactions');
//   }
// }
