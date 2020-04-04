import 'package:flutter/material.dart';
import 'package:e_doctor/models/ChatListItem.dart';
import 'package:e_doctor/screens/ChatScreen.dart';

class ChatsTab extends StatelessWidget {
  final List<ChatListItem> chatListItems = [
    ChatListItem(
      profileURL: "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
      personName: "Tremaine",
      date: "9:10 am",
      lastMessage: "beatae quasi sed" 
    ),
    ChatListItem(
      profileURL: "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
      personName: "Cletus",
      date: "9:10 am",
      lastMessage: "beatae quasi sed" 
    ),
    ChatListItem(
      profileURL: "https://images.pexels.com/photos/733872/pexels-photo-733872.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
      personName: "Cecil",
      date: "9:10 am",
      lastMessage: "beatae quasi sed" 
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: chatListItems.length,
      separatorBuilder: (ctx, i) {
        return Divider();
      },
      itemBuilder: (ctx, i) {
        return ListTile(
          title: Text(chatListItems[i].personName),
          subtitle: Text(chatListItems[i].lastMessage),
          trailing: Text(chatListItems[i].date),
          leading: CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage: NetworkImage(
              chatListItems[i].profileURL
            ),
          ),
          onTap: () {
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  person: chatListItems[i], 
                ),
              ),
            );
          },
        );
      },
    );
    
  }
}