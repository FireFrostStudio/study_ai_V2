class Message {
  bool fromUser;
  String messageContent;

  Message({required this.fromUser, required this.messageContent});
}

class Conversation {
  List<Message> messages;

  Conversation({required this.messages});
}