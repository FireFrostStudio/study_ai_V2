import 'package:flutter/material.dart';
import 'package:studyai_flutter_v2/conversation_page_elements/conversation_text_builder.dart';
import 'package:studyai_flutter_v2/data/conversation_data.dart';
import 'package:studyai_flutter_v2/resusable_components/bottom_send_chat.dart';
import 'package:studyai_flutter_v2/resusable_components/top_elements.dart';

class ConversationPage extends StatefulWidget {
  ConversationPage({super.key, required this.questionInput, required this.autoSendMessage, required this.currentConversation});

  Conversation currentConversation;

  @override
  // ignore: no_logic_in_create_state
  State<ConversationPage> createState() => _ConversationPageState(questionInput, autoSendMessage, currentConversation);
  final String questionInput;
  final bool autoSendMessage;
}

class _ConversationPageState extends State<ConversationPage> {
  String questionInput;
  bool autoSendMessage;
  Conversation currentConversation;
  _ConversationPageState(this.questionInput, this.autoSendMessage, this.currentConversation);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TopElements(isConversationPage: true,),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
                    child: ConversationTextBuilder(currentConversation: currentConversation,),
                  ),
                  SizedBox(height: 150,)
                ],
              ),
            ),
          ),
          BottomSendChat(isFromHomePage: false, preEnteredMessage: questionInput, autoSendMessage: autoSendMessage, currentConversation: currentConversation, onMessageSent: updateConversation,)
        ],
      ),
    );
  }

 void updateConversation(ChatMessage newMessage)
  {
      setState(() {
        currentConversation.messages.add(newMessage);
      });
  }
}