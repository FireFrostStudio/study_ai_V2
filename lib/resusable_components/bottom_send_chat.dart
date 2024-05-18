import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:studyai_flutter_v2/resusable_components/text_field_custom.dart';
import 'package:studyai_flutter_v2/conversation_page_elements/conversation_text_builder.dart';
import '../conversationPage.dart';
import '../data/conversation_data.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class BottomSendChat extends StatefulWidget {
  BottomSendChat(
      {super.key,
      required this.isFromHomePage,
      required this.preEnteredMessage,
      required this.autoSendMessage,
      this.currentConversation,
      this.onMessageSent});
  final bool isFromHomePage;
  final String preEnteredMessage;
  final bool autoSendMessage;
  Conversation? currentConversation;
  Function(Message)? onMessageSent;
  @override
  State<BottomSendChat> createState() => _BottomSendChatState();
}

class _BottomSendChatState extends State<BottomSendChat> {
  final TextEditingController _textEditingController = TextEditingController();

  bool textFieldReadOnly = false;
  @override
  void initState() {
    super.initState();
    _textEditingController.text = widget.preEnteredMessage;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Container(
            height: 125,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15))),
            child: textFieldReadOnly == false
                ? Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 15),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomTextField(
                                controller: _textEditingController,
                                readOnly: textFieldReadOnly,
                                style: TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w100),
                              )),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Center(
                                    child: Padding(
                                  padding: EdgeInsets.only(top: 5),
                                  child: ImageIcon(
                                    AssetImage("assets/icons/camera_icon.png"),
                                    size: 35,
                                    color: Colors.white,
                                  ),
                                ))),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            sendMessage(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Center(
                                    child: Padding(
                                  padding: EdgeInsets.only(top: 5),
                                  child: ImageIcon(
                                    AssetImage("assets/icons/send_icon.png"),
                                    size: 27,
                                    color: Colors.white,
                                  ),
                                ))),
                          ),
                        )
                      ],
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 15),
                    child: Center(
                      child: LoadingAnimationWidget.dotsTriangle(
                          color: Theme.of(context).colorScheme.primary,
                          size: 50),
                    ),
                  ))
      ],
    );
  }

  void sendMessage(BuildContext context) {
    if (widget.isFromHomePage) {
      bool sendRightAway = false;
      if (_textEditingController.text != "") {
        sendRightAway = true;
      }
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ConversationPage(
                  autoSendMessage: sendRightAway,
                  currentConversation: Conversation(messages: []),
                  questionInput: _textEditingController.text,
                )),
      );
    }

    if (widget.isFromHomePage == false &&
        _textEditingController.text != "" &&
        widget.onMessageSent != null) {
      widget.onMessageSent!(
          Message(fromUser: true, messageContent: _textEditingController.text));
      _textEditingController.clear();
      GetResponse(context, Message(fromUser: true, messageContent: _textEditingController.text));
      setState(() {
        textFieldReadOnly = true;
      });
    }
  }

  void GetResponse(BuildContext context, Message question)
  {
    
  }
}
