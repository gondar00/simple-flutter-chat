import 'package:flutter/material.dart';
import 'package:e_doctor/models/ChatListItem.dart';
import 'package:e_doctor/screens/ChatScreen.dart';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:e_doctor/tabs/chats_gql.dart';

class ChatsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        documentNode: gql(getChatsQuery),
        pollInterval: 100,
      ),
      builder: (QueryResult result, { VoidCallback refetch, FetchMore fetchMore }) {
        print("-----printing------chats");
        // print(result);
        var me = result.data['me']['conversations'];
        // var chats = ChatList.fromJson(me);
        print(me);

        return ListView.separated(
              itemCount: me.length,
              separatorBuilder: (ctx, i) {
                return Divider();
              },
              itemBuilder: (ctx, i) {
                return ListTile(
                  title: Text('name'),
                  subtitle: Text('last message'),
                  trailing: Text('date'),
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(
                      "https://images.pexels.com/photos/733872/pexels-photo-733872.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940"
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          person: ChatListItem(name: 'gandharv'), 
                        ),
                      ),
                    );
                  },
                );
              },
            );
      });
  }
}