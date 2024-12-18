import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:studyai_flutter_v2/getPremiumPage.dart';
import 'package:studyai_flutter_v2/resusable_components/text_field_custom.dart';
import 'package:studyai_flutter_v2/conversation_page_elements/conversation_text_builder.dart';
import '../conversationPage.dart';
import '../data/conversation_data.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:anthropic_dart/anthropic_dart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

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
  bool isTakingPicture = false;
  InterstitialAd? _interstitialAd;

  CameraController? _controller;
  late Future<void> _initializeControllerFuture;

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
    if (widget.isFromHomePage) {
      setState(() {
        textFieldReadOnly = false;
      });
    }
    WidgetsBinding.instance
        .addPostFrameCallback((_) => sendMessageOnStart(context));
  }

  void sendMessageOnStart(BuildContext context) {
    if (widget.autoSendMessage == true && _textEditingController.text != "") {
      sendMessage(context);
    }
  }

  // Future<void> sendPicture() async {
  //   XFile? pickedFile;

  //   if (Platform.isIOS) {
  //     var iosInfo = await DeviceInfoPlugin().iosInfo;
  //     if (iosInfo.isPhysicalDevice) {
  //       try {
  //         pickedFile =
  //         await ImagePicker().pickImage(source: ImageSource.camera);
  //         if (pickedFile == null) {
  //           throw Exception('No file was picked.');
  //         }
  //       } catch (error) {
  //         showDialog(
  //           context: context,
  //           builder: (_) => AlertDialog(
  //             title: Text(
  //               'Error',
  //               style: TextStyle(
  //                   fontWeight: FontWeight.bold, color: Colors.red.shade500),
  //             ),
  //             content: const Text(
  //               'Camera is currently unavailable or does not exist. Please try again.',
  //             ),
  //             actions: [
  //               TextButton(
  //                   onPressed: () {
  //                     Navigator.pop(context);
  //                   },
  //                   child: const Text(
  //                     "Close",
  //                     style: TextStyle(color: CupertinoColors.systemRed),
  //                   ))
  //             ],
  //           ),
  //         );
  //         return;
  //       }

  // if (await File(pickedFile.path).exists() == true) {
  //   _croppedFile = await ImageCropper()
  //       .cropImage(sourcePath: pickedFile.path, uiSettings: [
  //     AndroidUiSettings(
  //       toolbarTitle: "Crop Question",
  //     ),
  //     IOSUiSettings(
  //         title: "Crop Question", showCancelConfirmationDialog: true)
  //   ]);
  //   if (_croppedFile != null) {
  //     setState(() {
  //       _image = File(_croppedFile!.path);
  //       _recognizeText(pickedFile?.path);
  //     });
  //   }
  // }
  //   } else if (iosInfo.isPhysicalDevice == false) {
  //     showDialog(
  //       context: context,
  //       builder: (_) => AlertDialog(
  //         title: Text(
  //           'Error',
  //           style: TextStyle(
  //               fontWeight: FontWeight.bold, color: Colors.red.shade500),
  //         ),
  //         content: const Text(
  //           'Camera is currently unavailable or does not exist. Try running the app on a real device.',
  //         ),
  //         actions: [
  //           TextButton(
  //               onPressed: () {
  //                 Navigator.pop(context);
  //               },
  //               child: const Text(
  //                 "Close",
  //                 style: TextStyle(color: CupertinoColors.systemRed),
  //               ))
  //         ],
  //       ),
  //     );
  //   }
  // } else if (Platform.isAndroid) {
  //   try {
  //     pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
  //     if (pickedFile == null) {
  //       throw Exception('No file was picked.');
  //     }
  //   } catch (error) {
  //     print("Error");
  //     showDialog(
  //       context: context,
  //       builder: (_) => AlertDialog(
  //         title: Text(
  //           'Error',
  //           style: TextStyle(
  //               fontWeight: FontWeight.bold, color: Colors.red.shade500),
  //         ),
  //         content: const Text(
  //           'Camera is currently unavailable or does not exist.. Please try again.',
  //         ),
  //         actions: [
  //           TextButton(
  //               onPressed: () {
  //                 Navigator.pop(context);
  //               },
  //               child: const Text(
  //                 "Close",
  //                 style: TextStyle(color: CupertinoColors.systemRed),
  //               ))
  //         ],
  //       ),
  //     );
  //     return;
  //   }

  // if (await File(pickedFile.path).exists() == true) {
  //   _croppedFile = await ImageCropper()
  //       .cropImage(sourcePath: pickedFile.path, uiSettings: [
  //     AndroidUiSettings(
  //       toolbarTitle: "Crop Question",
  //     ),
  //     IOSUiSettings(
  //         title: "Crop Question", showCancelConfirmationDialog: true)
  //   ]);
  //   if (_croppedFile != null) {
  //     setState(() {
  //       _image = File(_croppedFile!.path);
  //       _recognizeText(pickedFile?.path);
  //     });
  //   }
  // }
  // }
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    if (_controller != null) {
      _controller!.dispose();
    }
    super.dispose();
  }

  Future<void> GetResponse(BuildContext context, ChatMessage question) async {
    Data userData = Data();
    XFile? image = userData.pictureTaken;
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
    bool isSendingPicture = false;

    if (image != null) {
      isSendingPicture = true;
    }

    List<Map<String, String>> messagesContent = [];

    if (widget.currentConversation!.messages.length >= 3) {
      messagesContent.add({
        'role': 'user',
        'content': widget
            .currentConversation!
            .messages[widget.currentConversation!.messages.length - 3]
            .messageContent,
      });
      messagesContent.add({
        'role': 'assistant',
        'content': widget
            .currentConversation!
            .messages[widget.currentConversation!.messages.length - 2]
            .messageContent,
      });
    }

    if (userData.isPremium && image != null) {
      messagesContent.add({'role': 'user', 'content': "source"});
    } else {
      messagesContent.add({
        'role': 'user',
        'content': question.messageContent,
      });
    }

    String base64Image = "";

    if (isSendingPicture) {
      question.messageContent = "${question.messageContent} [Image]";
      List<int> imageBytes = File(image!.path).readAsBytesSync();
      base64Image = base64Encode(imageBytes);
    }

    String body = jsonEncode({});

    if (isSendingPicture == false) {
      body = jsonEncode({
        'model': 'claude-3-haiku-20240307',
        'max_tokens': Data().isPremium ? 256 : 1024,
        'system': Data().isPremium == false
            ? 'You are using the free version of an educational assistant called Study AI. Give brief answers and if a question is too complex, end it by saying "more detail is included in Study AI Premium". As a formatting rule, do not ever write a quotation mark or include it in an answer or write any non-English character.'
            : "You are using the premium version of an educational assistant called Study AI. Give concise, detailed answers. As a formatting rule, never write a quotation mark or non-English character in your answer.",
        'messages': messagesContent
      });
    } else {
      if (question.messageContent == " [Image]") {
        body = jsonEncode({
          'model': 'claude-3-haiku-20240307',
          'max_tokens': Data().isPremium ? 256 : 1024,
          'system': Data().isPremium == false
              ? 'You are using the free version of an educational assistant called Study AI. Give brief answers and if a question is too complex, end it by saying "more detail is included in Study AI Premium". As a formatting rule, do not ever write a quotation mark or include it in an answer or write any non-English character.'
              : "You are using the premium version of an educational assistant called Study AI. Give concise, detailed answers. As a formatting rule, never write a quotation mark or non-English character in your answer.",
          'messages': [
            {
              'role': 'user',
              'content': [
                {
                  'type': 'image',
                  'source': {
                    'type': 'base64',
                    'media_type': 'image/jpeg',
                    'data': base64Image
                  }
                }
              ]
            },
          ]
        });
      } else {
        body = jsonEncode({
          'model': 'claude-3-haiku-20240307',
          'max_tokens': Data().isPremium ? 256 : 1024,
          'system': Data().isPremium == false
              ? 'You are using the free version of an educational assistant called Study AI. Give brief answers and if a question is too complex, end it by saying "more detail is included in Study AI Premium". As a formatting rule, do not ever write a quotation mark or include it in an answer or write any non-English character.'
              : "You are using the premium version of an educational assistant called Study AI. Give concise, detailed answers. As a formatting rule, never write a quotation mark or non-English character in your answer.",
          'messages': [
            {
              'role': 'user',
              'content': [
                {
                  'type': 'image',
                  'source': {
                    'type': 'base64',
                    'media_type': 'image/jpeg',
                    'data': base64Image
                  }
                },
                {"type": "text", "text": question.messageContent}
              ]
            },
          ]
        });
      }
    }
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

    userData.deletePicture();
  }

  @override
  Widget build(BuildContext context) {
    Data userData = Data();

    Future<void> takePicture(BuildContext context) async {
      Data data = Data();
      print("TAKING PICTURE");
      if (data.isPremium) {
        final ImagePicker imagePicker = ImagePicker();
        data.pictureTaken =
            await imagePicker.pickImage(source: ImageSource.camera);
        setState(() {});
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GetPremiumPage()),
        );
      }
    }

    return Column(
      children: [
        const Spacer(),
        if (userData.pictureTaken != null)
          Container(
            height: 125,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: [
                Image.file(File(userData.pictureTaken!.path)),
                GestureDetector(
                  onTap: () {
                    userData.deletePicture();
                    setState(() {});
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
                        child: const Center(child: Icon(Icons.delete))),
                  ),
                ),
              ]),
            ),
          ),
        //const SizedBox(height: 25),
        Container(
            height: 125,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.only(
                    topLeft:
                        Radius.circular(userData.pictureTaken != null ? 0 : 15),
                    topRight: Radius.circular(
                        userData.pictureTaken != null ? 0 : 15))),
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
                        GestureDetector(
                          onTap: () {
                            takePicture(context);
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
    Data data = Data();

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
        (_textEditingController.text != "" || data.pictureTaken != null) &&
        widget.onMessageSent != null) {
      widget.onMessageSent!(ChatMessage(
          fromUser: true,
          messageContent: data.pictureTaken == null
              ? _textEditingController.text
              : "${_textEditingController.text} [Image]"));
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

void deletePicutreTaken() {
  Data data = Data();
  data.deletePicture();
}
