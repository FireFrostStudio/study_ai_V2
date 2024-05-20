import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:studyai_flutter_v2/data/conversation_data.dart';
import 'package:studyai_flutter_v2/homePage.dart';
import 'package:studyai_flutter_v2/themes/theme_provider.dart';
import 'package:studyai_flutter_v2/welcomePage.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final data = Data();
  await data.loadPastData();
  final themeProvider = ThemeProvider();

  //REMOVE FOR PRODUCTION
  await Purchases.setLogLevel(LogLevel.debug);
  PurchasesConfiguration configuration;

  if(Platform.isAndroid)
  {
    // android
    configuration = PurchasesConfiguration("goog_ooqcznEJbhaVfQPTMWEiyIzsOJX");
  }
  else
  {
    // ios
    configuration = PurchasesConfiguration("appl_PBJPzwgsByikBKJfTSQbxwocCsx");
  }

  await Purchases.configure(configuration);

  Data().initalizeSubStatus();


  await MobileAds.instance.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<Data>(
          create: (_) => data,
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => themeProvider,
        ),
      ],
      child: MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const WelcomePage(),
      theme: Provider.of<ThemeProvider>(context).themeData
    );
  }
}
