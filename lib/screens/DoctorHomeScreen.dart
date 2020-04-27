import 'dart:core';
import 'package:jiffy/jiffy.dart';

import 'package:flutter/material.dart';
import 'package:e_doctor/screens/ChatScreen.dart';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:e_doctor/graphql/query/get_my_chats.dart';
import 'package:flutter/cupertino.dart';

import 'package:e_doctor/models/ChatMessage.dart';

class ConversationList {
  ConversationList({this.conversations});

  factory ConversationList.fromJson(List<dynamic> json) {
    final List<Conversation> conversations = json.map((dynamic convo) => Conversation.fromJson(convo)).toList();
    return ConversationList(conversations: conversations);
  }

  final List<Conversation> conversations;

  int get length => conversations.length;
}

class ErrorModel {
  final String path;
  final String message;

  ErrorModel({this.path, this.message});

  factory ErrorModel.fromJson(Map<String, dynamic> json) {
    return ErrorModel(path: json['path'], message: json['message']);
  }
}

class DoctorHomeScreen extends StatefulWidget {
  DoctorHomeScreen({this.userType});
  final String userType;

  @override
  _DoctorHomeScreenState createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        documentNode: gql(getChatsQuery),
        pollInterval: 100,
      ),
      builder: (QueryResult result, { VoidCallback refetch, FetchMore fetchMore }) {
        if(result.loading || result.data == null) 
          return const CupertinoActivityIndicator();
        if(result.data == null && !result.loading) 
          return Container();

        final List<dynamic> json = result.data['me']['conversations'] as List<dynamic>;
        final List<Conversation> conversations = json.map((dynamic convo) => Conversation.fromJson(convo)).toList();
        print('-----printing------conversations');
        print(conversations);

        return ListView.separated(
          itemCount: conversations.length,
          separatorBuilder: (BuildContext ctx, int i) {
            return const Divider();
          },
          itemBuilder: (BuildContext ctx, int i) {
            return ListTile(
              title: Text(conversations[i].name),
              subtitle: Text(Jiffy(conversations[i].updatedAt).fromNow()),
              trailing: Text(Jiffy(conversations[i].createdAt).fromNow()),
              onTap: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (BuildContext context) => ChatScreen(
                      id: conversations[i].id,
                      userType: widget.userType,
                      title: conversations[i].name,
                      participants: conversations[i].participants.map((dynamic participant) => Participant.fromJson(participant)).toList(),
                      texts: conversations[i].texts.map((dynamic message) => Message.fromJson(message)).toList()
                    ),
                  ),
                );
              },
            );
          },
        );
      }
    );
  }
}