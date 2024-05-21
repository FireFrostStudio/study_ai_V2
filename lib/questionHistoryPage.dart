import 'package:flutter/material.dart';
import 'package:studyai_flutter_v2/data/conversation_data.dart';
import 'package:studyai_flutter_v2/question_history_elements/question_historyExpanded_bottom.dart';
import 'package:studyai_flutter_v2/question_history_elements/question_history_builder.dart';
import 'package:studyai_flutter_v2/resusable_components/top_elements.dart';

class QuestionHistoryPage extends StatefulWidget {
  const QuestionHistoryPage({super.key});

  @override
  State<QuestionHistoryPage> createState() => _QuestionHistoryPageState();
}

class _QuestionHistoryPageState extends State<QuestionHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                TopElements(),
                  const Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 15),
                    child: Text(
                      "Question History",
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
                    ),
                  ),
                  const QuestionHistoryExpandedView()
                ],
              ),
            ),
          ),
          const QuestionHistoryExpandedBottom()
        ],
      ),
    );
  }
}
