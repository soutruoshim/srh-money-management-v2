import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'app/app.dart';
import 'translations/codegen_loader.g.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  final ByteData data =
      await PlatformAssetBundle().load('assets/lets-encrypt-r3.pem');
  SecurityContext.defaultContext
      .setTrustedCertificatesBytes(data.buffer.asUint8List());

  tz.initializeTimeZones();
  await EasyLocalization.ensureInitialized();
  await MobileAds.instance.initialize();
  if (Platform.isIOS || Platform.isMacOS) {
    await Firebase.initializeApp();
  } else {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: 'AIzaSyBLso16A4IVMJqo2l2kZBZoVKAAUEUdNUo',
            appId: '1:1064621194422:android:22fed26a22674774967a17',
            messagingSenderId: '',
            authDomain: 'hidden-lowlands-88685.herokuapp.com',
            projectId: 'monsy-fd079'));
  }

  runApp(EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('vi')],
      path:
          'assets/translations', // <-- change the path of the translation files
      fallbackLocale: const Locale('en'),
      saveLocale: false,
      useOnlyLangCode: true,
      assetLoader: const CodegenLoader(),
      child: const MyApp()));
}
