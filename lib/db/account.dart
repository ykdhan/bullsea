import 'package:hive/hive.dart';

part 'account.g.dart';

@HiveType(typeId: 0)
class DBAccount {
  @HiveField(0)
  String address;

  @HiveField(1)
  String network;

  @HiveField(2)
  String email;

  @HiveField(3)
  String photo;

  @HiveField(4)
  String name;

  DBAccount(
    this.address,
    this.network,
    this.email,
    this.photo,
    this.name,
  );
}
