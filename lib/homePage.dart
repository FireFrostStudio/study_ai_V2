import 'package:flutter/material.dart';
import 'package:studyai_flutter_v2/resusable_components/bottom_send_chat.dart';
import 'package:studyai_flutter_v2/home_page_elements/middle_home_elements.dart';
import 'package:studyai_flutter_v2/home_page_elements/question_history.dart';
import 'package:studyai_flutter_v2/home_page_elements/top_home_elements.dart';
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [TopHomePage(), MiddleHomePage(),QuestionHistoryHomePage(), SizedBox(height: 150,)],
                ),
              ),
            ),
            BottomSendChat(isFromHomePage: true, preEnteredMessage: "", autoSendMessage: true,)
          ],
        ));
  }
}
