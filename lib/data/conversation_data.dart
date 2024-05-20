import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class Data extends ChangeNotifier {
  static Data? _instance;

  Data._();

  factory Data() => _instance ??= Data._();

  PastConversations? pastConversations;
  bool isPremium = false;

  Future<void> initalizeSubStatus() async {
    CustomerInfo customerInfo = await Purchases.getCustomerInfo();
    isPremium = customerInfo.entitlements.all["Premium"]?.isActive ?? false;
    notifyListeners();
  }

  Future<void> loadPastData() async {
    pastConversations = await retrievePastConversations();
    print("Data Retreived. Count: " +
        pastConversations!.pastConversations.length.toString());
  }

  Future<void> savePastData() async {
    savePastConversations(pastConversations);
    notifyListeners();
  }

  void deleteData(int index) {
    pastConversations!.pastConversations.removeAt(index);
    savePastConversations(pastConversations);
    notifyListeners();
  }

  void deleteAllData() {
    pastConversations = PastConversations(pastConversations: []);
    savePastConversations(pastConversations);
    notifyListeners();
  }
}

class ChatMessage {
  bool fromUser;
  String messageContent;

  ChatMessage({required this.fromUser, required this.messageContent});
}

class Conversation {
  List<ChatMessage> messages;

  Conversation({required this.messages});
}

class PastConversations {
  List<Conversation> pastConversations;
  PastConversations({required this.pastConversations});
}

// Save PastConversations to disk
Future<void> savePastConversations(PastConversations? pastConversations) async {
  if (pastConversations == null) {
    return;
  }
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> conversationsJson =
      pastConversations!.pastConversations.map((conversation) {
    List<String> messagesJson = conversation.messages.map((message) {
      return '{"fromUser": ${message.fromUser}, "messageContent": "${message.messageContent}"}';
    }).toList();
    return '{"messages": [${messagesJson.join(',')}]}';
  }).toList();
  prefs.setStringList('pastConversations', conversationsJson);
}

Future<PastConversations> retrievePastConversations() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> conversationsJson =
      prefs.getStringList('pastConversations') ?? [];
  if (conversationsJson.isEmpty) {
    return PastConversations(pastConversations: []);
  }
  List<Conversation> conversations = conversationsJson.map((conversationJson) {
    String sanitizedJson =
        conversationJson.replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '');
    Map<String, dynamic> conversationMap = jsonDecode(sanitizedJson);
    List<ChatMessage> chat_messages =
        conversationMap['messages'].map<ChatMessage>((messageJson) {
      Map<String, dynamic> messageMap = messageJson;
      return ChatMessage(
          fromUser: messageMap['fromUser'],
          messageContent: messageMap['messageContent']);
    }).toList();
    return Conversation(messages: chat_messages);
  }).toList();
  return PastConversations(pastConversations: conversations);
}
