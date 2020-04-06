import 'package:flutter/material.dart';
import 'package:e_doctor/config/config.dart';
import 'package:e_doctor/models/ChatListItem.dart';

class CallsTab extends StatelessWidget {


  // final List<ChatListItem> chatListItems = [
  //   ChatListItem(
  //     profileURL: "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
  //     personName: "Tremaine",
  //     date: "9:10 am",
  //     lastMessage: "beatae quasi sed" 
  //   ),
  //   ChatListItem(
  //     profileURL: "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
  //     personName: "Cletus",
  //     date: "9:10 am",
  //     lastMessage: "beatae quasi sed" 
  //   ),
  // ];


  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 0,
      separatorBuilder: (ctx, i) {
        return Divider();
      },
      itemBuilder: (ctx, i) {
        return ListTile(
          title: Text('hello'),
          subtitle: Text('message'),
          trailing: IconButton(
            onPressed: (){},
            icon: Icon(
              i%6!=0?Icons.call:Icons.videocam,
              color: primaryColor,
            ),
          ),
          leading: CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage: NetworkImage(
              "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940"
            ),
          ),
          onTap: () {},
        );
      },
    );
  }
}