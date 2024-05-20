import 'package:flutter/material.dart';
import 'package:studyai_flutter_v2/data/conversation_data.dart';

class QuestionHistoryExpandedBottom extends StatefulWidget {
  const QuestionHistoryExpandedBottom({super.key});

  @override
  State<QuestionHistoryExpandedBottom> createState() =>
      _QuestionHistoryExpandedBottomState();
}

class _QuestionHistoryExpandedBottomState
    extends State<QuestionHistoryExpandedBottom> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Container(
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
          ),
          child: Center(
              child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: () {
                Data().deleteAllData();
              },
              child: Container(
                width: 300,
                height: 45,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(20)),
                child: const Center(
                  child: Text(
                    "Clear All",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                ),
              ),
            ),
          )),
        )
      ],
    );
  }
}
