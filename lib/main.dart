import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studyai_flutter_v2/homePage.dart';
import 'package:studyai_flutter_v2/themes/theme_provider.dart';
import 'package:studyai_flutter_v2/welcomePage.dart';
import 'package:firebase_core/firebase_core.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ChangeNotifierProvider(create: ((context) => ThemeProvider()
    ), child: MyApp(),)
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
