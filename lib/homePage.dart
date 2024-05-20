import 'package:flutter/material.dart';
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
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView(
          children: [
            const Text(
              "Study AI",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
            ),
            SizedBox(height: 20,),
            Container(
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, borderRadius: BorderRadius.circular(10)),
              height: 120,
              child: const Padding(
                padding: EdgeInsets.all(15),
                child: Row(
                  children: [
                    Icon(Icons.star, color: Colors.white,),
                    SizedBox(width: 20,),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Upgrade To Premium", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.start,),
                          Text("Get premium and enjoy exclusive features!", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_right, color: Colors.white,),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Divider(thickness: 1,),
            ),
            const ListTile(
              leading: Icon(Icons.book),
              title: Text("Terms Of Service"),
            ),
            const ListTile(
              leading: Icon(Icons.privacy_tip),
              title: Text("Privacy Policy"),
            )
          ],
        ),
      ),
    );
  }
}
