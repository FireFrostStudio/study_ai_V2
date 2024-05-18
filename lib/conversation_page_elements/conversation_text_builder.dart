import 'package:flutter/material.dart';
import 'package:studyai_flutter_v2/data/conversation_data.dart';

class ConversationTextBuilder extends StatefulWidget {
  ConversationTextBuilder({super.key, this.currentConversation});
  Conversation? currentConversation;
  @override
  State<ConversationTextBuilder> createState() => _ConversationTextBuilderState();
}

class _ConversationTextBuilderState extends State<ConversationTextBuilder> {
  @override
  Widget build(BuildContext context) {
    if (widget.currentConversation == null) {
      return const Text('No conversation found');
    }

    return Column(
      children: widget.currentConversation!.messages.map((message) {
        return Row(
          children: [
            message.fromUser? Spacer() : SizedBox(),
            Expanded(
              child: Container(
                alignment: message.fromUser? Alignment.centerRight : Alignment.centerLeft,
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.only(bottom: 8.0),
                decoration: BoxDecoration(
                  
                  color: message.fromUser
                   ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.secondary,
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                ),
                child: Text(
                  message.messageContent,
                  textAlign: message.fromUser? TextAlign.right : TextAlign.left,
                  style: message.fromUser ? TextStyle(color: Colors.white) : TextStyle(),
                ),
              ),
            ),
            message.fromUser == false? Spacer() : SizedBox(),
          ],
        );
      }).toList(),
    );
  }
}
