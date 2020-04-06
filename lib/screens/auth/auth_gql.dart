String signupMutation = """
  mutation signup(\$username: String!) {
    signup(username: \$username) {
      token
      user {
        id
        username
      }
    }
  }
""";