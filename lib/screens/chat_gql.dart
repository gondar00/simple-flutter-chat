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
          text
          createdAt
          author {
            id
            username
          }
        }
      }
    }
  }
""";
