import 'package:bullsea/db/account.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:web3dart/web3dart.dart';

import 'package:bullsea/common/model.dart';

import '../common/storage.dart';
import '../component/form.dart';
import '../main.dart';

class WalletProvider extends ChangeNotifier {
  WalletConnect? _connector;
  bool _connected = false;
  String _address = '';
  String _uri = '';

  bool get connected => _connected;
  String get address => _address;
  String get uri => _uri;

  WalletProvider() {
    init();
  }

  void init() async {
    _connector = WalletConnect(
        bridge: 'https://bridge.walletconnect.org',
        clientMeta: const PeerMeta(
            name: 'Bullsea',
            description: 'Web3 profile',
            url: 'https://bullsea.io',
            icons: [
              'https://files.gitbook.com/v0/b/gitbook-legacy-files/o/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
            ]));
    _connector?.on('connect', (session) => onConnect(session));
    _connector?.on('session_update', (payload) => onSessionUpdate(payload));
    _connector?.on('disconnect', (payload) => onDisconnect(payload));
  }

  Future connect() async {
    if (_connector?.connected == false) {
      try {
        final session =
            await _connector?.createSession(onDisplayUri: (uri) async {
          _uri = uri;
          await launchUrlString(uri, mode: LaunchMode.externalApplication);
        });
        print(session);
        _connected = true;
        _address = session?.accounts[0] ?? '';

        if (_address.isEmpty) {
          showBottomSheet(
              context: navigatorKey.currentState!.context,
              builder: (context) {
                return const BSText(text: 'Please update your Metamask app.');
              });
        }
        print('WALLET CONNECTED: $_address');

        final String signature = await sign('Bullsea: Sign');

        // BSStorage.setAccount(DBAccount(_address, 'ethereum', '', '', ''));
        notifyListeners();

        // await BSRequest.post('sign/salt', {'address': _address},
        //     (result) async {
        //   print('sign/salt');
        //   print(result);
        //   final String signature = await sign(result['plain']);

        //   await BSRequest.post('sign/verify', {
        //     'address': _address,
        //     'signature': signature,
        //   }, (result) async {
        //     print(result);
        //     print('WALLET SIGNED');
        //     // await BSStorage.syncAccount(false);
        //     notifyListeners();
        //   });
        // });
      } catch (exp) {
        showBottomSheet(
            context: navigatorKey.currentState!.context,
            builder: (context) {
              return BSText(text: 'ERROR Metamask: ${exp.toString()}');
            });
      }
    }
  }

  Future sign(String message) async {
    if (_connector?.connected == true) {
      try {
        EthereumWalletConnectProvider provider =
            EthereumWalletConnectProvider(_connector!);
        launchUrlString(_uri, mode: LaunchMode.externalApplication);

        final signature = await provider.personalSign(
            message: message, address: _address, password: "");

        return signature;
      } catch (exp) {
        print("Error while signing transaction");
        print(exp);
      }
    }
  }

  Future disconnect() async {
    _connector?.killSession();
    _connected = false;
    _address = '';
    _uri = '';

    final String address = BSStorage.getAccount().address;

    // await BSRequest.post('account/disconnect', {'address': address},
    //     (result) async {
    //   print('WALLET DISCONNECTED');

    await BSStorage.syncAccount(false);
    notifyListeners();
    // });
  }

  void onConnect(session) {
    _connected = true;
  }

  void onDisconnect(payload) {
    _connected = false;
  }

  void onSessionUpdate(payload) {}
}
