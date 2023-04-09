import 'package:bullsea/common/class.dart';
import 'package:bullsea/component/form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';

import '../common/model.dart';
import '../common/storage.dart';
import '../common/theme.dart';
import '../provider/wallet.dart';

class PageHome extends StatefulWidget {
  const PageHome({super.key});

  @override
  State<PageHome> createState() => PageHomeState();
}

class PageHomeState extends State<PageHome> {
  bool isTop = true;

  String address = '0x362E637e39F3FD8FCc70314E5aBF2D402a353DEc';
  String esToken = 'T5GHBVU6G5UVJTZCFU2Q54TQPC2HN5684P';
  List<BSTokenBalance> tokens = [];

  @override
  void initState() {
    super.initState();
    List<String> contracts = ['0xc944E90C64B2c07662A292be6244BDf05Cda44a7'];
    contracts.forEach((c) {
      print(c);
      BSRequest.get(
          'https://api.etherscan.io/api?module=account&action=tokenbalance&contractaddress=$c&address=$address&apikey=$esToken',
          (res) {
        if (res.status) {
          final eth = EtherAmount.fromBase10String(EtherUnit.ether, res.result);
          print('ether:${eth}');

          setState(() {
            tokens.add(BSTokenBalance(
                contract: c, name: 'Graph', symbol: 'GRT', amount: res.result));
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // final address = BSStorage.getAccount(key: 'address');
    final address = '0x362E637e39F3FD8FCc70314E5aBF2D402a353DEc';
    final wallet = Provider.of<WalletProvider>(context, listen: true);
    return Stack(children: [
      Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.all(20),
                child: address != null
                    ? Container(child: BSText(text: address))
                    : BSButton(
                        onTap: () async {
                          final connect = await wallet.connect();
                          if (connect) {
                            print('connected');
                          } else {
                            print('not connected');
                          }
                        },
                        text: 'Connect Metamask',
                        textColor: BSColor.gray0,
                        backgroundColor: BSColor.gray10,
                      )),
            Expanded(child: Container()),
          ])
    ]);
  }
}
