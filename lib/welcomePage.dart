import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studyai_flutter_v2/themes/theme_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:vibration/vibration.dart';

import 'homePage.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Stack(children: [
          //CHANGE THEME BUTTON TOP ROW
          Column(
            children: [
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text("Study AI",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w900)),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: GestureDetector(
                      onTap: () {
                        Provider.of<ThemeProvider>(context, listen: false)
                            .toggelTheme();
                        Vibration.vibrate();
                      },
                      child: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.circular(10)),
                        child: isDarkMode == true
                            ? Icon(Icons.light_mode)
                            : Icon(Icons.dark_mode),
                      ),
                    ),
                  )
                ],
              ),
              Spacer(),
              Lottie.asset('assets/lottie/StudyAIWelcomePageLottie.json',
                  width: 300, height: 300),
              Spacer(),
              const Padding(
                padding: EdgeInsets.only(bottom: 20, left: 30, right: 30),
                child: Text(
                  "Empowering Your Producitivity with AI.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 20, left: 30, right: 30),
                child: Text(
                  "Using Study AI, you can ask or take a picture of any question you may have. Our customized AI assistant works great at explaining in depth and complex topics.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 15,
                      letterSpacing: 1.2),
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomePage()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Container(
                    width: 325,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(100)),
                    child: const Center(
                        child: Text(
                      "Start A Conversation",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    )),
                  ),
                ),
              )
            ],
          ),
        ]),
      ),
    );
  }
}
