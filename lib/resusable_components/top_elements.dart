import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studyai_flutter_v2/homePage.dart';

import '../themes/theme_provider.dart';

class TopElements extends StatelessWidget {
  TopElements({super.key, this.isConversationPage = false});
  bool isConversationPage;

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: GestureDetector(
              onTap: () {
                if (isConversationPage == false) {
                  Navigator.pop(context);
                } else {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const HomePage()));
                }
              },
              child: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(10)),
                child: Icon(Icons.arrow_back_rounded),
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggelTheme();
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
    );
  }
}
