class ChatList {
  final List<ChatListItem> chats;

  ChatList({this.chats});

  factory ChatList.fromJson(List<dynamic> json) {
    var chats = json.map((chatItem) => ChatListItem.fromJson(chatItem)).toList();
    return ChatList(chats: chats);
  }

  int get length => chats.length;
}

class ChatListItem {
  final String id, name, participants;
  ChatListItem({this.id, this.name, this.participants});

  factory ChatListItem.fromJson(dynamic json) {
    return ChatListItem(
      id: json['id'].toString(),
      // email: json['email'].toString(),
      name: json['name'],
      participants: json['participants'],
    );
  }
}