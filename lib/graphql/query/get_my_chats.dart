String getChatsQuery = """
  query me {
    me {
      conversations {
        id
        name
        createdAt
        updatedAt
        participants {
          id
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
