import 'package:hive/hive.dart';

import '../db/account.dart';

class BSStorage {
  static getAccount({String? key}) {
    Box accountBox = Hive.box<DBAccount>('account');
    final acc = accountBox.get(0);
    return acc != null
        ? key != null
            ? acc[key]
            : acc
        : null;
  }

  static setAccount(DBAccount account) {
    Box accountBox = Hive.box<DBAccount>('account');
    accountBox.put(0, account);
  }

  static syncAccount(bool initSetting) async {
    // await BSRequest.get('account/info', (result) async {
    //   List<String> wallets = [];
    //   result['address'].forEach((wallet) {
    //     wallets.add(wallet.toString());
    //   });

    //   OGStorage.setAccount(DBAccount(
    //     result['accountUid'],
    //     result['name'] ?? '',
    //     result['email'] ?? '',
    //     result['photo'] ?? '',
    //     result['social'],
    //   ));
    // });
  }
}
