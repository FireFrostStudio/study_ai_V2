import 'package:flutter/material.dart';
import 'package:studyai_flutter_v2/data/conversation_data.dart';
import 'package:studyai_flutter_v2/questionHistoryPage.dart';
import 'package:studyai_flutter_v2/question_history_elements/question_history_builder.dart';

class QuestionHistoryHomePage extends StatelessWidget {
  const QuestionHistoryHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 30),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              "Question History",
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
            ),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => QuestionHistoryPage(
                            )),
                  );
                },
                child: Text(
                  "See All",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ))
          ]),
          QuestionHistoryHomeView()
        ],
      ),
    );
  }
}
