  
String getUserQuery = """
  query users {
    users {
      id
      username
    }
  }
""";

String createChatMutation = """
mutation createConversation(
    \$name: String
    \$participantIds: [ID!]!
    \$text: String
  ) {
    createConversation(
      name: \$name
      participantIds: \$participantIds
      text: \$text
    ) {
      id
      name
      participants {
        id
        username
      }
      texts {
        id
        text
        createdAt
        author {
          id
          username
        }
      }
    }
  }
""";