// class ChatMessage {
//   final String message;
//   final bool isSentByMe;
//   final String date;

//   ChatMessage({
//     this.message,
//     this.isSentByMe,
//     this.date
//   });
// }

// class ConversationList {
//   ConversationList({this.conversations});

//   factory ConversationList.fromJson(List<dynamic> json) {
//     final List<Conversation> conversations = json.map((dynamic convo) => Conversation.fromJson(convo)).toList();
//     return ConversationList(conversations: conversations);
//   }

//   final List<Conversation> conversations;

//   int get length => conversations.length;
// }

import 'package:e_doctor/models/ErrorModel.dart';

class Conversation {
  final String id;
  final String name;
  final String createdAt;
  final String updatedAt;
  final String lastMessage;
  final List<dynamic> participants;
  final List<dynamic> texts;
  final ErrorModel error;

  Conversation({this.id, this.name, this.createdAt, this.updatedAt, this.participants, this.texts, this.lastMessage, this.error});

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] as String,
      name: json['name'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      participants: json['participants'] as List<dynamic>,
      texts: json['texts'] as List<dynamic>,
      error: json['error'] != null ? ErrorModel.fromJson(json['error']) : null
    );
  }
}

class Participant {
  Participant({this.id, this.username });

  final String id;
  final String username;

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      id: json['id'] as String,
      username: json['username'] as String,
    );
  }
}

class Message {
  Message({this.id, this.text = '', this.createdAt, this.author});

  final String id;
  final String text;
  final String createdAt;
  final Author author;

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      text: json['text'] as String,
      createdAt: json['createdAt'] as String,
      author: Author.fromJson(json['author'])
    );
  }
}

class Author { 
  Author({this.id, this.username});

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'] as String,
      username: json['username'] as String,
    );
  }

  final String id;
  final String username;
}