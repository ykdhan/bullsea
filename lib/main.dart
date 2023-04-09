import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'common/model.dart';
import 'common/notification.dart';
import 'common/theme.dart';
import 'component/layout.dart';
import 'db/account.dart';
import 'firebase_options.dart';
import 'page/Home.dart';
import 'provider/wallet.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Device Orientation
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  // Firebase
  await Firebase.initializeApp(
    name: 'Bullsea',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Hive (DB)
  await Hive.initFlutter();
  Hive.registerAdapter<DBAccount>(DBAccountAdapter());
  await Hive.openBox<DBAccount>('account');

  // Provider
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<WalletProvider>(create: (_) => WalletProvider()),
  ], child: const App()));
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => AppState();
}

class AppState extends State<App> {
  Future<void> checkMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      print(initialMessage);
      // BSRequest.get('oracle/here?location=initialMessage', (result) async {});

      // switch (initialMessage.data['navigation']) {
      //   case 'curation':
      //     if (initialMessage.data['uid'] != null) {
      //       String uid = initialMessage.data['uid'];
      //       OGFunc.openCuration(uid);
      //     }
      //     break;
      //   case 'collection':
      //     if (initialMessage.data['uid'] != null) {
      //       String uid = initialMessage.data['uid'];
      //       OGFunc.openCollection(uid);
      //     }
      //     break;
      //   default:
      //     print('ERROR');
      //     break;
      // }
    }
  }

  @override
  void initState() {
    super.initState();
    checkMessage();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Bullsea',
      theme: ThemeData(
        primaryColor: BSColor.primary,
        scaffoldBackgroundColor: BSColor.gray1,
      ),
      home: Consumer<WalletProvider>(builder: (context, provider1, child) {
        return const TabLayout();
      }),
      initialBinding: BindingsBuilder(() {
        Get.put(NotificationController());
      }),
    );
  }
}

class TabLayout extends StatefulWidget {
  const TabLayout({super.key});

  @override
  State<TabLayout> createState() => TabLayoutState();
}

class TabLayoutState extends State<TabLayout> {
  double iconSize = 24;
  int tabIndex = 0;

  final List _options = [
    const PageHome(),
    Container(),
    Container(),
  ];

  @override
  void initState() {
    super.initState();
  }

  ScrollController sc = ScrollController();

  @override
  Widget build(BuildContext context) {
    // final view = Provider.of<ViewProvider>(context, listen: true);
    return Scaffold(
      appBar: BSAppBar(sizeZero: true, color: Colors.transparent),
      backgroundColor: BSColor.gray0,
      body: Center(child: _options.elementAt(tabIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person_circle_fill,
                  color: tabIndex == 0 ? BSColor.gray10 : BSColor.gray7,
                  size: iconSize),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.bell_fill,
                  color: tabIndex == 1 ? BSColor.gray10 : BSColor.gray7,
                  size: iconSize),
              label: 'Notifications'),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.gear_solid,
                  color: tabIndex == 2 ? BSColor.gray10 : BSColor.gray7,
                  size: iconSize),
              label: 'Settings'),
        ],
        type: BottomNavigationBarType.fixed,
        backgroundColor: BSColor.gray0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: tabIndex,
        onTap: (int index) {
          setState(() {
            tabIndex = index;
          });
        },
      ),
    );
  }
}
