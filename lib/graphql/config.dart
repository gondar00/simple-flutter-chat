import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLConfiguration {
  static Link link;
  static HttpLink httpLink = HttpLink(
    uri: 'https://infinite-plateau-74257.herokuapp.com',
  );

  static void setToken(String token) {
    final AuthLink auth = AuthLink(getToken: () async => 'Bearer ' + token);
    GraphQLConfiguration.link = auth.concat(GraphQLConfiguration.httpLink);
  }

  static void removeToken() {
    GraphQLConfiguration.link = null;
  }

  static Link getLink() {
    return GraphQLConfiguration.link ?? GraphQLConfiguration.httpLink;
  }

  ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
    GraphQLClient(
      cache: InMemoryCache(),
      link: getLink(),
    ),
  );
}