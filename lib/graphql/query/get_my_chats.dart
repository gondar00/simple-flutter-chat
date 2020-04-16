String getChatsQuery = """
  query me {
    me {
      conversations {
        id
        name
        createdAt
        updatedAt
        participants {
          username
        }
        texts {
          id
          createdAt
          text
          author {
            id
            username
          }
        }
      }
    }
  }
""";
