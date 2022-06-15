import 'package:hive/hive.dart';

part 'wallet.g.dart';

@HiveType(typeId: 0)
class Wallet {
  @HiveField(0)
  String key;
  @HiveField(1)
  String name;
  @HiveField(2)
  List<String> address;
  @HiveField(3)
  List<num> balance;
  @HiveField(4)
  String imagePath;
  // @HiveField(3)
  // List<Address> address;
  // @HiveField(4)
  // List<Image> image;

  Wallet(
    this.key,
    this.name,
    this.address,
    this.balance,
    this.imagePath,
  );
}
