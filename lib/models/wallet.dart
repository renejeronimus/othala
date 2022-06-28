import 'package:hive/hive.dart';

part 'wallet.g.dart';

@HiveType(typeId: 0)
class Wallet {
  @HiveField(0)
  String key;
  @HiveField(1)
  String name;
  @HiveField(2)
  String type;
  @HiveField(3)
  String network;
  @HiveField(4)
  List<String> address;
  @HiveField(5)
  List<num> balance;
  @HiveField(6)
  String imagePath;

  Wallet(
    this.key,
    this.name,
    this.type,
    this.network,
    this.address,
    this.balance,
    this.imagePath,
  );
}
