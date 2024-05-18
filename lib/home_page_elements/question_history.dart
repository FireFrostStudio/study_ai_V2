import 'package:flutter/material.dart';

class QuestionHistoryHomePage extends StatelessWidget {
  const QuestionHistoryHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              "Question History",
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
            ),
            GestureDetector(
              onTap: (){
                
              },
                child: Text(
              "See All",
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ))
          ])
        ],
      ),
    );
  }
}
