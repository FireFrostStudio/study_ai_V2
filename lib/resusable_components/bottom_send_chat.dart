import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:studyai_flutter_v2/resusable_components/text_field_custom.dart';
import 'package:studyai_flutter_v2/conversation_page_elements/conversation_text_builder.dart';
import '../conversationPage.dart';
import '../data/conversation_data.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:anthropic_dart/anthropic_dart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BottomSendChat extends StatefulWidget {
  BottomSendChat(
      {super.key,
      required this.isFromHomePage,
      required this.preEnteredMessage,
      required this.autoSendMessage,
      this.currentConversation,
      this.onMessageSent,
      this.conversationIndex});
  final bool isFromHomePage;
  final String preEnteredMessage;
  final bool autoSendMessage;
  int? conversationIndex;
  Conversation? currentConversation;
  Function(ChatMessage)? onMessageSent;
  @override
  State<BottomSendChat> createState() => _BottomSendChatState();
}

class _BottomSendChatState extends State<BottomSendChat> {
  final TextEditingController _textEditingController = TextEditingController();
  int? _conversationIndex;
  bool textFieldReadOnly = false;

  InterstitialAd? _interstitialAd;

  void loadAd() {
    InterstitialAd.load(
        adUnitId: Data().interstitialAdAndroidID,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
                // Called when the ad showed the full screen content.
                onAdShowedFullScreenContent: (ad) {},
                // Called when an impression occurs on the ad.
                onAdImpression: (ad) {},
                // Called when the ad failed to show full screen content.
                onAdFailedToShowFullScreenContent: (ad, err) {
                  // Dispose the ad here to free resources.
                  ad.dispose();
                },
                // Called when the ad dismissed full screen content.
                onAdDismissedFullScreenContent: (ad) {
                  // Dispose the ad here to free resources.
                  ad.dispose();
                  print("Closed");
                  loadAd();
                },
                // Called when a click is recorded for an ad.
                onAdClicked: (ad) {});

            debugPrint('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            _interstitialAd = ad;
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
          },
        ));
  }

  @override
  void initState() {
    super.initState();
    _textEditingController.text = widget.preEnteredMessage;
    _conversationIndex = widget.conversationIndex;
    loadAd();
    if(widget.isFromHomePage)
    {
      setState(() {
        textFieldReadOnly = false;
      });
    }
      WidgetsBinding.instance
        .addPostFrameCallback((_) => sendMessageOnStart(context));

    if(widget.isFromHomePage)
    {
      print("FROM HOME PAGE");
    }
    else
    {
      print("NOT FROM HOME PAGE");
    }
  }

  void sendMessageOnStart(BuildContext context) {
    if (widget.autoSendMessage == true && _textEditingController.text != "") {
      sendMessage(context);
    }
  }

  Future<void> GetResponse(BuildContext context, ChatMessage question) async {
    String apiKey = "";
    const String apiUrl = 'https://api.anthropic.com/v1/messages';
    final String defaultModel = "claude-3-haiku-20240307";
    await FirebaseFirestore.instance
        .collection("data")
        .doc("backend")
        .get()
        .then((value) {
      setState(() {
        apiKey = value.data()!['apiKey'];
      });
    });
    final headers = {
      'x-api-key': apiKey,
      'anthropic-version': '2023-06-01',
      'content-type': 'application/json',
    };

    final body = jsonEncode({
      'model': 'claude-3-haiku-20240307',
      'max_tokens': 256,
      'system': Data().isPremium == false
          ? 'You the free version of an educational assistant called Study AI. Give breif answers and if a question is too complex, end it by saying something like more detail is included in Study AI Premium. As a formatting rule, do not every write a quotation mark or include it in an answer.'
          : "You are the premium version of an educational assistant called Study AI. Give concise, detailed answers. As a formatting rule, never write a quotation mark in your answer.",
      'messages': [
        {'role': 'user', 'content': question.messageContent}
      ]
    });

    final response =
        await http.post(Uri.parse(apiUrl), headers: headers, body: body);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      String? output = getTextContent(responseData);
      widget.onMessageSent!(ChatMessage(
          fromUser: false, messageContent: output ?? "Error Loading Response"));
      setState(() {
        textFieldReadOnly = false;
      });

      if (_conversationIndex != null) {
        Data()
            .pastConversations!
            .pastConversations[_conversationIndex ?? 0]
            .messages
            .add(ChatMessage(
                fromUser: true, messageContent: question.messageContent));
        Data()
            .pastConversations!
            .pastConversations[_conversationIndex ?? 0]
            .messages
            .add(ChatMessage(fromUser: false, messageContent: output ?? " "));

        Data().savePastData();
      } else {
        Data().pastConversations!.pastConversations.add(Conversation(messages: [
              ChatMessage(
                  fromUser: true, messageContent: question.messageContent),
              ChatMessage(fromUser: false, messageContent: output ?? " ")
            ]));
        setState(() {
          _conversationIndex =
              Data().pastConversations!.pastConversations.length - 1;
        });
        Data().savePastData();
      }
    } else {
      // Handle error
      print("WAS AN ERROR");
      print(response.body);
    }
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
                                style: TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w100),
                              )),
                        ),
                        // GestureDetector(
                        //   onTap: () {},
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(10.0),
                        //     child: Container(
                        //         width: 45,
                        //         height: 45,
                        //         decoration: BoxDecoration(
                        //           color: Theme.of(context).colorScheme.primary,
                        //           borderRadius: BorderRadius.circular(15),
                        //         ),
                        //         child: const Center(
                        //             child: Padding(
                        //           padding: EdgeInsets.only(top: 5),
                        //           child: ImageIcon(
                        //             AssetImage("assets/icons/camera_icon.png"),
                        //             size: 35,
                        //             color: Colors.white,
                        //           ),
                        //         ))),
                        //   ),
                        // ),
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
      String inputText = _textEditingController.text;
      _textEditingController.clear();
      FocusManager.instance.primaryFocus?.unfocus();
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ConversationPage(
                  autoSendMessage: sendRightAway,
                  currentConversation: Conversation(messages: []),
                  questionInput: inputText,
                )),
      );
    }

    if (widget.isFromHomePage == false &&
        _textEditingController.text != "" &&
        widget.onMessageSent != null) {
      widget.onMessageSent!(ChatMessage(
          fromUser: true, messageContent: _textEditingController.text));
      GetResponse(
          context,
          ChatMessage(
              fromUser: true, messageContent: _textEditingController.text));
      _textEditingController.clear();
      setState(() {
        textFieldReadOnly = true;
      });
    }
    if (widget.currentConversation?.messages != null) {
      if (_interstitialAd != null &&
          Data().isPremium == false &&
          widget.currentConversation!.messages.length % 3 == 0) {
        try {
          _interstitialAd!.show();
        } catch (e) {
          print("Error Showing Ad. Code: " + e.toString());
        }
      }
    }
  }
}

String? getTextContent(Map<String, dynamic> responseData) {
  if (responseData['content'] != null && responseData['content'].length > 0) {
    final content = responseData['content'][0];
    if (content['type'] == 'text') {
      return content['text'];
    }
  }
  return null;
}
