import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:studyai_flutter_v2/conversationPage.dart';
import 'package:studyai_flutter_v2/getPremiumPage.dart';

import '../data/conversation_data.dart';

class MiddleHomePage extends StatelessWidget {
  const MiddleHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //Premium Widget
        Premium_Widget_HomePage(),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: [
              ExamplePrompt_Widget_HomePage(
                iconPath: "assets/icons/pencil_icon.png",
                title: "Writing Articles",
                description: "Explore our world-class generative models",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ConversationPage(
                              autoSendMessage: false,
                              questionInput:
                                  "Write me two sentences on the significance of Shakespeare.",
                              currentConversation: Conversation(messages: []),
                            )),
                  );
                },
              ),
              Spacer(),
              ExamplePrompt_Widget_HomePage(
                iconPath: "assets/icons/math_icon.png",
                title: "Math Help",
                description:
                    "Need answers to complex topics? Study AI can help.",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ConversationPage(
                              autoSendMessage: false,
                              questionInput:
                                  "Explain to me the function of the cell membrane.",
                              currentConversation: Conversation(messages: []),
                            )),
                  );
                },
              )
            ],
          ),
        )
      ],
    );
  }
}

class ExamplePrompt_Widget_HomePage extends StatelessWidget {
  const ExamplePrompt_Widget_HomePage(
      {super.key,
      required this.iconPath,
      required this.title,
      required this.description,
      required this.onTap});

  final String iconPath;
  final String title;
  final String description;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        width: 165,
        height: 225,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(30)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Center(
                      child: ImageIcon(
                    AssetImage(iconPath),
                    size: 25,
                    color: Colors.white,
                  )),
                ),
                Spacer()
              ]),
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 5),
                child: Text(
                  title,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 5),
                child: Text(
                  description,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
                ),
              ),
              const Spacer(),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Spacer(),
                    ImageIcon(
                      AssetImage("assets/icons/right_arrow_icon.png"),
                      size: 25,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Premium_Widget_HomePage extends StatelessWidget {
  const Premium_Widget_HomePage({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        width: double.infinity,
        height: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Theme.of(context).colorScheme.primary,
              Colors.purple.shade200,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Explore Study AI Premium",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    const Text(
                        "Send Pictures, get longer responses, and more!"),
                    const Spacer(),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GetPremiumPage()),
                          );
                        },
                        child: Container(
                          height: 35,
                          width: 125,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                              borderRadius: BorderRadius.circular(15)),
                          child: const Center(
                            child: Text(
                              "Upgrade Now",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ))
                  ],
                ),
              ),
              SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.asset(
                    "assets/icons/bulb-dynamic-color.png",
                    fit: BoxFit.contain,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
