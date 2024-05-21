import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studyai_flutter_v2/conversationPage.dart';
import 'package:studyai_flutter_v2/data/conversation_data.dart';

class QuestionHistoryExpandedView extends StatelessWidget {
  const QuestionHistoryExpandedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Data>(
      builder: (context, data, child) {
        if (data.pastConversations == null) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: Text("Error Loading History")),
          );
        }
        return Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
          child: Column(
            children: data.pastConversations!.pastConversations.reversed
                .map((conversation) {
              return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ConversationPage(
                              autoSendMessage: false,
                              questionInput: "",
                              currentConversation:
                                  data.pastConversations!.pastConversations[data
                                      .pastConversations!.pastConversations
                                      .indexOf(conversation)])),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(conversation.messages[0].messageContent),
                        )),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            onTap: () {
                              Data().deleteData(data
                                  .pastConversations!.pastConversations
                                  .indexOf(conversation));
                            },
                            child: Icon(Icons.delete,
                                color: Theme.of(context).colorScheme.primary),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
} // ignore: must_be_immutable

// ignore: must_be_immutable
class QuestionHistoryHomeView extends StatefulWidget {
  QuestionHistoryHomeView({super.key});

  @override
  State<QuestionHistoryHomeView> createState() =>
      _QuestionHistoryHomeViewState();
}

class _QuestionHistoryHomeViewState extends State<QuestionHistoryHomeView> {
  PastConversations lastTwoPastConversations =
      PastConversations(pastConversations: []);

  @override
  Widget build(BuildContext context) {
    return Consumer<Data>(
      builder: (context, data, child) {
        if (data.pastConversations != null &&
            data.pastConversations!.pastConversations.length >= 2) {
          lastTwoPastConversations.pastConversations.clear();
          lastTwoPastConversations.pastConversations.add(
              data.pastConversations!.pastConversations[
                  data.pastConversations!.pastConversations.length - 1]);
          lastTwoPastConversations.pastConversations.add(
              data.pastConversations!.pastConversations[
                  data.pastConversations!.pastConversations.length - 2]);
        }
        else if(data.pastConversations != null && data.pastConversations!.pastConversations.length == 1)
        {
          lastTwoPastConversations.pastConversations.clear();
          lastTwoPastConversations.pastConversations.add(data.pastConversations!.pastConversations[0]);
        }
        else
        {
          lastTwoPastConversations = PastConversations(pastConversations: []);
        }

        if (lastTwoPastConversations.pastConversations.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: Text("No History Yet.")),
          );
        }
        return Column(
          children:
              lastTwoPastConversations.pastConversations.map((conversation) {
            return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ConversationPage(
                            autoSendMessage: false,
                            questionInput: "",
                            currentConversation:
                                data.pastConversations!.pastConversations[data
                                    .pastConversations!.pastConversations
                                    .indexOf(conversation)])),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(conversation.messages[0].messageContent),
                      )),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          onTap: () {
                            Data().deleteData(data
                                .pastConversations!.pastConversations
                                .indexOf(conversation));
                          },
                          child: Icon(Icons.delete,
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
