import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wagon_client/consts.dart';
import 'package:wagon_client/main_window.dart';
import 'package:wagon_client/screens/login/screen.dart';
import 'package:wagon_client/web/web_yandexkey.dart';

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   await Firebase.initializeApp();
//     if (message.data['title'] == 'You have new message(s)' ||
//         message.data['title'] == 'New message in Group') {
//       //-- need not to do anythig for these message type as it will be automatically popped up.
//
//     } else if (message.data['title'] == 'Incoming Audio Call...' ||
//         message.data['title'] == 'Incoming Video Call...') {
//       final data = message.data;
//       final title = data['title'];
//       final body = data['body'];
//       final titleMultilang = data['titleMultilang'];
//       final bodyMultilang = data['bodyMultilang'];
//     }
//
// }

Future<void> main() async {
  Intl.defaultLocale = "ru_RU";
  WidgetsFlutterBinding.ensureInitialized();

  await Consts.init();

  Consts.yandexGeocodeKey = Consts.getString("yandexkey");
  await WebYandexKey().request(() {}, null);
  // Firebase.initializeApp().then((value) {
  //   if (Consts.getString("firebase_token").isEmpty) {
  //     FirebaseMessaging.instance.getToken().then((value) {
  //       String token = value!;
  //       print("FIREBASE TOKEN");
  //       print(token);
  //       Consts.setString("firebase_token", token);
  //     });
  //   }
  //});

  runApp(TaxoApp());
}

class TaxoApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    Widget home;
    if (Consts.getString("bearer").isEmpty) {
      home = LoginScreen();
    } else {
      home = WMainWindow();
    }
    return GetMaterialApp(
      home: home,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const <Locale>[
        // put all locales you want to support here
        const Locale('en', 'US'),
        const Locale('ru', 'RU'),
      ],
    );
  }
}
