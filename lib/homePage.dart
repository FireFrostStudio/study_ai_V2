import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:studyai_flutter_v2/conversationPage.dart';
import 'package:studyai_flutter_v2/data/conversation_data.dart';
import 'package:studyai_flutter_v2/getPremiumPage.dart';
import 'package:studyai_flutter_v2/questionHistoryPage.dart';
import 'package:studyai_flutter_v2/question_history_elements/question_history_builder.dart';
import 'package:studyai_flutter_v2/resusable_components/bottom_send_chat.dart';
import 'package:studyai_flutter_v2/home_page_elements/middle_home_elements.dart';
import 'package:studyai_flutter_v2/home_page_elements/question_history_homePage.dart';
import 'package:studyai_flutter_v2/home_page_elements/top_home_elements.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        drawer: HomePageDrawer(),
        body: Stack(
          children: [
            const SafeArea(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    TopHomePage(),
                    MiddleHomePage(),
                    QuestionHistoryHomePage(),
                    SizedBox(
                      height: 150,
                    )
                  ],
                ),
              ),
            ),
            BottomSendChat(
              isFromHomePage: true,
              preEnteredMessage: "",
              autoSendMessage: true,
            )
          ],
        ));
  }
}

class HomePageDrawer extends StatelessWidget {
  const HomePageDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<Data>(
        builder: (context, value, child) => Drawer(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: ListView(
                  children: [
                    const Text(
                      "Study AI",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (value.isPremium == false) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GetPremiumPage()),
                          );
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(10)),
                        height: 125,
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      value.isPremium == false
                                          ? "Upgrade To Premium"
                                          : "Premium Activated",
                                      style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                      textAlign: TextAlign.start,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      value.isPremium == false
                                          ? "Get premium and enjoy exclusive features!"
                                          : "Enjoy pro features like sending picutres, longer responses and no ads!",
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.arrow_right,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Divider(
                        thickness: 1,
                      ),
                    ),
                    ListTile(
                      onTap: () async {
                        try {
                          CustomerInfo customerInfo =
                              await Purchases.restorePurchases();
                          // ... check restored purchaserInfo to see if entitlement is now active
                          Data().initalizeSubStatus();
                        } on PlatformException catch (e) {
                          // Error restoring purchases
                        }
                      },
                      leading: const Icon(Icons.monetization_on),
                      title: const Text("Restore Purchase"),
                    ),
                    Divider(),
                    ListTile(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ConversationPage(
                                    autoSendMessage: false,
                                    currentConversation:
                                        Conversation(messages: []),
                                    questionInput: "",
                                  )), (Route<dynamic> route) => false
                        );
                      },
                      leading: const Icon(Icons.chat),
                      title: const Text("Start A Conversation"),
                    ),
                  ],
                ),
              ),
            ));
  }
}
