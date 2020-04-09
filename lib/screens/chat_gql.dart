// String getChatsQuery = '''
//   query me {
//     me {
//       conversations {
//         id
//         name
//         createdAt
//         updatedAt
//         participants {
//           username
//         }
//         texts {
//           id
//           text
//           createdAt
//           author {
//             id
//             username
//           }
//         }
//       }
//     }
//   }
// ''';


String sendTextMessageMutation = '''
  mutation sendTextMessage(\$conversationId: ID!, \$text: String!) {
    sendTextMessage(conversationId: \$conversationId, text: \$text) {
      id
      text
    }
  }
''';

String subscriptionNewText = '''
  subscription onTextAdded {
    text {
      mutation
      node {
        id
        text
        createdAt
        author {
          id
          username
        }
        conversation {
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
    }
  }
''';